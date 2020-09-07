function [varargout] = tagging_pv(cellid,path,varargin)
%addanalysis(@tagging_pv,'property_names',{'pv','i_diff'},'mandatory',{'D:\recording'},'arglist',{'event','BurstOn','window', [-0.1 0.2],'display',0});

%delanalysis(@tagging_pv)

prs = inputParser;
addRequired(prs,'cellid',@(cellid) iscellid(cellid) || (cellid) == 0) % cell ID
addRequired(prs,'path',@ischar)   % path to the data
addParameter(prs,'event','BurstOn',@ischar)
addParameter(prs,'window',[-0.1 0.2],@(s) size(s,2) == 2); %(!) 
addParameter(prs,'display',1,@(s) s == 0 || s == 1)
parse(prs,cellid,path,varargin{:})

if (prs.Results.cellid == 0)
    varargout{1}.prs = prs;
    return
end



[ratname,session,tetrode,unit] = cellid2tags(prs.Results.cellid); %tetrode zero-index like cpp

name = sprintf('STIMSPIKES%d_%d.mat',tetrode,unit);
path = fullfile(prs.Results.path,ratname,session);


pv = nan; i_diff = nan;
if exist(fullfile(path,name),'file')
    %[pv, i_diff] = tagging_index(prs.Results.cellid,'event', 'BurstOn','window',[-0.1 0.2],'display',0);
    [pv, i_diff] = tagging_index(prs.Results.cellid,varargin{:});
end

varargout{1}.pv     = pv;
varargout{1}.i_diff = i_diff;
end





