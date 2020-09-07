% this script uses AUC_reward_choice function to compute selectivity of
% neurons for past rewards and choices
clear; 
loadcb;
cellid = listtag('cells');
path = 'O:\ST_Duda\Maria\CellBaseFreeChoiceBaitBlock';
AUC = struct;
for i = 1:length(cellid)
[varargout] = AUC_reward_choice(cellid{i},path);
AUC.past_choice_r(i) = varargout.AUC_past_choice_r ;
AUC.past_choice_r_P(i) = varargout.AUC_past_choice_r_P ;
AUC.past_choice_nr(i) = varargout.AUC_past_choice_nr;
AUC.past_choice_nr_P(i) = varargout.AUC_past_choice_nr_P;
AUC.past_reward_right(i) =  varargout.AUC_past_reward_right;
AUC.past_reward_right_P(i) =  varargout.AUC_past_reward_right_P;
AUC.past_reward_left(i) =  varargout.AUC_past_reward_left;
AUC.past_reward_left_P(i) =  varargout.AUC_past_reward_left_P;
AUC.next_choice(i) =  varargout.AUC_next_choice;
AUC.next_choice_P(i) =  varargout.AUC_next_choice_P;
AUC.next_choice_control(i) =  varargout.AUC_next_choice_control;
AUC.next_choice_control_P(i) =  varargout.AUC_next_choice_control_P;
end
