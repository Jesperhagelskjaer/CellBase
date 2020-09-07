function [sw,MeanSpk] = extract_spike_width(meanW,stimes,dataW,fs)

n_Spk = find(stimes+25 < length(dataW), 1, 'last');
Spk = NaN(length(meanW(1):meanW(2)),4,n_Spk);
t_range = meanW(1):meanW(2);   


for iSpk = 1: n_Spk
    Spk(:,:,iSpk)= dataW(stimes(iSpk)+t_range,:);
end
MeanSpk = mean(Spk,3);

%after talk with duda this is the right way to find spikeWidth (how the
%commnuty do it) (can be influenced by the length of the template taken into account)
wvmean = - MeanSpk; % invert your spike waveforms. this is after you compute the mean waveforms for each channel. The size of the array is 4,nSamples
amx = max(max(wvmean));     %  maximum of a top channel
[my, mx] = find(wvmean==amx,1,'first');     % mx: largest channel and index
[amn, inxmin] = min(wvmean(my:end,mx));     %  minimum of mean waveforms from the peak
inxmin = inxmin + my -1; % minimun after the peak
t1 =  interp1(wvmean(1:my,mx),[1:my],(amx + amn)/2,'pchip'); % interpolate half width till the peak
t2 =  interp1(wvmean(my:inxmin,mx),[my:inxmin],(amx + amn)/2,'pchip'); % interpolate half width from the peak
sw = (t2-t1)*(1000000/fs); % express it in microseconds

end
