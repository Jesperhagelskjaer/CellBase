function [confusion] = correlate_timing(RT_time,Time_A)
%Creation the confusion matrix 

%NB t_A; DS_only could be made into counter instead of saving the timestamps. However, if one want to pull the waveforms later one have the options to do so

%created by JH 04-02-2021

jitter   = 30:50; 
RT_only  = RT_time;
timing   = [];
for j = 1:numel(Time_A)
    Time  = Time_A{j};
    t_A = [];
    for i = 1:numel(RT_time) 
        if ~isempty(floor(find(RT_time(i)- jitter < Time  & RT_time(i) + jitter > Time)))
            t_A   = [t_A RT_time(i)]; %Finds the spikes that are seen both by Dsort and JSearch
            timing = [timing i];      %Finds the RT_only spikes
        end
    end   
    T_A(j,1)  =  numel(t_A);
    
    DS_only = [];
    for i = 1:numel(Time) %finding the spikes in dsort not found by JSearch
        if isempty(floor(find(Time(i) - jitter < RT_time  & Time(i) + jitter > RT_time)))
            DS_only  = [DS_only Time(i)]; %The time index in agreement
        end
    end
    DS_Only(j,1)  =  numel(DS_only);    
end

test = unique(timing);
RT_only(test) = [];

confusion.t_A     = T_A;
confusion.RT_only = numel(RT_only);
confusion.DS_only = DS_Only;
end









