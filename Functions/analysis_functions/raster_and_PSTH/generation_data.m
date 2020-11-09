function [raster_high, spsth, tt] = generation_data(TE,SP,g)

idx = 0;
for j = 1:numel(g.triggerName)
    valid_trial                     = TE.(g.triggerName{j});
    valid_trial(valid_trial > 0)    = 1;
    valid_trial(isnan(valid_trial)) = 0;
    valid_trial_shift               = circshift(valid_trial', [g.trial 0]);
    [data]                          = splitting_data_set(valid_trial_shift,g);
    
    for i = 1:size(data,2)
        idx = idx + 1;
        [stimes]                           = stimes_event(SP,g,data{i},j);
        [raster_high{idx},raster_low{idx}] = stimes2binraster(g,stimes);
        [~, spsth(:,idx), ~]               = binraster2psth(raster_low{idx},g);
        
    end
end
tt = size(data,2);

end

