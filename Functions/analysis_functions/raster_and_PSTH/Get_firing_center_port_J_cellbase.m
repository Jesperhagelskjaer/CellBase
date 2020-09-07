function [firing] = Get_firing_center_port_J_cellbase(cellid,path,rez_name)
%addanalysis(@Get_firing_center_port_J_cellbase,'property_names',{'firing'},'mandatory',{'D:/recording','rezFinalK'})

%delanalysis(@Get_firing_center_port_J_cellbase)

% created (JH) 2020-07-10

prs = inputParser;
addRequired(prs,'cellid',@iscellid) % cell ID
addRequired(prs,'path',@ischar) % cell ID
parse(prs,cellid,path)

[r,s,tetrode,unit] = cellid2tags(prs.Results.cellid);
strSearch = strcat('EVENTSPIKES',num2str(tetrode),'_',num2str(unit),'.mat');
directory = fullfile(prs.Results.path,r,s);

[~, ~, ~, CenterPortExit, CenterPortEntry, ~, ~] = GET_TRIAL_EVENTS_FROM_FILE_EXTENDED(directory);
diff_times = CenterPortExit - CenterPortEntry;

files = dir([directory, '\', 'EVENTSPIKES*']);   

for i = 1:size(files,1)
    if strcmp(files(i,1).name,strSearch)
        fileName = files(i,1).name;
    end
end

fileName = fullfile(directory,fileName);
load(fileName, 'event_stimes'); %loading times

times = event_stimes{1};

%check up on this
ntrials = length(CenterPortEntry);
firing = nan(ntrials,1);
for trial = 1:ntrials
    firing(trial) = nnz((times{trial} > 0) & (times{trial} < diff_times(trial)))/diff_times(trial);
end

end



