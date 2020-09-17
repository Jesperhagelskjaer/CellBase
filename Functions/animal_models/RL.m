close all
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
firing         = 700;
incrase_f      = 2;
Firing         = zeros(nTrial+trial_lag,1);
reward_left    = reward(1,:)';
reward_right   = reward(2,:)';

a_right = (chosen_opt == 2 );
a_left  = (chosen_opt == 1 );


for t = 1:nTrial
    if a_right(t) == 1 && reward_right(t) == 1 
        Firing(t+trial_lag) = firing*incrase_f;
    else
        Firing(t+trial_lag) = firing;
    end
end

Firing(end-trial_lag+1:end)  = [];

reward_left_his  = reward_left;
reward_right_his = reward_right;
a_right_his      = a_right;
a_left_his       = a_left;
for i = 2:Trials_back
    reward_left_his(:,i)  = circshift(reward_left',  [0, i-1]);
    reward_right_his(:,i) = circshift(reward_right', [0, i-1]);
    a_right_his(:,i)      = circshift(a_right',  [0, i-1]);
    a_left_his(:,i)       = circshift(a_left',  [0, i-1]);
end


data = [a_right_his reward_right_his reward_left_his];
%data = [chosen_shift(:,2:end)]
[B,FitInfo] = lasso(data,Firing,'CV',4);
B = B(:,FitInfo.IndexMinMSE);

figure
plot(B)
% movA_Qa = movmean(Q(1,:),10);
% movA_Qb = movmean(Q(2,:),10);
% 
% figure
% plot(movA_Qa)
% hold on
% plot(a_bait_prob)
% legend('Qa', 'P(Reward A)')
% 
% figure
% plot(movA_Qb)
% hold on
% plot(b_bait_prob)
% legend('Qb', 'P(Reward B)')





