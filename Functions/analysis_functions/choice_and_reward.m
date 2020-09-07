function [varargout] = Choice_and_reward(cellid,path)

%addanalysis(@Choice_and_reward,'property_names',{'CH','RH','Indices_to_erase'},'mandatory',{'D:\recording'})
%addanalysis(@Choice_and_reward,'property_names',{'CH','RH'},'mandatory',{'D:\recording'})
%addanalysis(@Choice_and_reward,'property_names',{'Indices_to_erase'},'mandatory',{'D:\recording'})
%delanalysis(@Choice_and_reward)

%To do
% create check list for CELLIDLIST
% Give the possible to run other name of the bahvior

% created (JH) 2020-07-20
global CELLIDLIST
prs = inputParser;
addRequired(prs,'cellid',@(cellid) iscellid((cellid)) || (cellid) == 0) % cell ID
addRequired(prs,'path',@ischar)   % path to the data
parse(prs,cellid,path)

if (prs.Results.cellid == 0)
    varargout{1}.prs = prs;
    return
end

[r,s,~,~] = cellid2tags(prs.Results.cellid);
idx_neuron = findcellstr(CELLIDLIST',prs.Results.cellid); % CELLIDLIST must be column vector
if idx_neuron > 1
    cellid_2    = CELLIDLIST(idx_neuron-1);
    [r2,s2,~,~] = cellid2tags(cellid_2{1});
else
    r2 = '';s2 = '';
end

directory = fullfile(prs.Results.path,r,s);
number_files = size(dir([directory, '\' '*FreeChoiceDyn*']),1);

if number_files == 1 %if multiple behavior files is not possible to find out which one to take
    if ~(strcmp(r,r2) && strcmp(s,s2))
        TE = loadcb(cellid,'TrialEvents');
        [RH, CH, Indices_to_erase] = Collect_Reward_Choice_History(TE);
        varargout{1}.RH               = single(RH);
        varargout{1}.CH               = single(CH);
        varargout{1}.Indices_to_erase = single(Indices_to_erase);
    else
        varargout{1}.RH               = [];
        varargout{1}.CH               = [];
        varargout{1}.Indices_to_erase = [];
    end
else
    varargout{1}.RH               = nan;
    varargout{1}.CH               = nan;
    varargout{1}.Indices_to_erase = nan;
end

