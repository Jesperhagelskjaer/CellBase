% This function generates Trial Events file for Simple Free Choice task using Bpod
% synchronization
% TTL for light on is typically 64 or 128 and it marks the start of the
% stimulation not the pulse itself. Pulse comes with 0 and one needs to
% extract it based on the timestamps
function MakeStimEvents_DK(sessionpath,AquisitionSyst)

cd(sessionpath)
if AquisitionSyst == 'OpenEphys'
    % [DecimalEvents, Timestamps] = OpenEphysEvents2Bpod_Jane('all_channels.events');
    [DecimalEvents, Timestamps] = OpenEphysEvents2Bpod('all_channels.events');
    
    if sum(DecimalEvents == 64) > 1 && sum(DecimalEvents == 128) > 1
        TTLON = 64;
        TTLOFF = 0;
        if  Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) < 0.01
            StimTTLON = TTLON;
            StimTTLOFF = TTLOFF;
            InhibTTLON = 128;
            InhibTTLOFF = 0;
        elseif Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) > 0.05
            InhibTTLON = TTLON;
            InhibTTLOFF = TTLOFF;
            StimTTLON = 128;
            StimTTLOFF = 0;
        end
    elseif sum(DecimalEvents == 64) > 1
        TTLON = 64;
        TTLOFF = 0;
        if  Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) < 0.01
            StimTTLON = TTLON;
            StimTTLOFF = TTLOFF;
            InhibTTLON = 130;
            InhibTTLOFF = 134;
        elseif Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) > 0.05
            InhibTTLON = TTLON;
            InhibTTLOFF = TTLOFF;
            StimTTLON = 130;
            StimTTLOFF = 134;
        end
    elseif sum(DecimalEvents == 128) > 1
        TTLON = 128;
        TTLOFF = 0;
        if  Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) < 0.01
            StimTTLON = TTLON;
            StimTTLOFF = TTLOFF;
            InhibTTLON = 130;
            InhibTTLOFF = 134;
        elseif Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) > 0.05
            InhibTTLON = TTLON;
            InhibTTLOFF = TTLOFF;
            StimTTLON = 130;
            StimTTLOFF = 134;
        end
    else
        TTLON =  130;
        TTLOFF = 134;
        if  Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) < 0.01
            StimTTLON = TTLON;
            StimTTLOFF = TTLOFF;
            InhibTTLON = 1000;
        elseif Timestamps(find(DecimalEvents == TTLON,1)+1) - Timestamps(find(DecimalEvents == TTLON,1)) > 0.05
            InhibTTLON = TTLON;
            InhibTTLOFF = TTLOFF;
            StimTTLON = 1000;
            StimTTLOFF = 1000;
        end        
    end
    
    
    inx1 = find(DecimalEvents==StimTTLON); inx1 = inx1(2:end); % to avoid  stim events that happen at the end
    inx2 = inx1 - 1;
    
    StimDecimalEvents = DecimalEvents(inx1:inx2);
    StimTimestamps = Timestamps(inx1:inx2);
    
    inx3 = find(DecimalEvents==InhibTTLON); inx3 = inx3(2:end); 
    inx4 = inx3 - 1;
    
    InhibDecimalEvents = DecimalEvents(inx3:inx4);
    InhibTimestamps = Timestamps(inx3:inx4);
    
%     inx3 = DecimalEvents==InhibTTLON;
    
elseif  AquisitionSyst == 'Neuralynx'
    load events
    DecimalEvents = Events_Nttls;
    Timestamps = Events_TimeStamps;
end


%% identify stimevents based on TTL

% SE = struct;
% SE.BlueON = StimTimestamps(StimDecimalEvents == StimTTLON);
% SE.BlueOFF = StimTimestamps(StimDecimalEvents == StimTTLOFF);
% SE.RedON =  InhibTimestamps(InhibDecimalEvents == InhibTTLON);
% SE.RedOFF =  InhibTimestamps(InhibDecimalEvents == InhibTTLOFF);

SE = struct;
SE.BurstOn = Timestamps(inx2);
SE.BurstOff = Timestamps(inx1);
SE.RedBurstOn =  Timestamps(inx4);
SE.RedBurstOff =  Timestamps(inx3);







% save TrialEvents SE
save([sessionpath filesep 'StimEvents.mat'],'-struct','SE')
