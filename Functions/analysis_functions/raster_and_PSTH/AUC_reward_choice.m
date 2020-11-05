function [varargout] = AUC_reward_choice(cellid,varargin)
% add_analysis(@AUC_reward_choice,0,'property_names',{'AUC_pc_r', 'AUC_nc'});

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
    addParameter(prs,'event_name','CentralPortEpoch')
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    checking_freq();
    checking_choice_and_reward({'CH','RH'})
    
    return
end

[r,s,~,~] = cellid2tags(cellid);
POS       = findcellpos('animal',r,'session',s); %(!) find faster method
CH        = TheMatrix{POS(1),findanalysis('CH')};
RH        = TheMatrix{POS(1),findanalysis('RH')};

%[t1] = findanalysis('Indices_to_erase');
Firing      = TheMatrix{findcellstr(CELLIDLIST',cellid),findanalysis(f.event_name)};
RMI         = isnan(CH);
CH(RMI)     = []; 
RH(RMI)     = []; 
Firing(RMI) = [];

pc_l         = circshift(CH == -1, [1 0]);
pc_r         = circshift(CH ==  1, [1 0]);
pc_l(1)      = 0;
pc_r(1)      = 0;

RH(RH == -1) = 1; %(j) %did the animal receive a reward on either the left or right side
pr_trial     = circshift(RH, [1 0]); %pr - past reward
pr_trial(1)  = 0;

inx_r_rew  = pc_r  == 1 & pr_trial == 1;
inx_l_rew  = pc_l  == 1 & pr_trial == 1;
inx_r_nrew = pc_r  == 1 & pr_trial == 0;
inx_l_nrew = pc_l  == 1 & pr_trial == 0;

[AUC_pc_r, AUC_pc_r_p, ~]   = rocarea(Firing(inx_r_rew),Firing(inx_l_rew));
[AUC_pr_r, AUC_pr_r_p, ~]   = rocarea(Firing(inx_r_rew),Firing(inx_r_nrew));
[AUC_pc_nr, AUC_pc_nr_p, ~] = rocarea(Firing(inx_r_nrew),Firing(inx_l_nrew));
[AUC_pr_l, AUC_pr_l_p, ~]   = rocarea(Firing(inx_l_rew), Firing(inx_l_nrew));
[AUC_nc,AUC_nc_p,~]         = rocarea(Firing(CH == 1),Firing(CH == -1));
[AUC_nc_c,AUC_nc_c_p,~]     = rocarea(Firing(CH(randperm(length(CH))) == 1),Firing(CH(randperm(length(CH))) == -1));

varargout{1}.AUC_pc_r    = AUC_pc_r;
varargout{1}.AUC_pc_r_p  = AUC_pc_r_p;
varargout{1}.AUC_pc_nr   = AUC_pc_nr;
varargout{1}.AUC_pc_nr_p = AUC_pc_nr_p;
varargout{1}.AUC_pr_r    = AUC_pr_r;
varargout{1}.AUC_pr_r_p  = AUC_pr_r_p;
varargout{1}.AUC_pr_l    = AUC_pr_l;
varargout{1}.AUC_pr_l_p  = AUC_pr_l_p;
varargout{1}.AUC_nc      = AUC_nc;
varargout{1}.AUC_nc_p    = AUC_nc_p;
varargout{1}.AUC_nc_c    = AUC_nc_c;
varargout{1}.AUC_nc_c_p  = AUC_nc_c_p;

end