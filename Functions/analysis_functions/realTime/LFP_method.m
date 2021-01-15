function [varargout] = LFP_method(cellid,varargin)

%add_analysis(@LFP_method,1,'property_names',{},'arglist',{});
%add_analysis(@LFP_method,0,'property_names',{'test'},'arglist',{});
%add_analysis(@LFP_method,0,'property_names',{},'arglist',{'cells',[2]});
%add_analysis(@LFP_method,1,'property_names',{});

%delanalysis(@LFP_method)

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
    addParameter(prs,'xAxis',[-15 150])    % The range to cut for the template building
    addParameter(prs,'invert',0)          % Invert the electrical signal
    addParameter(prs,'PCA_cut',[-10 24])  % Cutting-range for the PCA
    addParameter(prs,'alignment','min')   % Align each spike to the minimum amplitude
    addParameter(prs,'plotting',1)        % plot the data
    addParameter(prs,'median_filter',1)   % meadian filter used after butterwards filter 
    addParameter(prs,'TT',3)              % number of templates to compare with main template
    addParameter(prs,'spline',1)          % [0/1] spline the spikes    
    addParameter(prs,'TTL',[1 2])         % The TTL for the templates on the Neuralinks system
    addParameter(prs,'shift',-15)         % Since the TTL trigger after the spike happened a shift is need so the axis center on the minimum deflection on the spike
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]    = cellid2tags(cellid);
POS          = findcellpos('animal',r,'session',s);

[dataF{1},timestamps{1}] = loading_and_preprocessing(r,s,'nrd');
R{1} = r;S{1} = s; 
idx          = findcellstr(CELLIDLIST',CELLIDLIST{POS(end)+1}); % CELLIDLIST must be column vector
[r,s,~,~]    = cellid2tags(CELLIDLIST{idx});
[dataF{2},timestamps{2}] = loading_and_preprocessing(r,s,'nrd');

R{2} = r;S{2} = s; 
waveforms_LFP(R,S,dataF,timestamps)

varargout{1}.test = 1

end

