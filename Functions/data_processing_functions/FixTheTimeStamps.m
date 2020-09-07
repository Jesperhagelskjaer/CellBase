% fix the TT file names

dirpath =  cd;
session = ls;
session(1:4,:) = [];
for isess = 1:size(session,1)
    sessionpath = [dirpath,'\',session(isess,:)];
    cd(sessionpath)
    tetrodestr = ls('*TT*.mat');
    for iTetr = 1:size(tetrodestr,1)
        load(tetrodestr(iTetr,:))
        tetrode = [tetrodestr(iTetr,1:4) tetrodestr(iTetr,6:end)];
        save(tetrode,'tSpikes')
        delete(tetrodestr(iTetr,:))
    end    
end

%%
delete files

dirpath =  cd;
session = ls;
session(1:2,:) = [];
for isess = 1:size(session,1)
    sessionpath = [dirpath,'\',session(isess,:)];
    cd(sessionpath)
    EVENTstr = ls('*EVENTSPIKES*.mat');
    for iTetr = 1:size(EVENTstr,1)
        delete(EVENTstr(iTetr,:))
    end    
end
%% fix the time in TrialEvents

dirpath =  cd;
session = ls;
session(1:6,:) = [];
FACTOR = 0.000001;
% FACTOR = 1000000;
for isess = 1:size(session,1)
    sessionpath = [dirpath,'\',session(isess,:)];
    cd(sessionpath)   
    TE = load('TrialEvents_FreqDiscr');
    TE.TrialStart = TE.TrialStart*FACTOR;
    TE.TrialEnd = TE.TrialEnd*FACTOR;
    TE.CenterPortEntry = TE.CenterPortEntry*FACTOR;
    TE.CenterPortExit = TE.CenterPortExit*FACTOR;
    TE.CenterPortRewardOFF = TE.CenterPortRewardOFF*FACTOR;
    TE.CenterPortRewardON = TE.CenterPortRewardON*FACTOR;
    TE.ITI = TE.ITI*FACTOR;
    TE.LeftPortEntry = TE.LeftPortEntry*FACTOR;
    TE.LeftPortExitFirst = TE.LeftPortExitFirst*FACTOR;
    TE.LeftPortExitLast = TE.LeftPortExitLast*FACTOR;
    TE.LeftRewardON = TE.LeftRewardON*FACTOR;
    TE.LeftRewardOFF = TE.LeftRewardOFF*FACTOR;
    TE.RightPortEntry = TE.RightPortEntry*FACTOR;
    TE.RightPortExitFirst = TE.RightPortExitFirst*FACTOR;
    TE.RightPortExitLast = TE.RightPortExitLast*FACTOR;
    TE.RightRewardON = TE.RightRewardON*FACTOR;
    TE.RightRewardOFF = TE.RightRewardOFF*FACTOR;
    TE.ReactionTimes = TE.ReactionTimes*FACTOR;
    TE.FrequencyON = TE.FrequencyON*FACTOR;
    TE.FrequencyOFF = TE.FrequencyOFF*FACTOR;
    
    save TrialEvents TE
end





%% make data structure
eventstr = ls('*EVENTSPIKES*.mat');
eventstr = strsplit(eventstr);
DATA = struct;
sessionpath = cd;
eventstr(end) = [];
for icell = 1:length(eventstr)
    cellid{icell} = [sessionpath,'/',eventstr{icell}(1:end)];
    load(cellid{icell});
    DATA(icell).epoch_rates = epoch_rates;
    DATA(icell).epochs = epochs;
    DATA(icell).event_stimes = event_stimes;
    DATA(icell).event_windows = event_windows;
    DATA(icell).events = events;
    DATA(icell).cellid = cellid;
end
load('TrialEvents')
save FreeChoice_20160122 DATA TE

%% delete files
allcells = 150:260; listtag('cells');
for iCell = [1:length(allcells)],
    cellid = allcells(iCell);
    sessionpath = cellid2fnames(cellid,'sess');
    filepath1 = cellid2fnames(cellid,'EVENTSPIKES');
    %     %filepath2 = cellid2fnames(allcells(iCell),'Stimspikes');
    %     %filepath3=cellid2fnames(allcells(iCell),'TrialEvents');
    cd(sessionpath);
    delete(filepath1);
    %     delete(filepath1);
    %
    %
    %    % delete(filepath3)
end