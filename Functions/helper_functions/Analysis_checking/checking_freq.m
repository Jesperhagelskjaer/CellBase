function [] = checking_freq()

if ~all(findanalysis('CentralPortEpoch'))
    fprintf("addanalysis(@average_firing_rate,1,'property_names',{'CentralPortEpoch'})\n")
end

end

