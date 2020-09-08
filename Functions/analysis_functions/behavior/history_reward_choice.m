function [varargout] = history_reward_choice(cellid,varargin)

% add_analysis(@history_reward_choice,1,'property_names',{'R_trial','C_trial'},'arglist',{'Trials_back',11})

% delanalysis(@history_reward_choice)

% created (JH) 2020-07-19
% To Do
% rewrite so no flipping is need change Junior code

global TheMatrix
global CELLIDLIST
persistent f

method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'Trials_back',11,@isnumeric)
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

Trials_back = f.Trials_back;

[ratname,session,~,~] = cellid2tags(cellid);
path_rat = fullfile(f.path,ratname,session);
full_temp = fullfile(path_rat,'*FreeChoice*');
behavior_session = size(dir(full_temp),1);

[r,s,~,~] = cellid2tags(cellid);

status = 1;
idx_neuron = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS = findcellpos('animal',r,'session',s); %(!) find faster method
if (POS(1) == idx_neuron) %check for already done
    status = 0;
end

if (behavior_session == 1) && ~isnan(status)
    
    Idx = findanalysis(@choice_and_reward);
    if ~all(Idx)
        fprintf("addanalysis(cChoice_and_reward,'property_names',{'CH','RH','Indices_to_erase'})\n")
    else
        [POS1, ~] = findanalysis('CH');
        [POS2, ~] = findanalysis('RH');
        CH = TheMatrix{POS(1),POS1};
        RH = TheMatrix{POS(1),POS2};
    end
    [~, ~, ~, CenterPortExit, ~, ~] = GET_TRIAL_EVENTS_FROM_FILE_EXTENDED(path_rat); %(!)
    if isempty(RH)
        status = 1;
    elseif length(RH) ~= length(CenterPortExit)
        status = nan;
    end
end

if isnan(status) || behavior_session ~= 1
    R_trial        = nan;
    C_trial        = nan;
elseif status == 0
    CH(isnan(CH))             = []; %check up on (JH)
    RH(isnan(CH))             = []; %check up on (JH)
    
    % TRIALS
    [R_R, R_L, C_R, C_L] = Get_history_matrices(RH, CH, Trials_back);
    R_pred = R_R - R_L;
    C_pred = C_R - C_L;
    
    R_pred(1, :) = [];
    C_pred(1, :) = [];
    R_trial        = single(R_pred');
    C_trial        = single(C_pred');
elseif status == 1
    R_trial        = [];
    C_trial        = [];
end

varargout{1}.R_trial        = R_trial;
varargout{1}.C_trial        = C_trial;

end