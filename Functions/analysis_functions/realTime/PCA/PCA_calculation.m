function [score,chs] = PCA_calculation(str,shiftMatrix,c,idx,method)

threshold = 65;
if strcmp(method,'single') 
    threshold = 35; %lowevering the thershold if one looking at one cluster
    threshold_la = 0.025; 
    shiftMatrix = shiftMatrix{idx};
    sum_th = 0.002;
elseif strcmp(method,'all') 
    threshold_la = 0.001;
    sum_th = 0.004;
end

value_max_abs = max(abs(max(shiftMatrix(:))), abs(min(shiftMatrix(:))));

shiftMatrix = shiftMatrix/value_max_abs;


[score_com,chs] = deal([]);
explained       = zeros(size(shiftMatrix,1),32);
for i = 1:32
    [~,score2,latent(:,i),~,explained(:,i)] = pca(squeeze(shiftMatrix(:,i,:))');
    if explained(1,i) > threshold && latent(1,i) > threshold_la && sum(explained(end-17,i)) < sum_th  %if the 1 component explains more than X percent of the variance is seen as the channels contains information  
        score_com = [score_com score2];
        chs       = [chs i];
    end
end

if isempty(chs)
    b = 2
end
%calculating the combined PCA
[~,score,~,~,~] = pca(score_com);

%plotting the PCA space
%plot_PCA_space(score,c,idx,str)

Z = linkage(score(:,1:3),'average','chebychev');
%dendrogram(Z)
T = cluster(Z,'cutoff',0.6,'Criterion','distance');
maxV = max(shiftMatrix(:));
minV = min(shiftMatrix(:));
cls  =  max(T);

for ch = 1:numel(chs)
    count = 1;
    for cl = 1:cls
        idx_cl = T == cl;
        if sum(idx_cl) > 50
            cl_p{ch}(:,count) = mean(shiftMatrix(:,chs(ch),idx_cl),3);
            count = count + 1;
        end
    end
end

figure
subplot(1,numel(chs)+2,[1 2])
if strcmp(method,'single')
    scatter3(score(:,1),score(:,2),score(:,3),[],T)   
elseif strcmp(method,'all')
    hold on
    for i = 1:c(end)
        idx = c == i;
        plot3(score(idx,1),score(idx,2),score(idx,3),'.')
    end
end
title([str, '-cluster  ',num2str(idx)]);xlabel('1-component'),ylabel('2-component');zlabel('3-component')
for m = 1:numel(chs)
    subplot(1,numel(chs)+2,m+2)
    plot(cl_p{m})
    ylim([minV maxV])
    title(['chs ' num2str(chs(m))])
end

end

