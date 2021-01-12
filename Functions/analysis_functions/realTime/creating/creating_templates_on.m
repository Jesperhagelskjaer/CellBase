function [Templates,tSpikes,WSpikes] = creating_templates_on(rez,dataF)

global f

xAxis     = f.xAxis(1):f.xAxis(2);                                       %creating the range to take out 
Templates = zeros(numel(xAxis),32,size(rez.M_template,3));

for i = 1:size(rez.M_template,3)
    
    time            = rez.st(logical(rez.st(:,end) == i),1);
    sWaveforms = zeros(numel(xAxis),32,numel(time));  %if the range is to large for the first spike to be taken out                
    
    %Check the range of the spikes
    if time(1) < abs(xAxis(1)) 
        time(1) = [];
    elseif time(end) < time(end) - abs(xAxis(end)) %if the range is to large for the first spike to be taken out 
        time(end) = [];
    end
    
    for ii = 1:numel(time)
        sWaveforms(:,:,ii) = dataF(xAxis+time(ii),:);
    end
    Templates(:,:,i) = mean(sWaveforms,3);
    tSpikes{i}       = time; %need to be here change code
    WSpikes{i}       = sWaveforms;
end
end

