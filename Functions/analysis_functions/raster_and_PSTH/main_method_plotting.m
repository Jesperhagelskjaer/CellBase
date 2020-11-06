clc
%clear all
%close all
loadcb

icell        = 82; %[82 85 90]; %1:length(allcells)
allcells     = listtag('cells');

TrigName     = 'LeftRewardON';

viewcell2b_j(cellid,TrigName,'splitDataSet', 500)

% input
%'splitDataSet' -> 500 %splitte the data set you are creating the PSTh from [1:500] and [501:end]   (defualt -> none (no split))  
%'trial'        ->   1 %looking at the PS can be in the range of 0 to the the total number of trial (defualt -> 0 (current trial)) 
%'triggerName   -> {'LeftRewardON','RightRewardOFF'}/{'RightRewardOFF'}/'RightRewardOFF'; must be in the SP/TE file (must be provided)) 