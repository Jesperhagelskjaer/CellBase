% This function generates Trial Events file for Simple Free Choice task using Bpod
% synchronization
function MakeTrialEvents_SimpleFreeChoiceFreqDiscr(sessionpath,AquisitionSyst)

cd(sessionpath)

if AquisitionSyst == 'OpenEphys'
[DecimalEvents, Timestamps] = OpenEphysEvents2Bpod_Jane('all_channels.events');
% [DecimalEvents, Timestamps] = OpenEphysEvents2Bpod('all_channels.events');

% get rid of spurious states
MaxNStates = 20;
DecimalEvents(DecimalEvents>MaxNStates)=[];
% DecimalEvents(find(diff(Timestamps)<0.00005)+1) = [];
% Timestamps(find(diff(Timestamps)<0.00005)+1) = [];
elseif  AquisitionSyst == 'Neuralynx'
load events
DecimalEvents = Events_Nttls;
Timestamps = Events_TimeStamps;
inx_0 = find(DecimalEvents ==0);
inx_Disc = [];
for iSp = 1:length(inx_0)-1
    if diff(DecimalEvents(inx_0(iSp):inx_0(iSp)+1)) > 1
        inx_Disc = [inx_Disc inx_0(iSp)];
    end
end
DecimalEvents(inx_Disc) = [];
Timestamps(inx_Disc) = [];
DecimalEvents = DecimalEvents(find(DecimalEvents==1):end);
end

%% test first length of SessionData matches length of DecimalEvents
nTrialEnds = sum(DecimalEvents == 0);
SessionName = dir('*FreeChoice*');
load(SessionName.name)

nT_FC = SessionData.nTrials;


SessionName = dir('*FreqDiscr*');
if size(SessionName,1) == 1 
load(SessionName.name)
nT_FD = SessionData.nTrials;
else
load(SessionName(1).name)    
nT_FD = SessionData.nTrials;
load(SessionName(2).name) 
nT_FD = nT_FD + SessionData.nTrials;
end


if nTrialEnds == nT_FC + nT_FD + 2 % + 2 for openephys +3 for neuralynx

%% simple free choice
TrialEndInx = find(DecimalEvents == 0);
SessionName = dir('*FreeChoice*');
load(SessionName.name)

TE_FC = struct;
TE_FC.TrialTypes = SessionData.TrialTypes;
TE_FC.LeftProbability = SessionData.LeftProbabilities;
TE_FC.RightProbability = SessionData.RightProbabilities;
TE_FC.WaitDelay = SessionData.WaitDelay;
TE_FC.RewardDelay = SessionData.RewardDelay;

% extract states according to decimal events
TrialStates_FC = [];
iT = 1;

for iTSe = 1:SessionData.nTrials
    if iTSe == 1
        TrialStates_FC = [TrialStates_FC SessionData.RawData.OriginalStateNamesByNumber{iTSe}(DecimalEvents(1:TrialEndInx(iT)-1)) 'EndTrial'];
    else
        TrialStates_FC = [TrialStates_FC SessionData.RawData.OriginalStateNamesByNumber{iTSe}(DecimalEvents(TrialEndInx(iT-1)+1:TrialEndInx(iT)-1)) 'EndTrial'];
    end
    iT = iT +1;
end

%for event timestamp extraction
TrialStatesByNumber_FC = NaN(1,length(TrialStates_FC));

TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'NewTrial', length('NewTrial'))) = 1;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'InitialPoke', length('InitialPoke'))) = 2;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'WaitInCenter', length('WaitInCenter'))) = 3;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'WaitReward', length('WaitReward'))) = 4;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'WaitForPortExit', length('WaitForPortExit'))) = 6;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'FreeChoice', length('FreeChoice'))) = 7;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'LeftReward', length('LeftReward'))) = 9;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'LeftRewardDelay', length('LeftRewardDelay'))) = 8; % needs to come after, because otherwise will be replaced by 'LeftReward'
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'RightReward', length('RightReward'))) = 11;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'RightRewardDelay', length('RightRewardDelay'))) = 10; % see above left
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'NoRewardLeft', length('NoRewardLeft'))) = 12;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'NoRewardRight', length('NoRewardRight'))) = 13;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'Drink', length('Drink'))) = 15;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'DrinkingGrace', length('DrinkingGrace'))) = 16;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'LeftInactivated', length('LeftInactivated'))) = 30;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'RightInactivated', length('RightInactivated'))) = 31;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'timeout', length('timeout'))) = 17;
TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'EndTrial', length('EndTrial'))) = 0;

