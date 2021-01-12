function [chs,score_com] = last_resort(explained,chs,score_com)

if isempty(chs)
    threshold = 0.03;
    while 1
        threshold = threshold - 0.005;
        for i = chs_start
            if sum(explained(end-17:end,i),1) > threshold
                score_com = [score_com score2{i}];
                chs       = [chs i];
            end
        end
        if ~isempty(chs)
            break
        end
    end
end
end



