function addcell(funhandle,cellid,columns,prop,input_var)
%ADDCELL   Add a cell to the database and perform all the analyses.
%   OK = ADDCELL(CELLID) adds the specified cell to the database and
%   performs the analyses. CELLID may also be a cell array of strings.
%   ADDCELL returns 1 if no errors occur and 0 otherwise.
%
%   OK = ADDCELL(CELLID,'QUIET') suppresses text displays.
%
%   See also ADDNEWCELLS.

%   Edit log: JH 2020_10_20

% Input argument check
global TheMatrix
global CELLIDLIST
[property_values] = feval(funhandle,cellid,prop,input_var);  % run analysis

if (cellid  ~= 0)
    idx = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
    for m = 1:numel(prop)
        holder{m} = property_values.(prop{m});
    end
    TheMatrix(idx,columns) = holder;
end
end
