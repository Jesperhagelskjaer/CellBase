clc
clear all
close all

lgt      = 20;  %lengh of spike window to take out 
spikeIDX = 2:4; %length and placement of the spike in the window [5:7]

[data]  = creating_data_sets(5000000,'gaussian');
[data]  = chopping_data(5000,lgt,data);
%[data]  = spike_implantation(data,spikeIDX);
%[data,sum]  = normalisation_spikes(data);
            
[explained] = PCA_calculation(data);

Var = var(data,0,2)
