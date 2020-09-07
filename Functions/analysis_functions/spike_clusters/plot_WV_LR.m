% Plot MClust extracted waveformrs, Isolation distance and Lratio, spikewidth, firing rate and total number of spikes
% for each  cluster. 

%initialize the variables
clear all;
clc;
close all;
loadcb; allcells = listtag('cells');
WV = cell(1,length(allcells));
ID = NaN(1,length(allcells));
LRatio = NaN(1,length(allcells));
NSpikes = NaN(1,length(allcells));
wvmean = NaN(4,42);
wvstd = NaN(4,42);
SpikeWidth = NaN(1,length(allcells));
FR = NaN(1,length(allcells));
Cells = struct;

tic
%extract waveforms using MClust engine
for icell = 1:length(allcells)
    SpikeTimes = loadcb(allcells(icell),'spikes');
    wave = extractSpikeWaveforms2(allcells(icell),'OpenEphys',SpikeTimes);
    [DM LrC valid_channels] = LRatio2(allcells{icell},'OpenEphys', 'FEATURE_NAMES', {'Energy'},'VALID_CHANNELS',[1  1 1 1]);
    wvmean = squeeze(nanmean(wave,1));
    wvstd = squeeze(nanstd(wave,1));
    WV{icell} = [wvmean, wvstd];
    NSpikes(icell) = size(wave,1);
    FR(icell) = NSpikes(icell)/(SpikeTimes(end) - SpikeTimes(1));
    [SpikeWidth(icell) t1 t2 mx ] = spikewidth(wvmean,allcells,icell);
    
 % plot waveforms   
    figure
    for i = 1:4
        subplot(1,4,i)
        errorbar(wvmean(i,:),wvstd(i,:))
        box off
         if i == mx
             hold on
             line([t2 t2],[nanmin(wvmean(mx,:)) nanmax(wvmean(mx,:))],'color','red'); line([t1 t1],[nanmin(wvmean(mx,:)) nanmax(wvmean(mx,:))],'color','red')
         end
        axis([0 42 min(min(squeeze(min(wave))))  max(max(squeeze(max(wave))))])
        if i == 1
            title([allcells{icell}([1:4,6:14,16:18])])
        elseif i == 2
            title(['LRatio = ' string(LrC)])
        elseif i == 3
            title({'ID = ' string(DM), 'FiringRate = ' string(FR(icell))})
        elseif i == 4
            if isnan(SpikeWidth(icell))
             title({'SpWidth = NaN ', 'NSpikes = ' string(NSpikes(icell))})
            else
             title({'SpWidth = ' string(SpikeWidth(icell)), 'NSpikes = ' string(NSpikes(icell))})
            end
        end
    end
    
    
    ID(icell) = DM; LRatio(icell) = LrC;
    clear wave DM LrC wvmean wvstd t1 t2
    print(figure(1), '-append', '-dpsc2', 'SpikeWV.ps');
    close(figure(1))
    
end
toc

function [SW t1 t2 mx] = spikewidth(wvmean,allcells,icell)
if allcells{icell}(16) == '6'
    wvmean = wvmean(1:2,find(~isnan(wvmean(1,:)),1,'first'):end);
    amx = max(max(wvmean));     % absolut maximum of mean waveforms
    [mx, my] = find(wvmean==amx,1,'first');     % mx: largest channel
    amn = min(wvmean(mx,:));     % absolut minimum of mean waveforms
    t1 =  interp1(wvmean(mx,1:my),[1:my],(amx + amn)/2,'pchip');
    t2 =  interp1(wvmean(mx,my:find(wvmean(mx,:)==amn)),[my:find(wvmean(mx,:)==amn)],(amx + amn)/2,'pchip');
    SW = (t2-t1)*33;
else
    amx = max(max(wvmean));     %  maximum of mean waveforms
    [mx, my] = find(wvmean==amx,1,'first');     % mx: largest channel
    amn = min(wvmean(mx,:));     %  minimum of mean waveforms
    t1 =  interp1(wvmean(mx,1:my),[1:my],(amx + amn)/2,'pchip');
    t2 =  interp1(wvmean(mx,my:find(wvmean(mx,:)==amn)),[my:find(wvmean(mx,:)==amn)],(amx + amn)/2,'pchip');
    SW = (t2-t1)*33;
end
end

% save the file
Cells.WV = WV;
Cells.ID = ID;
Cells.LRatio = LRatio;
Cells.SpikeWidth = SpikeWidth;
Cells.FR = FR;
Cells.NSpikes = NSpikes;
save('FreeChoiceCells.mat', '-struct', Cells, WV)

