function [psth, spsth, spsth_se] = binraster2psth(binraster)

global f

NUM_TRIALS = size(binraster,1);
margin = f.sigma * f.sigma_ex; 
remove_idx = (numel(-margin:f.dt:margin)-1)/2;

% Calculate PSTH
psth     = mean(binraster) / f.dt;
psth_sd  = std(binraster) / f.dt;
spsth    = smoothed_psth(psth);
spsth_se = smoothed_psth(psth_sd ./ sqrt(NUM_TRIALS-1));

psth(:,1:remove_idx)           = []; 
psth(:,end-remove_idx:end)     = []; 
spsth(:,1:remove_idx)          = []; 
spsth(:,end-remove_idx:end)    = []; 
spsth_se(:,1:remove_idx)       = []; 
spsth_se(:,end-remove_idx:end) = []; 
end