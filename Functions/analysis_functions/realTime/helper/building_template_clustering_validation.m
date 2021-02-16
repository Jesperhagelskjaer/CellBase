function [NSSD,mahal_d,d_isolation] = building_template_clustering_validation(cellid,dataF)

global CELLIDLIST
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
    [NSSD,Idx]        = norm_Sum_of_squred_diff(template,Templates); %(!use channels from The PCA analysis)
elseif strcmp(f.comparison,'NCC')
    template = template(2:end-1,:);
    for i = 1:size(Templates,3)
        NCC_value(i) = max(normxcorr2_mex(template,Templates(:,:,i),'valid'));
    end
    [value, idx] = sort(NCC_value);
    Idx          = idx(1:f.TT);    
end
    
W_Spikes_t        = W_Spikes(Idx); 
    
[mahal_d,d_isolation] = PCA_Mahanobilis_allCh(w_Spikes,W_Spikes_t,dataF,[]); 

end

