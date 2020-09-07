function [] = saving_data(TheMatrix,ANALYSES,CELLIDLIST)

assignin('base','TheMatrix',TheMatrix)
assignin('base','ANALYSES',ANALYSES)
cb = getpref('cellbase','fname');
[pth, fnm, ext] = fileparts(cb);
dsr = datestr(now);
dsr = regexprep(dsr,':','_');
backup_name = fullfile(pth,[fnm '_' dsr ext]);  % time stamped backup
copyfile(cb,backup_name)    % make backup before overwriting

% SAVE CELLBASE
save(getpref('cellbase','fname'),'TheMatrix','ANALYSES','CELLIDLIST','-v7.3')
end

