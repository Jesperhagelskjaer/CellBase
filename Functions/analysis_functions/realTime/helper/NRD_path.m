function [fullNameNRD] = NRD_path(r,s)
%check if there is folder name nrd/NRD which the nrd file is stored in

fullNameNRD = fullfile(getpref('cellbase','datapath'),r,s,'CheetahRawData.nrd');
if exist(fullNameNRD,'file')
    return
end

fullNameNRD = fullfile(getpref('cellbase','datapath'),r,s,'nrd/CheetahRawData.nrd');
if exist(fullNameNRD,'file')
    return
end

fullNameNRD = fullfile(getpref('cellbase','datapath'),r,s,'NRD/CheetahRawData.nrd');
if exist(fullNameNRD,'file')
    return
end  
    
end

