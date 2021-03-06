function [varargout] = history_reward_choice(cellid,varargin)
%   Examples:
% add_analysis(@history_reward_choice,1,'property_names',{'R_trial','C_trial','NR_trial'},'arglist',{'Trials_back',11})
% add_analysis(@history_reward_choice,0,'property_names',{'R_trial','C_trial','NR_trial'},'arglist',{'Trials_back',11})
% delanalysis(@history_reward_choice)

% created (JH) 2020-07-19


global TheMatrix
global CELLIDLIST
persistent f

if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'Trials_back',11,@(x) isscalar(x) && x > 0)
    parse(prs,varargin{:})
    
    f = prs.Results;
    checking_choice_and_reward(method)
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx_neuron = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

[R_trial,C_trial,NR_trial]       = deal([]);
if (POS(1) == idx_neuron)
    CH  = TheMatrix{POS(1),findanalysis('CH')};
    RH  = TheMatrix{POS(1),findanalysis('RH')};
    NRH = TheMatrix{POS(1),findanalysis('NRH')};
    CH(isnan(CH))             = [];
    RH(isnan(RH))             = [];
    NRH(isnan(NRH))           = [];
 
    [R_trial, NR_trial, C_trial] = Get_history_matrices(RH, CH, NRH, f.Trials_back);
end


varargout{1}.R_trial        = R_trial;
varargout{1}.NR_trial       = NR_trial;
varargout{1}.C_trial        = C_trial;
end


