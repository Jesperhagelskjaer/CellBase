function [AUC, P] = AUC_kernels(Firing, data, B_trial_neuron,method)

[AUC, P] = deal(zeros(numel(B_trial_neuron),1));
for i = 1:numel(B_trial_neuron)
    y = Firing(logical(data(:,i)));
    x = Firing(~logical(data(:,i)));
    if any(strcmp(method,'AUC_bootstr'))
        [AUC(i), P(i), ~] = rocarea(y,x);
    elseif  any(strcmp(method,'AUC')) 
        [AUC(i), P(i)] = rocac(y,x);
    end
end







