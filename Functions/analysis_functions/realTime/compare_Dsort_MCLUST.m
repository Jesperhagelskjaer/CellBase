function [varargout] = compare_Dsort_MCLUST(cellid,varargin)

%add_analysis(@compare_Dsort_MCLUST,1,'property_names',{'test'},'arglist',{});
%add_analysis(@compare_Dsort_MCLUST,0,'property_names',{'test'},'arglist',{});
%add_analysis(@compare_Dsort_MCLUST,1,'property_names',{'test'},'arglist',{'cells',[614:650]});
%add_analysis(@compare_Dsort_MCLUST,1,'property_names',{});

%delanalysis(@compare_Dsort_MCLUST)
global f

if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'plotting',1)          % plot the data
    addParameter(prs,'rezName','rezfinalK') % name of the rez file

    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end


varargout{1}.test = 1;

end

