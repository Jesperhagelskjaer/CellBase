function  add_analysis(funhandle,varargin)
%ADDANALYSIS   Add an analysis to CellBase.
%   ADDANALYSIS(FUNHANDLE) adds an analysis to CellBase with the specified
%   function handle. ADDANALYSIS also executes the analysis function passed
%   by FUNHANDLE on the cells included in CellBase. Note that the analysis
%   specified by FUNHANDLE should take a cell ID as its first input
%   argument.

%   Examples:
%   add_analysis(@average_firing_rate,1,'property_names',{'CentralPortEpoch','Total_FR'},'arglist',{'cells',[1 5 500]})

%   See also FINDANALYSIS.

%   Edit log: JH 2020/09/08

% Input arguments
prs = inputParser;
addRequired(prs,'funhandle',@(s)isa(s,'function_handle'))   % function handle
addOptional(prs,'add',1)
addParameter(prs,'property_names','',@(s)ischar(s)|iscellstr(s))   % output argument names
addParameter(prs,'arglist',{},@iscell)   % input arguments parameter-value pairs
parse(prs,funhandle,'add',varargin{:})
g = prs.Results;

global CELLIDLIST
global TheMatrix
global ANALYSES

% Load CellBase preferences
load(getpref('cellbase','fname'));

Lpropnames = length(g.property_names);   % number of property names

[NewAnal,columns] = check_main(funhandle,ANALYSES,Lpropnames,CELLIDLIST,TheMatrix,g);

%% Execute analysis

[arglist,range] = modifying_arg_list(g,CELLIDLIST,varargin{:});
arglist = [0 arglist];
for cellnum = range %
    if cellnum > 0
        disp(CELLIDLIST{cellnum})
        arglist{1} = CELLIDLIST{cellnum};
    end
    
    %try
    [property_values] = feval(funhandle,arglist{:});  % run analysis
    %catch ME
    %    disp(ME.message)
    %    disp('ADDANALYSIS: Error while executing the analysis function. Adding NaNs.')
    %    property_values = num2cell(nan(1,nout));   % if there is a error in execution, insert a NaN
    %end
    if (cellnum  ~= 0)
        for i = 1:Lpropnames %(!)
           holder{i} = property_values.(g.property_names{i});
        end
    else
        prs_value = property_values;
    end
       
    if (cellnum ~= 0 && g.add == 1)
        TheMatrix(cellnum,columns) = holder;
    elseif (cellnum  ~= 0 && g.add == 0)
        print_value(Lpropnames,holder,g)
    end
end

% Feedback
name_out(Lpropnames,funhandle,cellnum,g)

[ANALYSES] = adding_analysis(ANALYSES,funhandle,g,columns,prs_value,NewAnal);
% Return changed variables to workspace & save all
saving_data(g,TheMatrix,ANALYSES,CELLIDLIST)

