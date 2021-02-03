function stdshade_sorting(amatrix,acolor,alpha,F,smth,factor,amatrix_SD)
% usage: stdshading(amatrix,alpha,acolor,F,smth)
% plot mean and sem/std coming from a matrix of data, at which each row is an
% observation. sem/std is shown as shading.
% - acolor defines the used color (default is red) 
% - F assignes the used x axis (default is steps of 1).
% - alpha defines transparency of the shading (default is no shading and black mean line)
% - smth defines the smoothing factor (default is no smooth)
% JH 2020/28/23

%NB exist('acolor','var')==0 could be made in tilde exist
if exist('acolor','var')==0 || isempty(acolor)
    acolor='r'; 
end

if exist('alpha','var')==0   || isempty(alpha)
    alpha = 0.5; 
end

if exist('F','var')==0       || isempty(F)
    F = (1:size(amatrix,1))';
end

if exist('smth','var')== 0   || isempty(smth)
    smth = 1; 
end  

if exist('factor','var')== 0 || isempty(factor)
    factor = 1; 
end  

if size(amatrix,2) == 1 && ~isempty(amatrix_SD)
    amean = amatrix;
    astd  = amatrix_SD; % to get std shading
elseif size(amatrix,2) == 1 && isempty(amatrix_SD)
    amean = amatrix;
    astd  = zeros(numel(amatrix),1); % to get std shading
else
    amean = smooth(mean(amatrix,2),smth);
    astd  = std(amatrix,[],2)*factor; % to get std shading
end

fill([F; flip(F)],[amean+astd; flip(amean-astd)],acolor,'facealpha',alpha,'linestyle','none');
hold on;
plot(F,amean,'color',acolor,'linewidth',1.5); %% change color or linewidth to adjust mean line

end
