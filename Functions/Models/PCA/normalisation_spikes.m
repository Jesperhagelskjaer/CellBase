function [NwSpikes,Sum] = normalisation_spikes(wSpikes)

Sum      = abs(sum(wSpikes));
NwSpikes = wSpikes./Sum;
end

