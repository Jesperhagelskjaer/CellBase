  function [varargout] = AUC_reward_choice(cellid,varargin)
% function [AUC_past_choice_r, AUC_past_choice_r_P,AUC_past_reward_right,AUC_past_reward_right_P] = AUC_reward_choice_test(cellid,path)
% addanalysis(@AUC_reward_choice,'property_names',{'AUC_past_choice_r', 'AUC_past_reward_right', 'AUC_past_choice_nr', 'AUC_past_reward_left','AUC_next_choice', 'AUC_next_choice_control'},'mandatory',{'O:\ST_Duda\Maria\CellBaseFreeChoiceBaitBlock'})
% addanalysis(@AUC_reward_choice,'property_names',{'AUC_past_choice_r','AUC_past_choice_r_P','AUC_past_choice_nr','AUC_past_choice_nr_P',...
...'AUC_past_reward_right','AUC_past_reward_right_P', 'AUC_past_reward_left','AUC_past_reward_left_P','AUC_next_choice','AUC_next_choice_P',
...'AUC_next_choice_control','AUC_next_choice_control_P'},'mandatory',{'O:\ST_Duda\Maria\CellBaseFreeChoiceBaitBlock'})
% Compute how neurons are selective for the last reward but not choice,
% and vice-versa.

%add_analysis(@AUC_reward_choice,0,'property_names',{'AUC_past_choice_r'});

% delanalysis(@AUC_reward_choice)

% Author: Junior Samuel López Yépez - February/2020 (last update)
% changed JH 2020_06_30
% Approx. run-time with current data of 5 animals: 60 minutes
global TheMatrix
global CELLIDLIST
persistent f



if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];  
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
     addParameter(prs,'bootstrap',1000,@(x) isscalar(x) && x > 0) %
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

N = f.bootstrap;


[r,s,~,~] = cellid2tags(cellid);

POS = findcellpos_J('animal',r,'session',s); %(!) find faster method

% Get Behavioral variables
Idx = findanalysis(@Choice_and_reward); %(!) potential error Choice_and_reward can give 3 output
if ~all(Idx)
    fprintf("addanalysis(@Choice_and_reward,'property_names',{'CH','RH','Indices_to_erase'},'mandatory',{'D:\\recording'})\n")
    exit()
else
    [POS1, ~] = findanalysis('CH');
    [POS2, ~] = findanalysis('RH');
    CH = TheMatrix{POS(1),POS1};
    RH = TheMatrix{POS(1),POS2};
end

[pos, ~] = findanalysis('cp');
if ~all(pos) % JH check up on when not 1 or 2
    fprintf("addanalysis(@average_firing_Rate,'property_names',{'cp'},'mandatory',{'D:\\recording'},'arglist',{'type', 'cp'})\n");
    exit()
else
    idx_neuron = findcellstr(CELLIDLIST',cellid);
    Firing_center = TheMatrix{idx_neuron,pos(1)};
end

if all(isnan(CH))
    AUC_past_choice_r        = nan;
    AUC_past_choice_nr       = nan;
    AUC_past_reward_right    = nan;
    AUC_past_reward_left     = nan;
    AUC_next_choice          = nan;
    AUC_next_choice_control  = nan;
else
    Indices_to_erase                = isnan(CH);
    CH(Indices_to_erase)            = []; %check up on make sure equal length
    RH(Indices_to_erase)            = []; %check up on
    Firing_center(Indices_to_erase) = [];
    
    past_right_choice = circshift(CH == 1, [0 1]);
    past_left_choice = circshift(CH == 0, [0 1]);
    past_trial_rewarded = (abs(circshift(RH, [0 1])) == 1);
    past_trial_no_rewarded          = (abs(circshift(RH, [0 1])) == 0);
    [~,~,~,AUC_past_choice_r]       = perfcurve(past_right_choice(past_trial_rewarded), Firing_center(past_trial_rewarded),'true');
    [~,~,~,AUC_past_choice_nr]      = perfcurve(past_right_choice(past_trial_no_rewarded), Firing_center(past_trial_no_rewarded),'true');
    [~,~,~,AUC_past_reward_right]   = perfcurve(past_trial_rewarded(past_right_choice), Firing_center(past_right_choice),'true');
    [~,~,~,AUC_past_reward_left]    = perfcurve(past_trial_rewarded(past_left_choice), Firing_center(past_left_choice),'true');
    [~,~,~,AUC_next_choice]         = perfcurve((CH == 1), Firing_center,'true');
    [~,~,~,AUC_next_choice_control] = perfcurve((CH(randperm(length(CH))) == 1), Firing_center,'true');
end

varargout{1}.AUC_past_choice_r        = AUC_past_choice_r;
varargout{1}.AUC_past_choice_nr       = AUC_past_choice_nr;
varargout{1}.AUC_past_reward_right    = AUC_past_reward_right;
varargout{1}.AUC_past_reward_left     = AUC_past_reward_left;
varargout{1}.AUC_next_choice          = AUC_next_choice;
varargout{1}.AUC_next_choice_control  = AUC_next_choice_control;
end
