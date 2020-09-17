function [varargout] = behaviour_neurons_kernels(cellid,varargin)

% add_analysis(@behaviour_neurons_kernels,1,'property_names',{'B_trial_neuron','p_trial_neuron'})
% add_analysis(@behaviour_neurons_kernels,0,'property_names',{'B_trial_neuron','p_trial_neuron'},'arglist',{'ref',0})
% delanalysis(@behaviour_neurons_kernels)

% created (JH) 2020-07-20

global TheMatrix
global CELLIDLIST
persistent f

method       = varargin{1};

if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'loops',100,@(x) isnumeric(x) && iscaler(x) && (x > 0 ))
    addParameter(prs,'data',{'choice','reward','no_reward'})
    addParameter(prs,'ref',1,@(x) x == true || x == false)
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

B_trial_neuron = nan;p_trial_neuron = nan;
if exist('Firing','var') && length(Firing) == size(R,1)
    % %IMPORTANT
    F = zscore(Firing); %z_score pr columns (each nueron are centered to 0)

    if any(isnan(F))
        B_trial_neuron = nan(size(F,1),31);
        p_trial_neuron = nan(size(F,1),31);
    else
        if f.ref
            data = [];
            C(C == -1) = 0;  %reference C_left
            for i = 1:numel(f.data)
                switch f.data{i}
                    case 'choice'
                        data = [data C];
                    case 'reward'
                        %reference  = R == -1;     %R_left
                        data    = [data R == 1];   %R_right
                    case 'no_reward'
                        reference  = R == -1; %R_left
                        r_right    = R == 1;
                        data  = [data ones(size(reference)) - reference - r_right]; %no_reward
                end
            end
        else
            R    = [R == 1 R == -1];
            data = [C R];
        end
        [B_trial_neuron, p_trial_neuron] = lasso_regression(F, data,f.loops);
    end
end

varargout{1}.B_trial_neuron = B_trial_neuron;
varargout{1}.p_trial_neuron = p_trial_neuron;

end





