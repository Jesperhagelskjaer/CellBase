function [lastcolumn,NewAnal] = columns_idx(funhandle,g,ANALYSES,CELLIDLIST,TheMatrix)


lastcolumn = 0;
NewAnal    = 0;
if g.add == 1
    NumAnal  = length(ANALYSES);  % number of analyses in CellBase
    NumCells = length(CELLIDLIST);   % % number of cells in CellBase
    NewAnal = NumAnal + 1;  % rank of new analysis
    if NumAnal == 0
        lastcolumn = 0;
    else
        lastcolumn = ANALYSES(NumAnal).columns(end);  % last column in TheMatrix
        [NC, NA] = size(TheMatrix);  %size of TheMatrix
        if (NC ~= NumCells) || (NA ~= lastcolumn)
            error('addanalysis:databaseError','ADDANALYSIS: Internal database inconsistency!')
        end
    end
elseif g.add == 99
    [lastcolumn, prevanal] = findanalysis(funhandle,'position');  %#ok<ASGLU> % look for analysis in CellBase
    lastcolumn = lastcolumn - 1;
    NewAnal = [];
end

end

