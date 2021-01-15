clc
clear all
close all

lgt      = 20; %lengh of spike
spikeIDX = 2:4;

[data]  = creating_data_sets(5000000,'gaussian');
[data]  = chopping_data(5000,lgt,data);
%[data]  = spike_implantation(data,spikeIDX);
[data]  = normalisation_spikes(data);
            
[explained] = PCA_calculation(data);

Var = var(data,0,2)
[data]  = normalisation_spikes(data);
Var = var(data,0,2)