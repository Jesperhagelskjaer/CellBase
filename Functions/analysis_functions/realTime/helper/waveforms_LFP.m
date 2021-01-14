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
        
        [wSpikes_RT{idx},template{idx},tSpikes_RT{idx}] = creating_templates_RT(dataF{i},Timestamps{i},TTLs_time,TTLs==j);
        
    end
    
end

end

