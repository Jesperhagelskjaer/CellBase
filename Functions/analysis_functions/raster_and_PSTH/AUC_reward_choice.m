function [varargout] = AUC_reward_choice(cellid,varargin)
% add_analysis(@AUC_reward_choice,0,'property_names',{'AUC_past_choice_r', 'AUC_past_reward_right', 'AUC_past_choice_nr', 'AUC_past_reward_left','AUC_next_choice', 'AUC_next_choice_control'});

% delanalysis(@AUC_reward_choice)

% JH 2020_06_30 / 2020_10_30
global TheMatrix
global CELLIDLIST
global f
if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'bootstrap',1000,@(x) isscalar(x) && x > 0) %
    addParameter(prs,'transform','none',@(s)ismember(s,{'none' 'swap' 'scale'}))   % rescaling
    addParameter(prs,'display',false,@(s)islogical(s)|ismember(s,[0 1]))
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    checking_freq();
    checking_choice_and_reward({'CH','RH'})
    
    return
end

[r,s,~,~] = cellid2tags(cellid);
POS       = findcellpos('animal',r,'session',s); %(!) find faster method
[POS1, ~] = findanalysis('CH');
[POS2, ~] = findanalysis('RH');
CH        = TheMatrix{POS(1),POS1};
RH        = TheMatrix{POS(1),POS2};

Firing = TheMatrix{findcellstr(CELLIDLIST',cellid),findanalysis('CentralPortEpoch')};
RMI                = isnan(CH);
CH(RMI)            = []; %check up on make sure equal length
RH(RMI)            = []; %check up on
Firing(RMI)        = [];

past_left_choice            = circshift(CH == -1, [1 0]);
past_right_choice           = circshift(CH == 1, [1 0]);
RH(RH == -1)                = 1; %(j) %did the animal receive a reward on either the left or right side
past_trial_rewarded         = circshift(RH, [1 0]);

inx_r_rew  = past_right_choice == 1 & past_trial_rewarded == 1;
inx_l_rew  = past_left_choice  == 1 & past_trial_rewarded == 1;
inx_r_nrew = past_right_choice == 1 & past_trial_rewarded == 0;
inx_l_nrew = past_left_choice  == 1 & past_trial_rewarded == 0;

[AUC_past_choice_r, AUC_past_choice_r_P, ~]             = rocarea(Firing(inx_r_rew),Firing(inx_l_rew));
[AUC_past_reward_right, AUC_past_reward_right_P, ~]     = rocarea(Firing(inx_r_rew),Firing(inx_r_nrew));
[AUC_past_choice_nr, AUC_past_choice_nr_P, ~]           = rocarea(Firing(inx_r_nrew),Firing(inx_l_nrew));
[AUC_past_reward_left, AUC_past_reward_left_P, ~]       = rocarea(Firing(inx_l_rew),Firing(inx_l_nrew));
[AUC_next_choice,AUC_next_choice_P,~]                   = rocarea(Firing(CH == 1),Firing(CH == -1));
[AUC_next_choice_control,AUC_next_choice_control_P,~]   = rocarea(Firing(CH(randperm(length(CH))) == 1),Firing(CH(randperm(length(CH))) == -1));

varargout{1}.AUC_past_choice_r         = AUC_past_choice_r;
varargout{1}.AUC_past_choice_r_P       = AUC_past_choice_r_P;
varargout{1}.AUC_past_choice_nr        = AUC_past_choice_nr;
varargout{1}.AUC_past_choice_nr_P      = AUC_past_choice_nr_P;
varargout{1}.AUC_past_reward_right     = AUC_past_reward_right;
varargout{1}.AUC_past_reward_right_P   = AUC_past_reward_right_P;
varargout{1}.AUC_past_reward_left      = AUC_past_reward_left;
varargout{1}.AUC_past_reward_left_P    = AUC_past_reward_left_P;
varargout{1}.AUC_next_choice           = AUC_next_choice;
varargout{1}.AUC_next_choice_P         = AUC_next_choice_P;
varargout{1}.AUC_next_choice_control   = AUC_next_choice_control;
varargout{1}.AUC_next_choice_control_P = AUC_next_choice_control_P;

end