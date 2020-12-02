function [dataF,T] = loading_and_preprocessing(r,s)
global f

[fullNameNRD] = NRD_path(r,s);
for ch = 0:31
    fprintf('%d ',ch+1)
    [T, d, Header] = Nlx2MatNRD(fullNameNRD,ch,[1 1], 1, 1, [] );
    if ch == 0
        dataF = zeros(numel(d),32);
        cor_V          = str2double(Header{14,1}([13:end]))/1e-6;
    end    
    [d]            = filterButter(d);
    [d]            = bit2Volt(d,cor_V);
    [d]            = invertSignal(d,f.invert);
    dataF(:,ch+1)  = single(d);  
end

if f.median_filter
    dataF = dataF - median(dataF,2);
end

end

