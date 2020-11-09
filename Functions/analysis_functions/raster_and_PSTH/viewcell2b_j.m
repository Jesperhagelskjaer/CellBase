function viewcell2b_j(cellid,triggerName,varargin)


prs          = inputParser;
addRequired(prs,'cellid',@(x) iscell(x) )
addRequired(prs,'triggerName',@(x) iscell(x) || isstring(x) || ischar(x))
addParameter(prs,'window',[-0.5 1]) %
addParameter(prs,'dt',0.01) %
addParameter(prs,'sigma',0.02)
addParameter(prs,'trial',0)   % rescaling
addParameter(prs,'splitDataSet',[])
addParameter(prs,'event',[])
addParameter(prs,'p_lines','p_vlines')
parse(prs,cellid,triggerName,varargin{:})
g = prs.Results;


% Check if cellid is valid
if validcellid(cellid,{'list'}) ~= 1
    fprintf('%s is not valid.',cellid);
    return
end


%--------------------------------------------------------------------------
% Preprocessing
%--------------------------------------------------------------------------

% Time
margin = g.sigma * 3;     % add an extra margin to the windows
time   = g.window(1)-margin:g.dt:g.window(2)+margin;   % time base array

TE = loadcb(cellid,'TrialEvents');
SP = loadcb(cellid,'EVENTSPIKES');

[g] = checking_trigger_name(SP,g);

idx = 0;
for j = 1:numel(g.triggerName)
    data              = TE.(g.triggerName{j});
    valid_trial       = ~isnan(data); %(!)
    valid_trial_shift = circshift(valid_trial', [g.trial 0]);
    [data]            = splitting_data_set(valid_trial_shift,g);
    
    for i = 1:size(data,2)
        idx = idx + 1;
        
        [stimes]                           = stimes_event(SP,g,data{i},j);
        [raster_high{idx},raster_low{idx}] = stimes2binraster_J(g,stimes);
        %binraster{idx}            = stimes2binraster(stimes,time,g.dt); % Calculate binraster
        [~, spsth(:,idx), ~]      = binraster2psth_J(raster_low{idx},g.dt,g.sigma);
        
    end
end

[label_str]                  = label_creating(g.triggerName,size(data,2),g);
figure;
for i = 1:size(spsth,2)
    if strcmpi(g.p_lines,'p_vlines')
        Data       = repmat(~logical(raster_high{i}), 1, 1, 3); % makes multiple copies of your matrix in 3rd dimension
        subplot(size(spsth,2)+1,1,i);
        image(0.5:size(raster_high{i},2),1:size(raster_high{i},1),Data,'CDataMapping','scaled')
        set(gca,'XColor', 'none')
    elseif strcmpi(g.p_lines,'p_hlines')
        mul    = (1:1:size(raster_high{i},2))';
        mul2   = 1:1:size(raster_high{i},1);
        holder = raster_high{i}.* mul2';
        holder(holder == 0) = nan; %if nan they will not be plotted
        subplot(size(spsth,2)+1,1,i);
        plot(mul,holder,'|k','MarkerSize',0.5)        
        ylim([-1 size(holder,1)+1])
        xlim([0 size(holder,2)])
        %set(gca,'ytick',[])
    end
    title(label_str{i})
end
    
    subplot(size(spsth,2)+1,1,size(spsth,2)+1);
    plot(time(1:end-1),spsth) %(!)
    xlim([time(1) time(end)])
    ylabel('Rate (Hz)')
    xlabel('Time [s]')
    legend(label_str)
    
    
end


