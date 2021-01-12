function [score] = PCA_calculation(str,method,data,idx,Latent,Explained)

if strcmp(method,'all')
    idx = 1:numel(data);
    tt = sum(cellfun('size',data,3));
    Idx = false(tt,numel(data));
    end_v = 0;
    for i = 1:numel(data)
        start = 1 + end_v;
        end_v = size(data{i},3) + start - 1;
        Idx(start:end_v,i) = true;
    end
end

chs_start       = 1:32;
for t = 1:2
    shiftMatrix        = spike_alignment(data(idx),chs_start);
    [PCA_matrix]       = normalisation_spikes(shiftMatrix);
    [latent,explained] = deal(zeros(size(PCA_matrix,1),32));
    [score_com,chs]    = deal([]);
    score2             = {};
    for i = chs_start
        [~,score2{i},latent(:,i),~,explained(:,i)] = pca(squeeze(PCA_matrix(:,i,:))');
    end
    for i = chs_start
        if strcmp(method,'all')
            if (explained(1,i) > max(Explained(1,:)))
                score_com = [score_com score2{i}];
                chs       = [chs i];
            end
        elseif strcmp(method,'single')
            if sum(explained(end-17:end,i),1) > sum(Explained(end-17:end,i),1) || explained(1,i) > 70 %(latent(1,i) > threshold_la(t) &&
                score_com = [score_com score2{i}];
                chs       = [chs i];
            end
        end
    end
    [chs,score_com] = last_resort(explained,chs,score_com);
    chs_start = chs;
end

%figure,plot(squeeze(PCA_matrix(:,32,:)))
%figure,surf(mean(PCA_matrix,3))
%figure,surf(mean(data{idx},3))
%calculating the combined PCA
[~,score,~,~,~] = pca(score_com);

%plotting the PCA space
%plot_PCA_space(score,c,idx,str)

Z = linkage(score(:,1:3),'average','chebychev');
%dendrogram(Z)
T = cluster(Z,'cutoff',0.6,'Criterion','distance');


figure
if strcmp(method,'single')
    subplot(1,numel(chs)+2,[1 2])
    scatter3(score(:,1),score(:,2),score(:,3),[],T)
    title(str);xlabel('1-component'),ylabel('2-component');zlabel('3-component')
    c = parula(numel(unique(T)));
    for m = 1:numel(chs)
        subplot(1,numel(chs)+2,m+2)
        for cl = 1:numel(unique(T))
            data_shade = squeeze(shiftMatrix(:,chs(m),logical(cl == T)));
            stdshade_sorting(data_shade,c(cl,:))
        end
        title(['chs ' num2str(chs(m))])
        xlabel('Time [Samples]') %not nes. correct
        ylabel('Voltage [uV]')  %not nes. correct
    end
    h = findobj(gcf,'type','axes');
    for k=1:numel(chs)-1
        yi=get(h(1:numel(chs)),'YLim');
    end
    Max = max(cellfun(@max,yi,'uni',true));
    Min = min(cellfun(@min,yi,'uni',true));
    set(h(1:numel(chs)),'YLim',[Min Max]);
 
    
elseif strcmp(method,'all')
    for i = 1:numel(data)
        hold on
        plot3(score(Idx(:,i),1),score(Idx(:,i),2),score(Idx(:,i),3),'.')
    end
    title(str);xlabel('1-component'),ylabel('2-component');zlabel('3-component')
end

end






