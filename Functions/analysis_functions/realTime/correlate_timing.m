function [timing] = correlate_timing(RT_time,time)

jitter = 30:50;
[t_A,RT_only,ON_only] = deal([]);
for i = 1:numel(RT_time)
    index = floor(find(RT_time(i)- jitter < time  & RT_time(i) + jitter > time));
    if ~isempty(index)
        t_A  = [t_A RT_time(i)]; %the time index in agreement
    else
        RT_only  = [RT_only RT_time(i)]; %the time index in agreement
    end
end

for i = 1:numel(time)
    index = floor(find(time(i) - jitter < RT_time  & time(i) + jitter > RT_time));
    if isempty(index)
        ON_only  = [ON_only time(i)]; %the time index in agreement
    end
end

timing.t_A     = numel(t_A);
timing.RT_only = numel(RT_only);
timing.ON_only = numel(ON_only);
end




%     c = 0;
%     t_MS = datum.CW_t_JS_cor{i};
%     CW_NSI_DS = [];t_NSI_DS = [];CN_A_MC = [];
%     for ii = 1:length(t_MS)
%         %clusterSeen_MC = [];
%         bool = 1;
%         for MC = 1:size(datum.tSpikes_DSort_cor,2)
%
%             t_MC = datum.tSpikes_DSort_cor{MC};
%             index = floor(find(t_MS(ii)- jitter < t_MC  & t_MS(ii) + jitter > t_MC));
%             if ~isempty(index)
%                 CN_A_MC = [CN_A_MC MC];
%                 bool = 0;
%             end
%         end
%         if bool
%             c = c + 1;
%             t_NSI_DS     = [t_NSI_DS t_MS(ii)];
%             CW_NSI_DS  = cat(3,CW_NSI_DS,datum.CW_JS_cor{i}(:,:,ii));
%         end
%
%     end







