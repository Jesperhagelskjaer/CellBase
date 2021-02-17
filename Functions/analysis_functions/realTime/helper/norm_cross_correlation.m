function [value,Idx] = norm_cross_correlation(template,Templates)

global f

template = template(2:end-1,:);
value = zeros(size(Templates,3),1);
for i = 1:size(Templates,3)
    
    value(i) = max(normxcorr2_mex(double(template),double(Templates(:,:,i)),'valid'));
    
end
Idx = [];
if exist('f.TT','var')
    [value, idx] = sort(value,'descend');
    Idx          = idx(1:f.TT);
end

end

