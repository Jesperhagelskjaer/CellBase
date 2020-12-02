function Kilosort2CellID_J(rootdir)

sessionpath = fullfile(rootdir);
try
    [~, timestamps, ~] = load_open_ephys_data_faster(fullfile(rootdir,'all_channels.events'));
catch
    %sessionpath_csc = fullfile(rootdir,'csc','CSC1.ncs');
    %[timestamps, t, y,m, b, c] = Nlx2MatCSC(sessionpath_csc,[1 1 1 1 1], 1, 1, [] );
    timestamps = 0; %(!)
end

try
    load(fullfile(sessionpath,'rezFinalK'))
catch
    load(fullfile(sessionpath,'rezFinal'))
end
%define variables
sf = 30000;
tSpikes = [];
NCluster = size(rez.Merge_cluster(:, 3),1);
Chan = NaN(1, NCluster);
Lead = 1;
Tetrode = cell(1, NCluster);
iCounter = 1;
TIMEFACTOR = 1./3;

%generate cluster list
for k = 1:NCluster   
    Chan(k) = rez.Merge_cluster{k,5}(1); % take first channel of cluster
end

% bundle channels into tetrodes
for iTetr = 1:4:32 % number of tetrodes
    
    TetrInx = find(Chan <= iTetr + 3 & Chan >= iTetr);
    
    for iCl = TetrInx
        
        tSpikes = rez.st(rez.st(:,end) == rez.Merge_cluster{iCl,3},1);
        TetrN = floor(iTetr/4);
        Tetrode{iCounter} = ['TT',num2str(TetrN),'_',num2str(Lead)]; % tetrode names start at 0
        %           tSpikes = (tSpikes + timestamps(1)).*TIMEFACTOR; % kilosort does not add initial timestamp of the recordings
        tSpikes = (tSpikes + timestamps(1)*sf).*TIMEFACTOR; % kilosort does not add initial timestamp of the recordings
        save(fullfile(sessionpath,Tetrode{iCounter}), 'tSpikes') % save in the current directory spike times compatible with Mclust
        Lead = Lead + 1; 
        %tSpikes = [];
        iCounter = iCounter + 1;
    end
    
    Lead = 1;
end

end


