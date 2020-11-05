function viewcell2b_j(cellid,varargin)

% Default arguments
default_args={...
    'window',               [-0.5 1];...
    'dt',                   0.01;...
    'sigma',                0.02;...
    'isadaptive'            false;...
    'FigureNum',            1;...
    'TriggerName',          'PulseOn';...
    'SortEvent',            'PulseOn';...
    'eventtype',             'stim';... % 'behav'
    'ShowEvents',           {{'PulseOn'}};...
    'ShowEventsColors',     {{[0 0.8 0] [0.8 0.8 0] [0 0.8 0.8]}};...
    'Num2Plot',             'all';...
    'PlotDashedEvent',      '';...
    'PlotDashedCondition',  'min';...
    'PSTHPlot',             1;...
    'PSTHlinewidth',        1.5;...
    'DashedLineStyle',      ':';...
    'LastEvents',           '';...
    'Partitions',           'all';...
    'PrintCellID',          'on';...
    'PrintCellIDPos',       'bottom-right';...
    'BurstPSTH'             'off';......
    'trial'                 0;...
    };
[g,error] = parse_args(default_args,varargin{:});

% Check if cellid is valid
if validcellid(cellid,{'list'}) ~= 1
    fprintf('%s is not valid.',cellid);
    return
end


%--------------------------------------------------------------------------
% Preprocessing
%--------------------------------------------------------------------------

% Time
margin = g.sigma * 3;     % add an extra margin to the windows
time = g.window(1)-margin:g.dt:g.window(2)+margin;   % time base array

TE = loadcb(cellid,'TrialEvents');
SP = loadcb(cellid,'EVENTSPIKES');

trigger_pos = findcellstr(SP.events(:,1),g.TriggerName);

% TriggerName mismatch
if trigger_pos == 0
    error('Trigger name not found');
end

valid_trial                  = ~isnan(TE.(g.TriggerName)); %(!)
valid_trial_shift            = circshift(valid_trial', [g.trial 0]);
valid_trial_shift(1:g.trial) = 0;
stimes                       = SP.event_stimes{trigger_pos}(valid_trial_shift);
binraster                    = stimes2binraster(stimes,time,g.dt); % Calculate binraster
[~, spsth, ~]                = binraster2psth_J(binraster,g.dt,g.sigma);

binraster   = ~logical(binraster);
data = repmat(binraster, 1, 1, 3); % makes multiple copies of your matrix in 3rd dimension
figure;
h_s1 = subplot(2,1,1);
image(0.5:size(binraster,2),1:size(binraster,1),data,'CDataMapping','scaled')
set(gca,'box','off')
subplot(2,1,2);
plot(time,spsth)
xlim([time(1) time(end)])
ylabel('Rate (Hz)')
xlabel('Time [s]')




