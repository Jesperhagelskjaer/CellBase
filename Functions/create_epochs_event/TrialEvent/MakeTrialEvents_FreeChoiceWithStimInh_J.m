% This function generates Trial Events file for Simple Free Choice task using Bpod
% synchronization
function MakeTrialEvents_FreeChoiceWithStimInh_J(sessionpath,AquisitionSyst)

cd(sessionpath)
SubTrials = 0;
if AquisitionSyst == 'OpenEphys'
    [DecimalEvents, Timestamps] = OpenEphysEvents2Bpod('all_channels.events');
    %     DecimalEvents = [0 DecimalEvents(1:end)];
    %     Timestamps = [Timestamps(1)-0.001 Timestamps(1:end)];
    % if there are stimulation events in the behavioural session
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if sum(DecimalEvents == 64) > 0 && sum(DecimalEvents == 128) > 0
        inx1 = find(DecimalEvents == 64,1,'last') + 2;
        %         inx1 = 2737; % hack remove after done
        
        Timestamps = Timestamps(inx1:end);
        DecimalEvents = DecimalEvents(inx1:end);
        %         DecimalEvents = [DecimalEvents(1:43) 2  DecimalEvents(43:73) 2 DecimalEvents(73:end) ];
        %         Timestamps = [Timestamps(1:43) Timestamps(43) Timestamps(43:73) Timestamps(73)  Timestamps(73:end)   ];
        
        inx2 = find(DecimalEvents == 128,1,'first') - 2;
        Timestamps = Timestamps(1:inx2);
        DecimalEvents = DecimalEvents(1:inx2);
        
        MaxNStates = 16;
        Timestamps(DecimalEvents>MaxNStates)=[]; % dk do it if there are also light stim events before the beh session. m
        DecimalEvents(DecimalEvents>MaxNStates)=[];
        
        
        %         hack  to introduce artificial events if there are some missing
        %         DecimalEvents =  [DecimalEvents(1) 2 DecimalEvents(2:end)];
        %         t = Timestamps(1) + (Timestamps(2) - Timestamps(1))/2;
        %         Timestamps    =  [Timestamps(1) t Timestamps(2:end)];
        
        
    elseif sum(DecimalEvents == 64) > 0
        inx1 = find(DecimalEvents == 64,1,'last') + 2;
        Timestamps = Timestamps(inx1:end);
        DecimalEvents = DecimalEvents(inx1:end);
        
        DecimalEvents(DecimalEvents == 130) = 2; % hack to convert some states that start with light stimulation
        DecimalEvents(DecimalEvents == 131) = 3;
        DecimalEvents(DecimalEvents == 133) = 4;
        DecimalEvents(DecimalEvents == 134) = 5;
        DecimalEvents(DecimalEvents == 135) = 6;
        
        MaxNStates = 16;
        Timestamps(DecimalEvents>MaxNStates)=[]; % dk do it if there are also light stim events before the beh session. m
        DecimalEvents(DecimalEvents>MaxNStates)=[];
        
        %         DecimalEvents([1220:1222]) = [];
        %         Timestamps([1220:1222]) = [];
        
        
    elseif sum(DecimalEvents == 128) > 0
        
        inx1 = find(DecimalEvents == 128,1,'first') - 2;
        Timestamps = Timestamps(1:inx1);
        DecimalEvents = DecimalEvents(1:inx1);
        
        DecimalEvents(DecimalEvents == 130) = 2; % hack to convert some states that start with light stimulation
        DecimalEvents(DecimalEvents == 131) = 3;
        DecimalEvents(DecimalEvents == 133) = 4;
        DecimalEvents(DecimalEvents == 134) = 5;
        DecimalEvents(DecimalEvents == 135) = 6;
        
        MaxNStates = 16;
        Timestamps(DecimalEvents>MaxNStates)=[]; % dk do it if there are also light stim events before the beh session. m
        DecimalEvents(DecimalEvents>MaxNStates)=[];
        
    elseif sum(DecimalEvents >= 130) > 0
        
        DecimalEvents(DecimalEvents == 130) = 2; % hack to convert some states that start with light stimulation
        DecimalEvents(DecimalEvents == 131) = 3;
        DecimalEvents(DecimalEvents == 133) = 4;
        DecimalEvents(DecimalEvents == 134) = 5;
        DecimalEvents(DecimalEvents == 135) = 6;
        MaxNStates = 16;
        Timestamps(DecimalEvents>MaxNStates)=[]; % dk do it if there are also light stim events before the beh session. m
        DecimalEvents(DecimalEvents>MaxNStates)=[];
        
        %       DecimalEvents(28:29)= [];Timestamps(28:29)= []; % hack remove
        %       DecimalEvents(DecimalEvents == 16) = 15; % hack remove
        
    else
        MaxNStates = 16;
        Timestamps(DecimalEvents>MaxNStates)=[]; % dk do it if there are also light stim events before the beh session. m
        DecimalEvents(DecimalEvents>MaxNStates)=[];
        
        %         DecimalEvents(1:6) = [];
        %         Timestamps(1:6) = [];
        %         DecimalEvents =  [DecimalEvents(1) 2 3  DecimalEvents(2:end)];
        %         t = Timestamps(1) + (Timestamps(2) - Timestamps(1))/2;
        %         Timestamps    =  [Timestamps(1) t t  Timestamps(2:end)];
        %
        
    end
    
