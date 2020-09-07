function [BaitingFactor] = Baiting(cellid,path)
%addanalysis(@Baiting,'property_names',{'BaitingFactor'},'mandatory',{'O:\ST_Duda\Maria\CellBaseFreeChoiceBaitBlock'})

%delanalysis(@Baiting)

% created (JH) 2020-07-10

prs = inputParser;
addRequired(prs,'cellid',@iscellid) % cell ID
addRequired(prs,'path',@ischar) % cell ID
parse(prs,cellid,path)

TE = loadcb(cellid,'TrialEvents');
if length(unique(TE.BaitingFactor)) > 1
BaitingFactor = unique(TE.BaitingFactor);
else
BaitingFactor = ones(1,3)*unique(TE.BaitingFactor);    
end



