function [] = waveforms_LFP(r,s,dataF,Timestamps)

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

Max = max([template{1}(:);template{2}(:)])*1.1;
Min = min([template{1}(:);template{2}(:)])*1.1;

for ch=1:32
    figure
    hold on
    for i = 1:2
        plot(squeeze(template{i}(:,ch)))
    end
    title(['ch - ',num2str(ch)])
    ylim([Min Max])
    if f.useBitmVolt
        ylabel('Amplitude [uV]')
    else
        ylabel('Amplitude [bits]')
    end
    xlabel('Time [Samples]')
end


end

