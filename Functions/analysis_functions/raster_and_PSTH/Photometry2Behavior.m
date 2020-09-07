
LeftRewardCount = NaN(1,length(TE));
RightRewardCount = NaN(1,length(TE));
LeftCount = NaN(1,length(TE));
RightCount = NaN(1,length(TE));

inx1 = find(~isnan(TE.LeftRewardON));

for iTrial = inx1  
LeftRewardCount(iTrial) = nanmean(Count(Count(:,1) > TE.LeftPortEntry(iTrial) & Count(:,1) < TE.LeftPortExitFirst(iTrial),2));
end

inx2 = find(isnan(TE.LeftRewardON) & ~isnan(TE.LeftPortEntry) );
clear iTrial 

for iTrial = inx2  
LeftNoRewardCount(iTrial) = nanmean(Count(Count(:,1) > TE.LeftPortEntry(iTrial) & Count(:,1) < TE.LeftPortExitFirst(iTrial),2));
end

inx3 = find(~isnan(TE.RightRewardON));
clear iTrial
for iTrial = inx3  
RightRewardCount(iTrial) = nanmean(Count(Count(:,1) > TE.RightPortEntry(iTrial) & Count(:,1) < TE.RightPortExitFirst(iTrial),2));
end

inx4 = find(isnan(TE.RightRewardON) & ~isnan(TE.RightPortEntry) );
clear iTrial
for iTrial = inx4 
RightNoRewardCount(iTrial) = nanmean(Count(Count(:,1) > TE.RightPortEntry(iTrial) & Count(:,1) < TE.RightPortExitFirst(iTrial),2));
end


LeftReward = LeftRewardCount(inx1);
LeftNoReward = LeftNoRewardCount(inx2);
RightReward = RightRewardCount(inx3);
RightNoReward = RightNoRewardCount(inx4);


figure
plot(LeftReward,'*')
hold on 
plot(LeftNoReward,'*')
figure
plot(RightReward,'*')
hold on 
plot(RightNoReward,'*')