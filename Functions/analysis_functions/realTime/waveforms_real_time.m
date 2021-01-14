function [varargout] = waveforms_real_time(cellid,varargin)

%add_analysis(@waveforms_real_time,1,'property_names',{},'arglist',{});
%add_analysis(@waveforms_real_time,0,'property_names',{},'arglist',{});
%add_analysis(@waveforms_real_time,0,'property_names',{},'arglist',{'cells',[13]});
%add_analysis(@waveforms_real_time,1,'property_names',{});

%delanalysis(@waveforms_real_time)

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
    addParameter(prs,'shift',-15)         % Since the TTL trigger after the spike happened a shift is need so the axis center on the minimum deflection on the spike
    addParameter(prs,'xAxis',[-15 15])    % The range to cut for the template building
    addParameter(prs,'invert',0)          % Invert the electrical signal
    addParameter(prs,'plotting',1)        % plot the data
    addParameter(prs,'median_filter',1)   % meadian filter used after butterwards filter 
    addParameter(prs,'TTL',[1 2])         % The TTL for the templates on the Neuralinks system
    addParameter(prs,'ch_validation',1)   %plot only the channels the pass the PCA-noise test uses spline
    addParameter(prs,'spline',1)          %[0/1] spline the spikes 
    addParameter(prs,'PCA_cut',[-10 24])  % Cutting-range for the PCA
    addParameter(prs,'alignment','min')   % Align each spike to the minimum amplitude
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

load_data = 1;
if all(ismember(POS_old, POS)) && ~isempty(dataF)
    load_data = 0;
end

if POS(1) == idx || load_data  
    [dataF,Timestamps] = loading_and_preprocessing(r,s,'nrd');
end

getting_waveforms(cellid,dataF,Timestamps)

varargout{1}.test   = 1;

end

