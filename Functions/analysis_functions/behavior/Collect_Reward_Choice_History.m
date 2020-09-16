% Returns the reward history, choice history and incomplete trial indices
% from a file

function [RH, CH,Indices_to_erase] = Collect_Reward_Choice_History(TE)

% Which trials should the code take? Supplant:end-Substract
TrialLength = length(TE.TrialTypes);
Right       = zeros(TrialLength,1,'single'); % animal went right received  reward (JH)
No_Right    = zeros(TrialLength,1,'single'); % animal went right received no reward (JH)
Left        = zeros(TrialLength,1,'single'); % animal went left, received a reward  (JH)
No_Left     = zeros(TrialLength,1,'single'); % animal went left, but did not get a reward (JH)

% A complete trial is defined it as when it reaches the state "Reward" or
% "NoReward"
Right(~isnan(TE.RightRewardON)) = 1;
Left(~isnan(TE.LeftRewardON))   = 1;
No_Right(TE.NoReward == 1 & ~isnan(TE.RightPortEntry)) = 1;    
No_Left(TE.NoReward  == 1 & ~isnan(TE.LeftPortEntry))  = 1;    

% Combine the previous vectors for choice and reward history
Right_choice = Right + No_Right;   %combination of the chose if there was no reward on the choise
Left_choice  = Left + No_Left;
CH           = Right_choice + 2*Left_choice;
RH           = Right - Left; %(right == 1 ,left == -1)

% If it was neither 1 or 2 the action, then define it as incomplete
Indices_to_erase = find(CH == 0);

% Correct reward and choice history
RH(Indices_to_erase) = nan;
CH(Indices_to_erase) = nan;

% Convert them to vectors with {1,0} for CH and {1,0,-1} for RH
CH(CH == 2) = 0; %(right == 1, left == 0)
end