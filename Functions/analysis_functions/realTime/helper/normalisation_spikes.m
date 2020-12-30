function [data] = normalisation_spikes(shiftMatrix)

data = zeros(size(shiftMatrix,1),size(shiftMatrix,2),size(shiftMatrix,3));

for i = 1:size(shiftMatrix,3)
    norm_area   = trapz(abs(shiftMatrix(:,:,i)),2);
    data(:,:,i) = shiftMatrix(:,:,i)./norm_area;
end

end

