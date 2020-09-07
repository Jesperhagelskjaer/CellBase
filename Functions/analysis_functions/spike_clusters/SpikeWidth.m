% calculate spikewidth of from the mean waveform of the top channel

function [SW] = SpikeWidth(cells,dirpath)

Tetrode = NaN(1,length(cells));
SW = NaN(1,length(cells));
fshigh = 300;
slow = 5000;
fs = 30000;
TimeFactor = 1;
for icell = 1:length(cells)
%%%%%%%%%%%%%Locate the session for each cell and load spiketimes, stimevents andcontinous chan data%%%%%%%    
    [ratname,session,tetrode,unit] = cellid2tags(cells(icell));
    cd([dirpath,'/',ratname,'/' session])
    [d, timestamps, info] = load_open_ephys_data(sprintf('100_CH%d.continuous',17));
    data = zeros(4,round(length(d)));
    [b1, a1] = butter(3, [fshigh/fs,slow/fs]*2, 'bandpass');
    
    stimes = loadcb(cells(icell));
    stimes = ceil((stimes - timestamps(1))*fs);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    
%%%%%%%%%%%%%%%%%Filter only tetrode channel data and skip processing for already loaded data%%%%%%%%%%%%%%%%    
    Tetrode(icell) = tetrode;
    if icell == 1
        i = 1;
        for channel = tetrode*4 + 1 : tetrode*4 + 4  %load only channels that correspond to the tetrode
            [d, ~, ~] = load_open_ephys_data(sprintf('100_CH%d.continuous',channel));
            d = filtfilt(b1, a1, d);
            data(i,:) = d(1:size(data,2),1);
            i = i+1;
            clear d;
        end
        dataW = data';
        [sw] = ExtractSpikeWV(stimes,dataW,fs);
    elseif ~strcmp(prevsession, session) || Tetrode(icell-1) ~= Tetrode(icell)
%         clear data dataW
        i = 1;
        for channel = tetrode*4 + 1 : tetrode*4 + 4  %load only channels that correspond to the tetrode
            [d, ~, ~] = load_open_ephys_data(sprintf('100_CH%d.continuous',channel));
            d = filtfilt(b1, a1, d);
            data(i,:) = d(1:size(data,2),1);
            i = i+1;
            clear d;
        end
        dataW = data';
        [sw] = ExtractSpikeWV(stimes,dataW,fs);
    else
        [sw] = ExtractSpikeWV(stimes,dataW,fs);
    end
    SW(icell) = sw;
    prevsession = session;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%%%%%%%%%%%%%%%%%Identify spikes on the filtered Data after the light pulse %%%%%%%%%%%%%%%%    

    function [sw] = ExtractSpikeWV(stimes,dataW,fs)
        
        n_Spk = find(stimes+25 < length(dataW), 1, 'last');
        
        Spk = NaN(4,n_Spk,51);
        for ich = 1:4
            for iSpk = 1: n_Spk
                    Spk(ich,iSpk,:)= dataW(stimes(iSpk)-25:stimes(iSpk) + 25,ich);
            end
        MeanSpk(ich,:) = mean(squeeze(Spk(ich,(~isnan(Spk(1,:,1))),:))); % get rid of NaNs
        end
   wvmean = - MeanSpk; % invert your spike waveforms. this is after you compute the mean waveforms for each channel. The size of the array is 4,nSamples
   amx = max(max(wvmean));     %  maximum of a top channel
   [mx, my] = find(wvmean==amx,1,'first');     % mx: largest channel and index
   [amn, inxmin] = min(wvmean(mx,my:end));     %  minimum of mean waveforms from the peak
   inxmin = inxmin + my -1; % minimun after the peak
   t1 =  interp1(wvmean(mx,1:my),[1:my],(amx + amn)/2,'pchip'); % interpolate half width till the peak
   t2 =  interp1(wvmean(mx,my:inxmin),[my:inxmin],(amx + amn)/2,'pchip'); % interpolate half width from the peak
   sw = (t2-t1)*(1000000/fs); % express it in microseconds
    end
end



