function [B_all, p_all] = lasso_regression(Firing, X,loops)

B_temp = zeros(loops, size(X, 2));

parfor j = 1:loops % PARALLEL
    [B, FitInfo] = lasso(X,Firing, 'CV', 2, 'Alpha', 0.5, 'MaxIter', 1e3, 'Options',statset('UseParallel',true) ); %CV 4
    B_temp(j, :) = B(:, FitInfo.IndexMinMSE);
end

B_all = mean(B_temp);
figure
errorbar(B_all,std(B_temp))

p_all   = zeros(1, size(X, 2));

for j = 1:size(X, 2)
    p_all(j) = numel(find(B_temp(:, j) == 0))/loops;   
end

end


