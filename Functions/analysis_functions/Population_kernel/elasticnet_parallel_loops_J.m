function [B_all, p_all] = elasticnet_parallel_loops_J(Firing, R, C,loops)

X = [R C];
B_temp = zeros(loops, size(X, 2));

parfor j = 1:loops % PARALLEL
    [B, FitInfo] = lasso(X,Firing, 'CV', 4, 'Alpha', 0.5, 'MaxIter', 1e3, 'Options',statset('UseParallel',true) );
    B_temp(j, :) = B(:, FitInfo.IndexMinMSE);
end


B_all = mean(B_temp);
% std_v = std(B_temp);
% figure
% errorbar(B_all,std_v)

% Probability from normal distribution
%     p_all(i, :) = normcdf(0, abs(mean(B_temp)), std(B_temp));

% Probability from empirical distribution
history_length = size(X, 2);
p = ones(1, history_length);
idp = zeros(1, history_length);

parfor j = 1:history_length
    B_temp2 = B_temp(:, j);
    if B_temp2 < 0
        B_temp2 = -B_temp2;
    end
    [f, x] = ecdf(B_temp2);
    idp(j) = find(min(abs(x)) == abs(x), 1, 'first');
    if x(idp(j)) > eps
        p(j) = min(f(min(abs(x)) == abs(x)));
    else
        p(j) = max(f(min(abs(x)) == abs(x)));
    end
end
p_all = p;

end

%Y_length = size(Y, 1);
%idx = randi(Y_length, loops, Y_length); % From 1:Y_length values to a matrix with dim(loops, Y_length)

% Create tensors for parallel loop, Xdim(loops, trials, predictors), Ydim(loops, trials)
% XXX = zeros(loops, size(idx, 2), size(X, 2));
% YYY = zeros(loops, size(idx, 2));

% for k = 1:loops
%     XXX(k, :, :) = X(idx(k, :), :);
%     YYY(k, :) = Y(idx(k, :));
% end
% 
% parfor j = 1:loops % PARALLEL
%     X_temp = squeeze(XXX(j,:,:));
%     Y_temp = squeeze(YYY(j,:)); %firing rate
%     [B, FitInfo] = lasso(X_temp, Y_temp, 'CV', 4, 'Alpha', 0.5, 'MaxIter', 1e3, 'Options',statset('UseParallel',true) );
%     B_temp(j, :) = B(:, FitInfo.IndexMinMSE);
% end