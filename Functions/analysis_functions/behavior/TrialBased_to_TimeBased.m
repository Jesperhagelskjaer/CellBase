function [t_initial, t_stop, CT, RT] = TrialBased_to_TimeBased(CH, RH, CenterPortExit, RewardOn, dt, Time_back)

% The actual time back is dt*Time_back

% Define an action when the mouse leaves the center port
dummy = CenterPortExit;
ChoiceTime_Right = dummy.*(CH == 1);
ChoiceTime_Left = -dummy.*(CH == 0);
CT_pre = ChoiceTime_Right + ChoiceTime_Left;

% Define a reward when the reward is onset
dummy = RewardOn;
RewardTime_Right = dummy.*(RH == 1);
RewardTime_Left = -dummy.*(RH == -1);
RT_pre = RewardTime_Right + RewardTime_Left;

% Look only at the data between the first and the last event previously
% defined
t_initial = min([min(abs(CT_pre(CT_pre ~= 0))), min(abs(RT_pre(RT_pre ~= 0)))]);
t_stop = max([max(abs(CT_pre)), max(abs(RT_pre))]) + 2*dt;

% Memory allocation
ChoiceTime_Right_post = zeros(1, numel(t_initial:dt:t_stop));
ChoiceTime_Left_post = zeros(1, numel(t_initial:dt:t_stop));
RewardTime_Right_post = zeros(1, numel(t_initial:dt:t_stop));
RewardTime_Left_post = zeros(1, numel(t_initial:dt:t_stop));

% Counts the number of events per time bin with width "dt"
i = 1;
for t = t_initial:dt:t_stop
    ChoiceTime_Right_post(i) = nnz((abs(ChoiceTime_Right) >= t) & (abs(ChoiceTime_Right) < t+dt));
    ChoiceTime_Left_post(i) = -nnz((abs(ChoiceTime_Left) >= t) & (abs(ChoiceTime_Left) < t+dt));
    RewardTime_Right_post(i) = nnz((abs(RewardTime_Right) >= t) & (abs(RewardTime_Right) < t+dt));
    RewardTime_Left_post(i) = -nnz((abs(RewardTime_Left) >= t) & (abs(RewardTime_Left) < t+dt));
    i = i + 1;
end

% Combine the history to have one single vector with {-1,0,1}
CTx = ChoiceTime_Right_post + ChoiceTime_Left_post;
RTx = RewardTime_Right_post + RewardTime_Left_post;

% Memory allocation
CT = zeros(Time_back, length(CTx));
RT = zeros(Time_back, length(RTx));

% Create a matrix per history that saves what happened a Time_back number
% of dt bins
for i = 1:Time_back
    CT(i, :) = circshift(CTx, [0 i-1]);
    RT(i, :) = circshift(RTx, [0 i-1]);
end

end