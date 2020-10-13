function [AUC, P] = AUC_kernels(Firing, data, B_trial_neuron,method,test)

[~,idx] = max(abs(B_trial_neuron));

if all(B_trial_neuron == 0)
    AUC = nan;
    P   = nan;
else
    y = Firing(logical(data(:,idx)));
    [AUC, P] = deal(zeros(numel(B_trial_neuron),1));
    if strcmpi('all',test)
        Idx = 1:numel(B_trial_neuron);
        Idx(idx) = [];
        AUC(idx) = nan;
        P(idx)   = nan;
        for i = Idx
            x                 = Firing(logical(data(:,i)));
            if any(strcmp(method,'AUC_bootstr'))
                [AUC(i), P(i), ~] = rocarea(y,x);
            elseif  any(strcmp(method,'AUC')) || any(strcmp(method,'P'))
                [AUC(i), P(i)] = rocac(y,x);
            end
        end
    elseif strcmpi('own',test)
        x                 = Firing(~logical(data(:,idx)));
        if any(strcmp(method,'AUC_bootstr'))
            [AUC, P, ~] = rocarea(y,x);
        elseif  any(strcmp(method,'AUC')) || any(strcmp(method,'P'))
            [AUC, P] = rocac(y,x);
        end
    end
end





