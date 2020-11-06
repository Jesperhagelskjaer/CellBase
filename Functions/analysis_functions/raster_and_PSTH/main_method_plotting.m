clc
%clear all
%close all
loadcb

icell        = 82; %[82 85 90]; %1:length(allcells)
allcells     = listtag('cells');

TrigName     = 'LeftRewardON'; %'StimulusOn'; %'CuePokeInTime';%'WaterPortIn' 'CuePokeInTimeLast';'CenterPortLightOff'

viewcell2b_j(cellid,'TriggerName',TrigName,'trial',1,'splitDataSet',500)

cellid       = allcells(icell);



%features


%'splitDataSet' -> 500 %splitte the data set you are creating the PSTh from [1:500] and [501:end]
%'trial'        ->   1 %looking at the PS
