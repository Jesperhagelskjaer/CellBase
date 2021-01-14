function [outputArg1,outputArg2] = building_DSort_template(cellid,inputArg2)

global CELLIDLIST

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector

load(fullfile(getpref('cellbase','datapath'),r,s,strcat(f.rezName,'.mat')));

[Templates,~,W_Spikes] = creating_templates_on(rez,dataF);


end

