function [varargout] = average_firing_rate(cellid,varargin)


%add_analysis(@average_firing_rate,1,'property_names',{'Total_FR'},'arglist',{});
%add_analysis(@average_firing_rate,0,'property_names',{'CentralPortEpoch','Total_FR'},'arglist',{'cells',[1 15 30 45 50]});
%add_analysis(@average_firing_rate,0,'property_names',{'CentralPortEpoch','Total_FR'});

%delanalysis(@average_firing_rate)

persistent f

method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];  
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

for i = 1:numel(method)
    switch method{i}
        case 'Total_FR'
            [name,session,~,~]       = cellid2tags(cellid);
            path_full                = fullfile(f.path,name,session);
            SpikeTimes               = loadcb(cellid,'Spikes');
            if length(SpikeTimes) == 1
                [~, timestamps, ~] = load_open_ephys_data_faster(fullfile(path_full,'all_channels.events'));
                firing             = length(SpikeTimes)/(timestamps(end)-timestamps(1));
            else
                firing             = length(SpikeTimes)/(SpikeTimes(end)-SpikeTimes(1));
            end
            
        case 'CentralPortEpoch'
            
            EVSpikes   = loadcb(cellid,'EventSpikes');
            TE         = loadcb(cellid,'TrialEvents');
            diff_times = TE.CenterPortExit - TE.CenterPortEntry; %The time duraction the animal stays in the centerport 
            times      = EVSpikes.event_stimes{1};
            
            %check up on this
            ntrials = length(TE.CenterPortEntry);
            firing  = nan(ntrials,1);
            for trial = 1:ntrials
                firing(trial) = nnz((times{trial} > 0) & (times{trial} < diff_times(trial)))/diff_times(trial);
            end
        otherwise
            disp('error')
    end
    
    varargout{1}.(method{i}) = firing;
end

end