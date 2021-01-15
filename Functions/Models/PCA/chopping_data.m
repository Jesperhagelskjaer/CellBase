function [WSpikes] = chopping_data(tSpikes,lgt,data)

a = 1;
b = numel(data)-lgt-1;
r = round((b-a).*rand(tSpikes,1) + a);


WSpikes = zeros(lgt,tSpikes);
range = 1:lgt;
for i = 1:tSpikes
    WSpikes(:,i) = data(r(i)+range);
end

end
