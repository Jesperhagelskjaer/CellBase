function viewcell2b_j(cellid,triggerName,varargin)


prs          = inputParser;
addRequired(prs,'cellid',@(x) iscell(x) )
addRequired(prs,'triggerName',@(x) iscell(x) || isstring(x) || ischar(x))
addParameter(prs,'window',[-0.5 1]) %
addParameter(prs,'dt',0.01) %
addParameter(prs,'sigma',0.02)
addParameter(prs,'sigma_ex',3)
addParameter(prs,'trial',0)   % rescaling
addParameter(prs,'splitDataSet',[])
addParameter(prs,'event',[])
parse(prs,cellid,triggerName,varargin{:})
g = prs.Results;

% Check if cellid is valid
if validcellid(cellid,{'list'}) ~= 1
    fprintf('%s is not valid.',cellid);
    return
end

TE = loadcb(cellid,'TrialEvents');
SP = loadcb(cellid,'EVENTSPIKES');

[g] = checking_trigger_name(SP,g);

[raster_high, spsth,m] = generation_data(TE,SP,g);

[label_str]            = label_creating(g,m);

plotting_raster(raster_high,spsth,g,label_str)

end


