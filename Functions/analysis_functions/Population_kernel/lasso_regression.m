function [B_all, p_all,chow] = lasso_regression(Firing, X,loops,method)



B_temp = zeros(loops, size(X, 2));
for j = 1:loops % PARALLEL
    cv = cvpartition(numel(Firing),'KFold',2); 
    [B, FitInfo] = lasso(X,Firing,'CV', cv, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
    holdout = test(cv,1);

    
    for i = 1:40
        Y_test_z = Firing(logical(X(holdout,i)));
        Y_test_o = Firing(logical(~X(~holdout,i)));
        [~,~,~, AUC_mean(j,i)] = perfcurve([zeros(numel(Y_test_o),1) ; ones(numel(Y_test_z),1)],[Y_test_o ; Y_test_z],'0'); %check up on correct (!)
    end
    %[B, FitInfo] = lasso(X,Firing, 'CV', 2, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
    B_temp(j, :) = B(:, FitInfo.IndexMinMSE);

end
B_all = median(B_temp);

p_all   = zeros(1, size(X, 2));
for j = 1:size(X, 2)
    p_all(j) = numel(find(B_temp(:, j) == 0))/loops;
end

chow = nan;
if any(strcmp(method,'chow'))
    if size(X,2)+1 < ceil(numel(Firing)/2)
        chow = chowtest(X,Firing,ceil(numel(Firing)/2));
    end
end


end

