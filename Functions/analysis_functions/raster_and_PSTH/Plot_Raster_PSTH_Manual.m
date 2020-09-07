% initialize variables
clear
load cellid
allcells = cellid; % last cell is directory name
RangeOfCells = 1 %1:length(allcells);
EventN = 4; %48;
Raster = [];
Stimes = [];
dtt = 0.001;
time = [-1.1:dtt:1.1]; % Define the edges of the histogram
evwind = [time(1),time(end)];

Psth = NaN(length(RangeOfCells),EventN,length([time(1):dtt:time(end)]));
Psth_sd = Psth;
Spsth = Psth;
Spsth_se = Psth;
raster = cell(1,EventN);
Stime = cell(1,EventN);
sigma = 0.05;
r = 1;
% generate raster stimes
for iCell = RangeOfCells
    cellids = allcells{iCell};
    t = loadcells(cellids,'Spikes');
    if 1/mean(diff(t)) > 200
        t = t*10^4;
    end
    TE = loadcells(cellids,'TrialEvents');
    SessionData = loadcells(cellids,'SessionData');
    [event, varargout] = MakeEvent(SessionData,TE,EventN,'FreeChoice','Reward&ChoiceHistory'); % 'FreeChoice','DoNothing'
    [Stime, raster, psth, psth_sd, spsth, spsth_se] = Spikes2Raster(TE,time,event,t,dtt,evwind,sigma);
    
    Psth(r,:,:) = psth;
    Psth_sd(r,:,:) = psth_sd;
    Spsth(r,:,:) = spsth;
    Spsth_se(r,:,:) = spsth_se;
    Stimes = [Stimes;Stime];
    Raster = [Raster;raster];
    r = r + 1;
    clear t spsth psth Stime raster spsth_se psth_sd
end

%% if you want to plot one 
chop = 100;
XLIM = [chop+1 : length(Raster{1,1})-chop];
YLim = 30;
TrialInterval = 1:size(Raster{1,1},1); 
figure
subplot(3,1,1)
imagesc(Raster{1,1}(TrialInterval,XLIM)) % (350:400,XLIM))
colormap(flipud(gray));
box off
set(gca,'fontsize', 14,'TickDir','out','XLim',[XLIM(1) XLIM(end)],'XTick',[XLIM(1):500:XLIM(end)],'XtickLabel',[],'YLim',[0 50],'YTick',[0:10:50],'YTickLabel',[50:-10:0])
ylabel('Trial #'); xlabel('RightPortEntry');
subplot(3,1,2)
imagesc(Raster{1,2}(TrialInterval,XLIM))
colormap(flipud(gray));
box off
set(gca,'fontsize', 14,'TickDir','out','XLim',[XLIM(1) XLIM(end)],'XTick',[XLIM(1):500:XLIM(end)],'XtickLabel',[],'YLim',[0 50],'YTick',[0:10:50],'YTickLabel',[50:-10:0])
ylabel('Trial #'); xlabel('LeftPortEntry');
subplot(3,1,3)
plot(time(XLIM),squeeze(Spsth(1,1,XLIM)),'r','LineWidth',3)
hold on 
plot(time(XLIM),squeeze(Spsth(1,2,XLIM)),'b','LineWidth',3)
box off
set(gca,'fontsize', 14,'TickDir','out','XLim',[time(XLIM(1)) time(XLIM(end))],'XTick',[-1:0.5:1],'XtickLabel',[-1:0.5:1],'YLim',[0 YLim],'YTick',[0:5:10],'YTickLabel',[0:5:10])
ylabel('Firing Rate (Hz)'); xlabel('Time (sec) from PortEntry');legend('RightPortEntry','LeftPortEntry')
% set(gca,'fontsize', 14,'TickDir','out','XLim',[0 2000],'XTick',[0:500:2000],'XtickLabel',[-1:0.5:1],'YLim',[0 50],'YTick',[0:10:50],'YTickLabel',[50:-10:0])
% ylabel('Trial #')
print(figure(1), '-append', '-dpsc2', 'ForcedChoice.ps');

%%

