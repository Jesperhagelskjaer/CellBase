function NUM_newcellids = addnewcells(varargin)
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
    if g.prealign
        for iOld = 1:length(old_cellids) % get the latest events and epochs in the database
            try
                EVENTSPIKES = loadcb(old_cellids(iOld),'EventSpikes');
                behav_events = EVENTSPIKES.events;
                behav_epochs = EVENTSPIKES.epochs;
                break
            catch
            end
        end
        for iOld = 1:length(old_cellids)  % get the latest events and epochs in the database
            try
                STIMSPIKES = loadcb(old_cellids(iOld),'StimSpikes');
                stim_events = STIMSPIKES.events;
                stim_epochs = STIMSPIKES.epochs;
                break
            catch
            end
        end
        for iNuCell = 1:length(new_cellids)
            try
                prealignSpikes(new_cellids(iNuCell),'events',{behav_events},'epochs',{behav_epochs},'filetype','behav')
            catch
            end
            try
                prealignSpikes(new_cellids(iNuCell),'events',{stim_events},'epochs',{stim_epochs},'filetype','stim')
            catch
            end
        end
    end
   
    
    for i = 1:numel(ANALYSES)
        funhandle = ANALYSES(i).funhandle;
        columns   = ANALYSES(i).columns;
        prop      = ANALYSES(i).propnames;
        varg      = struct2cell(ANALYSES(i).parseInput_func);
        
        names = fieldnames(ANALYSES(i).parseInput_func);
        
        input_var = reshape([names(:) varg(:)]',1,[]);                     % combining key and values into a row vector
        for iC = [0 1:NUM_newcellids]                                      % using zero to set the parameter used in the functions              
            if iC > 0
                cellid = new_cellids{iC};
            else
                cellid = 0;
            end    
            addcell(funhandle,cellid,columns,prop,input_var);  
        end   
    end
else   %NUM_newcellids
    disp('No new cells found.')
end

cellbase_fname = getpref('cellbase','fname');
assignin('base','TheMatrix',TheMatrix)
assignin('base','CELLIDLIST',CELLIDLIST)
save(cellbase_fname,'TheMatrix','ANALYSES','CELLIDLIST')

end

