function [str] = event_name()

list = {'EventsEpochs_ToneFreq','EventsEpochs_Matching','EventsEpochs_FreqDiscrimination',...                   
        'EventsEpochs_FreeChoice','EventsEpochs_laserstim_Jane', 'EventsEpochs_FreeChoiceWithStimInh'};
[indx,~] = listdlg('ListString',list);

switch indx
    case 1
        str = 'EventsEpochs_ToneFreq';
    case 2
        str = 'EventsEpochs_Matching';
    case 3
        str = 'EventsEpochs_FreqDiscrimination';
    case 4
        str = 'EventsEpochs_FreeChoice';
    case 5
        str = 'EventsEpochs_laserstim_Jane';
    case 6 
        str = 'EventsEpochs_FreeChoiceWithStimInh';
end

end

