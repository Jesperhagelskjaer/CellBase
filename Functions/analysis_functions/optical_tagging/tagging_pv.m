function [varargout] = tagging_pv(cellid,varargin)
%add_analysis(@tagging_pv,0,'property_names',{'pv','i_diff'},'arglist',{'event','BurstOn','window', [-0.1 0.2],'display',0});

%delanalysis(@tagging_pv)

persistent f

method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'event','BurstOn',@ischar)
    addParameter(prs,'window',[-0.1 0.2],@(s)isnumeric(s) && size(s,2) == 2); %(!)
    addParameter(prs,'display',0,@(s) s == 0 || s == 1)
    addParameter(prs,'dt',0.001,@isnumeric)   % time resolution of the binraster, in seconds
    addParameter(prs,'event_filter','none',@ischar)   % filter events based on properties
    addParameter(prs,'filterinput',[])   % some filters need additional input
    addParameter(prs,'maxtrialno',5000)   % downsample events if more than 'maxtrialno'
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[ratname,session,tetrode,unit] = cellid2tags(cellid); %tetrode zero-index like cpp

name = sprintf('STIMSPIKES%d_%d.mat',tetrode,unit); %(!)
path = fullfile(f.path,ratname,session);            %(!)


pv = nan; i_diff = nan;
if exist(fullfile(path,name),'file')
    [pv, i_diff] = tagging_index(cellid,f);
end

varargout{1}.pv     = pv;
varargout{1}.i_diff = i_diff;
end