TrialEndInxFC = find(TrialStatesByNumber_FC == 0);
TrialStartInxFC = [1 TrialEndInxFC(1:end-1)+1];

TE_FC.TrialStart = Timestamps(TrialStartInxFC);
TE_FC.TrialEnd = Timestamps(TrialEndInxFC);
TE_FC.CenterPortEntry = NaN(1,SessionData.nTrials);
TE_FC.CenterPortExit = NaN(1,SessionData.nTrials);
TE_FC.EarlyWithdrawalCenter = NaN(1,SessionData.nTrials);
TE_FC.CenterPortRewardON = NaN(1,SessionData.nTrials);
TE_FC.CenterPortRewardOFF = NaN(1,SessionData.nTrials);
TE_FC.LeftPortEntry = NaN(1,SessionData.nTrials);
TE_FC.LeftPortExitFirst = NaN(1,SessionData.nTrials);
TE_FC.LeftPortExitLast = NaN(1,SessionData.nTrials);
TE_FC.LeftRewardON = NaN(1,SessionData.nTrials);
TE_FC.LeftRewardOFF = NaN(1,SessionData.nTrials);
TE_FC.RightPortEntry = NaN(1,SessionData.nTrials);
TE_FC.RightPortExitFirst = NaN(1,SessionData.nTrials);
TE_FC.RightPortExitLast = NaN(1,SessionData.nTrials);
TE_FC.EarlyWithdrawalSide = NaN(1,SessionData.nTrials);
TE_FC.RightRewardON = NaN(1,SessionData.nTrials);
TE_FC.RightRewardOFF = NaN(1,SessionData.nTrials);
TE_FC.Reward = zeros(1,SessionData.nTrials);
TE_FC.NoReward = zeros(1,SessionData.nTrials);


for iTSe = 1:SessionData.nTrials
    
    TrialInxFC = TrialStartInxFC(iTSe):TrialEndInxFC(iTSe);
    TE_FC.CenterPortEntry(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 2,1,'last'))) ;
    
    if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 7)) % 'FreeChoice' exists, no early withdrawal
        
        TE_FC.CenterPortExit(iTSe) =  Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 7,1))) ; % first instance of the state
        TE_FC.CenterPortRewardON(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 4,1))); % for some few trials there are 2 4 states
        TE_FC.CenterPortRewardOFF(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 6));
        
        if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 8)) % 'LeftRewardDelay' exists
            
            TE_FC.LeftPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 8));
            
            if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 9)) % 'LeftReward' exists
                
                TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'first')));
                TE_FC.LeftPortExitLast(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'last')));
                TE_FC.Reward(iTSe) = 1;
                TE_FC.LeftRewardON(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 9));
                TE_FC.LeftRewardOFF(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 15, 1, 'first')));
                
            else % early withdrawal from reward port (leads to end of trial)
                TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                TE_FC.LeftPortExitLast(iTSe) = TE_FC.LeftPortExitFirst(iTSe);
                TE_FC.NoReward(iTSe) = 1;
                TE_FC.EarlyWithdrawalSide(iTSe) = 1;
                
            end
            
        elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 12)) % 'NoRewardLeft' exists
            
            TE_FC.LeftPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 12));
            TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
            TE_FC.LeftPortExitLast(iTSe) = TE_FC.LeftPortExitFirst(iTSe);
            TE_FC.NoReward(iTSe) = 1;
            
        elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 30)) % 'LeftInactivated' exists
            
            TE_FC.LeftPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 30));
            TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
            TE_FC.LeftPortExitLast(iTSe) = TE_FC.LeftPortExitFirst(iTSe);
            TE_FC.NoReward(iTSe) = 1;
            
        elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 10)) % 'RightRewardDelay' exists
            
            TE_FC.RightPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 10));
            
            if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 11)) % 'RightReward' exists
                
                TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'first')));
                TE_FC.RightPortExitLast(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'last')));
                TE_FC.Reward(iTSe) = 1;
                TE_FC.RightRewardON(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 11));
                TE_FC.RightRewardOFF(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 15, 1, 'first')));
                
            else % early withdrawal from reward port (leads to end of trial)
                TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                TE_FC.RightPortExitLast(iTSe) = TE_FC.RightPortExitFirst(iTSe);
                TE_FC.NoReward(iTSe) = 1;
                TE_FC.EarlyWithdrawalSide(iTSe) = 1;
                
            end
            
        elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 13)) % 'NoRewardRight' exists
            
            TE_FC.RightPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 13));
            TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
            TE_FC.RightPortExitLast(iTSe) = TE_FC.RightPortExitFirst(iTSe);
            TE_FC.NoReward(iTSe) = 1;
            
        elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 31)) % 'RightInactivated' exists
            
            TE_FC.RightPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 31));
            TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
            TE_FC.RightPortExitLast(iTSe) = TE_FC.RightPortExitFirst(iTSe);
            TE_FC.NoReward(iTSe) = 1;
            
        else
            TE_FC.NoReward(iTSe) = 1; % 'FreeChoice' state visited, but no choice made
            
        end
        
    else % was an early withdrawal
        TE_FC.CenterPortExit(iTSe) =  Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 17,1,'first')));
        TE_FC.NoReward(iTSe) = 1;
        TE_FC.EarlyWithdrawalCenter(iTSe) = 1;
        
    end
    
