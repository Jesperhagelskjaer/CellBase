function [Latent,Explained] = random_template_noise(dataF,spikes,loops)
fprintf("Random template noise\n")

global f
xAxis     = f.xAxis(1):f.xAxis(2);                                       %creating the range to take out

end_d = size(dataF,1);
time = round(end_d.*rand(spikes,1));
time(time < 500)       = [];
time(time > end_d-500) = [];
sWaveforms = zeros(numel(xAxis),32,numel(time));
for i = 1:numel(time)
    sWaveforms(:,:,i) = dataF(xAxis+time(i),:);
end

[shiftMatrix_M] = spike_alignment({sWaveforms},1:32);
[shiftMatrix_M]    = normalisation_spikes(shiftMatrix_M);
for i = 1:loops
    s = RandStream('mlfg6331_64'); 
    Idx = datasample(s,1:spikes,spikes/20,'Replace',false);
    PCA_matrix = shiftMatrix_M(:,:,Idx);
    for ii = 1:32
        [~,~,latent{ii}(:,i),~,explained{ii}(:,i)] = pca(squeeze(PCA_matrix(:,ii,:))');
    end
end

for i = 1:32
    Latent(:,i)    = max(latent{i}(:,1:3));
    %Explained(:,i) = max(explained{i}(:,1:3));
    Explained(:,i)   = max(explained{i},[],2);
end





if 0
end_d = size(dataF,1);
for ii = 1:loops
    time = round(end_d.*rand(spikes,1));
    time(time < 500)       = [];
    time(time > end_d-500) = [];
    sWaveforms = zeros(numel(xAxis),32,numel(time));
    for i = 1:numel(time)
        sWaveforms(:,:,i) = dataF(xAxis+time(i),:);
    end
    waveforms{ii} = sWaveforms;
end

for i = 1:loops
    tic
   [shiftMatrix_M] = spike_alignment(waveforms(i),1:32);
   toc
   tic
   [PCA_matrix]    = normalisation_spikes(shiftMatrix_M);
   toc
   tic
   for ii = 1:32
        [~,~,latent{ii}(:,i),~,explained{ii}(:,i)] = pca(squeeze(PCA_matrix(:,ii,:))');
   end
   toc
   fprintf('\n')
end
for i = 1:32
    Latent_T(:,i)    = max(latent{i}(:,1:3));
    %Explained(:,i) = max(explained{i}(:,1:3));
    Explained_T(:,i)   = max(explained{i},[],2);
end
end
end



%figure;surf(mean(sWaveforms,3))