clc
clear all
close all

path        = {'D:\vsMClust\MM002\2019-02-21_17-24-28';
               'D:\vsMClust\MM002\2019-02-21_17-24-28'};

fname       = fullfile(path{1},'concat_session');
timestampsE = {};
Chs         = 3;
for ch = 1:Chs    
    holder = [];
    for i_path = 1:numel(path)   
        [data{i_path}, timestamps, info]    = load_open_ephys_data(fullfile(path{i_path},sprintf('100_CH%d.continuous',ch)));          
        if ch == 1
            [dataE, timestampsE{i_path}, infoE] = load_open_ephys_data('D:\vsMClust\MM002\2019-02-21_17-24-28\all_channels.events');
        end
    end
    
    for i_path = 1:numel(path)
       holder = [holder; data{i_path}];
    end
    data_cat(ch,:) = holder;
    
end

%% %saving the event matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
extra = 0;
event = [];
for i_path = 1:numel(path) 
    event = [event; timestampsE{i_path}+extra];
    extra = extra + numel(data{1,i_path})/30000;
end
save(fullfile(path{1},'cat_event.mat'),'event')

%% saving the data the dat file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fidout      = fopen(fname, 'w');
fwrite(fidout, data_cat, 'int16');   %Samples must in channel x time (as with openEphys)
fclose(fidout);

%%
[dataf, timestampsf, infof] = load_open_ephys_data_faster('D:\vsMClust\MM002\2019-02-21_17-24-28\100_CH1.continuous');
[data, timestamps, info]    = load_open_ephys_data('D:\vsMClust\MM002\2019-02-21_17-24-28\100_CH1.continuous'); 


figure
subplot(2,2,1)
plot(data(1:100))
title('start')
subplot(2,2,2)
plot(data(end-3000:end))
title('end')
subplot(2,2,3)
plot(dataf(1:100))
title('start - faster method')
subplot(2,2,4)
plot(dataf(end-3000:end))
title('end - faster method')

figure
subplot(2,2,1)
plot(data(1:100))
title('start')
subplot(2,2,2)
plot(data(end-3000:end))
title('end')
subplot(2,2,3)
plot(dataf(1:100))
title('start - faster method')
subplot(2,2,4)
plot(dataf(end-3000:end))
title('end - faster method')







% fid = fopen('D:\vsMClust\MM002\2019-02-21_17-24-28\100_CH1.continuous');
% hdr = fread(fid, 1024, 'char*1');
% timestamp = fread(fid, 1, 'int64',0,'l');
% N = fread(fid, 1, 'uint16',0,'l');
% recordingNumber = fread(fid, 1, 'uint16', 0, 'l');
% samples = fread(fid, N, 'int16',0,'b');
% recordmarker = fread(fid, 10, 'char*1');
% fclose(fid);
% figure;
% plot(samples(1:100));