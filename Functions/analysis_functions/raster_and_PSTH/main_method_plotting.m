clc
%clear all
%close all
loadcb

icell        = 82; %[82 85 90]; %1:length(allcells)

TrigName     = {'LeftRewardON','CenterPortExit'}; % The condition that need to be fulfilled 
event        = 'CenterPortEntry';                                   % Where the firing rate is taken from if the condition are met   

viewcell2b_j(CELLIDLIST(icell),TrigName,'trial',1,'splitDataSet',500,'p_lines','p_hlines','event',event)

% input
%'splitDataSet' -> 500 %splitte the data set you are creating the PSTh from [1:500] and [501:end]   (defualt -> none (no split))  
%'trial'        ->   1 %looking at the PS can be in the range of 0 to the the total number of trial (defualt -> 0 (current trial)) 
%'triggerName   -> {'LeftRewardON','RightRewardOFF'}/{'RightRewardOFF'}/'RightRewardOFF'; must be in the SP/TE file (must be provided)) 
% 'p_lines'     -> 'p_vlines'/p_hlines (default p_vlines )



% allcells = listtag('cells');
% for icell = 82 %[82 85 90]; %1:length(allcells)
% %     try
% cellid = allcells(icell);
% TrigName = 'CenterPortEntry'; %'StimulusOn'; %'CuePokeInTime';%'WaterPortIn' 'CuePokeInTimeLast';'CenterPortLightOff'
% SEvent =  'CenterPortExit';%'SidePortEntry' ;%'CuePokeInTime';  % 'WaterPortIn' 'CuePokeInTimeLast';
% % TE = loadcb(cellid(icell),'TrialEvents');
% loadcb(allcells(icell),'TrialEvents')
% FNum = icell+2;
% BurstPSTH = 'off';
% win = [-0.2 0.2];
% % parts = {{'#TrialTypes&Correct','#TrialTypes&Error'}}; % '#CueID';
% % parts = {{'#Discr:{[1] [2] [3]}&TrialTypes','#Discr:{[1] [2] [3]}&TrialType'}}; % '#CueID';
% %   parts = {{'#TrialTypes&Correct'}};
%   parts = {{'#TrialTypes:{[1 2]  [ 4 6]}&RightPortOn','#TrialTypes:{[1 2]  [4 6]}&LeftPortOn'}}; % '#CueID';
% %   parts = {{'#RightPortOn','#LeftPortOn'}}; % '#CueID';
% 
% % % parts = {{'#RewardHist:{ [13] [14] [15] [16]}'}}; % '#CueID';
% % parts = {{'#TrialTypes:{[1 2 3 4 5 6]}&RightPortOn','#TrialTypes:{[1 2 3 4 5 6]}&LeftPortOn'}}; % '#CueID';
% % parts = {{'#Correct:{[1]}'}};
% 
% % parts='#PreviousRewardHistory';
% %    parts='all';
% %parts='#RewardCue';
% isadaptivepsth = 'false';
% dt = 0.001;
% sigma = 0.005;
% PSTHstd = 'off';
%  % parts='#WaterValveDur';
% 
% %  ShEvent = {{'CenterPortExit','CenterPortEntry','StimulusOn'}};
%   ShEvent = {{'CenterPortExit','CenterPortEntry'}};
% 
% %ShEvent = {{'CuePokeInTime','CuePokeOutTime','WaterPortIn'}};
% %ShEvent={{'TriggerZoneIn','RewardCue','TriggerZoneOut','Zone1FirstEntry','ReminderCue','Zone1FirstExit','WaterValveOn','WaterValveOff','HomeZoneIn','RewardZoneIn'}};
% %ShEvent={{'RewardCue','TriggerZoneOut','ReminderCue','WaterValveOff','HomeZoneIn','RewardZoneIn','RewardZoneOut','HomeZoneOut','NextTriggerZoneIn'}};
% % ShEvent={{'TriggerZoneIn','TriggerZoneOut'}};
% ShEvColors=hsv(length(ShEvent{1}));
% ShEvColors=mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
% % viewcell2b(cellid,'TriggerName',TrigName,'SortEvent',SEvent,'ShowEvents',ShEvent,'ShowEventsColors',{ShEvColors},...
% % 'FigureNum',FNum,'eventtype','event','window',win,'dt',dt,'sigma',sigma,'PSTHstd',PSTHstd,'Partitions',parts,...
% % 'EventMarkerWidth',0,'PlotZeroLine','on', BurstPSTH, 'BurstPSTH')
% viewcell2b(cellid,'TriggerName',TrigName,'SortEvent',SEvent,'eventtype','behav','ShowEvents',ShEvent,'Partitions',parts,'window',win,'PSTHstd',PSTHstd,'FigureNum',FNum,'dt',dt,'sigma',sigma,'isadaptivepsth',isadaptivepsth)
% 
% % clear cellid TE
% %      print(figure(icell), '-append', '-dpsc2', 'Darcin.ps');
% %     close(figure(icell))
% %     end
% end