end

SidePortEntryFC = NaN(1, SessionData.nTrials);
SidePortEntryFC(~isnan(TE_FC.LeftPortEntry)) = TE_FC.LeftPortEntry(~isnan(TE_FC.LeftPortEntry));
SidePortEntryFC(~isnan(TE_FC.RightPortEntry)) = TE_FC.RightPortEntry(~isnan(TE_FC.RightPortEntry));

TE_FC.ReactionTimes = SidePortEntryFC - TE_FC.CenterPortExit;

SidePortExitLastFC = NaN(1, SessionData.nTrials);
SidePortExitLastFC(~isnan(TE_FC.LeftPortExitLast)) = TE_FC.LeftPortExitLast(~isnan(TE_FC.LeftPortExitLast));
SidePortExitLastFC(~isnan(TE_FC.RightPortExitLast)) = TE_FC.RightPortExitLast(~isnan(TE_FC.RightPortExitLast));

TE_FC.ITI = [NaN TE_FC.CenterPortEntry(2:end) - SidePortExitLastFC(1:end-1)];

% save TrialEvents TE
save([sessionpath filesep 'TrialEvents_FreeChoiceDynMatchRewDelay.mat'],'-struct','TE_FC')

% delete next incomplete trial in DecimalEvents and Timestamps
DecimalEvents(TrialEndInx(iT-1)+1:TrialEndInx(iT)) = [];
Timestamps(TrialEndInx(iT-1)+1:TrialEndInx(iT)) = [];
% re-assign trial starts in decimal events
TrialEndInx = find(DecimalEvents == 0);

%% for frequency discrimination
SessionName = dir('*FreqDiscr*');
load(SessionName.name)

TE_FD = struct;
TE_FD.TrialTypes = SessionData.TrialTypes;
TE_FD.Frequency = SessionData.Freq;
TE_FD.Discriminability = SessionData.Discriminability;
TE_FD.WaitDelay = SessionData.WaitDelay;
TE_FD.RewardDelay = SessionData.RewardDelay;

% extract states according to decimal events
TrialStates_FD = [];

for iTSe = 1:SessionData.nTrials
    
    TrialStates_FD = [TrialStates_FD SessionData.RawData.OriginalStateNamesByNumber{iTSe}(DecimalEvents(TrialEndInx(iT-1)+1:TrialEndInx(iT)-1)) 'EndTrial'];
    iT = iT +1;
end

% if length(DecimalEvents) ~= nTrials
%     DecimalEvents(length(TrialStates_FC)+1:end) = [];
%     Timestamps(nTrials+1:end) = [];
% end

TrialStatesByNumber_FD = NaN(1,length(TrialStates_FD));

TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'NewTrial', length('NewTrial'))) = 1;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'InitialPoke', length('InitialPoke'))) = 2;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'WaitDelay', length('WaitDelay'))) = 3;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'WaitReward', length('WaitReward'))) = 4;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'FreqPresentation', length('FreqPresentation'))) = 5;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'WaitForPortExit', length('WaitForPortExit'))) = 6;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'FreeChoice', length('FreeChoice'))) = 7;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'LeftReward', length('LeftReward'))) = 9;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'LeftRewardDelay', length('LeftRewardDelay'))) = 8; % needs to come after, because otherwise will be replaced by 'LeftReward'
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'RightReward', length('RightReward'))) = 11;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'RightRewardDelay', length('RightRewardDelay'))) = 10; % see above left
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'IncorrTrial', length('IncorrTrial'))) = 14;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'Drink', length('Drink'))) = 15;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'DrinkingGrace', length('DrinkingGrace'))) = 16;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'timeout', length('timeout'))) = 17;
TrialStatesByNumber_FD(strncmp(TrialStates_FD, 'EndTrial', length('EndTrial'))) = 0;

TrialEndInxFD = find(TrialStatesByNumber_FD == 0);
TrialStartInxFD = [1 TrialEndInxFD(1:end-1)+1];

TE_FD.TrialStart = Timestamps(TrialStartInxFD);
TE_FD.TrialEnd = Timestamps(TrialEndInxFD);
TE_FD.CenterPortEntry = NaN(1,SessionData.nTrials);
TE_FD.CenterPortExit = NaN(1,SessionData.nTrials);
TE_FD.EarlyWithdrawalCenter = NaN(1,SessionData.nTrials);
TE_FD.CenterPortRewardON = NaN(1,SessionData.nTrials);
TE_FD.CenterPortRewardOFF = NaN(1,SessionData.nTrials);
TE_FD.FrequencyON = NaN(1,SessionData.nTrials);
TE_FD.FrequencyOFF = NaN(1,SessionData.nTrials);
TE_FD.LeftPortEntry = NaN(1,SessionData.nTrials);
TE_FD.LeftPortExitFirst = NaN(1,SessionData.nTrials);
TE_FD.LeftPortExitLast = NaN(1,SessionData.nTrials);
TE_FD.LeftRewardON = NaN(1,SessionData.nTrials);
TE_FD.LeftRewardOFF = NaN(1,SessionData.nTrials);
TE_FD.RightPortEntry = NaN(1,SessionData.nTrials);
TE_FD.RightPortExitFirst = NaN(1,SessionData.nTrials);
TE_FD.RightPortExitLast = NaN(1,SessionData.nTrials);
TE_FD.RightRewardON = NaN(1,SessionData.nTrials);
TE_FD.RightRewardOFF = NaN(1,SessionData.nTrials);
TE_FD.EarlyWithdrawalSide = NaN(1,SessionData.nTrials);
TE_FD.Reward = zeros(1,SessionData.nTrials);
TE_FD.NoReward = zeros(1,SessionData.nTrials);
TE_FD.IncorrTrial = NaN(1,SessionData.nTrials);

SessionShift = length(TrialStates_FC);

