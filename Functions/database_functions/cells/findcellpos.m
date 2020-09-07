function matches = findcellpos(varargin)
%FINDCELLPOS   Locate animal, session or tetrode positions in CellBase.
%   POS = FINDCELLPOS(CELLID) returns the position of CELLID in
%   CELLIDLIST.
%
%
%   POS = FINDCELLPOS('RAT',RATID,'SESSION',SESSIONID) locates a session in
%   CELLIDLIST.
%
%   POS = FINDCELLPOS('RAT',RATID,'SESSION',SESSIONID,'TETRODE',TET) 
%   locates a tetrode in CELLIDLIST.
%
%   FINDCELLPOS returns the matching position indices in CellBase for a
%   particular animal, session, cell or tetrode.
%
%   See also FINDALLCELLS and ADDCELL.

%   Edit log: JH 03/09/20

% Load CellBase
global CELLIDLIST 
if isempty(CELLIDLIST)
    load(getpref('cellbase','fname'));
end

% Input argument check
N = nargin;
if ~(N==2 || N==4 || N==6)
    argerror;
    return
end

str = varargin{2};
for i = 4:2:N
    str = strcat(str,'_',num2str(varargin{i}));
end

% Look for matches
matches = [];
for i = 1:length(CELLIDLIST)
    if contains(CELLIDLIST{i},str)
       matches = [matches i];
    end
end

% -------------------------------------------------------------------------
function argerror

disp('FINDCELLPOS: There was an error in your arguments.')