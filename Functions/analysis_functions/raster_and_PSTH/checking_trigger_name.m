function [g] = checking_trigger_name(TE,g)

%if only one triggerName the user can input the name as array, however in the code it must be a cell
if ~iscell(g.triggerName)
    g.triggerName = {g.triggerName};
end

for i = 1:numel(g.triggerName)
    % TriggerName mismatch
    if isfield(TE,g.triggerName{i}) == 0
        error('trigger name not found');
    end
end

if ~isempty(g.event)
    % TriggerName mismatch
    if isfield(TE,g.event) == 0
        error('event name not found');
    end
end

end

