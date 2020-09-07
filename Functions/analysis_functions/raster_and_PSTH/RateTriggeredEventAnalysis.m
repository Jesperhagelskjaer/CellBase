%%%%%% Rate triggered event analysis %%%%%%%%%%%%%
TTfile = 'TT1_2.mat';
load(TTfile);
TE = load('TrialEvents');
[data, timestamps, info] = load_open_ephys_data('100_CH32.continuous');
Spikes = round(double(tSpikes)/10); % convert it into ms and center it to the begining
raster = zeros(1,Spikes(end)+ 1000);
for i = 1:length(Spikes)
    raster(Spikes(i)) = 1;
end


x = [-50:1:50];
norm = normpdf(x,0,10);
peth = conv(raster,norm,'same');
[pethpeaks inx]  = findpeaks(peth);
inxE = inx(pethpeaks>5*std(peth));

figure(1)
plot(peth)
for i = 1:length(inxE)
hold on 
plot(inxE(i), 0.1,'r*')
end

RightRewardON = RightRewardON(~isnan(RightRewardON));
inxI = find(inxE > RightRewardON(1)*1000,1,'first');
inxE = inxE(inxI:end);
RRB = NaN(1,length(inxE));
RRA = NaN(1,length(inxE));
for i = 1:length(inxE)
    RRB(i) =  RightRewardON(find(RightRewardON*1000<inxE(i),1,'last'))*1000 - inxE(i);
    if ~isempty(RightRewardON(find(RightRewardON*1000>inxE(i),1,'first')))
    RRA(i) =  RightRewardON(find(RightRewardON*1000>inxE(i),1,'first'))*1000 - inxE(i);
    end
end

figure
[N1, ~] = histc(RRB,[-80000:200:0]);
[N2, ~] = histc(RRA,[0:200:80000]);
% x = [-200:1:200];
% norm = normpdf(x,0,50);
% peth = conv([N1 N2],norm,'same');
% plot(peth)

bar([N1 N2])

LeftRewardON = RightRewardON(~isnan(RightRewardON));
inxI = find(inxE > LeftRewardON(1)*1000,1,'first');
inxE = inxE(inxI:end);
% LRB = NaN(1,length(inxE));
% LRA = NaN(1,length(inxE));
LRB = [];
LRA = [];

for i = 1:length(inxE)
%   LRB(i) =  LeftRewardON(find(LeftRewardON*1000<inxE(i),1,'last'))*1000 - inxE(i);
    LRB =  [LRB LeftRewardON(LeftRewardON*1000<inxE(i))*1000 - inxE(i)];
    if ~isempty(LeftRewardON(find(LeftRewardON*1000>inxE(i),1,'first')))
%     LRA(i) =  LeftRewardON(find(LeftRewardON*1000>inxE(i),1,'first'))*1000 - inxE(i);
    LRA =  [LRA LeftRewardON(LeftRewardON*1000>inxE(i))*1000 - inxE(i)];

    end
end
figure
[N1, C1] = histc(LRB,[-	8000:200:0]);
N1 = N1/length(~isnan(LeftRewardON));
[N2, C2] = histc(LRA,[0:200:8000]);
N2 = N2/length(~isnan(LeftRewardON));
Pre = max(N1)/mean(N1(1:end-10));
Post = max(N2)/mean(N2(10:end));
EventCorrelarion = max([Pre Post]);

% x = [-200:1:200];
% norm = normpdf(x,0,100);
% peth = conv([N1 N2],norm,'same');
% plot(peth)

bar([N1 N2])




