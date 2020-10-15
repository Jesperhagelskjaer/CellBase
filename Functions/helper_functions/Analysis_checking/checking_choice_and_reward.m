function [] = checking_choice_and_reward(input)

for i = 1:numel(input)
    switch input{i}
        case 'C_trial'
            if ~any(findanalysis('CH'))
                fprintf("addanalysis(@Choice_and_reward,'property_names',{'CH','RH','NR'})\n")
            end
        case 'R_trial'
            if ~any(findanalysis('RH'))
                fprintf("addanalysis(@Choice_and_reward,'property_names',{'CH','RH','NR'})\n")
            end
        case 'NR_trial'
            if ~any(findanalysis('NRH'))
                fprintf("addanalysis(@Choice_and_reward,'property_names',{'CH','RH','NR'})\n")
            end
    end
end
end

