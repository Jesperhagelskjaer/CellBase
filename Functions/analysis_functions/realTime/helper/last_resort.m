function [chs,score_com] = last_resort(explained,chs,score_com,score2)


if isempty(chs)
    threshold = 0.03;
    while 1
        threshold = threshold - 0.005;
        for i = 1:numel(score2)
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



