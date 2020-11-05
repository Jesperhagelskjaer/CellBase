function [str] = epoch_name()

list = {'EventsEpochs_default','EventsEpochs_firstrestart','EventsEpochs_FreeChoice',...                   
        'EventsEpochs_FreqDiscrimination','EventsEpochs_laserstim_Jane', 'EventsEpochs_Matching',...
        'EventsEpochs_pulseon','EventsEpochs_ToneFreq'};
[indx,~] = listdlg('ListString',list,'ListSize',[500,200],'SelectionMode','single');

switch indx
    case 1
        str = 'EventsEpochs_default';
    case 2
        str = 'EventsEpochs_firstrestart';
    case 3
        str = 'EventsEpochs_FreeChoice';
    case 4
        str = 'EventsEpochs_FreqDiscrimination';
    case 5
        str = 'EventsEpochs_laserstim_Jane';
    case 6 
        str = 'EventsEpochs_Matching';
    case 7
        str = 'EventsEpochs_pulseon';
    case 8
        str = 'EventsEpochs_ToneFreq';
end

end