% initialize axes for figure

XLim = [-0.75:dtt:0.75];


for icell = 1:length(allcells)
    figure(icell)
    tstring = allcells(RangeOfCells(icell));
    tstring = [tstring{1}(1:4),'.',tstring{1}(6:14),'.',tstring{1}(16:18),'.',tstring{1}(20:21)];
    YLim = max(max(squeeze(Spsth(icell,:,:)))) + 5;
    iPsth = 1:4;
    for iPlot = 1:12
        subplot(3,4,iPlot)
        for k = iPsth
%                         if iPlot == 1 xlabel('RightPortOutR'); ylabel('Firing Rate (Hz)'); elseif iPlot == 2 xlabel('LeftPortOutR'); elseif iPlot == 3 xlabel('RightPortOutNR'); elseif iPlot == 4 xlabel('LeftPortOutNR');
%                         elseif iPlot == 5 xlabel('RightPortInR'); ylabel('Firing Rate (Hz)'); elseif iPlot == 6 xlabel('LeftPortInR'); elseif iPlot == 7 xlabel('RightPortInNR'); elseif iPlot == 8 xlabel('LeftPortInNR');
%                         elseif iPlot == 9 xlabel('CenterPortOutRR'); ylabel('Firing Rate (Hz)'); elseif iPlot == 10 xlabel('CenterPortOutLR'); elseif iPlot == 11 xlabel('CenterPortOutRNR'); elseif iPlot == 12 xlabel('CenterPortOutLNR');
%                         elseif iPlot == 13 xlabel('CenterPortInRR'); ylabel('Firing Rate (Hz)'); elseif iPlot == 14 xlabel('CenterPortInLR'); elseif iPlot == 15 xlabel('CenterPortInRNR'); elseif iPlot == 16 xlabel('CenterPortInLNR'); end;
            if iPlot == 1 xlabel('RightPortEntryRight'); ylabel('Firing Rate (Hz)'); elseif iPlot == 2 xlabel('LeftPortEntryLeft'); elseif iPlot == 3 xlabel('LeftPortEntryRight'); elseif iPlot == 4 xlabel('RightPortEntryLeft');
            elseif iPlot == 5 xlabel('RightPortExitRight'); ylabel('Firing Rate (Hz)'); elseif iPlot == 6 xlabel('LeftPortExitLeft'); elseif iPlot == 7 xlabel('LeftPortExitRight'); elseif iPlot == 8 xlabel('RightPortExitLeft');
            elseif iPlot == 9 xlabel('CenterPortExit'); ylabel('Firing Rate (Hz)'); elseif iPlot == 10 xlabel('CenterPortExit'); elseif iPlot == 11 xlabel('CenterPortExit'); elseif iPlot == 12 xlabel('CenterPortExit');
            end
             plot(time,squeeze(Spsth(icell,k,:)))
            hold on
            axis([XLim(1) XLim(end) 0 YLim ])
        end
        iPsth = iPsth +4;
    end
   
    fstamp(tstring)
    print(figure(icell), '-append', '-dpsc2', 'ForcedChoice.ps');
    close(figure(icell))
