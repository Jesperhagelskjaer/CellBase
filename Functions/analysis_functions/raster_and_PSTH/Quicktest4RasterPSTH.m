 clear all
 load rezFinalK
 TE =  load('TrialEvents');
% %  TE = load('StimEvents'); 
% %TE =  load('StimEvents');
% %TE = TE_FC;
    [data, timestamps, info] = load_open_ephys_data('all_channels.events');
    [DecimalEvents, Timestamps] = OpenEphysEvents2Bpod('all_channels.events');
 for i = 1 :length(unique(rez.st(:,end)))
     stimes = rez.st((rez.st(:,end)==i),2)/1000;
     stimes = stimes + timestamps(1);

     % DecimalEvents = DecimalEvents(indx);
%    load('TT6_01.mat'); stimes = double(tSpikes)/10000;
 edges = [-0.5:0.01:0.5];


%  stimes = double(tSpikes);
event =  TE.CenterPortEntry; %TE.LeftPortEntry(~isnan(TE.LeftPortEntry)); %(find(TE.Reward==1))*1000;
% event = TE.LeftPortEntry(TE.Reward==1 & ~isnan(TE.LeftPortEntry)); %(find(TE.Reward==1))*1000;
%   inx = find(DecimalEvents ==128); event = Timestamps(inx(1:end-1)+1);
%   event = Timestamps(DecimalEvents==64);% - timestamps(1);
% event = event*30000;
% event = TE.RedON;
% event =  TE.BurstOn;
% event =  TE.RedON;

 Time = length(edges);
 SpikePETH = zeros(Time,1);
 TrialN = length(event);
 SpikeRaster = zeros(TrialN,Time);
 k = 0;
  inx = [];
%  figure
 for iTrial = 1:length(event)
     allspikes = double(stimes) - event(iTrial);
%      inx  = [inx find(allspikes < 60 & allspikes > 0)'];
     spikes = allspikes(allspikes>edges(1) & allspikes < edges(end));
%      for i = 1:length(spikes)
%          hold on
%          line([spikes(i) spikes(i)], [k k+1],'color','k')       
%      end
%      k = k + 1;
          SpikeRaster(iTrial,:) = histc(allspikes,edges);
          SpikePETH = SpikePETH + histc(allspikes,edges);
     clear allspikes
 end

% DT = 0.02;
% SIGMA = 0.05;
% COMP = {[1:TrialN]};
% VALID_TRIALS = 1:TrialN;
% [PSTH, SPSTH, SPSTH_SE] = binraster2psth(SpikeRaster,DT,SIGMA,COMP,VALID_TRIALS);
% stdshade_sorting(SPSTHM , SPSTHSE, 0.3, 'b')
%  figure
%  plot(SPSTH)

% SPSTHM = [SPSTH;SPSTH];
% SPSTHSE = [SPSTH_SE ; SPSTH_SE];

figure
%  subplot(2,1,1)
%  imagesc(-SpikeRaster)
%  colormap('gray')
%  subplot(2,1,2)
%  stdshade_sorting(SPSTHM , SPSTHSE, 0.3, 'b')
 bar(SpikePETH)
 clear stimes
 end


% This function generates Trial Events file for Free Choice task using Bpod
% synchronization 
% [DecimalEvents, Timestamps] = OpenEphysEvents2Bpod('all_channels.events');
% DecimalEvents(find(diff(Timestamps)<0.00005)+1) = [];
% Timestamps(find(diff(Timestamps)<0.00005)+1) = [];
% TrialInx = find(DecimalEvents == 0);
% if length(TrialInx) ~= length(SessionData.TrialTypes)
%     disp('DecimalEvents 0 do not match with SessionData TrialStart')
%     TrialInx = TrialInx(1:length(SessionData.TrialTypes));
% end
% TrialStates = [];
% inx = zeros(1,length(SessionData.RawData.OriginalStateNamesByNumber{1}));
% val = cell(1,length(SessionData.RawData.OriginalStateNamesByNumber{1}));
% 
% TE = struct;
% TE.CenterPortEntry = NaN(1,SessionData.nTrials);
% TE.CenterPortExit = NaN(1,SessionData.nTrials);
% TE.RightPortReward = NaN(1,SessionData.nTrials);
% TE.LeftPortReward = NaN(1,SessionData.nTrials);
% TE.Reward = zeros(1,SessionData.nTrials);
% 
% 
% for iTrial = 1:SessionData.nTrials
%     if iTrial == 1
%     TrialStates = [TrialStates SessionData.RawData.OriginalStateNamesByNumber{iTrial}(DecimalEvents(1:TrialInx(iTrial)-1)) 'EndTrial'];
%     else
%     TrialStates = [TrialStates SessionData.RawData.OriginalStateNamesByNumber{iTrial}(DecimalEvents(TrialInx(iTrial-1)+1:TrialInx(iTrial)-1)) 'EndTrial'];
%     end
% end
%     
%     TrialStatesByNumber = NaN(1,length(TrialStates));
%     
%     TrialStatesByNumber(strmatch('NewTrial',TrialStates)) = 1;
%     TrialStatesByNumber(strmatch('InitialPoke',TrialStates)) = 2;
%     TrialStatesByNumber(strmatch('WaitInCenter',TrialStates)) = 3;
%     TrialStatesByNumber(strmatch('CenterReward',TrialStates)) = 4;
%     TrialStatesByNumber(strmatch('FreeChoice',TrialStates)) = 5;
%     TrialStatesByNumber(strmatch('LeftReward',TrialStates)) = 6;
%     TrialStatesByNumber(strmatch('Drink',TrialStates)) = 7;
%     TrialStatesByNumber(strmatch('RightReward',TrialStates)) = 8;
%     TrialStatesByNumber(strmatch('DrinkingGrace',TrialStates)) = 9;
%     TrialStatesByNumber(strmatch('EndTrial',TrialStates)) = 0;
%      
%     TrialEndInx = find(TrialStatesByNumber== 0);
%     TrialStart = find(TrialStatesByNumber== 1);
%     
%     
%     for iTrial = 1:length(TrialInx)   
%     TrialStartInx(iTrial) = TrialStart(find(TrialStart < TrialEndInx(iTrial),1,'last'));  
%     TrialInx = TrialStartInx(iTrial):TrialEndInx(iTrial);
%     TE.CenterPortEntry(iTrial) = Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 1,1,'last'))) ;
%     if ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 5))
%     TE.CenterPortExit(iTrial) =  Timestamps(TrialInx(find(TrialStatesByNumber(TrialInx) == 4,1,'first'))) ;
%     end
%         
%    
%     if ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 6))
%         TE.LeftPortReward(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 6)) ;
%         TE.Reward(iTrial) = 1;
%     end
% 
% 
%     if ~isempty(TrialInx(TrialStatesByNumber(TrialInx) == 8))
%         TE.RightPortReward(iTrial) = Timestamps(TrialInx(TrialStatesByNumber(TrialInx) == 8)) ;
%         TE.Reward(iTrial) = 1;
%     end
%     
% 
%     
%     clear TrialInx
%     end 

% 
%   save TrialEvents TE

% SpikeCount = [];
% for i = 1:size(SpikeRaster,1)
%     inx = find(SpikeRaster(i,:)>1);
%     SpikeCount = [SpikeCount SpikeRaster(i,inx)];
% end
    