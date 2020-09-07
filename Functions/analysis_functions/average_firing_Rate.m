function [varargout] = average_firing_Rate(cellid,path,varargin)

% addanalysis(@average_firing_Rate,'property_names',{'CentralPortEpoch'},'mandatory',{'D:\recording'},'arglist',{'type', 'CentralPortEpoch'});
% addanalysis(@average_firing_Rate,'property_names',{'Total_FR'},'mandatory',{'D:\recording'},'arglist',{'type', 'Total_FR'});

%delanalysis(@average_firing_Rate)

prs = inputParser;
addRequired(prs,'cellid',@(cellid) iscellid((cellid)) || (cellid) == 0)
addRequired(prs,'path',@ischar) % cell ID
addParameter(prs,'type','Total_FR',@ischar)
parse(prs,cellid,path,varargin{:})

if (prs.Results.cellid == 0)
    varargout{1}.prs = prs;
    return
end

switch prs.Results.type
    case 'Total_FR'
        [name,session,~,~] = cellid2tags(prs.Results.cellid);
        path_full = fullfile(prs.Results.path,name,session);
        SpikeTimes               = loadcb(prs.Results.cellid,'Spikes');
        if length(SpikeTimes) == 1
            [~, timestamps, ~] = load_open_ephys_data_faster(fullfile(path_full,'all_channels.events'));
            firing = length(SpikeTimes)/(timestamps(end)-timestamps(1));
        else
            firing = length(SpikeTimes)/(SpikeTimes(end)-SpikeTimes(1));
        end
        
    case 'CentralPortEpoch'
        
        EVSpikes = loadcb(cellid,'EventSpikes');
        TE = loadcb(cellid,'TrialEvents');
        diff_times = TE.CenterPortExit - TE.CenterPortEntry;
        times = EVSpikes.event_stimes{1};
 
        %check up on this
        ntrials = length(TE.CenterPortEntry);
        firing = nan(ntrials,1);
        for trial = 1:ntrials
            firing(trial) = nnz((times{trial} > 0) & (times{trial} < diff_times(trial)))/diff_times(trial);
        end
    otherwise
        disp('error')
end

varargout{1}.(prs.Results.type) = firing;

end