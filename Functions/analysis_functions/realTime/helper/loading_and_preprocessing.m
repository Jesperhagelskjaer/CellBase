function [dataF,T] = loading_and_preprocessing(r,s,method)

global f


for ch = 0:31
    fprintf('%d ',ch+1)
    if strcmp(method,'nrd')
        [fullNameNRD]  = NRD_path(r,s);
        [T, d, Header] = Nlx2MatNRD(fullNameNRD,ch,[1 1], 1, 1, [] );
    elseif strcmp(method,'epysh')
        [filename]  = CSC_path(r,s);
        filename = fullfile(filename,sprintf('100_CH%d.continuous',ch+1));
        [d, T, info] = load_open_ephys_data_faster(filename);
    end
        
    if ch == 0
        dataF = zeros(numel(d),32,'single');
        if strcmp(method,'nrd')
            cor_V          = str2double(Header{14,1}([13:end]))/1e-6;
        elseif strcmp(method,'epysh') 
            cor_V = info.header.bitVolts;
        end
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

