function [data] = creating_data_sets(lgt,type)

if strcmpi(type,'gaussian')  
    data = normrnd(0,1,[1,lgt]);
elseif strcmpi(type,'randomWalk_gassian')
    data = normrnd(0,1,[1,lgt]);
    data = cumsum(data);
elseif strcmpi(type,'topHat')
   data = -1 + (1+1)*rand(lgt,1);

end


end

