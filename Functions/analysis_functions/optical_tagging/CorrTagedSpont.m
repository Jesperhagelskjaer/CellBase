% calculate waveform correlations of spikes that happen within X ms and Y
% ms periods of light stimulation period. X and Y are set in After and
% Peri Stim parameters
% after

function [Score] = CorrTagedSpont(cells,dirpath,AfterStim,PeriStim)

Score = NaN(1,length(cells));
fshigh = 300;
slow = 5000;
fs = 30000;
TimeFactor = 1;

Tetrode = NaN(length(cells), 1);

for icell = 1:length(cells)
%%%%%%%%%%%%%Locate the session for each cell and load spiketimes, stimevents andcontinous chan data%%%%%%%    
    [ratname,session,tetrode,unit] = cellid2tags(cells(icell));
    cd([dirpath,'/',ratname,'/' session])
    [d, timestamps, info] = load_open_ephys_data(sprintf('100_CH%d.continuous',17));
    data = zeros(4,round(length(d)));
    [b1, a1] = butter(3, [fshigh/fs,slow/fs]*2, 'bandpass');
    
    stimes = loadcb(cells(icell));
    stimes = ceil((stimes - timestamps(1))*fs);
    TE = [];
    try TE = loadcb(cells(icell),'StimEvents');
    StimEvents = (TE.BurstOn- timestamps(1))*fs;
    catch; disp('no stimevents')
        continue
    end
    
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
        [score, NLMeanSpk, LMeanSpk,counterSpkBl,counterSpkStim] = ExtractSpikeWV(stimes,dataW,StimEvents,AfterStim,PeriStim,fs);
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
        [score, NLMeanSpk, LMeanSpk,counterSpkBl,counterSpkStim] = ExtractSpikeWV(stimes,dataW,StimEvents,AfterStim,PeriStim,fs);
    else
        [score, NLMeanSpk, LMeanSpk,counterSpkBl,counterSpkStim] = ExtractSpikeWV(stimes,dataW,StimEvents,AfterStim,PeriStim,fs);
    end
    Score(icell) = score;
    save(['WV_',mat2str(tetrode),'_',mat2str(unit),'.mat'], 'NLMeanSpk', 'LMeanSpk', 'counterSpkBl', 'counterSpkStim');
    prevsession = session;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%%%%%%%%%%%%%%%%%Identify spikes on the filtered Data after the light pulse %%%%%%%%%%%%%%%%    

    function [score,NLMeanSpk,LMeanSpk,counterSpkBl,counterSpkStim] = ExtractSpikeWV(stimes,dataW,StimEvents,AfterStim,PeriStim,fs)
        
        LSpk = NaN(4,length(stimes)-1,41);
        NLSpk = NaN(4,length(stimes)-1,41);
        NLMeanSpk = NaN(4,41);
        LMeanSpk = NaN(4,41);
        counterSpkStim = zeros(4, 1);
        counterSpkBl = zeros(4, 1);
        for ich = 1:4
            for iSpk = 1: length(stimes)-1
                if stimes(iSpk) - StimEvents(find(StimEvents - stimes(iSpk) < 0,1,'last')) < PeriStim*fs % get spikes with 5 ms after stim
                    LSpk(ich,iSpk,:)= dataW(stimes(iSpk)-20:stimes(iSpk) + 20,ich);
                    counterSpkStim(ich) = counterSpkStim(ich) +1;
                elseif stimes(iSpk) - StimEvents(find(StimEvents - stimes(iSpk) > PeriStim*fs,1,'first')) > -AfterStim*fs %get spikes after 100 ms stim
                    NLSpk(ich,iSpk,:)= dataW(stimes(iSpk)-20:stimes(iSpk) + 20,ich);
                    counterSpkBl(ich) = counterSpkBl(ich) +1;
                end
            end
            NLMeanSpk(ich,:) = mean(squeeze(NLSpk(ich,(~isnan(NLSpk(1,:,1))),:))); % get rid of NaNs
            LMeanSpk(ich,:) = mean(squeeze(LSpk(ich,(~isnan(LSpk(1,:,1))),:)));
        end
        NLMeanSpk = reshape(NLMeanSpk',[],4*41);
        LMeanSpk = reshape(LMeanSpk',[],4*41);
        if sum(~isnan(LSpk(1,:,1))) > 1
            score = xcorr(NLMeanSpk,LMeanSpk,0,'coeff');
        else
            score = NaN;
        end
    end
end

% 
% clear all;
% dirpath = cd;
% loadcb
% cells = listtag('cells');
% PeriStim = 0.005;
% AfterStim = 0.1;
% [Score] = CorrTagedSpont(cells,dirpath,AfterStim,PeriStim);


