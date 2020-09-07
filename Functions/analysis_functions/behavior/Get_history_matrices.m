% CREATE HISTORY MATRICES
% Take the reward and choice history to create a matrix with m columns per 
% trial back, incluiding the current trial

function [R_R, R_L, C_R, C_L] = Get_history_matrices(RH, CH, Trials_back)

RH = RH';
CH = CH';

% Reward right
Reward_Right = RH;
Reward_Right(CH == 0) = 0; % If it was unchosen

% Copy the history and shift it one trial back per loop
R_R = Reward_Right; % Current trial
for i = 2:Trials_back
    R_R(i, :) = circshift(Reward_Right, [0, i - 1]);
end

% Reward left
Reward_Left = RH;
Reward_Left(CH == 1) = 0; % % If it was unchosen

% Copy the history and shift it one trial back per loop
R_L = Reward_Left; % Current trial
for i = 2:Trials_back
    R_L(i, :) = circshift(Reward_Left, [0, i - 1]);
end
% Reward left is taken from RH, it was originally negative, let's make it
% positive
R_L = -1*R_L;

% Choice right
% Copy the history and shift it one trial back per loop
Choice_Right = double(CH == 1);
C_R = Choice_Right; % Current trial
for i = 2:Trials_back
    C_R(i, :) = circshift(Choice_Right, [0, i - 1]);
end

% Choice left
C_L = double(C_R == 0);

end