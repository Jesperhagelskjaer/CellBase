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
    'splitDataSet'          [];
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

data   = TE.(g.TriggerName);
[data] = splitting_data_set(data,g);
name{1}   = g.TriggerName;
for i = 1:size(data,2)
    valid_trial{i}               = ~isnan(data{i}); %(!)
    valid_trial_shift{i}         = circshift(valid_trial{i}', [g.trial 0]);
    stimes{i}                    = SP.event_stimes{trigger_pos}(valid_trial_shift{i} );
    binraster{i}                 = stimes2binraster(stimes{i},time,g.dt); % Calculate binraster
    [~, spsth(:,i), ~]           = binraster2psth_J(binraster{i},g.dt,g.sigma);
    
end

[label_str]                     = label_creating(name,size(spsth,2));
psth_legend{size(spsth,2)}   = [];
figure;
for i = 1:size(data,2)
    Data       = repmat(~logical(binraster{i}), 1, 1, 3); % makes multiple copies of your matrix in 3rd dimension
    subplot(size(data,2)+1,1,i);
    image(0.5:size(binraster{i},2),1:size(binraster{i},1),Data,'CDataMapping','scaled')
    title(label_str{i})
    psth_legend{i} =  strcat(label_str{i});
    set(gca,'XColor', 'none')
end
subplot(size(data,2)+1,1,size(data,2)+1);
plot(time,spsth)
xlim([time(1) time(end)])
ylabel('Rate (Hz)')
xlabel('Time [s]')
legend(psth_legend)



