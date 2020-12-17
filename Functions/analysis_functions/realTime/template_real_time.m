function [varargout] = template_real_time(cellid,varargin)


%add_analysis(@template_real_time,0,'property_names',{'confusion'},'arglist',{});
%add_analysis(@template_real_time,0,'property_names',{'confusion'},'arglist',{'cells',[1]});
%add_analysis(@template_real_time,1,'property_names',{});

%delanalysis(@template_real_time)

global f
global CELLIDLIST
method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'type','bandpass')   %
    addParameter(prs,'direction',2)       % 1 -> forward, 2 -> forward and backswards
    addParameter(prs,'filter',1)          %
    addParameter(prs,'fsslow',8000)       % filtering
    addParameter(prs,'fshigh',300)        % filtering
    addParameter(prs,'fs',30000) %        % the recording system hertz
    addParameter(prs,'order',3) %         % the order of the filter
    addParameter(prs,'useBitmVolt',1)     % converts from bits to volts
    addParameter(prs,'TTL',[1 2])         % The TTL for the templates on the Neuralinks system
    addParameter(prs,'xAxis_on',[-12 20]) % 
    addParameter(prs,'shift',-15)         % online time (range should be as small as possible)
    addParameter(prs,'xAxis',[-15 15])    % online time (range should be as small as possible)
    addParameter(prs,'extra',10)          % online time (range should be as small as possible)
    addParameter(prs,'invert',0)          % invert the electrical signal
    addParameter(prs,'PCA_cut',[-10 24])  % cutting range for the PCA
    addParameter(prs,'alignment','min')   % align each spike to the minimum amplitude
    addParameter(prs,'plotting',1)        % plot the data
    addParameter(prs,'median_filter',1)   % meadian filter used after butterwards filter 
    addParameter(prs,'TT',3)              % number of template from Dsort to compare with Jsearch
    addParameter(prs,'spline',1)          %[0/1] spline the spikes    
    addParameter(prs,'purity',1)          %[0/1] look at the contamination for each cluster on each on
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

[confusion,NSSD] = deal({});
if POS(1) == idx
    [dataF,Timestamps] = loading_and_preprocessing(r,s);

    [confusion,NSSD]   = building_template_clustering(cellid,dataF,Timestamps);
    
end

varargout{1}.confusion  = confusion;
varargout{1}.NSSD       = NSSD;
%close all
end


