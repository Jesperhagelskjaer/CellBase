function [varargout] = correlate_events_neurons(cellid,path,varargin)

% created (JH)
% modified 2020-03-05 (JH)
% modified 2020-08-28 (JH)
% [d, timestamps, info] = load_open_ephys_data_faster(sprintf('100_CH%d.continuous',5));
% [ratname,session,tetrode,unit] = cellid2tags(cells(icell));
% calculate waveform correlations of spikes that happen within X ms and Y
% ms periods of light stimulation period. X and Y are set in After and
% Peri Stim parameters
% after

% the code below is not possible to put into a function due to the load is
% used to calculate the length in line 22 (find another method)

% addanalysis_J(@correlate_events_neurons,0,'mandatory',{'D:\recording'},'property_names',{'score','sw'},'arglist',{'fshigh', 300});

% runanalysis(@correlate_events_neurons,'mandatory',{'D:\recording'},'property_names',{'score'},'arglist',{'fshigh', 300});
% delanalysis(@correlate_events_neurons)

global dataW
global CELLIDLIST

%taking out the property name(s) 
idx_p  = find(strcmp(varargin,'property_names'));
method = varargin{idx_p+1};
varargin(idx_p+1) = [];varargin(idx_p)       = [];
varargin = [varargin{:}];

prs = inputParser;
errorMsg = 'Value must be positive, scalar, and numeric.';
validationFcn = @(x) assert(isnumeric(x) && isscalar(x) && (x > 0),errorMsg);
addRequired(prs,'cellid',@(cellid) iscellid((cellid)) || (cellid) == 0)
addRequired(prs,'path',@ischar) %
addParameter(prs,'fshigh',300,validationFcn)
addParameter(prs,'slow',8000,validationFcn)
addParameter(prs,'fs',30000,validationFcn)
addParameter(prs,'PeriStim',0.005,validationFcn)
addParameter(prs,'AfterStim',0.1,validationFcn)
addParameter(prs,'template_lgt',[-15 35],validationFcn)
addParameter(prs,'score',0)

parse(prs,cellid,path,varargin{:})
g = prs.Results;
if (g.cellid == 0)
    varargout{1}.prs = prs;
    return
end

PeriStim     = g.PeriStim; %duda
AfterStim    = g.AfterStim;  %duda
template_lgt = g.template_lgt;
fs           = g.fs;

score        = nan;
sw           = nan;
light        = nan;
MeanSpk      = nan;
counterNLSpk = nan;
counterLMSpk = nan;

try TE = loadcb(cellid,'StimEvents');
    light_bool = 1;
catch; disp('no stimevents');
    light_bool = 0;
end

if light_bool
    idx_neuron = findcellstr(CELLIDLIST',g.cellid); % CELLIDLIST must be column vector
    if idx_neuron > 1
        cellid_2    = CELLIDLIST(idx_neuron-1);
        [r2,s2,t2,~] = cellid2tags(cellid_2{1});
    else
        r2 = '';s2 = '';t2 = -1;
    end
    %%%%%%%%%%%%%Locate the session for each cell and load spiketimes, stimevents andcontinous chan data%%%%%%%
    [r1,s1,t1,~] = cellid2tags(cellid); %tetrode zero-index like cpp
    path = fullfile(g.path,r1,s1);
    
    [channel_start]    = find_number_of_files(path); %when channels start with at 17 but the tetrode will start at 1
    full_name          = fullfile(path,sprintf('100_CH%d.continuous',4*t1+1+channel_start));
    [d, timestamps, ~] = load_open_ephys_data_faster(full_name);
    
    timestamps  = timestamps/30000;
    stimes      = loadcb(cellid);
    stimes      = ceil((stimes - timestamps(1))*fs); %convert it into seconds (s)
    StimEvents  = (TE.BurstOn - timestamps(1))*fs; %convert it into seconds (s)
    
    %%%%%%%%%%%%%%%%%Filter only tetrode channel data and skip processing for already loaded data%%%%%%%%%%%%%%%%
    
    if compare_size_files_folder(path) %-> the files do not have the same size
        if ~strcmp(s1, s2) || t1 ~= t2
            [b1, a1] = butter(3, [g.fshigh/g.fs,g.slow/g.fs]*2, 'bandpass');
            dataW = zeros(length(timestamps),4);
            if 0
                dataW(:,1) = filtfilt(b1, a1, d);
                i = 2;
                for channel = (tetrode*4 + 2 : tetrode*4 + 4)+channel_start  %load only channels that correspond to the tetrode
                    full_name = fullfile(path,sprintf('100_CH%d.continuous',channel));
                    [d, ~, ~] = load_open_ephys_data_faster(full_name);
                    dataW(:,i) = filtfilt(b1, a1, d);
                    i = i + 1;
                end
            elseif 1
                dataW(:,1) = filtfilt(b1, a1, d);
                i = 2;
                for channel = (t1*4 + 2 : t1*4 + 4)+channel_start
                    [d] = load_ch_mex([path,'\'],num2str(channel));
                    d = FiltFiltM(b1, a1, d, 1);
                    
                    %dataW(:,i) = filtfilt(b1, a1, double(d));
                    dataW(:,i) = d;
                    i = i + 1;
                end
                clear d;
            end
        end
        
        %stimes1 = stimes + 5;
        stimes1 = stimes; % (delete -JH)
        if any(strcmp(method,'score'))
            [score, no_light_template, light_template,counterLMSpk,counterNLSpk] = extract_spike_waveform(template_lgt,stimes1,dataW,StimEvents,AfterStim,PeriStim,fs);
        end
        
        if any(strcmp(method,'sw')) || any(strcmp(method,'MeanSpk'))
            [sw,MeanSpk] = extract_spike_width(template_lgt,stimes,dataW,fs);
        end
        %figure_plot_4ch(par,no_light_template,icell,tetrode,'no_light');
        %figure_plot_4ch(par,light_template,icell,tetrode,'light');
        light = {'Y'};
    else
        score        = -90;
        sw           = -90;
        MeanSpk      = -90;
        light        = {'N'};
        counterNLSpk = -90;
        counterLMSpk = -90;
    end
    %figure_plot_4ch(par,MeanSpk,icell,tetrode,'base');
end

if any(strcmp(method,'score'))
    varargout{1}.score   = score;
end
if any(strcmp(method,'sw'))
    varargout{1}.sw      = sw;
end
if any(strcmp(method,'MeanSpk'))
    varargout{1}.MeanSpk = MeanSpk;
end


end






