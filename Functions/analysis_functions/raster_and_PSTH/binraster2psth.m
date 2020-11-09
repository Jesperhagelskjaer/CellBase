function [psth, spsth, spsth_se] = binraster2psth(binraster,g)

NUM_TRIALS = size(binraster,1);
margin = g.sigma * g.sigma_ex; 
remove_idx = (numel(-margin:g.dt:margin)-1)/2;

% Calculate PSTH
psth     = mean(binraster) / g.dt;
psth_sd  = std(binraster) / g.dt;
spsth    = smoothed_psth(psth,g);
spsth_se = smoothed_psth(psth_sd ./ sqrt(NUM_TRIALS-1),g);

psth(:,1:remove_idx)           = []; 
psth(:,end-remove_idx:end)     = []; 
spsth(:,1:remove_idx)          = []; 
spsth(:,end-remove_idx:end)    = []; 
spsth_se(:,1:remove_idx)       = []; 
spsth_se(:,end-remove_idx:end) = []; 
end