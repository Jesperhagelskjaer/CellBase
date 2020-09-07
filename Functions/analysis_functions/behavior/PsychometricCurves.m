%this script will plot psychometric curves for
allcells = listtag('cells');
cells = unique_session_cells(allcells);
N = 5;
FreqInx = cell(length(cells),N);
Perc_Freq = NaN(N,2);
RightCoiceRatio = NaN(length(cells),N);
for icell = 1:length(cells)
    loadcb(cells(icell),'TrialEvents')
    for iperc = 1:N
        Perc_Freq(iperc,:) = prctile(TE.StimulusFreq,[20*(iperc-1) 20*iperc]);
        FreqInx{icell,iperc} = find(TE.StimulusFreq > Perc_Freq(iperc,1) & TE.StimulusFreq < Perc_Freq(iperc,2));
        RightCoiceRatio(icell,iperc) = sum(~isnan(TE.RightPortEntry(FreqInx{icell,iperc})))/(sum(~isnan(TE.RightPortEntry(FreqInx{icell,iperc}))) + sum(~isnan(TE.LeftPortEntry(FreqInx{icell,iperc}))));
    end
    
    
end
MeanRightChoices = [mean(RightCoiceRatio(1:3,1)) mean(RightCoiceRatio(1:3,2)) mean(RightCoiceRatio(1:3,3)) mean(RightCoiceRatio(1:3,4)) mean(RightCoiceRatio(1:3,5))];
SerrRightChoices = [serr(RightCoiceRatio(1:3,1)) serr(RightCoiceRatio(1:3,2)) serr(RightCoiceRatio(1:3,3)) serr(RightCoiceRatio(1:3,4)) serr(RightCoiceRatio(1:3,5))];


errorbar(MeanRightChoices,SerrRightChoices,'LineWidth',3,'color','k')
box off
xlabel('Tone Frequency (kHz)','fontsize',18)
ylabel('Ratio of Right Choices','fontsize',18)
set(gca,'TickDir','out','fontsize',18,'XLim',[0.5 5.5],'XTick',[1:5],'XTickLabel',[0.8    0.9    1    1.1    1.2]...
    ,'YTick',[0:0.2:1],'TickLength',[0.02 0.02])