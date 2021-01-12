function [varargout] = template_cleaness(cellid,varargin)


%add_analysis(@template_cleaness,1,'property_names',{'mahal_d','d_isolation'},'arglist',{});
%add_analysis(@template_cleaness,0,'property_names',{'mahal_d','d_isolation'},'arglist',{});
%add_analysis(@template_cleaness,0,'property_names',{'mahal_d','d_isolation'},'arglist',{'cells',[13]});
%add_analysis(@template_cleaness,1,'property_names',{});

%delanalysis(@template_cleaness)

global f
global CELLIDLIST
persistent dataOld

if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'type','bandpass')   % filtering
    addParameter(prs,'direction',2)       % 1 -> forward, 2 -> forward and backswards
    addParameter(prs,'filter',1)          % filtering
    addParameter(prs,'fsslow',8000)       % filtering
    addParameter(prs,'fshigh',300)        % filtering
    addParameter(prs,'fs',30000) %        % the recording system hertz
    addParameter(prs,'order',3) %         % the order of the filter
    addParameter(prs,'useBitmVolt',1)     % converts from bits to volts
    addParameter(prs,'xAxis',[-15 15])    % The range to cut for the template building
    addParameter(prs,'invert',0)          % Invert the electrical signal
    addParameter(prs,'PCA_cut',[-10 24])  % Cutting-range for the PCA
    addParameter(prs,'alignment','min')   % Align each spike to the minimum amplitude
    addParameter(prs,'plotting',1)        % plot the data
    addParameter(prs,'median_filter',1)   % meadian filter used after butterwards filter 
    addParameter(prs,'TT',3)              % number of templates to compare with main template
    addParameter(prs,'spline',1)          % [0/1] spline the spikes    
    addParameter(prs,'purity',1)          % plotting the purity of the the individual cluster
    addParameter(prs,'rezName','rezfinalK')          %blot the shade
    
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

if POS(1) == idx || isempty('dataOld') 
    [dataF,~] = loading_and_preprocessing(r,s,'epysh');
else
    dataF      = dataOld;
end

[NSSD,mahal_d,d_isolation] = building_template_clustering_validation(cellid,dataF);

dataOld       = dataF;

varargout{1}.NSSD        = NSSD;
varargout{1}.mahal_d     = mahal_d;
varargout{1}.d_isolation = d_isolation;
close all
end