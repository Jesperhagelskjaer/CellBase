function  [POS ANALnum] = findanalysis(xstr,varargin)
%FINDANALYSIS   Find an analysis in CellBase.
%   POS = FINDANALYSIS(FUN) looks for an analysis function in
%   CellBase and returns matching positions in TheMatrix (0 for no match).
%
%   POS = FINDANALYSIS(PROPNAME) looks for a property in CellBase that
%   matches PROPNAME and returns the column number in TheMatrix of the
%   matching property.
%
%   [POS ANUM] = FINDANALYSIS(FUN) and [POS ANUM] = FINDANALYSIS(PROPNAME)
%   also returns the index of the relevant analysis / property in ANALYSES.
%   For properties the first number in ANUM is the position in the ANALYSES
%   variable and the second represents the position in propnames.
%
%   FINDANALYSIS returns 0 if no analysis or property found.
%
%   See also FINDPROP and ADDANALYSIS.

%   Edit log: BH 3/23/11, 5/3/12

% Get cellbase preferences
global CELLIDLIST ANALYSES TheMatrix
if isempty(CELLIDLIST)
    load(getpref('cellbase','fname'));
end

% Input argument check
try 
   funstr = func2str(xstr);
   fun = 1;    % function handle passed
catch %#ok<*CTCH>
   propstr = lower(xstr);
   fun = 0;     % property name passed
end

% Search among files already added to ANALYSES
ANALnum = [];
PROPnum = [];
for i = 1:length(ANALYSES)
    if fun   % function search
        if strcmpi(funstr,func2str(ANALYSES(i).funhandle))
            ANALnum = [ANALnum; i];   %#ok<AGROW> % found
        end 
    else        % property tag search
        pstr = lower(char(ANALYSES(i).propnames));
        pnum = strmatch(propstr,pstr,'exact');
        if pnum
             ANALnum = [ANALnum; i]; %#ok<AGROW>
             PROPnum = [PROPnum; pnum]; %#ok<AGROW>
        end
    end  % fun
end  % i

% Return with '0' if no match
if isempty(ANALnum)    % nothing found
    disp('FINDANALYSIS: No matching analysis/property found.');
    POS = 0;
    ANALnum = 0;
    return
end
    
% Calculate position (columns)
POS = [];
for i = 1:length(ANALnum)
    n = ANALnum(i);
    if fun
        p = 0;
    else
        p = PROPnum(i);
    end
    if p
        POS = [POS; ANALYSES(n).columns(p)]; %#ok<AGROW>
    else
        POS = [POS; ANALYSES(n).columns(:)]; %#ok<AGROW>
    end
end  % for each anum

% Return property index for properties generated by analyses
if ~fun
    ANALnum = [ANALnum PROPnum];
end