function [d] = invertSignal(d)

global f

if f.invert
    d = d * -1;
end

end

