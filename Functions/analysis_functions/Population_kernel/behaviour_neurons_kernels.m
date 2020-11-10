function [varargout] = behaviour_neurons_kernels(cellid,varargin)
% NOTE!!!!!!!!!!!!!!
% The trial input - both in reward, and no_reward, both the left and right side is used.
% This will in make the trial_input collinear leading to that the coefficients is not-directly related to
% the firing of the neuron for the given trial input. (This have been made after
% the wish of Duda Kvitsiani).
%
% Example:
% add_analysis(@behaviour_neurons_kernels,1,'property_names',{'B_trial_neuron','p_trial_neuron','AUC_kernel'},'arglist',{'loops',25,'trials',11})
% add_analysis(@behaviour_neurons_kernels,0,'property_names',{'B_trial_neuron','validation','AUC'},'arglist',{})
% add_analysis(@behaviour_neurons_kernels,1,'property_names',{'validation'},'arglist',{'data',{'C','R','NR' }})
% delanalysis(@behaviour_neurons_kernels)
%
% created (JH) 2020-07-20

global TheMatrix
global CELLIDLIST
persistent f
method       = varargin{1};
if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'loops',100,@(x) isscalar(x) && (x > 0 ))
    addParameter(prs,'data',{'R','NR'})
    addParameter(prs,'trials',11,@(x) isscalar(x) && x > 0)
    addParameter(prs,'display',false,@(s)islogical(s)|ismember(s,[0 1]))   
    
    if any(strcmp(method,'AUC')) || any(strcmp(method,'AUC_bootstr'))
        addParameter(prs,'bootstrap',0,@(x) isscalar(x) && x > 0)   % size of bootstrap sample
        addParameter(prs,'transform','none',@(s)ismember(s,{'none' 'swap' 'scale'}))   % rescaling
    end
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    
    % checking if the necessary data already exist in the "TheMatrix"
    checking_freq();
    checking_his(f);
    checking_indices_to_erase();
    return
end

[r,s,~,~]  = cellid2tags(cellid);
POS        = findcellpos('animal',r,'session',s); %(!) find faster method

remove_index = TheMatrix{POS(1),findanalysis('Indices_to_erase')};
if ~isnan(remove_index)
    Firing = TheMatrix{findcellstr(CELLIDLIST',cellid),findanalysis('CentralPortEpoch')};
    Firing(remove_index) = [];
end

[B_trial_neuron,p_trial_neuron,chow,AUC_kernel,P] = deal(nan);
if exist('Firing','var')
    % %IMPORTANT
    %Firing = zscore(Firing); %z_score pr columns (each neuron are centered to 0)
    
    if any(isnan(Firing))
        B_trial_neuron = nan(size(Firing,1),31);
        p_trial_neuron = nan(size(Firing,1),31);
    else
        data = [];
        for i = 1:numel(f.data)
            switch f.data{i}
                case 'C'
                    C  = TheMatrix{POS(1),findanalysis('C_trial')};
                    C(:,end-(size(C,2) - f.trials)+1:end) = [];
                    data = [data C == -1 C == 1];
                case 'R'
                    R  = TheMatrix{POS(1),findanalysis('R_trial')};
                    R(:,end-(size(R,2) - f.trials)+1:end) = [];
                    data  = [data R == -1 R == 1];   %R_right
                case 'NR'
                    NR = TheMatrix{POS(1),findanalysis('NR_trial')};
                    NR(:,end-(size(NR,2) - f.trials)+1:end) = [];
                    data  = [data NR == -1 NR == 1]; %no_reward
            end
        end
        if numel(Firing) == size(data,1)
            [B_trial_neuron, p_trial_neuron,chow,validation] = lasso_regression(Firing, data,f,method);
            
            if any(strcmp(method,'AUC')) || any(strcmp(method,'AUC_bootstr'))
                [AUC_kernel, P] =  AUC_kernels(Firing, data, B_trial_neuron,method); %send the not standized firing rate of the neurons
            end
        end
    end
end


varargout{1}.B_trial_neuron = B_trial_neuron;
varargout{1}.p_trial_neuron = p_trial_neuron;
varargout{1}.AUC            = AUC_kernel;
varargout{1}.P              = P;
varargout{1}.h              = chow;
varargout{1}.validation     = validation;
end





