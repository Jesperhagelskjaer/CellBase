function NUM_newcellids = addnewcells_J(varargin)
%ADDNEWCELLS   Add new cells to CellBase.
%   NM = ADDNEWCELLS adds new cells found in Cellbase directory structure
%   to CellBase calling FINDALLCELLS. It calls ADDCELL, which also performs
%   all the analyses. The number of newly added cells is returned.
%
%   NM = ADDNEWCELLS('PREALIGN',TRUE) calls PREALIGNSPIKES.


%   Edit log: JH 2020_10_12
global CELLIDLIST
global TheMatrix
global ANALYSES
% Default arguments
prs = inputParser;
addParameter(prs,'prealign',1,@(s)islogical(s)|ismember(s,[0 1]))   % control whether to run prealignSpikes
addParameter(prs,'dir','',@ischar)   % restrict addnewcells to a directory
addParameter(prs,'overwrite',1)   % restrict addnewcells to a directory
parse(prs,varargin{:})
g = prs.Results;
loadcb

% Find all cells and sort the new ones
if isempty(g.dir)
    all_cellids = findallcells;
else
    all_cellids = findallcells(g.dir);
end
old_cellids = listtag('cells');


if isempty(old_cellids)
    new_cellids = all_cellids;  % setdiff fails for empty set
else
    new_cellids = setdiff(all_cellids,old_cellids);
end
CELLIDLIST = horzcat(CELLIDLIST, new_cellids);
NUM_newcellids = length(new_cellids);


% Add cells; prealign if called that way
if NUM_newcellids > 0
    [name_old,session_old] = deal('');
    for i = 1:length(new_cellids)
        [name,session,~,~]       = cellid2tags(new_cellids(i));
        overwrite = overwrite_checking(g.overwrite,name,session,name_old,session_old);
        %Creating the TrialEvents event file if it does not exist 
        if ~exist(fullfile(getpref('cellbase','datapath'),name,session,'TrialEvents.mat'),'file') || overwrite == 1
            path                = fullfile(getpref('cellbase','datapath'),name,session);
            feval(getpref('cellbase').event,path,'OpenEphys')
        end
        %creating the
        if g.prealign == 1 && exist(fullfile(getpref('cellbase','datapath'),name,session,'TrialEvents.mat'),'file')
            prealignSpikes(new_cellids(i),'FUNdefineEventsEpochs',getpref('cellbase').epoch,'writing_behavior','overwrite')
        end
        [name_old,session_old] = deal(name,session);
    end
else   %NUM_newcellids
    disp('No new cells found.')  
end

%if analyssis alreadu exist in then do the analysis in this matrix
for i = 1:numel(ANALYSES)
    funhandle = ANALYSES(i).funhandle;
    columns   = ANALYSES(i).columns;
    prop      = ANALYSES(i).propnames;
    varg      = struct2cell(ANALYSES(i).parseInput_func);
    
    names = fieldnames(ANALYSES(i).parseInput_func);
    
    input_var = reshape([names(:) varg(:)]',1,[]);                     % combining key and values into a row vector, make smarter
    for iC = [0 1:NUM_newcellids]                                      % using zero to set the parameter used in the functions
        if iC > 0
            cellid = new_cellids{iC};
        else
            cellid = 0;
        end
        addcell(funhandle,cellid,columns,prop,input_var);
    end
end

cellbase_fname = getpref('cellbase','fname');
assignin('base','TheMatrix',TheMatrix)
assignin('base','CELLIDLIST',CELLIDLIST)
save(cellbase_fname,'TheMatrix','ANALYSES','CELLIDLIST')

end

        %MakeTrialEvents_SimpleFreeChoice
%         if exist(fullfile(getpref('cellbase','datapath'),name,session,'TrialEvents.mat'),'file')
%             EVENTSPIKES = loadcb(new_cellids(i),'EventSpikes');
%             behav_events = EVENTSPIKES.events;
%             behav_epochs = EVENTSPIKES.epochs;
%             %prealignSpikes(new_cellids(i),'events',behav_events,'epochs',behav_epochs,'filetype','behav')
%             prealignSpikes(new_cellids(i),'events',behav_events,'epochs',behav_epochs,'filetype','behav','writing_behavior','overwrite')
%         end
               
%         if exist(fullfile(getpref('cellbase','datapath'),name,session,'StimEvents.mat'),'file')       
%             STIMSPIKES = loadcb(new_cellids(i),'StimSpikes');
%             stim_events = STIMSPIKES.events;
%             stim_epochs = STIMSPIKES.epochs;
%             prealignSpikes(new_cellids(i),'events',stim_events,'epochs',stim_epochs,'filetype','stim')
%         end