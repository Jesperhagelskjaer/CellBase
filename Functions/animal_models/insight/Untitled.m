clc
clear all
close all

y = [8 8 8 8 8 0.2 0.2 0.2 0.2 0.2]';
x = [1 1 1 1 1 0   0   0   0   0]';

figure
subplot(2,1,1)
data = [x];
[B FitInfo] = lasso(data,y,'Intercept',false);
plot(B(1),'*')
sum((data.*B(1)+FitInfo.Intercept(1)-y).^2)/numel(y)
title({num2str(FitInfo.MSE(1))})
data = [1-x];
subplot(2,1,2)
[B,FitInfo] = lasso(data,y,'Intercept',false);
plot(B(1),'*')
title({num2str(FitInfo.MSE(1))})
sum((data.*B(1)+FitInfo.Intercept(1)-y).^2)/numel(y)

h = x;
h(h == 0) = -1;
figure
data = [x];
[B FitInfo] = lasso(h,y,'Intercept',false);
plot(B(1),'*')












figure
subplot(2,1,1)
data = [x];
[B,FitInfo] = lassoglm(data,y,'normal','CV',2);
%lassoPlot(B,FitInfo,'PlotType','CV');
plot(B(:,FitInfo.Index1SE),'*')
%title({num2str(FitInfo.MSE(FitInfo.idxLambdaMinDeviance))})
data = [1-x];
subplot(2,1,2)
[B,FitInfo] = lassoglm(data,y,'normal','CV',2);
%lassoPlot(B,FitInfo,'PlotType','CV');
plot(B(:,FitInfo.Index1SE),'*')
%title({num2str(FitInfo.MSE(FitInfo.IndexMinMSE))})

