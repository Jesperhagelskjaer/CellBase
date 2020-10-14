function [] = checking_his(input)

for i = 1:numel(input.data)
    switch input.data{i}
        case 'C'
            if ~any(findanalysis('C_trial'))
                fprintf("addanalysis(@history_reward_choice,1,'property_names',{'C_trial'})\n")
            end
        case 'R'
            if ~any(findanalysis('R_trial'))
                fprintf("addanalysis(@history_reward_choice,1,'property_names',{'R_trial'})\n")
            end
        case 'NR'
            if ~any(findanalysis('NR_trial'))
                fprintf("addanalysis(@history_reward_choice,1,'property_names',{'NR_trial'})\n")
            end
    end
end
end

