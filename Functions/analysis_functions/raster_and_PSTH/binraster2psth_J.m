function [psth, spsth, spsth_se] = binraster2psth_J(binraster,dt,sigma)

NUM_TRIALS = size(binraster,1);

% Calculate PSTH
psth = nanmean(binraster) / dt;
psth_sd = nanstd(binraster) / dt;
spsth = smoothed_psth(psth,dt,sigma);
spsth_se = smoothed_psth(psth_sd ./ sqrt(NUM_TRIALS-1),dt,sigma);

end