% run various analysis scripts

cells = listtag('cells');
EpochName1 = 'PostStimulus';
EpochName2 = 'PostStimulus';
SortTrials = {'TrialTypes','Correct'};
% SortTrials = {'LeftPortOn','RightPortOn'};
% SortTrials = [];
 value = {[1 2],[1]};
%  value = {[1],[1]};
N = 10000; % bootstrap value
[Dist P_Val] = ROC_Analysis(cells,EpochName1,EpochName2,SortTrials,value,N);

%% 

inx = size(ANALYSES,2);
 if strcmp(ANALYSES(inx).funhandle,'rocarea_PostStimulusTrialTypes&Correct') == 0;
     %strcmp(ANALYSES(inx).funhandle,'rocarea_PostStimulusLeftvsRight') == 0; %inx == 0     
  ANALYSES(inx+1).funhandle = 'rocarea_PostStimulusTrialTypes&Correct';
%  ANALYSES(inx+1).funhandle = 'rocarea_PrePostStimulus';
 ANALYSES(inx+1).vararging = {'PostStimulusTrialTypes&Correct'};
%  ANALYSES(inx+1).vararging = {'PrePostStimulus'};
 ANALYSES(inx+1).propnames = {'Dist_PostStimulusTrialTypes&Correct,','P_PostStimulusTrialTypes&Correct','nboot = 10000'};
% ANALYSES(inx+1).propnames = {'Dist_PrePostStimulus','P_PrePostStimulus','nboot = 10000'};
ANALYSES(inx+1).columns = [Dist;P_Val];
save(getpref('cellbase','fname'),'TheMatrix','ANALYSES','CELLIDLIST')

end

