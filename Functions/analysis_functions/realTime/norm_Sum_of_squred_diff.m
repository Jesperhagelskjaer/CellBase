function [NSSD,result] = norm_Sum_of_squred_diff(template_RT,Templates_on)

global f

for i = 1:size(Templates_on,3)
    template = Templates_on(:,:,i);
    T_n = size(template,1);
    
    for k = 1:size(template_RT,1)-T_n
        
        sgn = template_RT(1+k:T_n+k,:);
        
        top = sum(sum((sgn-template).^2));
        buttom = sqrt(sum(sum(sgn.^2)).*sum(sum(template.^2)));
        %buttom = sqrt(sum(sum(sgn)).^2*sum(sum(template)).^2) %check if this is the correct formula
        minV(k) = top/buttom;
        %top_t{i,j}(k) = top;
        
    end
    NSSD(i) = min(minV);
end

[~, index] = sort(NSSD);
result     = index(1:f.TT);

rgt             = f.xAxis_on(1):f.xAxis_on(2);
[minV]          = min(template_RT(:));
[idx_RT,~]      = find(template_RT == minV);
template_RT_cut = template_RT(rgt+idx_RT,:);

plotting_templates(template_RT_cut,Templates_on(:,:,result))

end