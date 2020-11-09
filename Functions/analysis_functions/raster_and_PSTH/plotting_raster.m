function plotting_raster(raster_high,spsth,g,label_str)

time   = g.window(1):g.dt:g.window(2);   % time base array
figure;
for i = 1:size(spsth,2)   
    mul    = (1:1:size(raster_high{i},2))';
    mul2   = 1:1:size(raster_high{i},1);
    holder = raster_high{i}.* mul2';
    holder(holder == 0) = nan; %if nan they will not be plotted
    subplot(size(spsth,2)+1,1,i);
    plot(mul,holder,'|k','MarkerSize',0.5)
    ylim([-1 size(holder,1)+1])
    xlim([0 size(holder,2)])
    set(gca,'xtick',[])
    title(label_str{i})
end

subplot(size(spsth,2)+1,1,size(spsth,2)+1);
plot(time,spsth)
ylabel('Rate (Hz)')
xlabel('Time [s]')
legend(label_str)
end

