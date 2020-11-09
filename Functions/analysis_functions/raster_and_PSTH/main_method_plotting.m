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