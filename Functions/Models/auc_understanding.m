
clear all
close all
clc
%% Gaussian
% n1     = 50;
% n2     = 300;
% n3     = n1;
% mean1  = 3;
% mean2  = 2;
% mean3  = 1;
% sigma1 = 0.1;
%
% sigma2 = 1;
% sigma3 = sigma1;
% x1 = normrnd(mean1,sigma1,[1,n1])';
% x2 = normrnd(mean2,sigma2,[1,n2])';
% x3 = normrnd(mean3,sigma3,[1,n3])';
% edge = -1:0.1:6;
%
% figure
% histogram(x1,edge)
% hold on
% histogram(x2,edge)
% histogram(x3,edge)
% legend({'target1','noise','target3'})
%
%
% points         = n1/numel(find(x2>mean1-sigma1*4));
% [~,~,~, ROCAUC_1_1]  = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2],0);
% [~,~,~, ROCAUC_1_2]  = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2]*-1,0);
% [~,~,~, ROCAUC_2_1]  = perfcurve([zeros(numel(x3),1) ; ones(numel(x2),1)],[x3 ; x2],0);
% [~,~,~, ROCAUC_2_2]  = perfcurve([zeros(numel(x3),1) ; ones(numel(x2),1)],[x3 ; x2]*-1,0);
%
% [~,~,~, AUC2_1_1]    = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2],0,'XCrit','reca','YCrit','prec');
% [~,~,~, AUC3_1_2]    = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2]*-1,0,'XCrit','reca','YCrit','prec');
%
% [~,~,~, AUC2_2_1]    = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2],0,'XCrit','reca','YCrit','prec');
% [~,~,~, AUC3_2_2]    = perfcurve([zeros(numel(x3),1) ; ones(numel(x2),1)],[x3 ; x2]*-1,0,'XCrit','reca','YCrit','prec');
%
%
% fprintf('The ROCAUC-1_1 - %0.2f\n',ROCAUC_1_1)
% fprintf('The ROCAUC-1_2 - %0.2f\n',ROCAUC_1_2)
% fprintf('The ROCAUC-2_1 - %0.2f\n',ROCAUC_2_1)
% fprintf('The ROCAUC-2_2 - %0.2f\n',ROCAUC_2_2)
% fprintf('The PR-AUC-1   - %0.2f\n',max([AUC2_1_1 AUC3_1_2]))
% fprintf('The PR-AUC-2   - %0.2f\n',max([AUC2_2_1 AUC3_2_2]))
%% Top hat

n1        = 10;
lgt       = 30;
range = (1:1:lgt);
x2 = repmat(range,1,n1);
x2 = sort(x2(:));
x1 = x2(1:30);


figure
histogram(x2,0.5:1:lgt-0.5)
hold on
histogram(x1,0.5:1:lgt-0.5)

[~,~,~, ROCAUC_1_1]  = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2],1);
[~,~,~, ROCAUC_1_2]  = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2]*-1,1);

fprintf('The ROCAUC-1_1 - %0.2f\n',ROCAUC_1_1)
fprintf('The ROCAUC-1_2 - %0.2f\n',ROCAUC_1_2)

[~,~,~, AUC2_1_1]    = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2],1,   'XCrit','reca','YCrit','prec');
[~,~,~, AUC3_1_2]    = perfcurve([zeros(numel(x1),1) ; ones(numel(x2),1)],[x1 ; x2]*-1,1,'XCrit','reca','YCrit','prec');

fprintf('The PR-AUC-1   - %0.2f\n',max([AUC2_1_1 AUC3_1_2]))


%%
Threshold = 1.1:1:5.1;
for i = 1:4
    threshold = Threshold(i);
    total  = [x1; x2];
    [sorted,idx] = sort(total);
    labels = [zeros(numel(x2),1);ones(numel(x2),1)];
    
    TP = numel(x1(x1 <= threshold)); %TP
    FP = numel(x2(x2 <= threshold)); %FP
    FN = numel(x1(x1 >= threshold)); %FN
    TN = numel(x2(x2 >= threshold)); %TN
       
    PREC      = TP /(TP + FP); %PREC  TP / (TP + FP)
    REC       = TP /(TP + FN); %REC   TP / (TP + FN)
    Acc(i)    = (TP + TN)/(TP + TN + FP + FN);
    MCC(i)    = (TP * TN-FP * FN) / ((TP + FP)*(TP + FN)*(TN + FP)*(TN + FN)); %MCC: Matthews correlation coefficient
    F05(i)    = 1.5 * PREC * REC / (0.25 * PREC + REC);
    F2(i)     = 2 * PREC * REC / (PREC + REC);
    Prec(i)   = PREC;                              
end
[v,idx] = max(Prec);
fprintf('Threshold: %0.2f and Prec score: %0.2f\n',Threshold(idx),v)
[v,idx] = max(F05);
fprintf('Threshold: %0.2f and F05 score:  %0.2f\n',Threshold(idx),v)
[v,idx] = max(F2);
fprintf('Threshold: %0.2f and F2 score:   %0.2f\n',Threshold(idx),v)
[v,idx] = max(Acc);
fprintf('Threshold: %0.2f and ACC score:  %0.2f\n',Threshold(idx),v)
[v,idx] = max(MCC);
fprintf('Threshold: %0.2f and MCC score:  %0.2f\n',Threshold(idx),v)