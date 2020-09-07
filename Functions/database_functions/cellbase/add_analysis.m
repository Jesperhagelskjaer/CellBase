function  add_analysis(funhandle,varargin)
%ADDANALYSIS   Add an analysis to CellBase.
%   ADDANALYSIS(FUNHANDLE) adds an analysis to CellBase with the specified
%   function handle. ADDANALYSIS also executes the analysis function passed
%   by FUNHANDLE on the cells included in CellBase. Note that the analysis
%   specified by FUNHANDLE should take a cell ID as its first input
%   argument.
%
%   ADDANALYSIS(FUNHANDLE,'PROPERTY_NAMES',PR) passes the list of property
%   names (PR, cell array of strings) to ADDANALYSIS. The property name
%   'default' is used if no property names are specified. The first N
%   outputs of the analysis function are used, where N is the number of
%   inserted properties (length of PR).
%
%   ADDANALYSIS(FUNHANDLE,'PROPERTY_NAMES',PR,'OUTPUT_SUBSET',OS) passes
%   the list of property names (PR, cell array of strings) to ADDANALYSIS.
%   The additional input argument OS determines which outputs of the
%   analysis function are included. OS should be a numerical array indexing
%   into the output argument list of the analysis function (integers
%   between 1 and the number of FUNHANDLE output arguments - see NARGOUT).
%   The length of OS should match the number of inserted properties (i.e.
%   the length of PR).
%
%   ADDANALYSIS(FUNHANDLE,'PROPERTY_NAMES',PR,'OUTPUT_SUBSET',OS,'MANDATORY',ARGM,'ARGLIST',ARGVAL)
%   also passes input arguments to FUNHANDLE. Mandatory arguments should be
%   passed in ARGM and parameter-value pairs should be specified in ARGVAL
%   (N-by-2 cell array). These are be passed on to the analysis function.
%
%   Examples:
%   addanalysis(@LRatio2,'property_names',{'ID_PC','Lr_PC'},'arglist',{'fea
%   ture_names' {'WavePC1' 'Energy'}})
%
%   addanalysis(@ultimate_psth,...
%   'mandatory',{'trial' @findAlignEvent_negfeedback_gonogo [-0.6 0.6]},...
%   'property_names',{'FA_psth' 'FA_psth_stats'},'output_subset',[1 6],...
%   'arglist',{'dt',0.001;'display',false;'sigma',0.02;'parts','all';'isadaptive',2;...
%   'event_filter','custom';'filterinput','FalseAlarm==1';'maxtrialno',Inf;...
%   'baselinewin',[-0.5 0];'testwin',[0 0.5];'relative_threshold',0.1});
%
%   See also FINDANALYSIS.

%   Edit log: AK 11/06, BH 3/24/11, 12/6/12, 5/16/13

% Input arguments
prs = inputParser;
addRequired(prs,'funhandle',@(s)isa(s,'function_handle'))   % function handle
addOptional(prs,'add',1)
addParameter(prs,'property_names','default',@(s)ischar(s)|iscellstr(s))   % output argument names
addParameter(prs,'mandatory',{},@iscell)   % mandatory input arguments
addParameter(prs,'arglist',{},@iscell)   % input arguments parameter-value pairs
addParameter(prs,'output_subset',[],@isnumeric)   % use a subset of output arguments
parse(prs,funhandle,'add',varargin{:})
g = prs.Results;

global CELLIDLIST
global TheMatrix
global ANALYSES

% Load CellBase preferences
load(getpref('cellbase','fname'));

Lpropnames = length(g.property_names);   % number of property names

% Is there an identical analysis already?
check_analysis(funhandle,ANALYSES,g)

% Is there an identical property name?
check_property_name(Lpropnames,g)

% Find the position for the new analysis
[lastcolumn,NewAnal] = columns_idx(ANALYSES,CELLIDLIST,TheMatrix);

columns = lastcolumn+1:lastcolumn+Lpropnames;  % allocate columns for new properties
pargl = g.arglist';%The prs_fucntion

%%
% Execute analysis
varargin(1:3) = [];
varargin(find(strcmp(varargin,'mandatory'))) = [];
varargin(find(strcmp(varargin,'arglist')))   = [];
name = 0;
for cellnum = 0:size(TheMatrix,1)   % loop through all cells
    if cellnum > 0
        disp(CELLIDLIST{cellnum})
        name = char(CELLIDLIST{cellnum});
    end
    arglist = [name g.mandatory varargin];  % input arguments for the analysis
    
    %try
    [property_values] = feval(funhandle,arglist{:});  % run analysis
    %catch ME
    %    disp(ME.message)
    %    disp('ADDANALYSIS: Error while executing the analysis function. Adding NaNs.')
    %    property_values = num2cell(nan(1,nout));   % if there is a error in execution, insert a NaN
    %end
    
    if (cellnum == 0)
        [ANALYSES] = adding_analysis(ANALYSES,funhandle,g,columns,pargl,property_values,NewAnal);
    else
        [TheMatrix] = saving_into_dataMatrix(TheMatrix,Lpropnames,property_values,g,cellnum,columns);   
    end
end

% Feedback
name_out(Lpropnames,funhandle,cellnum)

% Return changed variables to workspace & save all
saving_data(TheMatrix,ANALYSES,CELLIDLIST)

%clear global CELLIDLIST ANALYSES TheMatrix






