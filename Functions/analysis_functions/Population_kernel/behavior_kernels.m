function [varargout] = behavior_kernels(cellid,varargin)

% add_analysis(@behavior_kernels,1,'property_names',{'B_trial_behaviour'})
% add_analysis(@behavior_kernels,0,'property_names',{'B_trial_behaviour'},'arglist',{'data',{'R','NR'},'trials',5})

% delanalysis(@behavior_kernels)

% created (JH) 2020-09-15

global TheMatrix
global CELLIDLIST
persistent f

method       = varargin{1};

if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'loops', 10,@(x) isscalar(x) && (x > 0 ))
    addParameter(prs,'trials',10,@(x) isscalar(x) && (x > 0 ))
    addParameter(prs,'data',{'R','NR'})
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    checking_his(f);
    return
end

idx_neuron = findcellstr(CELLIDLIST',cellid);

C  = TheMatrix{idx_neuron,findanalysis('C_trial')};
if any(isnan(C))
    B = nan;
elseif isempty(C)
    B = [];
else
    
    C(C == -1) = 0;  %reference C_left
    y          = C(:,1);
    C          = C(:,2:f.trials+1);
    
    data = [];
    for i = 1:numel(f.data)
        switch f.data{i}
            case 'C'
                data = [data C];
            case 'R'
                R    = TheMatrix{idx_neuron,findanalysis('R_trial')};
                R    = R(:,2:f.trials+1);
                data = [data R == -1 R == 1];
            case 'NR'
                NR = TheMatrix{idx_neuron,findanalysis('NR_trial')};
                NR = NR(:,2:f.trials+1);
                data    = [data NR == -1 NR == 1];
        end
    end
    B_temp = zeros(f.loops, size(data, 2));
    for j = 1:f.loops
        [B,FitInfo] = lassoglm(data,y,'binomial','CV',2);
        B_temp(j, :)  = B(:, FitInfo.IndexMinDeviance)';
    end
    B = median(B_temp);
    
end

varargout{1}.B_trial_behaviour = B;
end




