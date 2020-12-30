function [time_error] = raster_stimulation(TTLs,TTLs_time)

global f

time_error = {};
for j = 1:numel(f.TTL)
    
    time_neuron = TTLs_time(logical(TTLs == f.TTL(j)));
    time        = TTLs_time(find(TTLs == f.TTL_light));
    time_b      = time - f.backwards;
    time_f      = time + f.forwards;
    [value]     = deal([]);
    
    for i = 1:length(time)
        neuron_within = time_neuron(time_neuron >= time_b(i) & time_neuron <= time_f(i));
        if f.TTL(j) == 2
            if ~isempty(neuron_within)
                %test(end+1) = neuron_within]; %be carefull here, recheck
                value(end+1)       = (neuron_within(end) - time(i))/1000;
            else    %and error in the internal TTL, a check in the TTL is made to see if value can be used
                try %since no check for "out of bounce" a try statement is used
                    value(end+1) = ((TTLs_time(idx_light(i)) - TTLs_time(idx_light(i)+2))/1000+1.033); %the light pulse is 1.033 ms
                catch
                end
            end
        else
            if ~isempty(neuron_within)
                value(end+1)  = (neuron_within(end) - time(i))/1000;
            end
        end
        
    end
    
    %use for figure in article
    
    edges = -f.backwards/1000:100/1000:f.forwards/1000;
    SpikeRaster2 = zeros(numel(value),numel(edges));
    %calculate raster and PETH
    for iTrial = 1:length(value)
        SpikeRaster2(iTrial,:) = histc(value(iTrial),edges);
    end
    
    figure
    imagesc(-SpikeRaster2,'XData',edges)
    colormap('gray')
    title(['template - ' num2str(f.TTL(j))]);ylabel('Trial'); xlabel('time [ms]');
    
end

%zero_count = length(find(TTLs == 0))
%idx_count = length(find(TTLs == 1)) + length(find(TTLs == 2))
%light = length(find(TTLs == 130))

end

