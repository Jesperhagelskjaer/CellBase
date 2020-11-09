function [stimes] = stimes_event(SP,g,data,j)

if isempty(g.event)
    trigger_pos       = findcellstr(SP.events(:,1),g.triggerName{j});
    stimes           = SP.event_stimes{trigger_pos}(data);    
else
    trigger_pos      = findcellstr(SP.events(:,1),g.event);
    stimes           = SP.event_stimes{trigger_pos}(data);    
end

