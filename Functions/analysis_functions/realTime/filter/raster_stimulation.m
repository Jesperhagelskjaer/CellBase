function [min_max,Error_total] = raster_stimulation(TTLs,TTLs_time)

global f
Error       = [0 0];
for j = 1:numel(f.TTL)
    
    time_neuron = TTLs_time(logical(TTLs == f.TTL(j)));
    time        = TTLs_time(find(TTLs == f.TTL_light));
    idx_light   = find(TTLs == f.TTL_light);
    time_b      = time - f.backwards;
    time_f      = time + f.forwards;
    time_2b     = time - 10000;
    time_2f     = time + 0;
    
    
    [value]     = deal([]);
    
    for i = 1:length(time)
        if f.TTL(j) == 1
            neuron_within = time_neuron(time_neuron >= time_b(i) & time_neuron <= time_2f(i));  
            if ~isempty(neuron_within)
                value{i}  = (neuron_within(end) - time(i))/1000;  
                if any(value{i} < -10)
                    Error(j) = Error(j) +1; 
                end
            end
   

        elseif f.TTL(j) == 2
            neuron_within = time_neuron(time_neuron >= time_2b(i) & time_neuron <= time_2f(i));
            if ~isempty(neuron_within)
                %test(end+1) = neuron_within]; %be carefull here, recheck
                value{i}       = (neuron_within(end) - time(i))/1000;
            else    %and error in the internal TTL, a check in the TTL is made to see if value can be used
                try %since no check for "out of bounce" a try statement is used
                    %value(end+1) = ((TTLs_time(idx_light(i)) - TTLs_time(idx_light(i)+2))/1000+1.033); %the light pulse is 1.033 ms
                    value{i} = ((TTLs_time(idx_light(i)) - TTLs_time(idx_light(i))+2)/1000 - 0.033); %the light pulse is 1.033 ms
                catch
                end
            end
        else

        end
        
    end
    
    %use for figure in article
    
    edges = -f.backwards/1000:100/1000:f.forwards/1000;
    SpikeRaster2 = zeros(numel(value),numel(edges));
    %calculate raster and PETH
    error       = [];
    for iTrial = 1:length(value)
        if isempty(value{iTrial})
            error = [error  iTrial];
        else
            SpikeRaster2(iTrial,:) = histc(value{iTrial},edges);
        end
    end
    value(error) = [];
    
    
    min_max(j,1) = min(cellfun(@max,value,'uni',true));
    min_max(j,2) = max(cellfun(@min,value,'uni',true));
    Error(j)     = numel(error) + Error(j);
    
    figure
    imagesc(-SpikeRaster2,'XData',edges)
    colormap('gray')
    title(['template - ' num2str(f.TTL(j))]);ylabel('Trial'); xlabel('time [ms]');
    
end
Error_total = sum(Error);
%zero_count = length(find(TTLs == 0))
%idx_count = length(find(TTLs == 1)) + length(find(TTLs == 2))
%light = length(find(TTLs == 130))

end

