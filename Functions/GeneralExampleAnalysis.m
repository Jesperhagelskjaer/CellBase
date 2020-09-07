%%  This script encapsulates functions that are needed to construct TrialEvent file
%   Prealign spikes to Behavioral Events and plot Raster-PSTH


%% initialize cellbase by going through clustered units (Mclust or Kilosort) and 
% generate files with MouseID_SessionID_CellID. This file only stores timestamps. 
% initcb
% %% Choose cellbase you want to work with and load it into working directory
% % each cellbase stores CELLIDLIST ( list of cells), ANALYSIS ( analysis
% % that you peformed on the entire dataset and want to easily retrieve it)
% % and MATRIX that stores for each cell 
% 
% choosecb % choose the right CB from the available list
% loadcb 
% allcells = listtag('cells'); % create allcells varable that stores names of all cells 
% cells = unique_session_cells(allcells); % pull out unique cells for each session
% for iSess = 1:length(cells) % loop through each session and pull behavioral events timestamps from synchronized data on ephys system
% MakeTrialEvents_FreeChoice(cells(iSess)) % store TrialEvents file as a structure arrary for each session
% end

%% prealign spikes to behavioral or light stimulation events
problem_behav_cellid = [];
cellids = listtag('cells');
for iC = 1:length(cellids)
    cellid = cellids(iC);
    try
        %         prealignSpikes(cellid,'FUNdefineEventsEpochs',@defineEventsEpochs_ToneFreq,'filetype','event','ifsave',1,'ifappend',0)
        %         prealignSpikes(cellid,'FUNdefineEventsEpochs',@defineEventsEpochs_Matching,'filetype','event','ifsave',1,'ifappend',0)
        %         prealignSpikes(cellid,'FUNdefineEventsEpochs',@defineEventsEpochs_FreqDiscrimination,'filetype','event','ifsave',1,'ifappend',0)
                  prealignSpikes(cellid,'FUNdefineEventsEpochs',@defineEventsEpochs_FreeChoice,'filetype','event','ifsave',1,'ifappend',0)
%                   prealignSpikes(cellid,'FUNdefineEventsEpochs',@defineEventsEpochs_laserstim_Jane,'filetype','stim','ifsave',1,'ifappend',0)
    catch
        disp('Error in prealignSpikes.'  );
        problem_behav_cellid = [problem_behav_cellid cellid];
    end
end






%% Generate raster-psth for behavioral events
allcells = listtag('cells');
for icell =  200:210 %length(allcells) 795:811
%     try
cellid = allcells(icell);
TrigName = 'CenterPortEntry'; %'StimulusOn'; %'CuePokeInTime';%'WaterPortIn' 'CuePokeInTimeLast';'CenterPortLightOff'
SEvent =  'CenterPortExit';%'SidePortEntry' ;%'CuePokeInTime';  % 'WaterPortIn' 'CuePokeInTimeLast';
% TE = loadcb(cellid,'TrialEvents');
loadcb(cellid,'TrialEvents')
FNum = icell;
BurstPSTH = 'off';
win = [-2 2];
%  parts = {{'#TrialTypes&Correct','#TrialTypes&Error'}}; % '#CueID';
%  parts = {{'#Discr:{[1] [2] [3]}&TrialTypes','#Discr:{[1] [2] [3]}&TrialType'}}; % '#CueID';
%   parts = {{'#TrialTypes&Correct'}};
%   parts = {{'#FreqCat:{[1 2 3]  [3 4 5]}&RightPortOn','#FreqCat:{[1 2 3]  [3 4 5]}&LeftPortOn'}}; % '#CueID';
%    parts = {{'#Reward:{[1]}'}};
% parts = {{'#RewardHist:{ [13] [14] [15] [16]}'}}; % '#CueID';
% parts = {{'#TrialTypes:{[1 2 3 4 5 6]}&RightPortOn','#TrialTypes:{[1 2 3 4 5 6]}&LeftPortOn'}}; % '#CueID';
%   parts = {{'#LeftRewardType:{[60] [61]}&Reward '}};
%   parts = {{'#PrevOptionCategory:{[1] [2] [3] [4] [5]}&Reward '}};
 % parts = {{'#RewardPortStayTimeCat:{ [1 2] [3] [4 5]}'}}; % '#CueID';
 parts = {{'#TrialTypes'}};
