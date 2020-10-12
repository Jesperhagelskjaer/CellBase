function [varargout] = checking_kernels(cellid,varargin)

% Example:
% add_analysis(@checking_kernels,1,'property_names',{values},'arglist',{})
% add_analysis(@checking_kernels,0,'property_names',{'B_trial_neuron','p_trial_neuron'},'arglist',{'ref',1})
% delanalysis(@checking_kernels)
%
% created (JH) 2020-10-02

global TheMatrix
global CELLIDLIST
global f

method       = varargin{1};

if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'checking_Idx',[9 10 11] ,@(x) isnumeric(x) && (x > 0 )) %(!)
    addParameter(prs,'data',{'reward','no_reward'})
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

value = nan;
if exist('Firing','var') && length(Firing) == size(R,1)
    % %IMPORTANT
    F = Firing;
    %F = zscore(Firing); %z_score pr columns (each neuron are centered to 0)

    if any(isnan(F))

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
        [AUC] = AUC_kernels(F, data,f.loops);
    end
end

varargout{1}.B_trial_neuron = values;
varargout{1}.p_trial_neuron = p_trial_neuron;

end
