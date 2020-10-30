function [B_all,p_all,chow,validation] = lasso_regression(Firing, X,f,method)

[B_all, p_all, validation,chow] = deal([]);
if any(strcmp(method,'B_trial_neuron'))
    loops = f.loops;
    B_temp = zeros(loops, size(X, 2));
    for j = 1:loops % PARALLEL
        
        [B, FitInfo] = lasso(X,Firing, 'CV', 2, 'MaxIter', 1e3);%, 'Options',statset('UseParallel',true) ); %CV 4
        
        B_temp(j, :) = B(:, FitInfo.IndexMinMSE);
    end
    B_all = median(B_temp);
    if any(strcmp(method,'p_trial_neuron'))
        p_all   = zeros(1, size(X, 2));
        for j = 1:size(X, 2)
            p_all(j) = numel(find(B_temp(:, j) == 0))/loops;
        end
    end
end

if any(strcmp(method,'chow'))
    if size(X,2)+1 < ceil(numel(Firing)/2)
        chow = chowtest(X,Firing,ceil(numel(Firing)/2));
    end
end

if any(strcmp(method,'validation'))
    if all(strcmpi(f.data,'R') | strcmpi(f.data,'NR'))
        idx          = true(44,4);
        idx(34:44,1) = 0; %1 2 3 % 1 = reward right; 2 = reward left; 3 no_ reward left
        idx(23:33,2) = 0; %1 2 4
        idx(1:11,3)  = 0; %2 3 4
        idx(12:22,4) = 0; %1 3 4
        
        data   = [1 2 3;1 2 4;2 3 4;1 3 4];
        
        coef_h{4} = [];
        pval_h{4} = [];
    elseif all(strcmpi(f.data,'C') | strcmpi(f.data,'R') | strcmpi(f.data,'NR'))
        idx          = true(66,10);
        idx([12:22,45:66],1)    = 0; %1 3 4
        idx([1:11,45:66],2)     = 0; %2 3 4
        idx([12:44],3)          = 0; %1 5 6
        idx([1:11,23:44],4)     = 0; %2 5 6
        idx([12:22,34:55],5)    = 0; %1 3 6
        idx([1:11,34:55],6)     = 0; %2 3 6
     
        idx([1:22,56:66],7)     = 0; %3 4 5
        idx([1:33],8)           = 0; %4 5 6
        idx([1:22,45:55],9)     = 0; %3 4 6
        idx([1:22,34:44],10)    = 0; %3 5 6
        %     idx(11:11,23:33,56:66,8) = 0; %1 4 5 ba
        data   = [1 3 4;
            2 3 4;
            1 5 6;
            2 5 6;
            1 3 6;
            2 3 6;
            3 4 5;
            4 5 6;
            3 4 6;
            3 5 6];
        
        coef_h{6} = [];
        pval_h{6} = [];
    end
    [idx_p,coef] = deal(nan(33,size(idx,2)));
    for i = 1:size(idx,2)
        mdl        = fitlm(X(:,idx(:,i)),Firing);
        idx_p(:,i) = mdl.Coefficients.pValue(2:end) < 0.05 & ~isnan(mdl.Coefficients.pValue(2:end));
        coef(:,i)  = mdl.Coefficients.Estimate(2:end);
        for m = 1:3
            range = (1:11)+11*(m-1);
            coef_h{data(i,m)} = [coef_h{data(i,m)} coef(range,i)];
            pval_h{data(i,m)} = [pval_h{data(i,m)} idx_p((range),i)];
        end
    end
    validation = [];
    for i = 1:numel(coef_h)
        validation = [validation; all(pval_h{i},2)];
    end
    if f.display
        point = {'r*','bo','gx','y+','mv','c<','k>','rh','bp','gd'};
        c     = {'r','b','g','y','m','c','k','r','b','g'};
        figure
        for i = 1:numel(coef_h)
            subplot(2,3,i)
            hold on
            for m = 1:size(coef_h{i},2)
                plot(coef_h{i}(:,m),c{m})
                plot(pval_h{i}(:,m),point{m})
            end
            title(num2str(i))
        end
        %    close all
    end    
end


end
% mdl = fitlm(X,Firing);
% idx = mdl.Coefficients.pValue(2:end) < 0.05 & ~isnan(mdl.Coefficients.pValue(2:end));
% cor = zeros(numel(idx),1);
% cor(idx) = 1;

% figure
% plot(mdl.Coefficients.Estimate(2:end))
% hold on
% plot(B_all,'r')
% plot(cor,'*')
% title('1 2 3 4')