% parts = {{'#RightReward', '#LeftReward'}};
%  parts={{'#PrevOptionCategory:{ [1 2] [3] [4 5]}'}};
%      parts='all';
%   parts='#Reward';
isadaptivepsth = 'false';
dt = 0.001;
sigma = 0.05;
PSTHstd = 'off';
% parts='#WaterValveDur';

%  ShEvent = {{'StimulusOn','CenterPortExit','CenterPortEntry'}};
 ShEvent = {{'CenterPortExit','CenterPortEntry', 'CenterPortExit'}};
% ShEvent = {{'CenterPortExit','SidePortExit','SidePortEntry'}};


%ShEvent = {{'CuePokeInTime','CuePokeOutTime','WaterPortIn'}};
%ShEvent={{'TriggerZoneIn','RewardCue','TriggerZoneOut','Zone1FirstEntry','ReminderCue','Zone1FirstExit','WaterValveOn','WaterValveOff','HomeZoneIn','RewardZoneIn'}};
%ShEvent={{'RewardCue','TriggerZoneOut','ReminderCue','WaterValveOff','HomeZoneIn','RewardZoneIn','RewardZoneOut','HomeZoneOut','NextTriggerZoneIn'}};
%ShEvent={{'TriggerZoneIn','TriggerZoneOut'}};
ShEvColors=hsv(length(ShEvent{1}));
ShEvColors=mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
% viewcell2b(cellid,'TriggerName',TrigName,'SortEvent',SEvent,'ShowEvents',ShEvent,'ShowEventsColors',{ShEvColors},...
% 'FigureNum',FNum,'eventtype','event','window',win,'dt',dt,'sigma',sigma,'PSTHstd',PSTHstd,'Partitions',parts,...
% 'EventMarkerWidth',0,'PlotZeroLine','on', BurstPSTH, 'BurstPSTH')
viewcell2b(cellid,'TriggerName',TrigName,'Num2Plot',200,'SortEvent',SEvent,'eventtype','behav','ShowEvents',ShEvent,'Partitions',parts,'window',win,'PSTHstd',PSTHstd,'FigureNum',FNum,'dt',dt,'sigma',sigma,'isadaptivepsth',isadaptivepsth)

% %  clear cellid TE
%       print(figure(icell), '-append', '-dpsc2', 'FreeChoice_D004_RightRewarType1.ps');
%      close(figure(icell))
end


%% 

%initialize variables for raster psth for ligth stimulation events
TrigEvent='BurstOn';
TrigEvent='StimTime';
SEvent='BurstOff';
SEvent='StimTime';
FNum=1;
win=[-0.02 0.1];
parts='all';
dt=0.001;
sigma=0.001;
PSTHstd='on';
% ShEvent={{'PulseOn','PulseOff','BurstOff'}};
ShEvent={{'StimTime'}};
ShEvColors=hsv(length(ShEvent{1}));
ShEvColors=mat2cell(ShEvColors,ones(size(ShEvColors,1),1),3);
 for iCell=  237 %[109 149 99 77 76 69 56 43 48 159 140]%62 69 76 77 99 100 109 112 121 124 140 149 159] %length(allcells)-5:length(allcells) % last 5 cells %23:27
%     cellid=allcells(1);
     cellid=allcells(iCell); 
    try
        FNum=iCell;
        viewcell2b(cellid,'TriggerName',TrigEvent,'SortEvent',SEvent,'ShowEvents',ShEvent,'ShowEventsColors',{ShEvColors},...
        'FigureNum',FNum,'eventtype','stim','window',win,'dt',dt,'sigma',sigma,'PSTHstd',PSTHstd,'Partitions',parts,...
        'EventMarkerWidth',0,'PlotZeroLine','on')
         pause(1)
     catch
     end
 end


