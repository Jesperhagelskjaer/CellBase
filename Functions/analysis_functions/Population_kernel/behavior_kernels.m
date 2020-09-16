function [varargout] = behavior_kernels(cellid,varargin)

% add_analysis(@behavior_kernels,1,'property_names',{'B_trial_behaviour'})
% add_analysis(@behavior_kernels,1,'property_names',{'B_trial_behaviour'},'arglist',{'data',{'choice','reward','no_reward'}})

% delanalysis(@behavior_kernels)

% The C_left and R_left is the reference.


% created (JH) 2020-09-15

global TheMatrix
global CELLIDLIST
persistent f

method       = varargin{1};

if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'trials',11,@(x) isnumeric(x) && iscaler(x) && (x > 0 ))
    addParameter(prs,'data',{'choice','reward','no_reward'})
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

idx_neuron = findcellstr(CELLIDLIST',cellid);

Idx = findanalysis(@history_reward_choice);
if ~all(Idx)
    fprintf("addanalysis(@history_reward_choice,1,'property_names',{'R_trial','C_trial'})\n")
else
    R  = TheMatrix{idx_neuron,findanalysis('R_trial')};
    C  = TheMatrix{idx_neuron,findanalysis('C_trial')};
    
    if any(isnan(R))
        B = nan;
    elseif isempty(R)
        B = [];
    else
        data = [];
        C(C == -1) = 0;  %reference C_left
        y          = C(:,1);     %(!)
        R          = R(:,2:f.trials);
        for i = 1:numel(f.data)
            switch f.data{i}    
                case 'choice'
                    data = [data C(:,2:f.trials)];
                case 'reward'
                    %reference  = R == -1;     %R_left
                    data    = [data R == 1];   %R_right                   
                case 'no_reward'
                    reference  = R == -1; %R_left
                    r_right    = R == 1;
                    data  = [data ones(size(reference)) - reference - r_right]; %no_reward
            end
            
        end
               
        [B,FitInfo] = lassoglm(data,y,'binomial','CV',5);
        B = B(:, FitInfo.IndexMinDeviance)';    
        %figure
        %plot(B)
        %close all
    end

end


varargout{1}.B_trial_behaviour = B;
end


%%
%data       = [C(:,2:f.trials) r_right no_reward];

%R = [double(R == 1) double(R == -1)];
%data = [C(:,2:f.trials),R];

