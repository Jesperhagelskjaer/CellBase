function [g] = checking_trigger_name(SP,g)

%if only one triggerName the user can input the name as array, however in the code it must be a cell
if ~iscell(g.triggerName)
    g.triggerName = {g.triggerName};
end

for i = 1:numel(g.triggerName)
    % TriggerName mismatch
    if findcellstr(SP.events(:,1),g.triggerName{i}) == 0
        error('trigger name not found');
    end
end
end

