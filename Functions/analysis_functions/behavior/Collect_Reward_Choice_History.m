% Returns the reward history, choice history and incomplete trial indices
% from a file

function [RH, CH,Indices_to_erase] = Collect_Reward_Choice_History(TE)



% Which trials should the code take? Supplant:end-Substract
TrialLength = length(TE.TrialTypes);
Right    = nan(TrialLength,1); % animal went right received  reward (JH)
No_Right = nan(TrialLength,1); % animal went right received no reward (JH)
Left     = nan(TrialLength,1); % animal went left, received a reward  (JH)
No_Left  = nan(TrialLength,1); % animal went left, but did not get a reward (JH)


% A complete trial is defined it as when it reaches the state "Reward" or
% "NoReward"

 
Right(~isnan(TE.RightRewardON)) = 1;
No_Right(TE.NoReward == 1 & ~isnan(TE.RightPortEntry)) = 1;    
Left(~isnan(TE.LeftRewardON)) = 1;
No_Left(TE.NoReward == 1 & ~isnan(TE.LeftPortEntry)) = 1;    


% Make zero the NaN entries ()
Right(isnan(Right))       = 0; %if equal to nan the animal did not do that current action and therefore idx is set to zero (JH)
Left(isnan(Left))         = 0; %if equal to nan the animal did not do that current action and therefore idx is set to zero (JH)
No_Right(isnan(No_Right)) = 0; %if equal to nan the animal did not do that current action and therefore idx is set to zero (JH)
No_Left(isnan(No_Left))   = 0; %if equal to nan the animal did not do that current action and therefore idx is set to zero (JH)

% Combine the previous vectors for choice and reward history
Right_choice   = Right + No_Right;   %combination of the chose if there was no reward on the choise
Left_choice    = Left + No_Left;
Data_actions   = Right_choice + 2*Left_choice;
Reward_History = Right - Left; %(right == 1 ,left == -1)

% If it was neither 1 or 2 the action, then define it as incomplete
Indices_to_erase = find(Data_actions == 0);

% Correct reward and choice history
Reward_History(Indices_to_erase) = nan;
Data_actions(Indices_to_erase)   = nan;

% Convert them to vectors with {1,0} for CH and {1,0,-1} for RH
RH = Reward_History;
CH = Data_actions;
CH(CH == 2) = 0; %(right == 1, left == 0)
end