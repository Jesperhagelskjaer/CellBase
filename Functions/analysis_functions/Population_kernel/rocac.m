function [AUC, P] = rocac(x,y,varargin)
%ROCAREA   Receiver-operator characteristic.
%   D = ROCAREA(X,Y) calculates area under ROC curve (D) for the samples X
%   and Y.
%
%   [D P SE] = ROCAREA(X,Y,'BOOTSTRAP',N) calculates permutation test
%   p-value and bootstrap standard error (N, number of bootstrap samples).
%
%   Optional input parameter-value paits (with default values):
%       'bootstrap', 0 - size of bootstrap sample; 0 corresponds to no
%           bootstrap analysis
%       'transform', 'none' - 'swap': rescales results between 0.5 - 1
%           'scale' - rescales results between -1 to 1
%       'display', false - controls plotting of the ROC curve

%   Edit log: JH 2020_10_02

% Default arguments

% Binning

global f

% [D cdfx cdfy] = auc(x,y,Lx,Ly,bins);
[X,Y,~, AUC] = perfcurve([zeros(numel(x),1) ; ones(numel(y),1)],[x ; y],'0'); %check up on correct (!)

% Rescale
switch f.transform
    case 'swap'
        AUC = abs(AUC-0.5) + 0.5;   % 'swap'
    case 'scale'
        AUC = 2 * (AUC - 0.5);   % 'scale'
end
P = -1;
% Bootstrap
if f.bootstrap > 0
    myStatistic = @(x1,x2) mean(x1)-mean(x2);
    bootstrapStat = zeros(f.bootstrap ,1);
    for k = 1:f.bootstrap
        sampX1 = x(randi([1,numel(x)],numel(x),1));
        sampX2 = y(randi([1,numel(y)],numel(y),1));
        bootstrapStat(k) = myStatistic(sampX1,sampX2);
    end
    %CI = prctile(bootstrapStat,[100*0.05/2,100*(1-0.05/2)]);
    %H = CI(1)>0 | CI(2)<0;
if 0 > mean(bootstrapStat)
    idx = find(0 > sort(bootstrapStat),1,'last'); %(!) looks only at one side
else
    idx = find(0 > sort(bootstrapStat),1,'first'); %(!) looks only at one side
end

if isempty(idx)
    P = 0;
else
    P = idx/numel(bootstrapStat);
end

end


% Plot
if f.display
    figure
    plot(X,Y,'b',[0 1],[0 1],'k');
    xlabel('x');ylabel('y');title(num2str(AUC));
end
