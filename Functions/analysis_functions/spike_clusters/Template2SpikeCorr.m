
function  [M_corr Std_corr]  = Template2SpikeCorr(sessionpath,rez)

cd = sessionpath;
fshigh = 5000;
fs = 30000;
slow = 300;
[d, timestamps, info] = load_open_ephys_data(sprintf('100_CH%d.continuous',1));
data = zeros(32,round(length(d)/2));
[b1, a1] = butter(3, [fshigh/fs,slow/fs]*2, 'bandpass');

for i = 1:32
    [d, timestamps, info] = load_open_ephys_data(sprintf('100_CH%d.continuous',i));
    d = filtfilt(b1, a1, d);
    data(i,:) = d(1:size(data,2),1);
end
dataW = data'*rez.Wrot;
dataW = dataW';
%%

MaxSpk = 1000;
Cells = length(unique(rez.st(:,end)));
M_corr = zeros(1,Cells);
Std_corr = zeros(1,Cells);


for i = 1:Cells
    
    SelectCh = rez.Merge_cluster{i,end}';
    SelectCh = Limit2Tetrodes(SelectCh(1));
    
    %     SelectCh = 1:32;
    M_Waveform = rez.M_template(:,SelectCh,i);
    SpkN = length(find(rez.st(:,end) == i));
    inxS = find(rez.st(:,end)== i);
    if SpkN > MaxSpk
        SpkN = MaxSpk;
    end
    R = NaN(1,SpkN);
    
    for isp = 1:SpkN
        %       S_Waveform = dataW(rez.st(inxS(isp),1)-19:rez.st(inxS(isp),1)+20,SelectCh);
        S_Waveform = dataW(rez.st(inxS(isp),1)-19:rez.st(inxS(isp),1)+40,SelectCh); %   - dataW(rez.st(inxS(isp),1)-29);
        [r, ~] = corrcoef(S_Waveform(1:30,:), M_Waveform(1:30,:));
        R(1,isp) = r(1,2);
    end
    
    M_corr(1,i) = mean(R);
    Std_corr(1,i) = std(R);
    
    for k = 1:Cells
        CorrValues = corrcoef(rez.M_template(:,:,i),rez.M_template(:,:,k));
        MatrixCorr(i,k) = CorrValues(1,2);
    end
    
    clear R S_Waveform inxS M_Waveform SelectCh
end


end