elseif  AquisitionSyst == 'Neuralynx'
    load events
    DecimalEvents = Events_Nttls;
    Timestamps = Events_TimeStamps;
end


%% test first that length of SessionData matches length of DecimalEvents
nTrialEnds = sum(DecimalEvents == 0);
SessionName = dir('*FreeChoice*');
if length(SessionName) == 1
    load(SessionName(1).name)
    
    % If first trial is corrupted remove it from SessionData
    % SessionData.RawData.OriginalStateNamesByNumber(1) = [];
    % SessionData.RawEvents.Trial(1) = [];
    % SessionData.TrialTypes(1) = [];
    % SessionData.TrialStartTimestamp(1) = [];
    % SessionData.LeftProbabilities(1) = [];
    % SessionData.RightProbabilities(1) = [];
    % SessionData.RewardDelay(1) = [];
    % SessionData.WaitDelay(1) = [];
    % SessionData.Factor(1) = [];
    % SessionData.nTrials = SessionData.nTrials - 1;
    
    nT_FC = SessionData.nTrials;
    
elseif length(SessionName) == 2
    load(SessionName(1).name); S1 = SessionData; clear SessionData;
    load(SessionName(2).name); S2 = SessionData; clear SessionData;
    SessionData.TrialTypes = [S1.TrialTypes S2.TrialTypes];
    SessionData.nTrials = S1.nTrials + S2.nTrials;
    SessionData.RawEvents.Trial = [S1.RawEvents.Trial S2.RawEvents.Trial];
    SessionData.RawData.OriginalStateNamesByNumber = [S1.RawData.OriginalStateNamesByNumber S2.RawData.OriginalStateNamesByNumber];
    SessionData.RawData.OriginalStateData = [S1.RawData.OriginalStateData S2.RawData.OriginalStateData];
    SessionData.RawData.OriginalEventData = [S1.RawData.OriginalEventData S2.RawData.OriginalEventData];
    SessionData.TrialStartTimestamp = [S1.TrialStartTimestamp S2.TrialStartTimestamp];
    SessionData.WaitDelay =   [S1.WaitDelay S2.WaitDelay];
    SessionData.RewardDelay = [S1.RewardDelay S2.RewardDelay];
    SessionData.LeftProbabilities = [S1.LeftProbabilities S2.LeftProbabilities];
    SessionData.RightProbabilities = [S1.RightProbabilities S2.RightProbabilities];
    nT_FC = SessionData.nTrials;
else
    nT_FC = 0;

end


