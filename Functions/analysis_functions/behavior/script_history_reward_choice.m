
cellid = listtag('cells');
path = 'O:\Nat_Duda\Maria\CellBaseFreeChoiceBaitBlock';
for i = 1 %852 %length(cellid)
%   [varargout] = history_reward_choice(cellid{i},path,'Trials_back', 11, 'Time_back', 41,'dt',0.2);
% varargout(1).R_trial;
% varargout(1).C_trial;
% varargout(1).C_current_time;
%    [varargout] = behaviour_neurons_kernels(cellid{i});
%    [varargout] = IC_refractary_period(cellid{1},path,'method','diff','refractory_p', 1);
[averageFiringRate] = averageFiringRate(cellid{i},path);

end
