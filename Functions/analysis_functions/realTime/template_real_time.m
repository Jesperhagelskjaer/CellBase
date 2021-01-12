function [varargout] = template_real_time(cellid,varargin)


%add_analysis(@template_real_time,1,'property_names',{'confusion','mahal_d','d_isolation'},'arglist',{});
%add_analysis(@template_real_time,0,'property_names',{'confusion','mahal_d','d_isolation'},'arglist',{});
%add_analysis(@template_real_time,0,'property_names',{'confusion','mahal_d','d_isolation'},'arglist',{'cells',[13]});
%add_analysis(@template_real_time,1,'property_names',{});

%delanalysis(@template_real_time)

global f
global CELLIDLIST

persistent dataF
persistent POS_old


method       = varargin{1};

if (cellid == 0)
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
    addParameter(prs,'TTL',[1 2])         % The TTL for the templates on the Neuralinks system
    addParameter(prs,'shift',-15)         % Since the TTL trigger after the spike happened a shift is need so the axis center on the minimum deflection on the spike
    addParameter(prs,'xAxis',[-15 15])    % The range to cut for the template building
    addParameter(prs,'invert',0)          % Invert the electrical signal
    addParameter(prs,'PCA_cut',[-10 24])  % Cutting-range for the PCA
    addParameter(prs,'alignment','min')   % Align each spike to the minimum amplitude
    addParameter(prs,'plotting',1)        % plot the data
    addParameter(prs,'median_filter',1)   % meadian filter used after butterwards filter 
    addParameter(prs,'TT',3)              % number of template from Dsort to compare with Jsearch
    addParameter(prs,'spline',1)          %[0/1] spline the spikes    
    addParameter(prs,'purity',1)          %[0/1] look at the contamination for each cluster on each on
    addParameter(prs,'shading',1)         %blot the shade
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

error = 0;
load_data = 1;
if all(ismember(POS_old, POS)) && ~isempty(dataW)
    if isnan(dataW(1,1))
        error = 1;
    else
        load_data = 0;
    end
end




[confusion,NSSD,mahal_d,d_isolation] = deal({});

if POS(1) == idx || load_data  
    [dataF,Timestamps] = loading_and_preprocessing(r,s,'csc');
end

%    [confusion,NSSD,mahal_d, d_isolation]   = building_template_clustering(cellid,dataF,Timestamps);
    


varargout{1}.confusion   = confusion;
varargout{1}.NSSD        = NSSD;
varargout{1}.mahal_d     = mahal_d;
varargout{1}.d_isolation = d_isolation;
close all
end


