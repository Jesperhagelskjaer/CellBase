function [shiftMatrix_M] = spike_alignment(X,chs)

global f

if nargin == 1
    chs = 1:32;
end

if f.spline
    rg = (abs(f.xAxis(1))-3)*4:(abs(f.xAxis(1))+3)*4;
end

if strcmp(f.alignment,'min')
    %find the index which to align each channel with different minimum pr.
    center = 200;
    % Create the matrix for the shifted traces
   
    shiftMatrix_M = [];
    for cl = 1:numel(X)
        data = X{cl};
        si = size(data,1)*4-4;  %(!)
        shiftMatrix = zeros(center*2,32,size(data,3));
        for i = 1:size(data,3)
            
            %Finds the mimimum value of the trace over the four channels
            if f.spline
                holder = spline(1:size(data(:,:,i),1),data(:,:,i)',1:0.25:size(data(:,:,i),1))'; %(!)
            else
                holder = data(:,chs,i);
            end
            
            [value,~] = min(min(holder(rg,chs)));
            [m, ~]    = find(holder == value);
            
            start = center - m(1); %(1) if is index more than one index having the value take the first value
            shiftMatrix(start:start+si,:,i) = holder;  %holder for the corrected traces
        end
        shiftMatrix_M = cat(3,shiftMatrix_M,shiftMatrix);
    end
end

%cutting out the non-excential part of the waveform
shiftMatrix_M = shiftMatrix_M(center+(f.PCA_cut(1):f.PCA_cut(2)),:,:);
end

