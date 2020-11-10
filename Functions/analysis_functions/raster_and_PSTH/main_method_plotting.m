clc
%clear all
%close all
loadcb

icell        = 82; %[82 85 90]; %1:length(allcells)
TrigName     = {'Reward'}; % The condition that need to be fulfilled 
event        = 'CenterPortEntry';                                   % Where the firing rate is taken from if the condition are met   

viewcell2b(CELLIDLIST(icell),TrigName,'trial',1,'event',event)

%'splitDataSet',500,