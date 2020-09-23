%close all
clear all
clc
%% setting parameters
baiting_factor = 0.1 ;
lr             = 0.4;
forget_rate    = 0.2;
temperature    = 1.5; %1.5;
types          = 6;
nrepeats       = 3;
count_a        = 2;
count_b        = 2;

model_name     = 'baiting';   % block_length  /  baiting

trials_block = repmat(1:types,1,nrepeats);
typeorder    = trials_block(randperm(numel(trials_block)));
TrialTypes   = repelem(typeorder,randi([50 150], 1, types*nrepeats));

opt_a_prob = [0.1 0.4 0.25 0.25 0.17 0.33];
opt_b_prob = [0.4 0.1 0.25 0.25 0.33 0.17];

a_prob = opt_a_prob(TrialTypes(1));
b_prob = opt_b_prob(TrialTypes(1));

nTrial         = length(TrialTypes);
b_bait_prob    = zeros(nTrial,1);
a_bait_prob    = zeros(nTrial,1);
choice_prob    = NaN(nTrial,1);
chosen_opt     = NaN(nTrial,1); % A=1 ; B=0
reward         = zeros(2,nTrial);
no_reward      = zeros(2,nTrial);
Q              = NaN(2,nTrial);

Q(:,1)          = 0.5; %rand(1);

% computing the Q values and choice probability
switch model_name
    case 'block_length'
        for t = 1:nTrial
            if t>transit_block
                opt_a_prob = TrialTypes(t);
                opt_b_prob = TrialTypes(t);
            end
            
            choice_prob(t) = exp(Q(1,t)./temperature) / sum(exp(Q(:,t)./temperature));
            
            if choice_prob(t)> rand
                chosen_opt(t) = 1;
                if opt_a_prob > rand
                    reward(1,t) = 1;
                end
                
                Q(1,t+1) = Q(1,t) + lr*(reward(1,t)-Q(1,t)) ;
                Q(2,t+1) = Q(2,t) + forget_rate*(reward(2,t)-Q(2,t)) ;
            else
                chosen_opt(t) = 2;
                if opt_b_prob(t) > rand
                    reward(2,t) = 1;
                end
                
                Q(1,t+1) = Q(1,t) + forget_rate*(reward(1,t)-Q(1,t));
                Q(2,t+1) = Q(2,t) + lr*(reward(2,t)-Q(2,t)) ;
            end
        end
    case 'baiting'
        for t = 1:nTrial
            choice_prob(t) = exp(Q(1,t)./temperature) / sum(exp(Q(:,t)./temperature));
            
            if choice_prob(t)> rand
                chosen_opt(t) = 1;
                a_prob = opt_a_prob(TrialTypes(t));
                if a_prob > rand
                    reward(1,t) = 1;
                else
                    no_reward(1,t) = 1;
                end
                
                Q(1,t+1) = Q(1,t) + lr*(reward(1,t)-Q(1,t)) ;
                Q(2,t+1) = Q(2,t) + forget_rate*(0-Q(2,t)) ;
                
                b_prob  = 1 - (1 - opt_b_prob(TrialTypes(t-count_b + 2)))^count_b;
                count_a = 2;
                count_b = count_b + 1;
            else
                chosen_opt(t) = 2;
                b_prob = opt_b_prob(TrialTypes(t));
                if b_prob > rand
                    reward(2,t) = 1;
                else
                    no_reward(2,t) = 1;
                end
                
                Q(1,t+1) = Q(1,t) + forget_rate*(0-Q(1,t));
                Q(2,t+1) = Q(2,t) + lr*(reward(2,t)-Q(2,t));
                
                a_prob  = 1 - (1 - opt_a_prob(TrialTypes(t-count_a + 2)))^count_a;
                count_b = 2;
                count_a = count_a + 1;
            end
            b_bait_prob(t) = b_prob;
            a_bait_prob(t) = a_prob;
        end
end
%% plot Q values, reward and choice outcome and choice probabilities
trial_lag      = 3;
Trials_back    = 11;
firing         = 7;
increase_noice = 3;
Firing         = zeros(nTrial+trial_lag,1);
reward_left    = reward(1,:)';
reward_right   = reward(2,:)';
a_right        = (chosen_opt == 2 );
a_left         = (chosen_opt == 1 );
no_reward_left  = no_reward(1,:)';
no_reward_right = no_reward(2,:)';
no_reward     = ones(numel(reward_left),1)-reward_left-reward_right;
all_reward    = reward_left + reward_right;

%condition = {'reward_right',1,3,2;...      %name,condition(0/1),trial_lag,increase_firing
%    'reward_left', 1,4,3;};
%condition = {'reward_right',1,3,2;...      %name,condition(0/1),trial_lag,increase_firing
%    'reward_left', 1,4,3;};

