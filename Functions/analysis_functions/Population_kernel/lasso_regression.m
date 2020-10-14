function [B_all, p_all,chow] = lasso_regression(Firing, X,loops,method)



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

chow = nan;
if any(strcmp(method,'chow'))
    if size(X,2)+1 < ceil(numel(Firing)/2)
        chow = chowtest(X,Firing,ceil(numel(Firing)/2));
    end
end


end

