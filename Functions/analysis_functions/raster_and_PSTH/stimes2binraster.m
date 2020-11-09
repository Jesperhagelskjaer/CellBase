function [C_high, C_low] = stimes2binraster(g,data)
%STIMES2BINRASTER   Calculate binraster from spike times.
%   BINRASTER = STIMES2BINRASTER(STIMES,TIME,DT,EV_WINDOWS,WINDOW_MARGIN)
%   calculates binrasters using spike times (STIMES) and time vector (TIME)
%   at a resolution of DT. Time window boundaries corresponding to the rows
%   of the binraster are specified by EV_WINDOWS. A margin of WINDOW_MARGIN
%   is added.
%
%   See also VIEWCELL2B and PLOT_RASTER2A.

%margin = g.sigma * 3;     % add an extra margin to the windows
%time   = g.window(1)-margin:g.dt:g.window(2)+margin;   % time base array
margin = g.sigma * g.sigma_ex;     % add an extra margin to the windows

edge_high  = g.window(1):0.001:g.window(2);
edge_low   = g.window(1)-margin-g.dt:g.dt:g.window(2)+margin+g.dt;   % time base array
C_high   = zeros(numel(data),numel(edge_high)-1);
C_low   = zeros(numel(data),numel(edge_low)-1);
for i = 1:numel(data)
    [C_high(i,:)]    = histcounts(data{i},edge_high)'; %(!)
    [C_low(i,:)]     = histcounts(data{i},edge_low)';  %(!)
end

end

