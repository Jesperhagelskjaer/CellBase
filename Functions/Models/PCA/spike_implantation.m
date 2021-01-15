function  [data]  = spike_implantation(data,spikeIDX)

data(spikeIDX,:) = data(spikeIDX,:)-1;

end

