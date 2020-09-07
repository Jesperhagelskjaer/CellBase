function [TrialT, SidePortExit, SidePortEntry, CenterPortExit, CenterPortEntry, RewardOn, TE] = GET_TRIAL_EVENTS_FROM_FILE_EXTENDED(LINK_Recordings)

fileName_TE = strcat(LINK_Recordings, '\TrialEvents.mat');
load(fileName_TE)

% Important TE (Time Events)
% ReactionTime = TE.ReactionTime;

if(exist('TE', 'var'))
    TrialT = TE.TrialTypes;

    if(isfield(TE,'SidePortExit'))
        SidePortExit = TE.SidePortExit;
        SidePortEntry = TE.SidePortEntry;
        RewardOn = TE.SidePortEntry;
    else
        R_real_entry = TE.RightPortEntry;
        L_real_entry = TE.LeftPortEntry;
        R_entry = TE.RightRewardON;
        R_exit = TE.RightPortExitLast;
        L_entry = TE.LeftRewardON;
        L_exit = TE.LeftPortExitLast;
        R_real_entry(isnan(R_real_entry)) = 0;
        L_real_entry(isnan(L_real_entry)) = 0;
        R_entry(isnan(R_entry)) = 0;
        L_entry(isnan(L_entry)) = 0;
        R_exit(isnan(R_exit)) = 0;
        L_exit(isnan(L_exit)) = 0;
        SidePortEntry = R_real_entry + L_real_entry;
        RewardOn = R_entry + L_entry;
        SidePortExit = R_exit + L_exit;
    end
    CenterPortExit = TE.CenterPortExit;
    CenterPortEntry = TE.CenterPortEntry;
else
    if ~exist('SidePortEntry', 'var')
        TrialT = TrialTypes;
        R_real_entry = RightPortEntry;
        L_real_entry = LeftPortEntry;
        R_entry = RightRewardON;
        R_exit = RightPortExitLast;
        L_entry = LeftRewardON;
        L_exit = LeftPortExitLast;
        R_real_entry(isnan(R_real_entry)) = 0;
        L_real_entry(isnan(L_real_entry)) = 0;
        R_entry(isnan(R_entry)) = 0;
        L_entry(isnan(L_entry)) = 0;
        R_exit(isnan(R_exit)) = 0;
        L_exit(isnan(L_exit)) = 0;
        SidePortEntry = R_real_entry + L_real_entry;
        RewardOn = R_entry + L_entry;
        SidePortExit = R_exit + L_exit;
        TE = [];
    else
        TrialT = TrialTypes;
%         SidePortExit = SidePortExit;
%         SidePortEntry = SidePortEntry;
        RewardOn = SidePortEntry;
    end
end

end