function [varargout] = neural_activity_behavior(cellid,varargin)

%add_analysis(@neural_activity_behavior,1,'property_names',{'test'},'arglist',{});
%add_analysis(@neural_activity_behavior,0,'property_names',{'test'},'arglist',{});
%add_analysis(@neural_activity_behavior,1,'property_names',{'test'},'arglist',{'cells',[614:650]});
%add_analysis(@neural_activity_behavior,1,'property_names',{});

%delanalysis(@neural_activity_behavior)

global f

if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'xAxis',[-500 500])    % plotting axis [mS]
    addParameter(prs,'plotting',1)          % plot the data
    addParameter(prs,'rezName','rezfinalK') % name of the rez file
    addParameter(prs,'dt',0.01) %
    addParameter(prs,'sigma',0.02)
    addParameter(prs,'sigma_ex',3)
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

PSTH_neural_activity_behavior(cellid)

%varargout{1}.test = 1;

end

