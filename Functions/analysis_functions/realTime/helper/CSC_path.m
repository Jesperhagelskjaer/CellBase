function [fullNameCSC] = CSC_path(r,s)
%check if there is folder name nrd/NRD which the nrd file is stored in

fullNameCSC = fullfile(getpref('cellbase','datapath'),r,s,'100_CH17.continuous');
if exist(fullNameCSC,'file')
    fullNameCSC = fullfile(getpref('cellbase','datapath'),r,s);
    return
end

fullNameCSC = fullfile(getpref('cellbase','datapath'),r,s,'csc/100_CH17.continuous');
if exist(fullNameCSC,'file')
    fullNameCSC = fullfile(getpref('cellbase','datapath'),r,s,'csc');
    return
end

fullNameCSC = fullfile(getpref('cellbase','datapath'),r,s,'CSC/100_CH17.continuous');
if exist(fullNameCSC,'file')
    fullNameCSC = fullfile(getpref('cellbase','datapath'),r,s,'CSC');
    return
end  
    
end
