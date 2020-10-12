function addcell(cellid,idx,varargin)
%ADDCELL   Add a cell to the database and perform all the analyses.
%   OK = ADDCELL(CELLID) adds the specified cell to the database and
%   performs the analyses. CELLID may also be a cell array of strings.
%   ADDCELL returns 1 if no errors occur and 0 otherwise.
%
%   OK = ADDCELL(CELLID,'QUIET') suppresses text displays.
%
%   See also ADDNEWCELLS.

%   Edit log: AK 8/05, BH 3/21/11, 5/20/13, 4/18/14

% Input argument check
global TheMatrix
global ANALYSES

% Perform analyses
for i = 1:numel(ANALYSES)
    
    funhandle = ANALYSES(i).funhandle;
    columns   = ANALYSES(i).columns;
    prop      = ANALYSES(i).propnames;
    varg      = ANALYSES(i).parseInput_func;
    
    names = fieldnames(ANALYSES(i).parseInput_func);
    for m = 0:numel(varg)-1
        input_var{1,m*2+1}    =   names{m+1}; 
        input_var{1,m*2+2}    =   ANALYSES(i).parseInput_func.(names{m+1});
    end
    %clear property_values
    
    [property_values] = feval(funhandle,cellid,prop,input_var);  % run analysis
    
    if (cellid  ~= 0)
        for m = 1:numel(prop)
            holder{m} = property_values.(prop{m});
        end
        TheMatrix(idx,columns) = holder;
    end        
end
