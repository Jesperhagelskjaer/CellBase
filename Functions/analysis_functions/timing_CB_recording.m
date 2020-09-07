function [timing] = timing_CB_recording(cellid,path,rez_name)

%addanalysis(@timing_CB_recording,'property_names',{'timing'},'mandatory',{'D:\recording','rezFinalK'});

prs = inputParser;
addRequired(prs,'cellid',@iscellid) % cell ID
addRequired(prs,'path',@ischar)   % path to the data
addRequired(prs,'rez_name',@ischar)   % path to the data
parse(prs,cellid,path,rez_name)

path     = prs.Results.path;
[r,s,tetrode,neuron] = cellid2tags(prs.Results.cellid);

%% CB spike timing
SpikeTimes               = loadcb(prs.Results.cellid,'Spikes');

SpikeTimes_z = SpikeTimes - SpikeTimes(1);

%% TT files
name = strcat('TT',num2str(tetrode),'_',num2str(neuron),'.mat');
full_path = fullfile(path,r,s,name);
load(full_path,'tSpikes');
TT_spikes = length(tSpikes);

tSpikes_z = tSpikes-tSpikes(1);

%% rez files
fullfile_rez = fullfile(path,r,s,prs.Results.rez_name);
load(fullfile_rez);
thl                = tabulate(rez.st(:,8));                          % count number each template is seen
template_in_idx    = find(thl(:,2) ==  TT_spikes);                   % matching the number the templates are seen to CB (making sure it the right template-id from rex)
spike_time_idx_rez = rez.st(find(rez.st(:,8) == template_in_idx),1); % sample idx from the rez file 
spike_idx_rez_cor  = spike_time_idx_rez-spike_time_idx_rez(1);       % correction to zero index
spike_time_s_rez   = spike_idx_rez_cor/30000;                        % convert from (samples) to (s)


%% Checking for fucntions
timing = true;
if all(round(SpikeTimes_z*10000) == round(tSpikes_z))
    fprintf("There is factor 10000 difference between CB and TT\n")
else
    fprintf("There could potential be and error between CB and TT\n")
    timing = false;
end

if all(round(SpikeTimes_z*100000) == round(spike_time_s_rez*100000))  % the factor 100000 moves the decimals to the otherside thereby making "round" precise 
    fprintf("CB is measured in (s) and rez in samples\n")
else
    fprintf("There could potential be and error between CB and rez\n")
    timing = false;
end

%% notes
%CB to TT
    %tSpikes_z = SpikeTimes_z * 10000           % SpikeTimes_z_cor = SpikeTimes_z * 10000 

%rez to CB
    %spike_idx_rez_cor = spike_idx_rez-spike_idx_rez(1);
    %spike_time_s_rez = spike_idx_rez_cor/30000; %convert from (samples) to (s)

end