for iTSe = 1:SessionData.nTrials
    
    TrialInxFD = TrialStartInxFD(iTSe):TrialEndInxFD(iTSe);
    TimeInx = (TrialStartInxFD(iTSe):TrialEndInxFD(iTSe)) + SessionShift;
    TE_FD.CenterPortEntry(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 2,1,'last'))) ;
    
    if ~isempty(TrialInxFD(TrialStatesByNumber_FD(TrialInxFD) == 7)) % 'FreeChoice' exists, no early withdrawal
        
        TE_FD.CenterPortExit(iTSe) =  Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 7)) ;
        TE_FD.CenterPortRewardON(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 4));
        TE_FD.CenterPortRewardOFF(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 5));
        TE_FD.FrequencyON(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 5));
        TE_FD.FrequencyOFF(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 6,1))); % first exit
        
        if ~isempty(TrialInxFD(TrialStatesByNumber_FD(TrialInxFD) == 8)) % 'LeftRewardDelay' exists
            
            TE_FD.LeftPortEntry(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 8));
            
            if ~isempty(TrialInxFD(TrialStatesByNumber_FD(TrialInxFD) == 9)) % 'LeftReward' exists
                
                TE_FD.LeftPortExitFirst(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 16, 1, 'first')));
                TE_FD.LeftPortExitLast(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 16, 1, 'last')));
                TE_FD.Reward(iTSe) = 1;
                TE_FD.LeftRewardON(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 9));
                TE_FD.LeftRewardOFF(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 15, 1, 'first')));
                
            else % early withdrawal from reward port (leads to timeout)
                TE_FD.LeftPortExitFirst(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 17));
                TE_FD.LeftPortExitLast(iTSe) = TE_FD.LeftPortExitFirst(iTSe);
                TE_FD.NoReward(iTSe) = 1;
                TE_FD.EarlyWithdrawalSide(iTSe) = 1;
                
            end
            
        elseif ~isempty(TrialInxFD(TrialStatesByNumber_FD(TrialInxFD) == 10)) % 'RightRewardDelay' exists
            
            TE_FD.RightPortEntry(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 10));
            
            if ~isempty(TrialInxFD(TrialStatesByNumber_FD(TrialInxFD) == 11)) % 'RightReward' exists
                
                TE_FD.RightPortExitFirst(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 16, 1, 'first')));
                TE_FD.RightPortExitLast(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 16, 1, 'last')));
                TE_FD.Reward(iTSe) = 1;
                TE_FD.RightRewardON(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 11));
                TE_FD.RightRewardOFF(iTSe) = Timestamps(TimeInx(find(TrialStatesByNumber_FD(TrialInxFD) == 15, 1, 'first')));
                
            else % early withdrawal from reward port (leads to timeout)
                TE_FD.RightPortExitFirst(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 17));
                TE_FD.RightPortExitLast(iTSe) = TE_FD.RightPortExitFirst(iTSe);
                TE_FD.NoReward(iTSe) = 1;
                TE_FD.EarlyWithdrawalSide(iTSe) = 1;
                
            end
            
        elseif ~isempty(TrialInxFD(TrialStatesByNumber_FD(TrialInxFD) == 14)) % 'IncorrTrial' exists
            
            TE_FD.IncorrTrial(iTSe) = 1;
            TE_FD.NoReward(iTSe) = 1;
            
            if TE_FD.TrialTypes(iTSe) == 1 % left would have been correct choice, but visited right
                
                TE_FD.RightPortEntry(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 14));
                TE_FD.RightPortExitFirst(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 0));
                TE_FD.RightPortExitLast(iTSe) = TE_FD.RightPortExitFirst(iTSe);
                
            else % right would have been correct choice, but visited left
                
                TE_FD.LeftPortEntry(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 14));
                TE_FD.LeftPortExitFirst(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 0));
                TE_FD.LeftPortExitLast(iTSe) = TE_FD.LeftPortExitFirst(iTSe);
            end
                 
        else
            TE_FD.NoReward(iTSe) = 1; % 'FreeChoice' state visited, but no choice made
            
        end
        
    else % was an early withdrawal
        TE_FD.CenterPortExit(iTSe) = Timestamps(TimeInx(TrialStatesByNumber_FD(TrialInxFD) == 17));
        TE_FD.NoReward(iTSe) = 1;
        TE_FD.EarlyWithdrawalCenter(iTSe) = 1;
        
    end
    
end

SidePortEntryFD = NaN(1, SessionData.nTrials);
SidePortEntryFD(~isnan(TE_FD.LeftPortEntry)) = TE_FD.LeftPortEntry(~isnan(TE_FD.LeftPortEntry));
SidePortEntryFD(~isnan(TE_FD.RightPortEntry)) = TE_FD.RightPortEntry(~isnan(TE_FD.RightPortEntry));

TE_FD.ReactionTimes = SidePortEntryFD - TE_FD.CenterPortExit;

SidePortExitLastFD = NaN(1, SessionData.nTrials);
SidePortExitLastFD(~isnan(TE_FD.LeftPortExitLast)) = TE_FD.LeftPortExitLast(~isnan(TE_FD.LeftPortExitLast));
SidePortExitLastFD(~isnan(TE_FD.RightPortExitLast)) = TE_FD.RightPortExitLast(~isnan(TE_FD.RightPortExitLast));

TE_FD.ITI = [NaN TE_FD.CenterPortEntry(2:end) - SidePortExitLastFD(1:end-1)];

% save TrialEvents TE
save([sessionpath filesep 'TrialEvents_FreqDiscr.mat'],'-struct','TE_FD')
k = 'something idiotic';
else
    'DecimalEvents do not match SessionData'
end    
