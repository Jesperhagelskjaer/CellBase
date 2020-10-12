% CREATE HISTORY MATRICES
% Take the reward and choice history to create a matrix with m columns per 
% trial back, incluiding the current trial

function [RH_his, NR_his, CH_his] = Get_history_matrices(RH_his, CH_his, NR_his, Trials_back)

for i = 2:Trials_back
    RH_his(:,i) = circshift(RH, [i - 1,0]);
    NR_his(:,i) = circshift(NR, [i - 1,0]);
    CH_his(:,i) = circshift(CH, [i - 1,0]);
end

end


