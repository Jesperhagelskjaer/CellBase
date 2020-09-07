function [score,NLMeanSpk,LMeanSpk,counterLMSpk,counterNLSpk] = extract_spike_waveform(meanW,stimes,dataW,StimEvents,AfterStim,PeriStim,fs)
% Modified (JH)


rgn         = meanW(1):meanW;  
LSpk        = NaN(length(rgn),4,length(stimes));
NLSpk       = NaN(length(rgn),4,length(stimes));
PeriStim_fs = PeriStim*fs;

for iSpk = 1:length(stimes)
    idx_spk = stimes(iSpk);   
    if idx_spk - StimEvents(find(StimEvents - idx_spk < 0,1,'last')) < PeriStim_fs % get spikes with 5 ms after stim
        LSpk(:,:,iSpk) = dataW(idx_spk + rgn,:);           
    elseif StimEvents(find(StimEvents - idx_spk > PeriStim_fs,1,'first')) - idx_spk < AfterStim*fs %get spikes after 100 ms stim
        NLSpk(:,:,iSpk)= dataW(idx_spk + rgn,:);
    end
end

LSpk(:,:,squeeze(any(any(isnan(LSpk),1),2)))   = [];
NLSpk(:,:,squeeze(any(any(isnan(NLSpk),1),2))) = [];
LMeanSpk                                       = mean(LSpk,3);
NLMeanSpk                                      = mean(NLSpk,3);
counterLMSpk                                   = size(LSpk,3);
counterNLSpk                                   = size(NLSpk,3);

LMeanSpk_c  = LMeanSpk(:);
NLMeanSpk_c = NLMeanSpk(:);
if ~isempty(NLSpk) && ~isempty(LSpk)
    score = max(xcorr(NLMeanSpk_c,LMeanSpk_c,1,'coeff'));
else
    score = NaN;
end

end

