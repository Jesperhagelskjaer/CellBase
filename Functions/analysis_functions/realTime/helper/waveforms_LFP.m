function [area_diff,area_ratio] = waveforms_LFP(r,s,dataF,Timestamps)

global f
idx = 0;
for i = 1:2
    idx = idx + 1;
    fullNameEvent    = fullfile(getpref('cellbase','datapath'),r{i},s{i},'Events.nev');
    [TTLs,TTLs_time] = loadEvent(fullNameEvent);
    TTL_value        = unique(TTLs);
    TTL_value        = TTL_value(ismember(TTL_value,f.TTL));
    
    for j = TTL_value
        [wSpikes{idx},template{idx},tSpikes{idx}] = creating_templates_RT(dataF{i},Timestamps{i},TTLs_time,TTLs==j);
    end
end

end_neuron = 25;
LFP_start  = 60;
end_LFP    = 120
edge = 1:abs(f.xAxis(1))+abs(f.xAxis(2));
for m = 1:2
    neuron = wSpikes{m}(1:end_neuron,:,:);
    LFP    = wSpikes{m}(LFP_start:end_LFP,:,:);
    for i = 1:32
        neuron_ch = squeeze(neuron(:,i,:));
        neuron_LFP = squeeze(LFP(:,i,:));
        for j = 1:size(neuron_ch,2)
            
            Min = squeeze(min(neuron_ch(:,j)));
            Nueron_idx{m}(i,j) = find(Min == neuron_ch(:,j));
            
            Min = squeeze(min(neuron_LFP(:,j)));
            LFP_index{m}(i,j) = find(Min == neuron_LFP(:,j))+LFP_start;
        end
    end
end

for i = 1:32
    figure
    for m = 1:2
        subplot(2,1,m)
        histogram(Nueron_idx{m}(i,:),edge)
        hold on
        histogram(LFP_index{m}(i,:),edge)
    end
end




Max   = max([template{1}(:);template{2}(:)])*1.1;
Min   = min([template{1}(:);template{2}(:)])*1.1;
MaxWS = max([wSpikes{1}(:);wSpikes{2}(:)])*1.1;
MinWS = min([wSpikes{1}(:);wSpikes{2}(:)])*1.1;
lgt = 1:numel(template{1}(:,1));
for ch=1:32
    figure
    hold on
    for i = 1:2
        plot(squeeze(template{i}(:,ch)))
        area(i,ch) = trapz(lgt, abs(template{i}(:,ch)));
    end
    title(['ch - ',num2str(ch)])
    ylim([Min Max])
    if f.useBitmVolt
        ylabel('Amplitude [uV]')
    else
        ylabel('Amplitude [bits]')
    end
    
    xlabel('Time [Samples]')
    figure
    for i = 1:2
        subplot(2,1,i)
        plot(squeeze(wSpikes{i}(:,ch,:)))
        ylim([MinWS MaxWS])
        if i == 1
            title(['ch - ',num2str(ch)])
        end
        if f.useBitmVolt
            ylabel('Amplitude [uV]')
        else
            ylabel('Amplitude [bits]')
        end
    end
end
test = area-area(1,:);
area_diff = mean(test(2,:));
test = area/area(1,:);
area_ratio = mean(test(2,:));

end

