% clear all
% load rez
% load TT2_1.mat
% close all
clear title
Edge = [-5 5];
wn = 20;
for icell_1 = [14]
    for icell_2 = [1:13,15:39]   
        Cluster1 = icell_1;
        Cluster2 = icell_2;
        T1 = rez.st(rez.st(:,end)==Cluster1,1)/30000;
        T2 = rez.st(rez.st(:,end)==Cluster2,1)/30000;

%         T1 = rez.st(inx2,2) ;
%         T2 = rez.st(inx1,2) ;

%         T1 = rez.st(rez.st(:,end)==Cluster1,2);
%         T2 = (double(tSpikes))/10 -timestamps(1)*1000;

%         TS1 = load('TT0_02');
%         TS2 = load('TT1_03');
%         T1 = TS1.tSpikes;
%         T2 = TS2.tSpikes;
%         T1 = double(T1);
%         T2 = double(T2);
%         Raster = zeros(length(T2),100);
%         for i = 1:length(T2)
%             allspikes = T1 -T2(i);
%             spikes = ceil(allspikes(allspikes > Edge(1) & allspikes < Edge(2)) + Edge(2));
%             Raster(i,spikes) = 1;
%         end
%         bar(sum(Raster))
[H1 ccr lwr upr rccg] = somccg_conf_filter(T1,T2,wn);
        title([icell_1 icell_2])
    end
end

