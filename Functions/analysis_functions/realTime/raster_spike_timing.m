function [varargout] = raster_spike_timing(cellid,varargin)

%add_analysis(@raster_spike_timing,1,'property_names',{'min_max','Error_total'},'arglist',{});


% min_max the minimum time the the neuron is found in the signal relative to the light pulse
% Error_total. The code is not perfect on the HPP, so the timing can be outside of the given range, and the Error_total is the  
% number that and error happaned in the session.

%delanalysis(@raster_spike_timing)

%cellbase -> LFP

global f
global CELLIDLIST

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'TTL',[1 2])         % The TTL for the templates on the Neuralinks system
    addParameter(prs,'TTL_light',130) 
    addParameter(prs,'backwards',14000) 
    addParameter(prs,'forwards', 1000) 
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
POS        = findcellpos('animal',r,'session',s);

time_error = [];
if POS(1) == findcellstr(CELLIDLIST',cellid)
    fullNameEvent    = fullfile(getpref('cellbase','datapath'),r,s,'Events.nev');
    [TTLs,TTLs_time] = loadEvent(fullNameEvent);
    [min_max,Error_total] = raster_stimulation(TTLs,TTLs_time);
else
    [min_max,Error_total] = deal([]);
end

%close all
varargout{1}.min_max     = min_max;
varargout{1}.Error_total = Error_total;
close all
end

