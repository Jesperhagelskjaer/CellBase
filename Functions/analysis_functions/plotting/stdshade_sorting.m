function stdshade_sorting(amatrix,acolor,alpha,F,smth,factor)
% usage: stdshading(amatrix,alpha,acolor,F,smth)
% plot mean and sem/std coming from a matrix of data, at which each row is an
% observation. sem/std is shown as shading.
% - acolor defines the used color (default is red) 
% - F assignes the used x axis (default is steps of 1).
% - alpha defines transparency of the shading (default is no shading and black mean line)
% - smth defines the smoothing factor (default is no smooth)
% JH 2020/28/23

if exist('acolor','var')==0 
    acolor='r'; 
end

if exist('alpha','var')==0   || isempty(alpha)
    alpha = 0.5; 
end

if exist('F','var')==0       || isempty(F)
    F = 1:size(amatrix,1);
end

if exist('smth','var')== 0   || isempty(smth)
    smth = 1; 
end  

if exist('factor','var')== 0 || isempty(factor)
    factor = 1; 
end  


amean = smooth(mean(amatrix,2),smth)';
astd  = (std(amatrix,[],2)*factor)'; % to get std shading
 
fill([F fliplr(F)],[amean+astd fliplr(amean-astd)],acolor,'facealpha',alpha,'linestyle','none');
hold on;
plot(F,amean,acolor,'linewidth',1.5); %% change color or linewidth to adjust mean line

end
