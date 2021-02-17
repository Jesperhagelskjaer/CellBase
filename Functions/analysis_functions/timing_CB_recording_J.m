function [varargout] = timing_CB_recording_J(cellid,varargin)


%add_analysis(@timing_CB_recording_J,1,1,'property_names',{'cb_to_ds'},'arglist',{});
%add_analysis(@timing_CB_recording_J,0,0,'property_names',{},'arglist',{});
%add_analysis(@timing_CB_recording_J,1,1,'property_names',{},'arglist',{'cells',[2001:500]});
%add_analysis(@timing_CB_recording_J,1,1,'property_names',{});

%delanalysis(@timing_CB_recording_J)

global f

if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'rez','rezFinal')  % Which method to compare [NCC/NSSD]
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,tetrode,neuron] = cellid2tags(cellid);

%% CB spike timing
SpikeTimes               = loadcb(cellid,'Spikes');

SpikeTimes_z = SpikeTimes - SpikeTimes(1);

%% TT files
name = strcat('TT',num2str(tetrode),'_',num2str(neuron),'.mat');
full_path = fullfile(f.path,r,s,name);
load(full_path,'tSpikes');
TT_spikes = length(tSpikes);

tSpikes_z = tSpikes-tSpikes(1);

%% rez files
load(fullfile(f.path,r,s,f.rez));
thl                = tabulate(rez.st(:,8));                          % count number each template is seen
cb_to_ds    = find(thl(:,2) ==  TT_spikes);                   % matching the number the templates are seen to CB (making sure it the right template-id from rex)
spike_time_idx_rez = rez.st(find(rez.st(:,8) == cb_to_ds),1); % sample idx from the rez file 
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

varargout{1}.cb_to_ds = cb_to_ds;


end












