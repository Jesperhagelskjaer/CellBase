function [] = plotting_templates(template_RT,Templates,chs)

global f

if f.plotting
    if nargin < 3
        chs = 1:32;
        [w, h] = deal(6);
    else
        [h] = deal(ceil(numel(chs)/2));%+1;
        [w] = deal(ceil(numel(chs)/2));
    end
    legend_name{f.TT + 1} = 'RT';
    for tt = 1:f.TT
        legend_name{tt} = ['cl -', num2str(tt)];
    end
    
    max_V = max([template_RT(:);Templates(:)]);
    min_V = min([template_RT(:);Templates(:)]);
    
    figure
    for ch = 1:numel(chs)
        subplot(h,w,ch)
        hold on
        for tt = 1:f.TT
            plot(Templates(:,chs(ch),tt))
            xlabel('samples') 
        end
        plot(template_RT(:,chs(ch)),'*')
        title(['Ch - ',num2str(chs(ch))])
        ylim([min_V max_V])
        legend(legend_name)
        if f.useBitmVolt
            ylabel('Amplitude [volts]')
        else
            ylabel('Amplitude [bits]')
        end
    end
end

end