end
% [SortInx, Inx] = sort(event(2,~isnan(event(2,:))) - event(6,~isnan(event(6,:))));
% StartInx = find(time==-0.5);
% EndInx =  find(time==0.5);
% LimitInx = StartInx:EndInx;
% LimitTime = time(StartInx:EndInx);
% MidInx = (EndInx-StartInx)/2+1;
% ChooseCell = 1;
% ChooseEvent = 6;
% RefEvent = 5;
%
% Trials = 250; %size(Raster{ChooseCell,ChooseEvent},1);
% XTick = LimitTime(1):0.25:LimitTime(end);
% XTickLabel = LimitTime(1):0.25:LimitTime(end);
% ylim = size(Raster{ChooseCell,ChooseEvent,:},1);
% YTick = 0:50:Trials;
% YTickLabel = Trials:-50:0;
% figure
% subplot(2,1,1)
% imagesc(-squeeze(Raster{ChooseCell,ChooseEvent}(:,LimitInx)))
% line([MidInx MidInx],[0 ylim],'LineStyle','--','Color',[0.7 0.7 0.7])
% colormap('gray')
% box off
% hold on
% for i = 1:length(SortInx)
%     line([MidInx + SortInx(i)/dtt MidInx + SortInx(i)/dtt],[i-1 i])
% end
% set(gca,'TickDir','out','XTick',[1:250:LimitInx(end)],'XTickLabel',[],'YTick',YTick,'YTickLabel',YTickLabel,'fontsize',12)
% ylabel('#Trials')
% subplot(2,1,2)
% errorshade(LimitTime,squeeze(Spsth(ChooseCell,ChooseEvent,LimitInx)),squeeze(Spsth_se(ChooseCell,ChooseEvent,LimitInx)));
% hold on
% errorshade(LimitTime,squeeze(Spsth(ChooseCell,RefEvent,LimitInx)),squeeze(Spsth_se(ChooseCell,RefEvent,LimitInx)),'LineColor','r');
% set(gca,'TickDir','out','XTick',XTick,'XTickLabel',XTickLabel,'YTick',[0:5:YLim],'YTickLabel',[0:5:YLim],'fontsize',12)
% xlabel('SidePortExit (sec)')
% ylabel('FiringRate (Hz)')
% set(gcf,'renderer','painters')
%
%

%% 

if ~isempty(varargout)
    RewardChoices = varargout;
    figure
    subplot(2,1,1)
    bar([RewardChoices(1,1) RewardChoices(2,1) RewardChoices(1,2) RewardChoices(2,2) RewardChoices(1,3) RewardChoices(2,3) RewardChoices(1,4) RewardChoices(2,4) RewardChoices(1,5) RewardChoices(2,5) RewardChoices(1,6) RewardChoices(2,6)])
    subplot(2,1,2)
    bar([ RewardChoices(3,1) RewardChoices(4,1)  RewardChoices(3,2) RewardChoices(4,2)  RewardChoices(3,3) RewardChoices(4,3)  RewardChoices(3,4) RewardChoices(4,4)  RewardChoices(3,5) RewardChoices(4,5)  RewardChoices(3,6) RewardChoices(4,6)])
    
    figure
    
    subplot(2,1,1)
    bar([RewardChoices(2,1)/RewardChoices(1,1) RewardChoices(2,2)/RewardChoices(1,2) RewardChoices(2,3)/RewardChoices(1,3) RewardChoices(2,4)/RewardChoices(1,4) RewardChoices(2,5)/RewardChoices(1,5) RewardChoices(2,6)/RewardChoices(1,6)])
    axis([0 7 0 10])
    subplot(2,1,2)
    bar([ RewardChoices(4,1)/RewardChoices(3,1)  RewardChoices(4,2)/RewardChoices(3,2)  RewardChoices(4,3)/RewardChoices(3,3)  RewardChoices(4,4)/RewardChoices(3,4)  RewardChoices(4,5)/RewardChoices(3,5)  RewardChoices(4,6)/RewardChoices(3,6)])
    axis([0 7 0 10])
    
end
% figure
% bar([RightChoices1/RewardRight1 LeftChoices1/RewardLeft1 RightChoices2/RewardRight2 LeftChoices2/RewardLeft2 RightChoices3/RewardRight3 LeftChoices3/RewardLeft3 RightChoices4/RewardRight4 LeftChoices4/RewardLeft4 RightChoices5/RewardRight5 LeftChoices5/RewardLeft5 RightChoices6/RewardRight6 LeftChoices6/RewardLeft6])
%
% figure
% bar([RightChoices1/LeftChoices1 RewardRight1/RewardLeft1 RightChoices2/LeftChoices2 RewardRight2/RewardLeft2  RightChoices3/LeftChoices3 RewardRight3/RewardLeft3 RightChoices4/LeftChoices4 RewardRight4/RewardLeft4 RightChoices5/LeftChoices5 RewardRight5/RewardLeft5 RightChoices6/LeftChoices6 RewardRight6/RewardLeft6 ])
%






