function viewcell2b_j(cellid,varargin)


prs          = inputParser;
addParameter(prs,'window',[-0.5 1]) %
addParameter(prs,'dt',0.01) %
addParameter(prs,'sigma',0.02)
addParameter(prs,'trial',0)   % rescaling
addParameter(prs,'splitDataSet',[])
addParameter(prs,'event_name','CentralPortEpoch')
addParameter(prs,'triggerName',[])
parse(prs,varargin{:})
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

idx = 1;
%tt = size(data,2) * numel(g.triggerName);
%[valid_trial{tt},valid_trial_shift{tt},stimes{tt},binraster{tt} ] = deal([]);
%spsth
for j = 1:numel(g.triggerName)
    data        = TE.(g.triggerName{j});
    [data]      = splitting_data_set(data,g);
    trigger_pos = findcellstr(SP.events(:,1),g.triggerName{j});
    for i = 1:size(data,2)
        valid_trial{idx}               = ~isnan(data{i}); %(!)
        valid_trial_shift{idx}         = circshift(valid_trial{idx}', [g.trial 0]);
        stimes{idx}                    = SP.event_stimes{trigger_pos}(valid_trial_shift{idx} );
        binraster{idx}                 = stimes2binraster(stimes{idx},time,g.dt); % Calculate binraster
        [~, spsth(:,idx), ~]           = binraster2psth_J(binraster{idx},g.dt,g.sigma);
        idx = idx +1;
    end
end

[label_str]                  = label_creating(g.triggerName,size(data,2));
figure;
for i = 1:size(spsth,2)
    Data       = repmat(~logical(binraster{i}), 1, 1, 3); % makes multiple copies of your matrix in 3rd dimension
    subplot(size(spsth,2)+1,1,i);
    image(0.5:size(binraster{i},2),1:size(binraster{i},1),Data,'CDataMapping','scaled')
    title(label_str{i})
    set(gca,'XColor', 'none')
end
subplot(size(spsth,2)+1,1,size(spsth,2)+1);
plot(time,spsth)
xlim([time(1) time(end)])
ylabel('Rate (Hz)')
xlabel('Time [s]')
legend(label_str)



