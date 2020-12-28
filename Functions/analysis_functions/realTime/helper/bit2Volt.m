function [data] = bit2Volt(data,value)

global f

if f.useBitmVolt
    data = data*value;   
end
    
end

