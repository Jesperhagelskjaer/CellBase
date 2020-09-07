%Dynamic renaming of folders for cellbase
%Expected initial folder format: YYYY-MM-DD-HH-MM-SS
% you have to be in the animal directory
clear all

CurrentFolder = cd;
Session = dir;
Session = Session(3:end);
delPos = [5 8 11:19];
SessNames = cellstr(char(Session(1:end).name));

for isess = 1:length(Session)
    newname = char(Session(isess).name);
    newname(delPos) = [];
    if sum(strncmp(newname, SessNames, 8)) == 0 
        newname = [newname 'a'];
        movefile(Session(isess).name , newname)
        UpD_Session = dir;
        UpD_Session = UpD_Session(3:end);
        SessNames = cellstr(char(UpD_Session(1:end).name));
    elseif sum(strncmp(newname, SessNames, 8)) == 1
        newname = [newname 'b'];
        movefile(Session(isess).name , newname)
        UpD_Session = dir;
        UpD_Session = UpD_Session(3:end);
        SessNames = cellstr(char(UpD_Session(1:end).name));
    elseif sum(strncmp(newname, SessNames, 8)) == 2
        newname = [newname 'c'];
        movefile(Session(isess).name , newname)
        UpD_Session = dir;
        UpD_Session = UpD_Session(3:end);
        SessNames = cellstr(char(UpD_Session(1:end).name));
    end
end
