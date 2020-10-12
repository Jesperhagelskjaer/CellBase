function [B_all, p_all,stab,h] = lasso_regression(Firing, X,loops,method)



B_temp = zeros(loops, size(X, 2));
parfor j = 1:loops % PARALLEL
    [B, FitInfo] = lasso(X,Firing, 'CV', 2, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
    B_temp(j, :) = B(:, FitInfo.IndexMinMSE);
end
B_all = median(B_temp);

p_all   = zeros(1, size(X, 2));
for j = 1:size(X, 2)
    p_all(j) = numel(find(B_temp(:, j) == 0))/loops;
end

if size(X,2)+1 < ceil(numel(Firing)/2)
    h = chowtest(X,Firing,ceil(numel(Firing)/2));
else
    h = nan;
end

stab = nan;
if any(strcmp(method,'stability'))

     [B1, FitInfo1] = lasso(X(1:end/2,:),Firing(1:end/2,:), 'CV', 2, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
      [B2, FitInfo2] = lasso(X(end/2:end,:),Firing(end/2:end,:), 'CV', 2, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
    error1         = 1/size(X(1:end/2,:),1)   * sum((sum(B2(:, FitInfo2.IndexMinMSE)'.*X(1:end/2,:),2)   + FitInfo2.Intercept(FitInfo2.IndexMinMSE) - Firing(1:end/2,:)).^2);
    error2         = 1/size(X(end/2:end,:),1) * sum((sum(B1(:, FitInfo1.IndexMinMSE)'.*X(end/2:end,:),2) + FitInfo1.Intercept(FitInfo1.IndexMinMSE) - Firing(end/2:end,:)).^2);
    if (FitInfo1.MSE(FitInfo1.IndexMinMSE) - 3*FitInfo1.SE(FitInfo1.IndexMinMSE) < error2 && FitInfo1.MSE(FitInfo1.IndexMinMSE) + 3*FitInfo1.SE(FitInfo1.IndexMinMSE) > error2) && ...
         (FitInfo2.MSE(FitInfo2.IndexMinMSE) - 3*FitInfo2.SE(FitInfo2.IndexMinMSE) < error1 && FitInfo2.MSE(FitInfo2.IndexMinMSE) + 3*FitInfo2.SE(FitInfo2.IndexMinMSE) > error2)
        %disp('okay')
        stab = 0;
    else
        %disp('not stable')
        stab = 1;
    end    
end









% stab = nan;
% if any(strcmp(method,'stability'))
%     [B1, FitInfo1] = lasso(X(1:end/2,:),Firing(1:end/2,:), 'CV', 2, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
%     [B2, FitInfo2] = lasso(X(end/2:end,:),Firing(end/2:end,:), 'CV', 2, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
%     error1         = 1/size(X(1:end/2,:),1)   * sum((sum(B2(:, FitInfo2.IndexMinMSE)'.*X(1:end/2,:),2)   + FitInfo2.Intercept(FitInfo2.IndexMinMSE) - Firing(1:end/2,:)).^2);
%     error2         = 1/size(X(end/2:end,:),1) * sum((sum(B1(:, FitInfo1.IndexMinMSE)'.*X(end/2:end,:),2) + FitInfo1.Intercept(FitInfo1.IndexMinMSE) - Firing(end/2:end,:)).^2);
%     if (FitInfo1.MSE(FitInfo1.IndexMinMSE) - 3*FitInfo1.SE(FitInfo1.IndexMinMSE) < error2 && FitInfo1.MSE(FitInfo1.IndexMinMSE) + 3*FitInfo1.SE(FitInfo1.IndexMinMSE) > error2) && ...
%          (FitInfo2.MSE(FitInfo2.IndexMinMSE) - 3*FitInfo2.SE(FitInfo2.IndexMinMSE) < error1 && FitInfo2.MSE(FitInfo2.IndexMinMSE) + 3*FitInfo2.SE(FitInfo2.IndexMinMSE) > error2)
%         disp('okay')
%         stab = 1;
%     else
%         disp('not stable')
%         stab = 0;
%     end    
% end


end

% B_all = mean(B_temp);
% [value,idx] = max(abs(B_all_median));
%
%
% %if idx>1
%     y = Firing(logical(X(:,idx)));
%     x = Firing(logical(X(:,32)));
%     [D, P, SE] = rocarea(y,x,'bootstrap',1000,'display',1)
%     figure
%     subplot(2,1,1)
%     plot(B_all_median)
%     subplot(2,1,2)
%     errorbar(B_all,std(B_temp))
% %     if D > 0.60
% %         t = 2
% %     end
% % %end
