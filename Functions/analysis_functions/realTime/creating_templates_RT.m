function [waveforms,template,tSpikes_RT] = creating_templates_RT(dataF,Timestamps,TTLs_time,TTLs)

global f

xAxis      = (f.xAxis_on(1)-f.extra:f.xAxis_on(2)+f.extra)+f.shift;
time_RT    = TTLs_time(TTLs); %one correspond to laserPulse on
waveforms  = zeros(numel(xAxis),32,numel(time_RT));
tSpikes_RT = zeros(numel(time_RT),1);
for i = 1:numel(time_RT)
    %create the timeseries for the block
    indexBlock       = find(time_RT(i) <= Timestamps,1) - 1; %%check to find better way
    waveforms(:,:,i) = dataF(xAxis+indexBlock,:);
    tSpikes_RT(i)    = indexBlock;
end

template          = mean(waveforms,3);

end

