function [events,epochs] = defineEventsEpochs_FreeChoice
%DEFINEEVENTSEPOCHS_DEFAULT   Define events and epochs for spike extraction.
%   [EVENTS,EPOCHS] = DEFINEEVENTSEPOCHS_DEFAULT defines events and epochs
%   for spike extraction. 
%
%   EVENTS is a Nx4 cell array with columns corresponding to EventLabel,
%   EventTrigger1, EventTrigger2, Window. EventLabel is the name for
%   referencing the event. EventTrigger1 and EventTrigger2 are names of
%   TrialEvent variables (e.g. 'LeftPortIn'). For fixed windows, the two
%   events are the same; for variable windows, they correspond to the start
%   and end events. Window specifies time offsets relative to the events;
%   e.g. events(1,:) = {'OdorValveOn','OdorValveOn','OdorValveOn',[-3 3]};
%
%   EPOCH is a Nx4 cell array with columns corresponding to  EpochLabel, 
%   ReferenceEvent, Window, RealWindow. EventLabel is the name for 
%   referencing the epoch. ReferenceEvent should match an EventLabel in 
%   EVENTS (used for calculating the epoch rates). RealWindow is currently
%   not implemented (allocated for later versions).
%
%   See also MAKETRIALEVENTS2_GONOGO and DEFINEEVENTSEPOCHS_PULSEON.

%   Edit log: DK 19/01/17

% Define events and epochs
%              EventLabel       EventTrigger1      EventTrigger2      Window
i = 1;
events(i,:) = {'CenterPortEntry',     'CenterPortEntry',      'CenterPortEntry',           [-3 3]};    i = i + 1;
events(i,:) = {'CenterPortExit',      'CenterPortExit',       'CenterPortExit',            [-3 3]};    i = i + 1;
events(i,:) = {'LeftPortEntry',       'LeftPortEntry',        'LeftPortEntry',             [-3 3]};    i = i + 1;
events(i,:) = {'RightPortEntry',      'RightPortEntry',       'RightPortEntry',            [-3 3]};    i = i + 1;
events(i,:) = {'LeftPortExitFirst',        'LeftPortExitFirst',    'LeftPortExitFirst',         [-3 3]};    i = i + 1;
events(i,:) = {'RightPortExitFirst',       'RightPortExitFirst',    'RightPortExitFirst',       [-3 3]};    i = i + 1;
events(i,:) = {'CenterPortLightOff',  'CenterPortRewardOFF',   'CenterPortRewardOFF',      [-3 3]};    i = i + 1;
% events(i,:) = {'SidePortEntry',       'SidePortEntry',         'SidePortEntry',            [-3 3]};    i = i + 1;
% events(i,:) = {'SidePortExit',        'SidePortExit',          'SidePortExit',             [-3 3]};    i = i + 1;
events(i,:) = {'LeftPortExitLast',        'LeftPortExitLast',    'LeftPortExitLast',         [-3 3]};    i = i + 1;
events(i,:) = {'RightPortExitLast',       'RightPortExitLast',    'RightPortExitLast',       [-3 3]};    i = i + 1;
events(i,:) = {'CenterPortRewardON',  'CenterPortRewardON',    'CenterPortRewardON',       [-3 3]};    i = i + 1;
events(i,:) = {'CenterPortRewardOFF', 'CenterPortRewardOFF',   'CenterPortRewardOFF',      [-3 3]};    i = i + 1;
events(i,:) = {'LeftRewardON',       'LeftRewardON',        'LeftRewardON',             [-3 3]};    i = i + 1;
events(i,:) = {'LeftRewardOFF',      'LeftRewardOFF',       'LeftRewardOFF',            [-3 3]};    i = i + 1;
events(i,:) = {'RightRewardON',       'RightRewardON',        'RightRewardON',             [-3 3]};    i = i + 1;
events(i,:) = {'RightRewardOFF',       'RightRewardOFF',        'RightRewardOFF',             [-3 3]};    i = i + 1;





% Variable events
events(i,:) = {'CenterStay',        'CenterPortEntry',             'CenterPortExit',        [-1 1]};    i = i + 1;
events(i,:) = {'RightPortStay',     'RightPortEntry',              'RightPortExit',          [-1 1]};    i = i + 1;
events(i,:) = {'LeftPortStay',      'LeftPortEntry',               'LeftPortExit',          [-1 1]};    i = i + 1;

% Define epochs for rate calculations
%               EpochLabel      ReferenceEvent     Window             RealWindow
i = 1;

epochs(i,:) = {'CenterStay',       'CenterPortLightOff',  [0 0.5],       'FreeChoice'};    i = i + 1;
epochs(i,:) = {'LeftPortStay',     'LeftPortEntry',       [0 0.5],       'LeftPortExit'};  i = i + 1;
epochs(i,:) = {'RightPortStay',    'RightPortEntry',      [0 0.5],        'RightPortExit'};  i = i + 1;

