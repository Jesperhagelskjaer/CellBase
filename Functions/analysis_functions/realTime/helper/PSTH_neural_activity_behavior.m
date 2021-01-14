function PSTH_neural_activity_behavior(cellid)
global f

[r,s,t,n]  = cellid2tags(cellid);
events     = {}; %will need to crate it since matlab have a int. func. called the same, otherwise it will complain in he tittle where events is used
load(fullfile(getpref('cellbase','datapath'),r,s,strcat('EVENTSPIKES',num2str(t),'_',num2str(n),'.mat'))); %load the spikes event for the given neuron


edges1      = (-3+f.dt/2):f.dt:(3-f.dt/2);
edges2      = -3:f.dt:3;
Time        = length(edges1);

for i = 1:numel(event_stimes) %event_stimes -> comes from the load EVENTSPIKES
    
    time = event_stimes{i};
    TrialN      = length(time);
    SpikeRaster = zeros(TrialN,Time);
    
    for iTrial = 1:length(time)
        SpikeRaster(iTrial,:) = histcounts(time{iTrial},edges2);
    end
                          
    [psth, spsth, spsth_se] = binraster2psth(SpikeRaster);
    figure
    stdshade_sorting(psth',[],[],[],[],[],spsth_se')  
end

close all
end
%     PSTH = movmean(mean(SpikeRaster),f.movingMean);
%     Mean = mean(PSTH);
%     idx1 = find(f.xAxis(1)/1000 <= edges2,1,'first');
%     idx2 = find(f.xAxis(2)/1000 >= edges2,1,'last');
%     xAxis = (f.xAxis(1)/1000:step:f.xAxis(2)/1000)*1000;
%     figure
%     hold on
%     plot(xAxis,PSTH(idx1:idx2))
%     plot(xAxis,ones(numel(idx1:idx2),1)*Mean)
%     xlabel('Time [mS]');ylabel('Average spikes');title(events{i,1})
%     ylim([0 max(PSTH)+max(PSTH)/100*3])