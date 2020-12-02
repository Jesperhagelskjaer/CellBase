function [] = plot_PCA_space(score,c)

figure
hold on
for cl = 1:c(end)
    idx = c == cl;
    lgd_scat{cl} = ['cl - ',num2str(cl)];
    plot3(score(idx,1),score(idx,2),score(idx,3),'o','MarkerSize',4)
end
lgd_scat{c(end)} = 'RT'; %overwrite the last one since this the real-time cluster
legend(lgd_scat)
end

