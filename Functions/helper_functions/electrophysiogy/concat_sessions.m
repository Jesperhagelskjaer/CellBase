clc
clear all
close all

path        = {'D:\vsMClust\MM002\2019-02-21_17-24-28';
               'D:\vsMClust\MM002\2019-02-21_17-24-28'};

fname       = fullfile(path{1},'concat_session');
timestampsE = {};
Chs         = 32;
for ch = 1:Chs    
    holder = [];
    for i_path = 1:numel(path)   
        [data, ~, ~]    = load_open_ephys_data(fullfile(path{i_path},sprintf('100_CH%d.continuous',ch)));          
        if ch == 1
            [~, timestampsE{i_path}, ~] = load_open_ephys_data('D:\vsMClust\MM002\2019-02-21_17-24-28\all_channels.events');
            lgt(i_path) = numel(data);
        end
        holder = [holder; int16(data)];
    end
    if ch == 1
        data_cat = zeros(Chs,numel(holder),'int16');
    end

    data_cat(ch,:) = holder;
    
end

%% %saving the event matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
extra = 0;
event = [];
for i_path = 1:numel(path) 
    event = [event; timestampsE{i_path}+extra];
    extra = extra + lgt(i_path)/30000;
end
save(fullfile(path{1},'cat_event.mat'),'event')

%% saving the data the dat file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fidout      = fopen(fname, 'w');
fwrite(fidout, data_cat, 'int16');   %Samples must in channel x time (as with openEphys)
fclose(fidout);

%%
% [dataf, timestampsf, infof] = load_open_ephys_data_faster('D:\vsMClust\MM002\2019-02-21_17-24-28\100_CH1.continuous');
% [data, timestamps, info]    = load_open_ephys_data('D:\vsMClust\MM002\2019-02-21_17-24-28\100_CH1.continuous'); 
% 
% 
% figure
% subplot(2,2,1)
% plot(data(1:100))
% title('start')
% subplot(2,2,2)
% plot(data(end-3000:end))
% title('end')
% subplot(2,2,3)
% plot(dataf(1:100))
% title('start - faster method')
% subplot(2,2,4)
% plot(dataf(end-3000:end))
% title('end - faster method')
% 
% figure
% subplot(2,2,1)
% plot(data(1:100))
% title('start')
% subplot(2,2,2)
% plot(data(end-3000:end))
% title('end')
% subplot(2,2,3)
% plot(dataf(1:100))
% title('start - faster method')
% subplot(2,2,4)
% plot(dataf(end-3000:end))
% title('end - faster method')





