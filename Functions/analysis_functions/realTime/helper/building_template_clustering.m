function [confusion,score,mahal_d,d_isolation] = building_template_clustering(cellid,dataF,Timestamps)

global f

[r,s,~,~]  = cellid2tags(cellid);

load(fullfile(getpref('cellbase','datapath'),r,s,'rezfinal.mat'));

[Templates,tSpikes_on,wSpikes_on] = creating_templates_on(rez,dataF);

fullNameEvent    = fullfile(getpref('cellbase','datapath'),r,s,'Events.nev');
[TTLs,TTLs_time] = loadEvent(fullNameEvent);
TTL_value        = unique(TTLs);
TTL_value        = TTL_value(ismember(TTL_value,f.TTL));

[confusion,mahal_d,d_isolation] = deal({});
score        = [];
for j = TTL_value
    
    [wSpikes_RT,template,tSpikes_RT] = creating_templates_RT(dataF,Timestamps,TTLs_time,TTLs==j);
    
    %[NSSD(:,j),idx]       = norm_Sum_of_squred_diff(template,Templates_on); %(!use channels from The PCA analysis)
    
    if strcmp(f.comparison,'NSSD')
        [score(:,j),Idx]        = norm_Sum_of_squred_diff(template,Templates); %(!use channels from The PCA analysis)
    elseif strcmp(f.comparison,'NCC')
    
        template = template(2:end-1,:);
        for i = 1:size(Templates,3)
            score(:,j) = max(normxcorr2_mex(template,Templates(:,:,i),'valid'));
        end
        [score(:,j), idx] = sort(score(:,j));
        Idx          = idx(1:f.TT);
    end
    
    tSpikes_on_sim        = tSpikes_on(Idx); %taken out the spikes the match the NSSD calculation
    
    [confusion{end+1}]    = correlate_timing(tSpikes_RT,tSpikes_on_sim);
    
    [mahal_d{end+1},d_isolation{end+1}] = PCA_Mahanobilis_allCh(wSpikes_RT,wSpikes_on(Idx),dataF,TTL_value(j));
    
end
%close all
end

