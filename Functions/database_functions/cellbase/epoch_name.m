function [str] = epoch_name()

path  = matlab.desktop.editor.getActiveFilename; %get the path to this code
out   = regexp(path,'\','split');
idx   = find(strcmpi('Functions',out));
path  = fullfile(out{1:idx},'create_epochs_event\eventsEpochs');
files = dir(path);

for i = 3:numel(files)
   names{i-2} = files(i).name;
end

[idx,~] = listdlg('ListString',names,'ListSize',[500,200],'SelectionMode','single');

str = names{idx}(1:end-2); %removing the ".m" extension

end

