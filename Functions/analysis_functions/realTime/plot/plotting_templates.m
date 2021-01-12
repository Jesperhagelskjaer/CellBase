function [] = plotting_templates(template,Templates,str,chs)

global f

if f.plotting
    if nargin < 4
        chs = 1:32;
        [w, h] = deal(6);
    else
        [h] = deal(ceil(numel(chs)/2));%+1;
        [w] = deal(ceil(numel(chs)/2));
    end
    legend_name{f.TT + 1} = str;
    for tt = 1:f.TT
        legend_name{tt} = ['cl -', num2str(tt)];
    end
    
    max_V = max([template(:);Templates(:)]);
    min_V = min([template(:);Templates(:)]);
    
    figure
    for ch = 1:numel(chs)
        subplot(h,w,ch)
        hold on
        for tt = 1:f.TT
            plot(Templates(:,chs(ch),tt))
            xlabel('samples') 
        end
        plot(template(:,chs(ch)),'*')
        title(['Ch - ',num2str(chs(ch))])
        ylim([min_V max_V])
        if ch == numel(chs)
            legend(legend_name)
        end
        if f.useBitmVolt
            ylabel('Amplitude [volts]')
        else
            ylabel('Amplitude [bits]')
        end
    end
end

end


