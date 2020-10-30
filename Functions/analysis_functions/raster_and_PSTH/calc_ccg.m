function [data] = calc_ccg(x1,y1,f)

edges = -f.interval(1):f.resolution:f.interval(2);
edges2 = -f.interval(1)+0.5:f.resolution:f.interval(2)-0.5;
data = zeros(length(edges)-1,1);

for i = 1:numel(x1)
    M1 = x1{i}*1000;
    M2 = y1{i}*1000;
    
    SpikePETH_M = zeros(length(edges)-1,1);
    %calculate  PETH
    for iTrial = 1:numel(M1)
        allspikes = M2 - M1(iTrial);
        C = histcounts(allspikes,edges)';
        SpikePETH_M = SpikePETH_M + C;
    end
    data = data + SpikePETH_M;
end
% if f.display
%     figure
%     bar(edges2,data)
% end

end

