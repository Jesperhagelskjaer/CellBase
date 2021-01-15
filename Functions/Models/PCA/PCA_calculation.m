function [explained] = PCA_calculation(wSpikes) 


[coeff,score,latent,tsquared,explained] = pca(wSpikes');


end

