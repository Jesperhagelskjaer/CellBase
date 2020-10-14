function [] = checking_indices_to_erase()

if ~all(findanalysis('Indices_to_erase'))
    fprintf("addanalysis(@choice_and_reward,1,'property_names',{'Indices_to_erase'})\n")
else
    
end

