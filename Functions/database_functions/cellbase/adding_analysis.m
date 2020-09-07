function [ANALYSES] = adding_analysis(ANALYSES,funhandle,g,columns,pargl,property_values,NewAnal)

ANALYSES(NewAnal).funhandle        = funhandle;   % function handle
ANALYSES(NewAnal).varargin         = [g.mandatory pargl(:)'];   % fixed input arguments
ANALYSES(NewAnal).propnames        = g.property_names;   % property names
ANALYSES(NewAnal).output_subset    = g.output_subset;   % out arguments to include
ANALYSES(NewAnal).columns          = columns;   % columns in TheMatrix
ANALYSES(NewAnal).timestamp        = timestamp;   % execution time stamp
ANALYSES(NewAnal).parseInput_func  = property_values.prs.Results;   % execution time stamp
end

