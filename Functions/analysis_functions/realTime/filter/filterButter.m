function [data_filterede] = filterButter(data_filterede)

global f
    
if f.filter
        
    [b1, a1] = butter(f.order, [f.fshigh/f.fs,f.fsslow/f.fs]*2,f.type);
    data_filterede = filter(b1, a1, data_filterede);
    
    if (f.direction   == 2)
        data_filterede = flipud(data_filterede);
        %Backward filtering using butterworth coefficient
        data_filterede = filter(b1, a1, data_filterede);
        data_filterede = flipud(data_filterede);
    elseif (f.direction > 2)
        fprintf('Error in filtering passes - function paused')
        pause();    
    end   
end

end

