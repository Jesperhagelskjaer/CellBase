function [template,Templates] = spline_template(template,Templates)

global f

if f.spline 
    template  = spline(1:size(template,1),template',1:0.25:size(template,1))';
    for i = 1:size(Templates,3)
        holder(:,:,i) = spline(1:size(Templates,1),Templates(:,:,i)',1:0.25:size(Templates,1))';
    end
    Templates = holder;
end

end

