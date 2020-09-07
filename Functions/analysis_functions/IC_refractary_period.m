function [varargout] = IC_refractary_period(cellid,varargin)
%addanalysis(@IC_refractary_period,'property_names',{'IC_percent'},'arglist',{'method','diff','refractory_p', 1});

%delanalysis(@IC_refractary_period)

%latency is given in (ms) default 1 ms

prs = inputParser;
addRequired(prs,'cellid',@(cellid) iscellid((cellid)) || (cellid) == 0) % cell ID
addParameter(prs,'refractory_p',1,@(x) isnumeric(x) && (x >= 0))
addParameter(prs,'method','diff',@ischar)

parse(prs,cellid,varargin{:})

if (prs.Results.cellid == 0)
    varargout{1}.prs = prs;   
    return 
end


refractory_p             = prs.Results.refractory_p*30;
SpikeTimes               = loadcb(prs.Results.cellid,'Spikes');
tSpikes_corr             = round((SpikeTimes - SpikeTimes(1))*30000+1); % converting spike times (s) into samples and setting first spike to 1
full_spike               = false(tSpikes_corr(end),1);                  % creating a total sample recording
full_spike(tSpikes_corr) = 1;
Spikes                   = length(SpikeTimes);

if strcmp(prs.Results.method,'conv')
    c               = round(xcorr(full_spike,refractory_p)); % could make a fourier analysis instead
    total_violation = sum(c(refractory_p+2:end));            % without the centerspike    
elseif strcmp(prs.Results.method,'diff')
    c               = diff(SpikeTimes*1000);
    total_violation = length(find(c <= prs.Results.refractory_p));  
end
varargout{1}.IC_percent      = total_violation/Spikes*100;
end

