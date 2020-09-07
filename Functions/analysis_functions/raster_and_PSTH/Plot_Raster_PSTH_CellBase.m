%%  yapsana

% TrigEvent='BurstOn';
% TrigEvent='StimTime';
% SEvent='BurstOff';
% SEvent='StimTime';
% FNum=1;
% win=[-0.02 0.1];
% parts='all';
% dt=0.001;
% sigma=0.001;
% PSTHstd='on';
% % ShEvent={{'PulseOn','PulseOff','BurstOff'}};
% ShEvent={{'StimTime'}};
% ShEvColors=hsv(length(ShEvent{1}));
% ShEvColors=mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
%  for iCell=  237 %[109 149 99 77 76 69 56 43 48 159 140]%62 69 76 77 99 100 109 112 121 124 140 149 159] %length(allcells)-5:length(allcells) % last 5 cells %23:27
% %     cellid=allcells(1);
%      cellid=allcells(iCell); 
%     try
%         FNum=iCell;
%         viewcell2b(cellid,'TriggerName',TrigEvent,'SortEvent',SEvent,'ShowEvents',ShEvent,'ShowEventsColors',{ShEvColors},...
%         'FigureNum',FNum,'eventtype','stim','window',win,'dt',dt,'sigma',sigma,'PSTHstd',PSTHstd,'Partitions',parts,...
%         'EventMarkerWidth',0,'PlotZeroLine','on')
%          pause(1)
%      catch
%      end
%  end
% 

%% ikincisini de buraya
allcells = listtag('cells');
for icell = 82 %[82 85 90]; %1:length(allcells)
%     try
cellid = allcells(icell);
TrigName = 'CenterPortLightOff'; %'StimulusOn'; %'CuePokeInTime';%'WaterPortIn' 'CuePokeInTimeLast';'CenterPortLightOff'
SEvent =  'CenterPortExit';%'SidePortEntry' ;%'CuePokeInTime';  % 'WaterPortIn' 'CuePokeInTimeLast';
% TE = loadcb(cellid(icell),'TrialEvents');
loadcb(allcells(icell),'TrialEvents')
FNum = icell+2;
BurstPSTH = 'off';
win = [-0.2 0.2];
% parts = {{'#TrialTypes&Correct','#TrialTypes&Error'}}; % '#CueID';
% parts = {{'#Discr:{[1] [2] [3]}&TrialTypes','#Discr:{[1] [2] [3]}&TrialType'}}; % '#CueID';
%   parts = {{'#TrialTypes&Correct'}};
  parts = {{'#TrialTypes:{[1 2]  [ 4 6]}&RightPortOn','#TrialTypes:{[1 2]  [4 6]}&LeftPortOn'}}; % '#CueID';
%   parts = {{'#RightPortOn','#LeftPortOn'}}; % '#CueID';

% % parts = {{'#RewardHist:{ [13] [14] [15] [16]}'}}; % '#CueID';
% parts = {{'#TrialTypes:{[1 2 3 4 5 6]}&RightPortOn','#TrialTypes:{[1 2 3 4 5 6]}&LeftPortOn'}}; % '#CueID';
% parts = {{'#Correct:{[1]}'}};

% parts='#PreviousRewardHistory';
%    parts='all';
%parts='#RewardCue';
isadaptivepsth = 'false';
dt = 0.001;
sigma = 0.005;
PSTHstd = 'off';
 % parts='#WaterValveDur';

%  ShEvent = {{'CenterPortExit','CenterPortEntry','StimulusOn'}};
  ShEvent = {{'CenterPortExit','CenterPortEntry', 'CenterPortLightOff'}};

%ShEvent = {{'CuePokeInTime','CuePokeOutTime','WaterPortIn'}};
%ShEvent={{'TriggerZoneIn','RewardCue','TriggerZoneOut','Zone1FirstEntry','ReminderCue','Zone1FirstExit','WaterValveOn','WaterValveOff','HomeZoneIn','RewardZoneIn'}};
%ShEvent={{'RewardCue','TriggerZoneOut','ReminderCue','WaterValveOff','HomeZoneIn','RewardZoneIn','RewardZoneOut','HomeZoneOut','NextTriggerZoneIn'}};
% ShEvent={{'TriggerZoneIn','TriggerZoneOut'}};
ShEvColors=hsv(length(ShEvent{1}));
ShEvColors=mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
% viewcell2b(cellid,'TriggerName',TrigName,'SortEvent',SEvent,'ShowEvents',ShEvent,'ShowEventsColors',{ShEvColors},...
% 'FigureNum',FNum,'eventtype','event','window',win,'dt',dt,'sigma',sigma,'PSTHstd',PSTHstd,'Partitions',parts,...
% 'EventMarkerWidth',0,'PlotZeroLine','on', BurstPSTH, 'BurstPSTH')
viewcell2b(cellid,'TriggerName',TrigName,'SortEvent',SEvent,'eventtype','behav','ShowEvents',ShEvent,'Partitions',parts,'window',win,'PSTHstd',PSTHstd,'FigureNum',FNum,'dt',dt,'sigma',sigma,'isadaptivepsth',isadaptivepsth)

% clear cellid TE
%      print(figure(icell), '-append', '-dpsc2', 'Darcin.ps');
%     close(figure(icell))
%     end
end

%% 


cellid = pv_all(18);
TrigName = 'PulseOn'; %'StimulusOn'; %'CuePokeInTime';%'WaterPortIn' 'CuePokeInTimeLast';'CenterPortLightOff'
SEvent =  'PulseOn';%'SidePortEntry' ;%'CuePokeInTime';  % 'WaterPortIn' 'CuePokeInTimeLast';
loadcb(cellid,'StimEvents')
BurstPSTH = 'off';
parts='all';
isadaptivepsth = 'false';
dt = 0.001;
sigma = 0.001;
PSTHstd = 'off';
win = [-0.05 0.05];
FNum = 1;

% ShEvColors=hsv(length(ShEvent{1}));
% ShEvColors=mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
viewcell2b(cellid,'TriggerName',TrigName,'SortEvent',SEvent,'eventtype','stim','Partitions',parts,'window',win,'PSTHstd',PSTHstd,'FigureNum',FNum,'dt',dt,'sigma',sigma,'isadaptivepsth',isadaptivepsth)