%%    

%make trialcode for history
% TE.RewardHist = NaN(1,length(TE.TrialTypes));
% TE.RewardHist(TE.PreviousNoReward==1&TE.NoReward==1&TE.PreviousLeftPortOn==1&TE.LeftPortOn==1)=1;
% TE.RewardHist(TE.PreviousNoReward==1&TE.Reward==1&TE.PreviousLeftPortOn==1&TE.LeftPortOn==1)=2;
% TE.RewardHist(TE.PreviousReward==1&TE.NoReward==1&TE.PreviousLeftPortOn==1&TE.LeftPortOn==1)=3;
% TE.RewardHist(TE.PreviousReward==1&TE.Reward==1&TE.PreviousLeftPortOn==1&TE.LeftPortOn==1)=4;
% TE.RewardHist(TE.PreviousNoReward==1&TE.NoReward==1&TE.PreviousLeftPortOn==1&TE.RightPortOn==1)=5;
% TE.RewardHist(TE.PreviousNoReward==1&TE.Reward==1&TE.PreviousLeftPortOn==1&TE.RightPortOn==1)=6;
% TE.RewardHist(TE.PreviousReward==1&TE.NoReward==1&TE.PreviousLeftPortOn==1&TE.RightPortOn==1)=7;
% TE.RewardHist(TE.PreviousReward==1&TE.Reward==1&TE.PreviousLeftPortOn==1&TE.RightPortOn==1)=8;
% TE.RewardHist(TE.PreviousNoReward==1&TE.NoReward==1&TE.PreviousRightPortOn==1&TE.LeftPortOn==1)=9;
% TE.RewardHist(TE.PreviousNoReward==1&TE.Reward==1&TE.PreviousRightPortOn==1&TE.LeftPortOn==1)=10;
% TE.RewardHist(TE.PreviousReward==1&TE.NoReward==1&TE.PreviousRightPortOn==1&TE.LeftPortOn==1)=11;
% TE.RewardHist(TE.PreviousReward==1&TE.Reward==1&TE.PreviousRightPortOn==1&TE.LeftPortOn==1)=12;
% TE.RewardHist(TE.PreviousNoReward==1&TE.NoReward==1&TE.PreviousRightPortOn==1&TE.RightPortOn==1)=13;
% TE.RewardHist(TE.PreviousNoReward==1&TE.Reward==1&TE.PreviousRightPortOn==1&TE.RightPortOn==1)=14;
% TE.RewardHist(TE.PreviousReward==1&TE.NoReward==1&TE.PreviousRightPortOn==1&TE.RightPortOn==1)=15;
% TE.RewardHist(TE.PreviousReward==1&TE.Reward==1&TE.PreviousRightPortOn==1&TE.RightPortOn==1)=16;


%% delete files from the cellbase or Make trial/stim Events

rootdir = cd;
session = dir;
session = session(3:end);
% for i =  1:18% [8 11 18 21 24 26 27]*
%     sessionpath = [rootdir,'\',session(i).name];
%     MakeTrialEvents_FreeChoiceWithStimInh(sessionpath,'OpenEphys')
% end

for i =  1:length(session)% [8 11 18 21 24 26 27]*
    sessionpath = [rootdir,'\',session(i).name];
    cd(sessionpath)
%      delete *EVENTSPIKES*.mat
%      delete TT*.mat
%      delete TrialEvents.mat
%        delete *STIMSPIKES*.mat
%     delete StimEvents.mat
%     delete TrialEvents_FreeChoiceDynMatch.mat
% MakeTrialEvents_FreeChoiceWithStimInh(sessionpath,'OpenEphys')
% try
%     MakeStimEvents_DK(sessionpath,'OpenEphys')
% catch; disp([sessionpath,'skipped']);
% end
end




