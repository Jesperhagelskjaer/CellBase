function [score] = PCA_calculation(str,method,data,idx)
[score] = deal([]);
threshold = 65;
if strcmp(method,'single')
    threshold = [30 32] ; %lowevering the thershold if one looking at one cluster
    threshold_la =[0.015 0.01] ;
    sum_th = [0.01 0.02];
elseif strcmp(method,'all')
    threshold = [65 70];
    threshold_la = 0.001;
    sum_th = 0.004;
    idx = 1:numel(data);
end

chs_start       = 1:32;
for t = 1:2
    shiftMatrix        = spike_alignment(data(idx),chs_start);
    [PCA_matrix]       = normalisation_spikes(shiftMatrix);
    [latent,explained] = deal(zeros(size(PCA_matrix,1),32));
    [score_com,chs]    = deal([]);
    score2              = {};
    for i = chs_start
        [~,score2{i},latent(:,i),~,explained(:,i)] = pca(squeeze(PCA_matrix(:,i,:))');
    end
    for i = chs_start
        if strcmp(method,'all')
            if (explained(1,i) > threshold(t))
                score_com = [score_com score2{i}];
                chs       = [chs i];
            end
        elseif strcmp(method,'single')
            if (latent(1,i) > threshold_la(t) && sum(explained(end-17:end,i),1) > sum_th(t)) || explained(1,i) > 70
                score_com = [score_com score2{i}];
                chs       = [chs i];
            elseif sum(explained(end-17:end,i),1) > 0.03
                score_com = [score_com score2{i}];
                chs       = [chs i];
            end
        end
    end
    if isempty(chs)
        threshold = 0.03;
        while 1
            threshold = threshold - 0.005;
            for i = chs_start
                if sum(explained(end-17:end,i),1) > threshold
                    score_com = [score_com score2{i}];
                    chs       = [chs i];
                end
            end
            if ~isempty(chs)
                break
            end
        end 
    end
    chs_start = chs;
end



if isempty(chs)
    b = 2
else

    %figure,plot(squeeze(PCA_matrix(:,32,:)))
    %figure,surf(mean(data{idx},3))
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
        c = [];
        for cl = 1:numel(data)
            c = [c; ones(size(data{cl},3),1)*cl];
        end
        for i = 1:c(end)
            idx = c == i;
            plot3(score(idx,1),score(idx,2),score(idx,3),'.')
        end
    end
    title(str);xlabel('1-component'),ylabel('2-component');zlabel('3-component')
    
    for m = 1:numel(chs)
        subplot(1,numel(chs)+2,m+2)
        try
            plot(cl_p{m})
            ylim([minV maxV])
        catch
        end
        title(['chs ' num2str(chs(m))])
    end
end
end




