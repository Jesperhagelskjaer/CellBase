function [str] = epoch_name()

path = matlab.desktop.editor.getActiveFilename;
out  = regexp(path,'\','split');
idx = find(strcmpi('Functions',out));
path = fullfile(out{1:idx},'create_epochs_event\eventsEpochs');
files = dir(path);

for i = 3:numel(files)
   names{i-2} = files(i).name;
end


[idx,~] = listdlg('ListString',names,'ListSize',[500,200],'SelectionMode','single');

str = names{idx}(1:end-2); %removing the ".m" extension
 
end

% list = {'EventsEpochs_default','EventsEpochs_firstrestart','EventsEpochs_FreeChoice',...                   
%         'EventsEpochs_FreqDiscrimination','EventsEpochs_laserstim_Jane', 'EventsEpochs_Matching',...
%         'EventsEpochs_pulseon','EventsEpochs_ToneFreq'};
% [indx,~] = listdlg('ListString',list,'ListSize',[500,200],'SelectionMode','single');


% switch indx
%     case 1
%         str = 'EventsEpochs_default';
%     case 2
%         str = 'EventsEpochs_firstrestart';
%     case 3
%         str = 'EventsEpochs_FreeChoice';
%     case 4
%         str = 'EventsEpochs_FreqDiscrimination';
%     case 5
%         str = 'EventsEpochs_laserstim_Jane';
%     case 6 
%         str = 'EventsEpochs_Matching';
%     case 7
%         str = 'EventsEpochs_pulseon';
%     case 8
%         str = 'EventsEpochs_ToneFreq';
% end