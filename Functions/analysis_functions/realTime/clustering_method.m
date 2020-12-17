function clustering_method(score,shiftMatrix,c)

Z = linkage(score(:,1:3),'average','chebychev');
%dendrogram(Z)
T = cluster(Z,'cutoff',120,'Criterion','distance');
maxV = max(shiftMatrix(:));
minV = min(shiftMatrix(:));
figure
subplot(1,size(shiftMatrix,2)+2,[1; 2])
scatter3(score(:,1),score(:,2),score(:,3),[],T)
title('Hierarchical clustering');xlabel('1-component'),ylabel('2-component');zlabel('3-component')
legend_plot = {};
for i = 1:numel(unique(T))
    if size(shiftMatrix(:,:,T == i),3) > 20 %more than X spikes in the hiarchi cluster
        
        for j = 1:size(shiftMatrix,2)
            subplot(1,size(shiftMatrix,2)+2,j+2)
            hold on
            plot(mean(shiftMatrix(:,j,T == i),3))
            ylim([minV maxV])
        end
        legend_plot{end+1} = [' cl - ',num2str(i),' ',num2str(size(shiftMatrix(:,j,T == i),3))];
    end
end
legend(legend_plot)



%The row -> the orginal cluster 
figure
for i = 1:numel(unique(c))        % number of clusters in the TT files that are similar to the real-time template
    idx   = c == i;               % take out the index of the differen template    
    cls  = T(logical(c == i));    % find the comparison between Hiearchi-clustering and the TT file 
    value = tabulate(cls);        % tabulate the value that the TT files compares to the Hiearchi-clustering
    tst   = find(value(:,3) > 5); % more than percent X spikes 
    for m = 1:size(shiftMatrix,2) % number of chs that are calculated with the PCA single channels methods
        for j = 1:numel(tst)      % number of clusters in T    
            subplot(numel(unique(c)),size(shiftMatrix,2),size(shiftMatrix,2) *(i-1)+m)
            hold on
            plot(mean(shiftMatrix(:,m,idx(T == tst(j))),3))
        end
        ylim([minV maxV] )
        title(['cluster - ' num2str(i)])
    end
end



end


