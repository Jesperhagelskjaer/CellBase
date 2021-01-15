function [NwSpikes] = normalisation_spikes(wSpikes)

Sum      = sum(wSpikes,2);
NwSpikes = wSpikes./Sum;
end

