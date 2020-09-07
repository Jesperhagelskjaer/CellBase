function [] = check_analysis(funhandle,ANALYSES,g)

[jnk, prevanal] = findanalysis(funhandle,'position');  %#ok<ASGLU> % look for analysis in CellBase
if prevanal
    for i = 1:length(prevanal)
        if isequal(ANALYSES(floor(prevanal(i))).varargin,g.arglist) % analysis already in CellBase
            error('addanalysis:analysisExists','ADDANALYSIS: Analysis already performed in column %d. Delete first.',prevanal(i))
        end
    end
end
end

