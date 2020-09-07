clear all
close all
Trial2Del = 5;
CurrentFolder = cd;
Session = dir;
Session = Session(3:end);
for isess = 1:11
sessionpath = [CurrentFolder '\' Session(isess).name];
[CH, RH, TrialTypes, TrialLength] = Collect_BaitingFactor(sessionpath,Trial2Del);

%initialize the variables  for rewarded switch and stay
RewStay = NaN(1,length(CH));
RewSwitch = NaN(1,length(CH));
NonRewStay = NaN(1,length(CH));
NonRewSwitch = NaN(1,length(CH));

%Shift RH and CH with one place
CH_Shift = [CH(2:end) NaN];
RH_Shift = [RH(2:end) NaN];

%Logicals of stay vs shift
Stay  = CH_Shift == CH;
Switch = CH_Shift ~= CH;

%Stay vs switch after reward
RTrials = abs(RH);

RC_Merge = RH + CH_Shift; % -1:LRLC 0:LRRC 1:RRLC 2:RRRC
RewStay = RTrials == 1 & Stay == 1;
RewSwitch = RTrials == 1 & Stay == 0;
NonRewStay = RTrials == 0 & Stay == 1;
NonRewSwitch = RTrials == 0 & Stay == 0;

for i = 1:3
StayT(i) = nansum(Stay(TrialTypes ==i))/length((Stay(TrialTypes ==i)));  
SwitchT(i) = 1 - StayT(i);
RewStayT(i) = nansum(RewStay(TrialTypes ==i))/sum((RTrials(TrialTypes ==i)));
RewSwitchT(i) = 1-RewStayT(i);
NonRewStayT(i) = nansum(NonRewStay(TrialTypes ==i))/sum( 1 - (RTrials(TrialTypes ==i)));
NonRewSwitchT(i) = 1-NonRewStayT(i);
end



%Plots
figure
subplot(3,1,1);
bar([StayT' SwitchT']);
axis([0.5 3.5 0 1])
subplot(3,1,2);
bar([RewStayT'  RewSwitchT']);
axis([0.5 3.5 0 1])
subplot(3,1,3);
bar([NonRewStayT' NonRewSwitchT']);
axis([0.5 3.5 0 1])


end



