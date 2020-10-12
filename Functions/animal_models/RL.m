%close all
clear all
clc
%%
rng(10)

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
            
             a_bait_prob(t) = a_prob;
             b_bait_prob(t) = b_prob;
           
            
            if choice_prob(t)> rand
                chosen_opt(t) = 1;
                
                if a_prob > rand
                    reward(1,t) = 1;
                else
                    no_reward(1,t) = 1;
                end
                
                Q(1,t+1) = Q(1,t) + lr*(reward(1,t)-Q(1,t)) ;
                Q(2,t+1) = Q(2,t) + forget_rate*(0-Q(2,t)) ;
                
                b_prob  = 1 - (1 - opt_b_prob(TrialTypes(t-count_b + 2)))^count_b;
                a_prob  = opt_a_prob(TrialTypes(t));
                count_a = 2;
                count_b = count_b + 1;
            else
                chosen_opt(t) = 2;
                
                if b_prob > rand
                    reward(2,t) = 1;
                else
                    no_reward(2,t) = 1;
                end
                
                Q(1,t+1) = Q(1,t) + forget_rate*(0-Q(1,t));
                Q(2,t+1) = Q(2,t) + lr*(reward(2,t)-Q(2,t));
                
                a_prob  = 1 - (1 - opt_a_prob(TrialTypes(t-count_a + 2)))^count_a;
                b_prob = opt_b_prob(TrialTypes(t));
                count_b = 2;
                count_a = count_a + 1;
            end

        end
end

if 0
movA_Qa = movmean(Q(1,:),10);
movA_Qb = movmean(Q(2,:),10);

figure
plot(movA_Qa)
hold on
plot(a_bait_prob)
legend('Qa', 'P(Reward A)')

figure
plot(movA_Qb)
hold on
plot(b_bait_prob)
legend('Qb', 'P(Reward B)')  
end



%% plot Q values, reward and choice outcome and choice probabilities

Trials_back     = 11;
firing          = 7;
inc_noice_f     = 1;
remember_rate   = 0.7;
Firing          = zeros(nTrial+11,1);
reward_left     = reward(1,:)';
reward_right    = reward(2,:)';
a_right         = (chosen_opt == 2 );
a_left          = (chosen_opt == 1 );
no_reward_left  = no_reward(1,:)';
no_reward_right = no_reward(2,:)';
no_reward       = ones(numel(reward_left),1)-reward_left-reward_right;
all_reward      = reward_left + reward_right;
                %name,condition(0/1),trial_lag,increase_firing
%condition = {'a_right',1,3,2;...      
%             'a_left', 1,3,2;};
%condition = {'a_right',1,3,2};
%condition = {'a_right',1,3,0.5};
%condition = {'a_left',1,3,2};
%condition = {'a_left',1,3,0.5};
%condition = {'reward_right',1,3,2;...     
%             'reward_left', 1,4,3;};
%condition = {'reward_right',1,3,0.5;...     
%             'reward_left', 1,4,2;};

%condition = {'a_right',1,3,2;...      
%             'a_left', 1,4,3;};


%condition = {'no_reward',1,3,2};      
%condition = {'reward_right',1,3,2};
%condition = {'reward_right',1,3,0.5}; 
%condition = {'reward_left',1,3,2};
%condition = {'reward_left',1,3,0.5};
%condition  = {'no_reward_right',1,3,3};
%condition  = {'no_reward_right',1,3,0.6;...
%              'no_reward_left',1,3,1};

%condition = {'reward_left',1,3,2};
%condition = {'reward_left',1,3,0.5};
%condition = {'no_reward_left',1,3,2};
%condition = {'no_reward_left',1,3,0.5};
condition = {'a_right',1,3,2;...
             'no_reward_left',1,3,1.4;...
             'reward_right',1,3,1.2};

r = rand(numel(Firing),1) - 1;
Firing(:) = firing+r*inc_noice_f;

con = zeros(nTrial+11,1);
for c = 1:size(condition,1)
    value     = eval(condition{c,1}) == condition{c,2};
    trial_lag = condition{c,3};
    incrase_f = condition{c,4};
    for t = 1:nTrial
        if value(t) == 1
             if remember_rate > rand
                if ~(incrase_f == 1)  
                    Firing(t+trial_lag) = Firing(t+trial_lag) + incrase_f * rand;
                end
            end
            con(t+trial_lag) = c;
        end       
    end
end
if any(Firing < 0)
    disp('Negative firing rate of one or more trals')
end
t1 = size(value,1);
t2 = size(Firing,1);
Firing(end-(t2-t1)+1:end)  = [];
con(end-(t2-t1)+1:end)     = [];

reward_left_his     = reward_left;
reward_right_his    = reward_right;
non_reward_his      = no_reward;
a_right_his         = double(a_right);
a_left_his          = double(a_left);
no_reward_left_his  = double(no_reward_left);
no_reward_right_his = double(no_reward_right);
all_reward_his      = all_reward;
for i = 2:Trials_back
    reward_left_his(:,i)     = circshift(reward_left',    [0, i-1]);
    reward_right_his(:,i)    = circshift(reward_right',   [0, i-1]);
    a_right_his(:,i)         = circshift(a_right',        [0, i-1]);
    a_left_his(:,i)          = circshift(a_left',         [0, i-1]);
    non_reward_his(:,i)      = circshift(no_reward',      [0, i-1]);
    no_reward_left_his(:,i)  = circshift(no_reward_left', [0, i-1]);
    no_reward_right_his(:,i) = circshift(no_reward_right',[0, i-1]);
    all_reward_his(:,i)      = circshift(all_reward',     [0, i-1]);
end

idx = 1:Trials_back:4*11;
data = [reward_left_his reward_right_his no_reward_left_his no_reward_right_his];
B_temp = zeros(25, size(data,2));

parfor j = 1:25 % PARALLEL
    [B, FitInfo] = lasso(data,Firing, 'CV', 2, 'MaxIter', 1e3); %CV 4
    B_temp(j, :) = B(:, FitInfo.IndexMinMSE);
end


B_all = mean(B_temp);
%M = median(B_temp)
figure
errorbar(B_all,std(B_temp))
boxplot(B_temp)
hold on
plot(idx,zeros(numel(idx),1),'*')
title('reward left - reward right - no reward left - no reward right')
%lassoPlot(B,FitInfo,'PlotType','CV');

idx         = (con == 0);
con(idx)    = [];
Firing(idx) = [];

[~,~,~,AUC] = perfcurve(con,Firing,'1')
[~,~,~,AUC] = perfcurve(con,Firing,'2')
figure
histogram(Firing(con == 1))
hold on 
histogram(Firing(con == 2))
[D, P, SE] = rocarea(Firing(con == 1),Firing(con == 2),'bootstrap',100,'display',1)
