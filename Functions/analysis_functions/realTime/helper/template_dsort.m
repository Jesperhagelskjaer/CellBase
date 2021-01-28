function [Templates,tSpikes,W_Spikes] = template_dsort(cellid,dataF)

global f

[r,s,~,~]  = cellid2tags(cellid);

load(fullfile(getpref('cellbase','datapath'),r,s,strcat(f.rezName,'.mat')));

[Templates,tSpikes,W_Spikes] = creating_templates_on(rez,dataF);



end

