function [spsth, conv_psth] = smoothed_psth(psth,g)
%SMOOTHED_PSTH   Smoothed PSTH.
%   [SPSTH, CONV_PSTH] = SMOOTHED_PSTH(PSTH,DT,SIGMA) calculates smoothed
%   PSTH (SPSTH) from PSTH at time resolution DT. SIGMA determines the
%   smoothing Kernel (3*SIGMA wide). Filtered PSTH without normalization is
%   returned in CONV_PSTH.
%
%   See also BINRASTER2PSTH.

%   Edit log: BH 6/23/11

% Make smoothed PSTH
if g.sigma > 0
    kernel_time = -g.sigma_ex*g.sigma:g.dt:g.sigma_ex*g.sigma;      % 3 sigma wide
    kernel = normpdf(kernel_time,0,g.sigma);       % define smoothing kernel
    conv_psth = conv(psth,kernel);               % convolve filter and psth
    
    steps = length(kernel);                     % the next 4 lines make sure to clip the ends of the convolved array correctly.
    first = floor(steps/2) + mod(steps,2);        % there is an issue with rounding if dt is too close to sigma
    last = length(conv_psth) - floor(steps/2);
    spsth = conv_psth(first:last);              
    
    spsth = spsth / sum(kernel);  % normalize by kernel area and dt
else
    spsth = psth;
    conv_psth = psth;
end