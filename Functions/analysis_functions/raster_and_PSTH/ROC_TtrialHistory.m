% clear all
loadspikes = 'Dsort';
factor = 10000;
N  = 1000;
icell = 1;
DT = 0.001;
edges = [-1:DT:1];
TrialLength = length(edges);
rasteredges = [-1:0.001:1];
pval = 0.01;
TrialsBack = 1;
% allcells  = [589]; event = TE:CenterPortEntry; eventparse = TE.CenterPortEntry;pasthistory  = TE.RightPortEntry;pastparse = TE.Reward;
% allcells  = [375]; event = TE:CenterPortEntry; eventparse = TE.CenterPortEntry;pasthistory  = TE.LeftPortEntry;pastparse = TE.Reward;
% allcells  = [359]; event = TE:CenterPortEntry; eventparse = TE.CenterPortEntry;pasthistory  = TE.LeftPortEntry;pastparse = TE.Reward;

switch loadspikes
    case 'Dsort'
        load rezFinalK
        CellN = length(unique(rez.st(:,end)));
        [data, timestamps, info] = load_open_ephys_data('all_channels.events');
        TE =  load('TrialEvents');
        %         load('TrialEvents');
        ROC_Dist = NaN(CellN,TrialsBack);
        ROC_P = NaN(CellN,TrialsBack);
%         spsth = NaN(CellN,TrialsBack,length(edges));
        spsth1 = NaN(CellN,TrialsBack,length(edges));
        spsth2 = NaN(CellN,TrialsBack,length(edges));
    case  'MClust'
        SelectCells = 1:1164;
        loadcb
        allcells = listtag('cells');
        cells = allcells(SelectCells);
        CellN = length(cells);
        ROC_Dist = NaN(CellN,TrialsBack);
        ROC_P = NaN(CellN,TrialsBack);
        spsth1 = NaN(CellN,TrialsBack,length(edges));
        spsth2 = NaN(CellN,TrialsBack,length(edges));
        
