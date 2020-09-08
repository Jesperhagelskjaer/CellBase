function [varargout] = Baiting(cellid,varargin)
%add_analysis(@Baiting,'property_names',1,{'BaitingFactor'})

%delanalysis(@Baiting)

% created (JH) 2020-07-10

persistent f

method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

TE = loadcb(cellid,'TrialEvents');
if length(unique(TE.BaitingFactor)) > 1
    BaitingFactor = unique(TE.BaitingFactor);
else
    BaitingFactor = ones(1,3)*unique(TE.BaitingFactor);
end

varargout{1}.BaitingFactor = BaitingFactor;




