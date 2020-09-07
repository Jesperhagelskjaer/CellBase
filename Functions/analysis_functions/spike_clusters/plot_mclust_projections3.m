% load all spikes
function plot_mclust_projections3(Cluster1TS,Cluster2TS)

% as input argument provide Timestamps of a cluster

%specify the session and tetrode that you want to load
sessionpath = 'O:\ST_Duda\Recordings\SortedData\FreeChoice\MClustSorted\D003\20170212a';
TT = 'TT3';
TTpath = [sessionpath,'\' TT,'.spikes'];
allspikes = LoadTT_openephys(TTpath);
 [~,~, InxCluster1] = intersect(allspikes, Cluster1TS);
[~,~, InxCluster2] = intersect(allspikes, Cluster2TS);
wf_prop = load(sessionpath,'\',TT,'_feature_Peak.fd','-mat');


% plot in feature space

figure
for i = 1:3
subplot(2,2,i)
plot(wf_prop.FeatureData(:,1),wf_prop.FeatureData(:,i+1),'.','MarkerSize',1,'Colour','k')
hold on 
plot(wf_prop.FeatureData(InxCluster1,1),wf_prop.FeatureData(InxCluster1,i+1),'.','MarkerSize',1,'Colour','g')
hold on 
plot(wf_prop.FeatureData(InxCluster2,1),wf_prop.FeatureData(InxCluster2,i+1),'.','MarkerSize',1,'Colour','y')
box off
end



