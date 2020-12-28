function [varargout] = raster_spike_timing(cellid,varargin)

%add_analysis(@raster_spike_timing,0,'property_names',{},'arglist',{});
global f
global CELLIDLIST
method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
        
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);


if POS(1) == idx
    fullNameEvent    = fullfile(getpref('cellbase','datapath'),r,s,'Events.nev');
    [TTLs,TTLs_time] = loadEvent(fullNameEvent);
    TTL_value        = unique(TTLs);
    TTL_value        = TTL_value(ismember(TTL_value,f.TTL));
    


end


end

