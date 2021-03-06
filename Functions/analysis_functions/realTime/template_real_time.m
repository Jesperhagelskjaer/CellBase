function [varargout] = template_real_time(cellid,varargin)

% 
%add_analysis(@template_real_time,1,0,'property_names',{'confusion','mahal_d','d_isolation'},'arglist',{});
%add_analysis(@template_real_time,0,0,'property_names',{'confusion','mahal_d','d_isolation'},'arglist',{});
%add_analysis(@template_real_time,0,0,'property_names',{'confusion','mahal_d','d_isolation'},'arglist',{});

%delanalysis(@template_real_time)

%comparing the Jsearch template with the closest dsort template in the cellbase
%cellbase -> rt

global f
global CELLIDLIST
global Latent
global Explained
global method
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
    addParameter(prs,'shift',-16)         % Since the TTL trigger after the spike happened a shift is need so the axis center on the minimum deflection on the spike
    addParameter(prs,'xAxis',[-15 15])    % The range to cut for the template building
    addParameter(prs,'invert',0)          % Invert the electrical signal
    addParameter(prs,'PCA_cut',[-10 24])  % Cutting-range for the PCA
    addParameter(prs,'comparison','NCC')  % Which method to compare [NCC/NSSD]
    addParameter(prs,'alignment','min')   % Align each spike to the minimum amplitude
    addParameter(prs,'plotting',1)        % plot the data
    addParameter(prs,'median_filter',1)   % meadian filter used after butterwards filter 
    addParameter(prs,'TT',3)              % number of template from Dsort to compare with Jsearch
    addParameter(prs,'spline',1)          %[0/1] spline the spikes    
    addParameter(prs,'purity',1)          %[0/1] look at the contamination for each cluster on each on
    addParameter(prs,'All',1)             %Looks at all the template where all = f.TT
    addParameter(prs,'shading',1)         %blot the shade
    addParameter(prs,'std_plotting',1)    %The different waveform with
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
POS        = findcellpos('animal',r,'session',s);
[confusion,score,mahal_d,d_isolation] = deal([]);
if POS(1) == findcellstr(CELLIDLIST',cellid) % CELLIDLIST must be column vector
    [dataF,Timestamps] = loading_and_preprocessing(r,s,'nrd');
    if f.purity || f.All
        [Latent,Explained] = random_template_noise(dataF,100000,100);
    end
    [confusion,score,mahal_d, d_isolation]  = building_template_clustering(cellid,dataF,Timestamps);
end
    
varargout{1}.confusion   = confusion;
varargout{1}.score       = score;
varargout{1}.mahal_d     = mahal_d;
varargout{1}.d_isolation = d_isolation;
close all
end


