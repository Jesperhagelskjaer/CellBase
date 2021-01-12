function [NSSD,result] = norm_Sum_of_squred_diff(temp,Templates)

global f
range = 1:size(temp,1)-3;
for i = 1:size(Templates,3)
    template = Templates(2:end-2,:,i);
    
    for k = 0:3
        range_t = range + k;
        sgn = temp(range_t,:);
        
        top = sum(sum((sgn-template).^2));
        buttom = sqrt(sum(sum(sgn.^2)).*sum(sum(template.^2)));
        %buttom = sqrt(sum(sum(sgn)).^2*sum(sum(template)).^2) %check if this is the correct formula
        minV(k+1) = top/buttom;
        %top_t{i,j}(k) = top;
        
    end
    NSSD(i) = min(minV);
end

[~, index] = sort(NSSD);
result     = index(1:f.TT);

plotting_templates(temp,Templates(:,:,result),'ref')

end