%
clear
loadcb
allcells = listtag('cells');
icell = 1;
TrialsBack = 15;
CellRange = 120:150;

for cellNum = CellRange %[51 77 52 78 57 81 58 82 64 85]
    t = loadcb(allcells(cellNum));
    TE = loadcb(allcells(cellNum),'TrialEvents');
    event = NaN(1,length(TE.TrialTypes));
    SortEvent1 = TE.RightPortEntry;
    SortEvent2 = TE.RightPortEntry;
    
    for i = 1:length(event)
        if  ~isnan(SortEvent1(i)) %TE.Reward(i)==1 && ~isnan(SortEvent1(i))
            event(i) = SortEvent1(i);
        end
    end
    
    offset = [0 1];
    
    
    for iTrial = 16:length(event)
        for iHist = 1:TrialsBack
            if ~isnan(SortEvent1(iTrial-iHist)) && TE.Reward(iTrial-iHist) == 1
                Allspikes = t-event(iTrial);
                on_spike=Allspikes(Allspikes>=offset(1) & Allspikes<=offset(2));
                stimes1{iTrial,iHist}=on_spike;
                clear Allspikes
            elseif ~isnan(SortEvent1(iTrial-iHist)) && TE.NoReward(iTrial-iHist) == 1
                Allspikes = t-event(iTrial);
                on_spike=Allspikes(Allspikes>=offset(1) & Allspikes<=offset(2));
                stimes2{iTrial,iHist}=on_spike;
                clear Allspikes
                %             for k = 1:length(on_spike)
                %                 line([on_spike(k) on_spike(k)],[iTrial-1 iTrial],'color','k');
                %             end
            end
        end
    end
    
    
    
    %     figure
    sigma = 0.05; dt = 0.001;
    margin = sigma*3;
    ev_window = [offset(1) offset(2)];
    time = offset(1) - margin : dt : offset(2) + margin;
    N = 1000;
    Dist = [];
    P_Val = [];
    for iHist = 1:TrialsBack
        all_trials1 = length(stimes1(:,1));
        all_trials2 = length(stimes2(:,1));
        
        Trials1 = cellfun(@isempty,stimes1(:,iHist));
        valid_trials1 = find(Trials1 == 0)';
        COMPTRIALS1 = {[valid_trials1]};
        
        Trials2 = cellfun(@isempty,stimes2(:,iHist));
        valid_trials2 = find(Trials2 == 0)';
        COMPTRIALS2 = {[valid_trials2]};
        
        ev_windows1 = repmat(ev_window,length(valid_trials1),1);
        ev_windows2 = repmat(ev_window,length(valid_trials2),1);
        
        binraster1 = stimes2binraster(stimes1(valid_trials1,iHist),time,dt,ev_windows1);
        binraster2 = stimes2binraster(stimes2(valid_trials2,iHist),time,dt,ev_windows2);
        
        RATE1 = nansum(binraster1')/(offset(2) -offset(1));
        RATE2 = nansum(binraster2')/(offset(2) -offset(1));
        
        [D, P, SE] = rocarea(RATE1,RATE2,'bootstrap',N,'transform','scale');
        Dist = [Dist D];
        P_Val = [P_Val P];
        
        
        %         [psth, spsth, spsth_se] = binraster2psth(binraster1,dt,sigma,COMPTRIALS,valid_trials);
        %         subplot(4,2,1)
        %         plot([-offset-margin:dt:offset+margin],spsth,'color',[iHist/7, iHist/7 , iHist/7])
        %         hold on
        %         subplot(4,2,iHist+1)
        % %         dim2 = [0.85 0.85 .01 .03];
        % %         dim2 = [0.42 0.65 .01 .03];
        % %         dim2 = [0.85 0.65 .01 .03];
        % %         dim2 = [0.42 0.45 .01 .03];
        % %         dim2 = [0.85 0.45 .01 .03];
        % %         dim2 = [0.42 0.45 .01 .03];
        %
        % %         annotation('rectangle',dim2,'FaceColor',[iHist/7, iHist/7 , iHist/7],'FaceAlpha',.2)
        % %         (length(valid_trials))
        %          imagesc(-raster)
        %          colormap('gray')
        %
        %
        % %          axis([-offset offset min(spsth) max(spsth)+2])
        clear binraster1 binraster2  psth spsth spsth_se all_trials1 Trials1 valid_trials1 all_trials2 Trials2 valid_trials2 COMPTRIALS1 COMPTRIALS2 NumTrials
    end
    ROC_Dist(icell,:) = Dist;
    ROC_P(icell,:) = P_Val;
    icell = icell + 1;
end

% ROC with P value
pval = 0.05;

% plot([length(find(ROC_P(:,1)<pval)) length(find(ROC_P(:,2)<pval)) length(find(ROC_P(:,3)<pval)) length(find(ROC_P(:,4)<pval)) length(find(ROC_P(:,5)<pval)) length(find(ROC_P(:,6)<pval)) length(find(ROC_P(:,7)<pval))],'*')


for icell = 1:(CellRange(end)-CellRange(1))
    figure
    inx = find(ROC_P(icell,:)<pval);
    if ~isempty(inx)
        plot(inx,ROC_Dist(icell,inx),'*')
    end
    hold on
    plot(ROC_Dist(icell,:))
axis([1 15 -2 2])
end




pval =0.005;
inx = {};
 for i = 1:15
   inx{i} = find(ROC_P([1:45],i)<pval)'; 
   Dist(i) =  mean((ROC_Dist(inx{i},i)));
 end
 
figure
plot([1:15],Dist(1:15))



