function [varargout] = behaviour_neurons_kernels(cellid,varargin)
% NOTE!!!!!!!!!!!!!!
% The trial input - both in reward, and no_reward, both the left and right side is used.
% This will in make the trial_input collinear leading to that the coefficients is not-directly related to
% the firing of the neuron for the given trial input. (This have been made after
% the wish of Duda Kvitsiani).
%
% Example:
% add_analysis(@behaviour_neurons_kernels,1,'property_names',{'B_trial_neuron','p_trial_neuron','AUC','P','stability','h'},'arglist',{'loops',25})
% add_analysis(@behaviour_neurons_kernels,0,'property_names',{'B_trial_neuron','p_trial_neuron','AUC','P','stability'},'arglist',{'loops',25})
% add_analysis(@behaviour_neurons_kernels,0,'property_names',{'B_trial_neuron','p_trial_neuron','AUC','P'},'arglist',{'loops',25,'display',1})
% delanalysis(@behaviour_neurons_kernels)
%
% created (JH) 2020-07-20

global TheMatrix
global CELLIDLIST
global f
method       = varargin{1};
if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'loops',100,@(x) isnumeric(x) && (x > 0 ))
    addParameter(prs,'data',{'reward','no_reward'})
    addParameter(prs,'ref',1,@(x) x == true || x == false)
    addParameter(prs,'lgt',11,@(x) x > 0)
    
    if any(strcmp(method,'AUC')) || any(strcmp(method,'P')) || any(strcmp(method,'AUC_bootstr'))
        addParameter(prs,'bootstrap',1000,@isnumeric)   % size of bootstrap sample
        addParameter(prs,'transform','none',@(s)ismember(s,{'none' 'swap' 'scale'}))   % rescaling
        addParameter(prs,'display',false,@(s)islogical(s)|ismember(s,[0 1]))   % control displaying rasters and PSTHs
    end
    
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

idx_neuron = findcellstr(CELLIDLIST',cellid);
[r,s,~,~] = cellid2tags(cellid);
POS = findcellpos('animal',r,'session',s); %(!) find faster method

Idx2 = findanalysis('Indices_to_erase');
if ~all(Idx2)
    fprintf("addanalysis(@choice_and_reward,1,'property_names',{'CH','RH','Indices_to_erase'})\n")
else
    remove_index = TheMatrix{POS(1),Idx2};
end

if ~isnan(remove_index)
    
    Idx1 = findanalysis(@history_reward_choice);
    if ~all(Idx1)
        fprintf("addanalysis(@history_reward_choice,1,'property_names',{'R_trial','C_trial'})\n")
    else
        R  = TheMatrix{POS(1),findanalysis('R_trial')};
        C  = TheMatrix{POS(1),findanalysis('C_trial')};
        NR = TheMatrix{POS(1),findanalysis('NR_trial')};
        
        R(:,1) = []; %The first is the anticipation of reward
        NR(:,1) = []; %The first is the anticipation of reward
        if (size(R,2) > f.lgt)
            R(:,end-(size(R,2) - f.lgt):end-1) = [];
        end
        if (size(C,2) > f.lgt)
            C(:,end-(size(C,2) - f.lgt):end) = [];
        end
        if (size(NR,2) > f.lgt)
            NR(:,end-(size(NR,2) - f.lgt)) = [];
        end
        
    end
    
    Idx3 = findanalysis('CentralPortEpoch');
    if ~all(Idx3)
        fprintf("addanalysis(@average_firing_rate,1,'property_names',{'CentralPortEpoch'})\n")
    elseif isnan(remove_index)
        %will check for error in behavior -> will not create firing
    else
        Firing = TheMatrix{idx_neuron,Idx3};
        Firing(remove_index) = [];
    end
end

B_trial_neuron = nan;p_trial_neuron = nan;stability = nan;h = nan;
[AUC,P] = deal(nan);
if exist('Firing','var') && length(Firing) == size(R,1)
    % %IMPORTANT
    %F = Firing;
    F = zscore(Firing); %z_score pr columns (each neuron are centered to 0)
    
    if any(isnan(F))
        B_trial_neuron = nan(size(F,1),31);
        
        p_trial_neuron = nan(size(F,1),31);
    else
        if f.ref
            data = [];
            for i = 1:numel(f.data)
                switch f.data{i}
                    case 'choice'
                        data = [data C == -1 C == 1];
                    case 'reward'
                        data  = [data R == -1 R == 1];   %R_right
                    case 'no_reward'
                        data  = [data NR == -1 NR == 1]; %no_reward
                end           
            end
        else
            C(C == -1) = 0;
            data = [C  R == -1 R == 1];
        end
        [B_trial_neuron, p_trial_neuron,stability,h] = lasso_regression(F, data,f.loops,method);
        
        if any(strcmp(method,'AUC')) || any(strcmp(method,'P')) || any(strcmp(method,'AUC_bootstr'))
            [AUC, P] =  AUC_kernels(Firing, data, B_trial_neuron,method); %send the not standized firing rate of the neurons
        end
    end
end

varargout{1}.B_trial_neuron = B_trial_neuron;
varargout{1}.p_trial_neuron = p_trial_neuron;
varargout{1}.AUC            = AUC;
varargout{1}.P              = P;
varargout{1}.stability      = stability;
varargout{1}.h              = h;


end





