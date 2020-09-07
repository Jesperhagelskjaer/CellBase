function [firing] = Get_firing_center_port(cellid,path)
%addanalysis(@Get_firing_center_port,'property_names',{'CenterPortFiring'},'mandatory',{'O:\ST_Duda\Maria\CellBaseFreeChoiceBaitBlock'})

%delanalysis(@Get_firing_center_port)

% created (JH) 2020-07-10

prs = inputParser;
addRequired(prs,'cellid',@iscellid) % cell ID
addRequired(prs,'path',@ischar) % cell ID
parse(prs,cellid,path)

EVSpikes = loadcb(cellid,'EventSpikes');
TE = loadcb(cellid,'TrialEvents');
diff_times = TE.CenterPortExit - TE.CenterPortEntry;
times = EVSpikes.event_stimes{1};

%check up on this
ntrials = length(CenterPortEntry);
firing = nan(ntrials,1);
for trial = 1:ntrials
    firing(trial) = nnz((times{trial} > 0) & (times{trial} < diff_times(trial)))/diff_times(trial);
end

end



