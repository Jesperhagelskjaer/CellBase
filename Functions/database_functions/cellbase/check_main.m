function [NewAnal,columns] = check_main(funhandle,ANALYSES,Lpropnames,CELLIDLIST,TheMatrix,g)

% Is there an identical analysis already?
check_analysis(funhandle,ANALYSES,g)

% Is there an identical property name?
check_property_name(Lpropnames,g)

% Find the position for the new analysis
[lastcolumn,NewAnal] = columns_idx(g,ANALYSES,CELLIDLIST,TheMatrix);

columns = lastcolumn+1:lastcolumn+Lpropnames;  % allocate columns for new properties

end

