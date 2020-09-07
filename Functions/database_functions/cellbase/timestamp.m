function [ts] = timestamp

c = clock;
ts = sprintf('%d/%d/%d %.2d:%.2d',c(2),c(3),c(1),c(4),c(5));

end