if nTrialEnds == nT_FC - SubTrials  % if only one stimulation /inhibition protocol is applied
    
    
    %% simple free choice
    TrialEndInx = find(DecimalEvents == 0);
    
    TE_FC = struct;
    TE_FC.TrialTypes = SessionData.TrialTypes;
    TE_FC.LeftProbability = SessionData.LeftProbabilities;
    TE_FC.RightProbability = SessionData.RightProbabilities;
    TE_FC.WaitDelay = SessionData.WaitDelay;
    TE_FC.RewardDelay = SessionData.RewardDelay;
    try
        TE_FC.BaitingFactor = SessionData.Factor;
    catch
    end
    
    % extract states according to decimal events
    TrialStates_FC = [];
    for iTSe = 1:SessionData.nTrials - SubTrials
        
        if iTSe == 1
            TrialStates_FC = [TrialStates_FC SessionData.RawData.OriginalStateNamesByNumber{iTSe}(DecimalEvents(1:TrialEndInx(iTSe)-1)) 'EndTrial'];
        else
            TrialStates_FC = [TrialStates_FC SessionData.RawData.OriginalStateNamesByNumber{iTSe}(DecimalEvents(TrialEndInx(iTSe-1)+1:TrialEndInx(iTSe)-1)) 'EndTrial'];
        end
    end
    
    %for event timestamp extraction
    TrialStatesByNumber_FC = NaN(1,length(TrialStates_FC));
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'NewTrial',        length('NewTrial')))         = 1;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'InitialPoke',     length('InitialPoke')))      = 2;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'WaitInCenter',    length('WaitInCenter')))     = 3;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'WaitReward',      length('WaitReward')))       = 4;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'WaitForPortExit', length('WaitForPortExit')))  = 6;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'FreeChoice',      length('FreeChoice')))       = 7;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'LeftReward',      length('LeftReward')))       = 9;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'LeftRewardDelay', length('LeftRewardDelay')))  = 8; % needs to come after, because otherwise will be replaced by 'LeftReward'
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'RightReward',     length('RightReward')))      = 11;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'RightRewardDelay',length('RightRewardDelay'))) = 10; % see above left
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'NoRewardLeft',    length('NoRewardLeft')))     = 12;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'NoRewardRight',   length('NoRewardRight')))    = 13;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'Drink',           length('Drink')))            = 15;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'DrinkingGrace',   length('DrinkingGrace')))    = 16;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'timeout',         length('timeout')))          = 17;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'ITI',             length('ITI')))              = 18;
    TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'EndTrial',        length('EndTrial')))         = 0;
    
    
    %     TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'LeftInactivated', length('LeftInactivated'))) = 30;
    %     TrialStatesByNumber_FC(strncmp(TrialStates_FC, 'RightInactivated', length('RightInactivated'))) = 31;
    
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
    TE_FC.LeftPortOn = NaN(1,SessionData.nTrials);
    TE_FC.RightPortOn = NaN(1,SessionData.nTrials);
    TE_FC.ITI = NaN(1,SessionData.nTrials);
    
    
    
    for iTSe =1:SessionData.nTrials -SubTrials
        
        TrialInxFC = TrialStartInxFC(iTSe):TrialEndInxFC(iTSe);
        
        %the first trial is something scewed totally up 
        tt = find(TrialStatesByNumber_FC(TrialInxFC) == 2,1,'first');
        if ~isempty(tt)
            
            TE_FC.CenterPortEntry(iTSe) = Timestamps(TrialInxFC(tt)) ;
            
            if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 7)) && isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 17))  % 'FreeChoice' exists, no early withdrawal
                
                TE_FC.CenterPortExit(iTSe) =  Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 7,1,'first'))) ; % 7 state repeats for few trials
                TE_FC.CenterPortRewardON(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 4,1,'first')));
                if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 6))
                    TE_FC.CenterPortRewardOFF(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 6,1,'last')));
                else
                    TE_FC.CenterPortRewardOFF(iTSe) = NaN;
                end
                if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 8)) % 'LeftRewardDelay' exists
                    TE_FC.LeftPortOn(iTSe) = 1;
                    
                    TE_FC.LeftPortEntry(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 8,1,'first')));
                    
                    if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 9)) % 'LeftReward' exists
                        
                        TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'first')));
                        TE_FC.LeftPortExitLast(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'last')));
                        TE_FC.Reward(iTSe) = 1;
                        TE_FC.LeftRewardON(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 9,1,'first')));
                        TE_FC.LeftRewardOFF(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 15, 1, 'first')));
                        
                    else % early withdrawal from reward port (leads to end of trial)
                        TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                        TE_FC.LeftPortExitLast(iTSe) = TE_FC.LeftPortExitFirst(iTSe);
                        TE_FC.NoReward(iTSe) = 1;
                        TE_FC.EarlyWithdrawalSide(iTSe) = 1;
                        
                    end
                    
                elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 12)) % 'NoRewardLeft' exists
                    
                    TE_FC.LeftPortEntry(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 12,1,'first')));
                    TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                    TE_FC.LeftPortExitLast(iTSe) = TE_FC.LeftPortExitFirst(iTSe);
                    TE_FC.NoReward(iTSe) = 1;
                    
                    %             elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 30)) % 'LeftInactivated' exists
                    %
                    %                 TE_FC.LeftPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 30));
                    %                 TE_FC.LeftPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                    %                 TE_FC.LeftPortExitLast(iTSe) = TE_FC.LeftPortExitFirst(iTSe);
                    %                 TE_FC.NoReward(iTSe) = 1;
                    
                elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 10)) % 'RightRewardDelay' exists
                    
                    TE_FC.RightPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 10));
                    TE_FC.RightPortOn(iTSe) = 1;
                    
                    if ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 11)) % 'RightReward' exists
                        
                        TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'first')));
                        TE_FC.RightPortExitLast(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 16, 1, 'last')));
                        TE_FC.Reward(iTSe) = 1;
                        TE_FC.RightRewardON(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 11,1,'first')));
                        TE_FC.RightRewardOFF(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 15, 1, 'first')));
                        
                    else % early withdrawal from reward port (leads to end of trial)
                        TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                        TE_FC.RightPortExitLast(iTSe) = TE_FC.RightPortExitFirst(iTSe);
                        TE_FC.NoReward(iTSe) = 1;
                        TE_FC.EarlyWithdrawalSide(iTSe) = 1;
                    end
                    
                elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 13)) % 'NoRewardRight' exists
                    
                    TE_FC.RightPortEntry(iTSe) = Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 13, 1, 'first')));
                    TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                    TE_FC.RightPortExitLast(iTSe) = TE_FC.RightPortExitFirst(iTSe);
                    TE_FC.NoReward(iTSe) = 1;
                    
                    %             elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 31)) % 'RightInactivated' exists
                    %
                    %                 TE_FC.RightPortEntry(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 31));
                    %                 TE_FC.RightPortExitFirst(iTSe) = Timestamps(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 0));
                    %                 TE_FC.RightPortExitLast(iTSe) = TE_FC.RightPortExitFirst(iTSe);
                    %                 TE_FC.NoReward(iTSe) = 1;
                    
                else
                    TE_FC.NoReward(iTSe) = 1; % 'FreeChoice' state visited, but no choice made
                    
                end
                
            elseif ~isempty(TrialInxFC(TrialStatesByNumber_FC(TrialInxFC) == 17)) % was an early withdrawal
                TE_FC.CenterPortExit(iTSe) =  Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 17,1,'first')));
                TE_FC.NoReward(iTSe) = 1;
                TE_FC.EarlyWithdrawalCenter(iTSe) = 1;
            else
                TE_FC.CenterPortExit(iTSe) =  Timestamps(TrialInxFC(find(TrialStatesByNumber_FC(TrialInxFC) == 3,1,'last')));
                TE_FC.NoReward(iTSe) = 1;
                TE_FC.EarlyWithdrawalCenter(iTSe) = 1;
            end
        end %(J)
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
    save([sessionpath filesep 'TrialEvents.mat'],'-struct','TE_FC')
    
else
    disp('DecimalEvents do not match SessionData')
end