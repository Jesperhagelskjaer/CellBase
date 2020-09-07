function [Dist P_Val] = ROC_Analysis(cells,EpochName1,EpochName2,SortTrials,value,N)
Dist = [];
P_Val = [];
for icell = 1:length(cells)
    loadcb(cells(icell),'EVENTSPIKES')
    loadcb(cells(icell),'TrialEvents')
    pos1 = find(strcmp(epochs(:,1),EpochName1)==1);
    pos2 = find(strcmp(epochs(:,1),EpochName2)==1);
    if isempty(SortTrials)
        [D, P, SE] = rocarea(epoch_rates{pos1},epoch_rates{pos2},'bootstrap',N,'transform','scale');
        Dist = [Dist D];
        P_Val = [P_Val P];
    else
        sortinx{1} = find(TE.(eval(['SortTrials{1}'])) == value{1}(1)&TE.(eval(['SortTrials{2}'])) == value{2}(1));
        sortinx{2} = find(TE.(eval(['SortTrials{1}'])) == value{1}(2)&TE.(eval(['SortTrials{2}'])) == value{2}(1));
%         sortinx{1} = find(TE.(eval(['SortTrials{1}'])) == value{1}(1));
%         sortinx{2} = find(TE.(eval(['SortTrials{2}'])) == value{2}(1));

        Epoch_rates1 = epoch_rates{pos1}(sortinx{1});
        Epoch_rates2 = epoch_rates{pos2}(sortinx{2});
        [D, P, SE] = rocarea(Epoch_rates1,Epoch_rates2,'bootstrap',N,'transform','scale');
        Dist = [Dist D];
        P_Val = [P_Val P];        
    end
end







