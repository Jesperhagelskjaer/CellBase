function [] = plot_PCA_space(score,c,cls,str)

global f

if isempty(cls)
    cls = 1:c(end);
end

figure
hold on
for cl = cls
    if isempty(cls)
        idx = c == cl;
        plot3(score(idx,1),score(idx,2),score(idx,3),'o','MarkerSize',4)
        lgd_scat{cl} = ['cl - ',num2str(cl)];
    else
        plot3(score(:,1),score(:,2),score(:,3),'o','MarkerSize',4)
        lgd_scat{1} = ['cl - ',num2str(cl)];
    end  
end

if f.TT + 1 == cls
    lgd_scat{1}     = 'RT';
elseif isempty(cls)
    lgd_scat{end+1} = 'RT';
end

xlabel('1-component');ylabel('2-component');zlabel('3-component');
view(50,50)
legend(lgd_scat)
title(str)
end

