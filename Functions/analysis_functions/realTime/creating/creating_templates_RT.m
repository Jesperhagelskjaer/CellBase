function [waveforms,template,tSpikes_RT] = creating_templates_RT(dataF,Timestamps,TTLs_time,TTLs)

global f

xAxis      = (f.xAxis(1):f.xAxis(2))+f.shift;
time_RT    = TTLs_time(TTLs); %one correspond to laserPulse on
waveforms  = zeros(numel(xAxis),32,numel(time_RT));
tSpikes_RT = zeros(numel(time_RT),1);
count = 1;
for i = 1:numel(time_RT)

    %create the timeseries for the block
    indexBlock       = find(time_RT(i) <= Timestamps,1) - 1; %%check to find better way
    if indexBlock > 0
        waveforms(:,:,count) = dataF(xAxis+indexBlock,:); %will create very small 
        tSpikes_RT(i)    = indexBlock;
        count = count + 1;
    end
end

template          = mean(waveforms,3);


end

