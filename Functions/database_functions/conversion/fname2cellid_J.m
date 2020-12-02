function   cellid = fname2cellid_J(fname)
%FNAME2CELLID    Convert filenames to cell IDs.
%   CELLID = FNAME2CELLID(FILENAME) converts valid filenames into cellids
%   or returns empty if it fails.
%
%   Valid filenames
%   (1) start with the default path or only include 'rat\session\unit.mat'
%   (2) unit 1 of tetrode 1 is called Sc1_1.mat
%   (3) session name can only contain '.' or '_' characters but not both
%   (4) should be consistent across the database
%
%   See alse FINDALLCELLS.

%   ZFM additions:
%   - Uses the preference 'cell_pattern' to store a search term that selects
%   files corresponding to units. The default is 'Sc*.mat'. E.g.
%
%   setpref('cellbase','cell_pattern','Sc*.mat')
%
%   - Uses the preference 'group' to store an 'cut' subdirectory
%   under the session directory. E.g.
%
%   setpref('cellbase','group','Mike');

%   Edit log: JH 17/11/2020

% Get cellbase preferences

cellbase_path  = getpref('cellbase','datapath');
cell_pattern   = getpref('cellbase','cell_pattern');
[~,name,~]     = fileparts(fname);

cellid = 0;
if startsWith(name,cell_pattern) %The first check to incorporate the right neuron into the cellbase
    %
    % Strip datpath from file
    fn = char(strrep(fname,cellbase_path,''));
    fs = filesep;
    
    % Parse the filename (ratname\sessionname\analysisdir\)
    [ratname,remain]  = strtok(fn,fs);
    [session,remain]  = strtok(remain(2:end),fs);
    
    % Extract tetrode unit
    [tetrodeunit,~] = strtok(remain(2:end),'.');
    tu              =  sscanf(tetrodeunit,[cell_pattern '%d_%d']);
    if regexp(name,tetrodeunit) %The last to incorporate the right neuron into the cellbase
        cellid = sprintf('%s_%s_%d.%d',ratname,session,tu(1),tu(2));
        disp(cellid)
    end
end