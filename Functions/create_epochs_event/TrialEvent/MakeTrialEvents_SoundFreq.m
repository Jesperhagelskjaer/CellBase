
[DecimalEvents, Timestamps] = OpenEphysEvents2Bpod('all_channels.events');
DecimalEvents(find(diff(Timestamps)<0.00005)+1) = [];
Timestamps(find(diff(Timestamps)<0.00005)+1) = [];
% DecimalEvents(2) = 2;

TrialInx = find(DecimalEvents == 0);
if length(TrialInx) ~= length(SessionData.TrialTypes)
    disp('DecimalEvents 0 do not match with SessionData TrialStart')
    TrialInx = TrialInx(1:length(SessionData.TrialTypes));
end
TrialStates = [];
inx = zeros(1,length(SessionData.RawData.OriginalStateNamesByNumber{1}));
val = cell(1,length(SessionData.RawData.OriginalStateNamesByNumber{1}));

TE = struct;
TE.CenterPortEntry = NaN(1,SessionData.nTrials);
TE.CenterPortExit = NaN(1,SessionData.nTrials);
TE.StimulusOn = NaN(1,SessionData.nTrials);
TE.LeftPortEntry = NaN(1,SessionData.nTrials);
TE.RightPortEntry = NaN(1,SessionData.nTrials);
TE.Correct = NaN(1,SessionData.nTrials);
TE.Error = NaN(1,SessionData.nTrials);
TE.WaterDelivery = NaN(1,SessionData.nTrials);
TE.EarlyWithdrawal = NaN(1,SessionData.nTrials);
TE.LeftPortExit = NaN(1,SessionData.nTrials);
TE.RightPortExit = NaN(1,SessionData.nTrials);
TE.TrialTypes = SessionData.TrialTypes;
TE.Difficulty = SessionData.TrialDiscriminabilities;
TE.StimulusFreq = SessionData.StimulusFrequencies;



for iTrial = 1:SessionData.nTrials
    if iTrial == 1
    TrialStates = [TrialStates SessionData.RawData.OriginalStateNamesByNumber{iTrial}(DecimalEvents(1:TrialInx(iTrial)-1)) 'EndTrial'];
    else
    TrialStates = [TrialStates SessionData.RawData.OriginalStateNamesByNumber{iTrial}(DecimalEvents(TrialInx(iTrial-1)+1:TrialInx(iTrial)-1)) 'EndTrial'];
    end
%     TE.CenterPortEntry(iTrial) = Timestamps(strmatch('NewTrial',TrialStates(TrialInx(iTrial)+1:TrialInx(iTrial+1))));
end
    
    TrialStatesByNumber = NaN(1,length(TrialStates));
    
    TrialStatesByNumber(strmatch('WaitForPoke',TrialStates)) = 1;
    TrialStatesByNumber(strmatch('CueDelay',TrialStates)) = 2;
    TrialStatesByNumber(strncmp('EarlyWithdrawalP...',TrialStates,16)) = 3;
    TrialStatesByNumber(strmatch('DeliverStimulus',TrialStates)) = 4;
    TrialStatesByNumber(strmatch('WaitForResponse',TrialStates)) = 5;
    TrialStatesByNumber(strmatch('WaitForPortOut',TrialStates)) = 6;
    TrialStatesByNumber(strcmp('LeftRewardDelay',TrialStates)) = 7;
    TrialStatesByNumber(strmatch('Punish',TrialStates)) = 8;
    TrialStatesByNumber(strcmp('LeftReward',TrialStates)) = 9;
    TrialStatesByNumber(strmatch('RewardEarlyWithd...',TrialStates)) = 10;
    TrialStatesByNumber(strcmp('RightRewardDelay',TrialStates)) = 11;
    TrialStatesByNumber(strcmp('RightReward',TrialStates)) = 12;
    TrialStatesByNumber(strmatch('Drinking',TrialStates)) = 13;
    TrialStatesByNumber(strcmp('DrinkingGrace',TrialStates)) = 14;
    TrialStatesByNumber(strmatch('Debounce',TrialStates)) = 15;
    TrialStatesByNumber(strmatch('EndTrial',TrialStates)) = 17;
   
     
    TrialEndInx = find(TrialStatesByNumber== 17);
    TrialStart = find(TrialStatesByNumber== 1);
    for iTrial = 1:length(TrialEndInx)    
    TrialStartInx(iTrial) = TrialStart(find(TrialStart < TrialEndInx(iTrial),1,'last'));  
    TrialInx = TrialStartInx(iTrial):TrialEndInx(iTrial);
    TE.CenterPortEntry(iTrial) = Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 1,1,'last'))) ;
    if ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 4))
    TE.CenterPortExit(iTrial) =  Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 4)) ;
    TE.StimulusOn(iTrial) = Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 2,1,'last'))) ;
    elseif ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 3))
    TE.EarlyWithdrawal(iTrial) =  Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 2));        
    end
    
    if ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 9))
        TE.LeftPortEntry(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 5)) ;
        TE.Correct(iTrial) = 1;
        TE.WaterDelivery(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 7)) ;
        TE.LeftPortExit(iTrial) = Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 13,1,'first'))) ;
    elseif ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 8)) && SessionData.TrialTypes(iTrial) == 2
        TE.LeftPortEntry(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 5));
        if isfield(SessionData.RawEvents.Trial{iTrial}.Events,'Port1Out') && SessionData.RawEvents.Trial{iTrial}.Events.Port1Out(end) > SessionData.RawEvents.Trial{iTrial}.States.CueDelay(1)
        PokeOutInx = find(SessionData.RawEvents.Trial{iTrial}.Events.Port1Out > SessionData.RawEvents.Trial{iTrial}.States.CueDelay(1),1,'first');      
        TE.LeftPortExit(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 5))+ (SessionData.RawEvents.Trial{iTrial}.Events.Port1Out(PokeOutInx) - SessionData.RawEvents.Trial{iTrial}.States.WaitForResponse(2));
        TE.Correct(iTrial) = 0;
        end
    end
    
    if ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 12)) && ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 11))
        TE.RightPortEntry(iTrial) = Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 5,1,'last'))) ;
        TE.Correct(iTrial) = 1;
        TE.WaterDelivery(iTrial) = Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 11,1,'last'))) ;
        TE.RightPortExit(iTrial) = Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 13,1,'first'))) ;
    elseif ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 8)) && SessionData.TrialTypes(iTrial) == 1
        TE.RightPortEntry(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 5));
        if isfield(SessionData.RawEvents.Trial{iTrial}.Events,'Port3Out') && SessionData.RawEvents.Trial{iTrial}.Events.Port3Out(end) > SessionData.RawEvents.Trial{iTrial}.States.CueDelay(1)
        PokeOutInx = find(SessionData.RawEvents.Trial{iTrial}.Events.Port3Out > SessionData.RawEvents.Trial{iTrial}.States.CueDelay(1),1,'first'); 
        TE.RightPortExit(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 5))+ (SessionData.RawEvents.Trial{iTrial}.Events.Port3Out(PokeOutInx) - SessionData.RawEvents.Trial{iTrial}.States.WaitForResponse(2));
        TE.Correct(iTrial) = 0;
        end
    end
    
    clear TrialInx PokeOutInx
end 
save TrialEvents TE