function [value,mahal_d,d_isolation] = building_template_clustering_validation(cellid,dataF)

global CELLIDLIST
global method 
global f
[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);
idx        = find(POS == idx);

load(fullfile(getpref('cellbase','datapath'),r,s,strcat(f.rezName,'.mat')));

[Templates,~,W_Spikes] = creating_templates_on(rez,dataF);

template           = Templates(:,:,idx);
w_Spikes           = W_Spikes{idx};
Templates(:,:,idx) = [];
W_Spikes(idx)      = [];

if strcmp(f.comparison,'NSSD')
   [value,Idx]        = norm_Sum_of_squred_diff(template,Templates); %(!use channels from The PCA analysis)
elseif strcmp(f.comparison,'NCC')
   [value,Idx] = norm_cross_correlation(template,Templates);
end
    
W_Spikes_t        = W_Spikes(Idx); 
[d_isolation,mahal_d] = deal([]);
if any(strcmp(method,'mahal_d')) ||  any(strcmp(method,'d_isolation'))
    [mahal_d,d_isolation] = PCA_Mahanobilis_allCh(w_Spikes,W_Spikes_t,dataF,[]); 
end

end

