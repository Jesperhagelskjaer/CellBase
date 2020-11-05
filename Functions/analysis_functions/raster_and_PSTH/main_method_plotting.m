clc
%clear all
%close all
loadcb

icell = 82; %[82 85 90]; %1:length(allcells)
allcells = listtag('cells');
cellid = allcells(icell);

TrigName = 'LeftRewardON'; %'StimulusOn'; %'CuePokeInTime';%'WaterPortIn' 'CuePokeInTimeLast';'CenterPortLightOff'

viewcell2b_j(cellid,'TriggerName',TrigName,'trial',1)




%viewcell2b_j(cellid,'TriggerName',TrigName)