end
% [DecimalEvents, Timestamps] = OpenEphysEvents2Bpod('all_channels.events');
for i = 1:CellN
    %  stimes = rez.st((rez.st(:,5)==i),1)./30000;
    switch loadspikes
        case 'Dsort'
            stimes = rez.st((rez.st(:,end)==i),2)/1000;
            stimes = stimes + timestamps(1);
        case 'MClust'
            stimes = loadcb(cells(i));           
            TE = loadcb(cells(i),'TrialEvents');
            % loadcb(cells(i),'TrialEvents');
            % TE = load('TrialEvents_FreeChoiceDynMatchJesper');
    end
    
    
    event =        TE.CenterPortEntry; %TE.LeftPortEntry(~isnan(TE.LeftPortEntry)); %(find(TE.Reward==1))*1000;
    eventparse =    ones(1,length(TE.TrialTypes)); %TE.LeftPortEntry;
    pasthistory  = TE.LeftPortEntry;
    pastparse{1} = TE.Reward;
    pastparse{2} = TE.NoReward;
    Dist = [];
    P_Val = [];
    
    for iback = 1:TrialsBack
        for iType = 1:2 % trial type based on reward or no rewards  and etc
            iback;
            events = eventseparation(event,eventparse, pasthistory,pastparse{iType},iback);
            
            Time = length(edges);
            SpikePETH = zeros(Time,1);
            rastertime = length(rasteredges);
            TrialN = length(events);
            SpikeRaster = zeros(TrialN,rastertime);
            k = 0;
            inx = [];
            PrEV = zeros(1,length(events));
            PostEV = zeros(1,length(events));
            %  figure
            for iTrial = 1:length(events)
                allspikes = double(stimes) - events(iTrial);
                spikes = allspikes(allspikes>edges(1) & allspikes < edges(end));
                
                
                %             PrEV(iTrial) = PrevEvent(find(PrevEvent - events(iTrial) > edges(1),1,'last'));
                %             PostEV(iTrial) = PostEvent(find(PostEvent - events(iTrial) < edges(end),1,'first'));
                
                inx  = [inx find(allspikes < 60 & allspikes > 0)'];
                %                  figure(1)
                %                  for i = 1:length(spikes)
                %                      hold on
                %                      line([spikes(i) spikes(i)], [iTrial iTrial+1],'color','k')
                %                  end
                
                SpikeRaster(iTrial,:) = histc(allspikes,rasteredges);
                SpikePETH = SpikePETH + histc(allspikes,edges);
                clear allspikes
            end
            SpikePETH = SpikePETH/(length(events)*DT);
            SIGMA = 0.03;
            TrialN = length(events);
            COMP = {[1:TrialN]};
            VALID_TRIALS = 1:TrialN;
            [PSTH, SPSTH, SPSTH_SE] = binraster2psth(SpikeRaster,DT,SIGMA,COMP,VALID_TRIALS);
            SPSTHM = [SPSTH;SPSTH];
            SPSTHSE = [SPSTH_SE ; SPSTH_SE];
            if iType == 1
                SPSTH1 = SPSTH;
%               RATE1 = nansum(SpikeRaster(:,(TrialLength-1)/2:TrialLength)')/edges(end);
                RATE1 = nansum(SpikeRaster(:,1:TrialLength)')/edges(end);
                SpikeRaster = zeros(TrialN,rastertime);
                
            else
                SPSTH2 = SPSTH;
%               RATE2 = nansum(SpikeRaster(:,(TrialLength-1)/2:TrialLength)')/edges(end);
                RATE2 = nansum(SpikeRaster(:,1:TrialLength)')/edges(end);
                
                SpikeRaster = zeros(TrialN,rastertime);
            end
        end
        spsth1(i,iback,:) = SPSTH1; % - zscore(SPSTH2);
        spsth2(i,iback,:) = SPSTH2; % - zscore(SPSTH2);
        
        
        [D, P, SE] = rocarea(RATE1,RATE2,'bootstrap',N,'transform','scale');
        Dist = [Dist D];
        P_Val = [P_Val P];
        
        %         SPSTH1 = SPSTH1 - mean(SPSTH1(1:500));
        %         SPSTH2 = SPSTH2 - mean(SPSTH2(1:500));
        
        
        %                 subplot(2,1,1)
        %                 imagesc(-SpikeRaster)
        %                 colormap('gray')
        %                 subplot(2,1,2)
        %         %       stdshade_sorting(SPSTHM , SPSTHSE, 0.3, 'b')
        %                 plot(SPSTH2);
        %                 axis([0 length(edges) 0 max(SPSTH2) + 1])
        %               axis([0 length(edges) 0 80])
        
    end
    
    ROC_Dist(i,:) = Dist;
    ROC_P(i,:) = P_Val;
    clear stimes
end

for i = 1:size(ROC_Dist,1)
    if ROC_Dist(i,1) < 0
        ROC_Dist(i,:) = -ROC_Dist(i,:);
    end
end

%%%%%%%%%%%%%%%plot psth and ROC scores for past events%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
colors = ['r','g','b','k','y','m','c'];
for icell = 1:CellN
    h = figure;
    movegui(h,'east');
    subplot(2,1,1)
    for iback = 1:TrialsBack
        plot(squeeze(spsth1(icell,iback,:)),'color',colors(iback));
        hold on
        plot(squeeze(spsth2(icell,iback,:)),'color',colors(iback),'LineStyle','--');
        axis([0 length(edges) min(min(spsth1(icell,:,:))) - 1 max(max(spsth1(icell,:,:))) + 1])
    end
    inx = find(ROC_P(icell,:)<pval);
    subplot(2,1,2)
    if ~isempty(inx)
        plot(inx,ROC_Dist(icell,inx),'*')
    end
    hold on
    plot(ROC_Dist(icell,:))
    title(num2str(icell))

    %     axis([1 5 -2 2])
end

% figure
% for iTrial = 1:length(events)
%     for iSpk = 1:size(SpikeRaster,2)
%         line([SpikeRaster(iTrial,iSpk) SpikeRaster(iTrial,iSpk)],[iTrial-1 iTrial])
%         %                 line([PrEV(iTrial) PrEV(iTrial)],[iTrial - 1 iTrial],'g')
%         %                 line([PostEV(iTrial) PostEV(iTrial)],[iTrial - 1 iTrial],'g')
%     end
%     clear stimes
% end



%%%%%%%%%%% parse out events based on history %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function events = eventseparation(event,eventparse,pasthistory,pastparse,iback)
indx = find(~isnan(eventparse));
inx = indx(~isnan(event(indx)));
events = NaN(1,length(inx));
for i = iback + 1 :length(inx)
    if ~isnan(pasthistory(inx(i) - iback)) && pastparse(inx(i) - iback) == 1
        events(i) = event(inx(i));
    end
end
events = events(~isnan(events));
end
