function [varargout] = raster_spike_timing(cellid,varargin)

%add_analysis(@raster_spike_timing,0,'property_names',{'time_error'},'arglist',{});
global f
global CELLIDLIST

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'TTL',[1 2])         % The TTL for the templates on the Neuralinks system
    addParameter(prs,'TTL_light',130) 
    addParameter(prs,'backwards',15000) 
    addParameter(prs,'forwards', 1000) 
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

time_error = [];
if POS(1) == idx
    fullNameEvent    = fullfile(getpref('cellbase','datapath'),r,s,'Events.nev');
    [TTLs,TTLs_time] = loadEvent(fullNameEvent);
    
    [time_error] = raster_stimulation(TTLs,TTLs_time);
end

%close all
varargout{1}.time_error     = time_error;
end

