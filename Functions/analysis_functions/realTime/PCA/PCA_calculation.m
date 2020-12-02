function [score,chs] = PCA_calculation(shiftMatrix,c)

[score_com,chs] = deal([]);
explained       = zeros(size(shiftMatrix,1),32);
for i = 1:32
    [~,score2,~,~,explained(:,i)] = pca(squeeze(shiftMatrix(:,i,:))');
    if explained(1,i) > 65
        score_com = [score_com score2];
        chs       = [chs i];
    end
end

%plotting the PCA space
plot_PCA_space(score_com,c)

%calculating the combined PCA
[~,score,~,~,~] = pca(score_com);

end

