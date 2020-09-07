% Convert Kilosort spikes into cell base compatible format.
% Spikes are rounded to millisecond scale
% you have to be in the directory that stores rez and TrialEvents file
%
clear all; clc; close all;
% load data
rootdir = cd;
clear cd;
session = dir;
session = session(3:end);
sessions2cluster =  1:length(session);
sf = 30000;

for i =  sessions2cluster % [8 11 18 21 24 26 27]*
    sessionpath = [rootdir,'\',session(i).name];
    cd(sessionpath);
    [data, timestamps, info] = load_open_ephys_data_faster('all_channels.events');
    load('rezFinalK')
    % load('TrialEvents')
    
    %define variables
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
            save(Tetrode{iCounter}, 'tSpikes') % save in the current directory spike times compatible with Mclust
            Lead = Lead + 1; tSpikes = [];iCounter = iCounter + 1;
        end
        
        Lead = 1;
    end
end