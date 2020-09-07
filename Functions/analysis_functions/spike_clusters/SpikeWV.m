% Calculate spike width for each cell. You have to be in the directory of
% the animal with many sessions
% SW is the output file and comment it after run first animal.
%
% clear all; clc; close all;
% load data
rootdir = cd;
clear cd;
session = dir;
session = session(3:end);
sessions2cluster =  1:length(session);
sf = 30000;
SW = []; % comment it after first animal to concatenate across sessions
for i =  sessions2cluster % [8 11 18 21 24 26 27]*
    sessionpath = [rootdir,'\',session(i).name];
    cd(sessionpath);
    load('rezFinalK')
    NCluster = size(rez.Merge_cluster(:, 3),1);
    Chan = NaN(1, NCluster);
    Lead = 1;
    WV = cell(1, NCluster);
    iCounter = 1;
   
    %generate cluster list
    for k = 1:NCluster
        
        Chan(k) = rez.Merge_cluster{k,5}(1); % take first channel of cluster
    end
    
    % bundle channels into tetrodes
    for iTetr = 1:4:32 % number of tetrodes
        
        TetrInx = find(Chan <= iTetr + 3 & Chan >= iTetr);
        
        for iCl = TetrInx
            
            wv = rez.M_template(:,Chan(iCl),iCl);
            TetrN = floor(iTetr/4);
            WV{iCounter} = ['WV',num2str(TetrN),'_',num2str(Lead)]; % tetrode names start at 0
            
            
            wvmean = - wv; % invert your spike waveforms. this is after you compute the mean waveforms for each channel. The size of the array is 4,nSamples
            [amx, mx] = max(wvmean);     %  maximum of a top channel
%             [mx, my] = find(wvmean==amx,1,'first');     % mx: largest channel and index
            [amn, inxmin] = min(wvmean(mx:end));     %  minimum of mean waveforms from the peak
            inxmin = inxmin + mx -1; % minimun after the peak
            if length(find(rez.st(:,end)==iCl)) == 1
                sw = NaN;
            else
            t1 =  interp1(wvmean(1:mx),[1:mx],(amx + amn)/2,'pchip'); % interpolate half width till the peak
            t2 =  interp1(wvmean(mx:inxmin),[mx:inxmin],(amx + amn)/2,'pchip'); % interpolate half width from the peak
            sw = (t2-t1)*(1000000/sf); % express it in microseconds
            end
%             save(WV{iCounter}, 'sw') % save in the current directory spike times compatible with Mclust
             SW  = [SW sw];
            Lead = Lead + 1; tSpikes = [];iCounter = iCounter + 1;
        end
        
        Lead = 1;
    end
end