%condition = {'a_right',1,3,2;...      %name,condition(0/1),trial_lag,increase_firing
%    'a_left', 1,4,3;};

%condition = {'a_right',1,3,2;...      %name,condition(0/1),trial_lag,increase_firing
%    'a_left', 1,4,3;};



%condition = {'no_reward',1,3,2};      %name,condition(0/1),trial_lag,increase_firing
%condition = {'reward_right',1,3,2};      %name,condition(0/1),trial_lag,increase_firing
%condition = {'reward_left',1,3,2};
condition  = {'no_reward_right',1,3,2};

Firing(:) = firing;
for c = 1:size(condition,1)
    value     = eval(condition{c,1}) == condition{c,2};
    trial_lag = condition{c,3};
    incrase_f = condition{c,4};
    for t = 1:nTrial
        if value(t) == 1
            Firing(t+trial_lag) = firing*incrase_f+rand*increase_noice;
        end
    end
end
t1 = size(reward_left,1);
t2 = size(Firing,1);
Firing(end-(t2-t1)+1:end)  = [];

reward_left_his  = reward_left;
reward_right_his = reward_right;
non_reward_his   = no_reward;
a_right_his      = double(a_right);
a_left_his       = double(a_left);
no_reward_left_his  = double(no_reward_left);
no_reward_right_his = double(no_reward_right);
all_reward_his = all_reward;
for i = 2:Trials_back
    reward_left_his(:,i)  = circshift(reward_left',  [0, i-1]);
    reward_right_his(:,i) = circshift(reward_right', [0, i-1]);
    a_right_his(:,i)      = circshift(a_right',      [0, i-1]);
    a_left_his(:,i)       = circshift(a_left',       [0, i-1]);
    non_reward_his(:,i)   = circshift(no_reward',    [0, i-1]);
    no_reward_left_his(:,i)  = circshift(no_reward_left',       [0, i-1]);
    no_reward_right_his(:,i) = circshift(no_reward_right',    [0, i-1]);
    all_reward_his(:,i)          =  circshift(all_reward',    [0, i-1]);
end

idx = 1:Trials_back:7*11;

figure
data = [a_right_his a_left_his reward_left_his reward_right_his non_reward_his];
[B,FitInfo] = lasso(data,Firing,'CV',4);
%lassoPlot(B,FitInfo,'PlotType','CV');
%legend('show') % Show legend
B = B(:,FitInfo.IndexMinMSE);
subplot(3,3,1)
plot(B)
hold on
plot(idx,[0 0 0 0 0 0 0],'*')
title('a right - a left - reward left - reward right - no reward')

data = [a_right_his reward_right_his non_reward_his];
[B,FitInfo] = lasso(data,Firing,'CV',4);
% lassoPlot(B,FitInfo,'PlotType','CV');
% legend('show') % Show legend
B = B(:,FitInfo.IndexMinMSE);
subplot(3,3,2)
plot(B)
hold on
plot(idx,[0 0 0 0 0 0 0],'*')
title('a right - reward right - no reward')

data = [a_left_his reward_left_his non_reward_his];
[B,FitInfo] = lasso(data,Firing,'CV',4);
% lassoPlot(B,FitInfo,'PlotType','CV');
% legend('show') % Show legend
B = B(:,FitInfo.IndexMinMSE);
subplot(3,3,3)
plot(B)
hold on
plot(idx,[0 0 0 0 0 0 0],'*')
title('a left - reward left - no reward')

data = [a_left_his reward_left_his reward_right_his no_reward_left_his no_reward_right_his non_reward_his];
[B,FitInfo] = lasso(data,Firing,'CV',4);
%lassoPlot(B,FitInfo,'PlotType','CV');
%legend('show') % Show legend
B = B(:,FitInfo.IndexMinMSE);
subplot(3,3,7)
plot(B)
hold on
plot(idx,[0 0 0 0 0 0 0],'*')
title('a l - reward left - reward right - no reward left - no reward right - no reward')

data = [a_right_his a_left_his reward_left_his reward_right_his no_reward_left_his no_reward_right_his all_reward_his];
[B,FitInfo] = lasso(data,Firing,'CV',4);
%lassoPlot(B,FitInfo,'PlotType','CV');
%legend('show') % Show legend
B = B(:,FitInfo.IndexMinMSE);
subplot(3,3,8)
plot(B)
hold on
plot(idx,[0 0 0 0 0 0 0],'*')
title('a l - a r - reward left - reward right - no reward left - no reward right - all reward')

data = [a_left_his reward_left_his reward_right_his];
[B,FitInfo] = lasso(data,Firing,'CV',4);
% lassoPlot(B,FitInfo,'PlotType','CV');
% legend('show') % Show legend
B = B(:,FitInfo.IndexMinMSE);
subplot(3,3,9)
plot(B)
hold on
plot(idx,[0 0 0 0 0 0 0],'*')
title('a left - reward left - reward right')



