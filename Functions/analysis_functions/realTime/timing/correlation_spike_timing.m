function [] = correlation_spike_timing()


jitter = par.jitter;
for i_path = 1:size(par.path,1)
    for bd = 1:length(par.chs{2})
        bd_idx = par.chs{2}(bd);
        

       any(strcmp(par.VS,'js'))
            t_c = datum.tS_js_cor{i_path}(bd_idx,:);
            t_c(cellfun('isempty', t_c)) = [];
            T_cor = datum.TW_js_cor{i_path}(bd_idx,:);
            T_cor(cellfun('isempty', T_cor)) = [];
        else
            fprintf('\n\n No MClust data or JSearch data\n\n')
        end
        
        t_DS_c = datum.tS_ds_cor{i_path}(bd_idx,:);
        t_DS_c(cellfun('isempty', t_DS_c)) = [];
        
        TW_ds_cor = datum.TW_ds_cor{i_path}(bd_idx,:);
        TW_ds_cor(cellfun('isempty', TW_ds_cor)) = [];
        
        if (isempty(t_c) || isempty(t_DS_c))
            continue
        end
        
        %% In agreement
        CN_NSI_MC_h    = []; %not seen in any of the MCust template
        CN_A_DS_h      = {}; %clusterholderT
        CW_A_h         = {};
        t_A_h          = {};
        CN_A_h         = {};
        t_NSI_MC_h     = {};
        CW_NSI_MS_h    = {};
        for i = 1:size(t_DS_c,2) 
            c = 0;
            c_A = 0;
            
            t_DS = t_DS_c{i};
            CN_A_DS = [];TW_A = [];TW_NSI_MC = [];t_A = []; t_NSI_MC = [];
            for ii = 1:length(t_DS)
                bool = 1;
                for MC = 1:size(t_c,2) %cluster in MClust/JSearch
                    
                    t_MC = t_c{MC};% + par.time_Shift;
                    index = floor(find(t_DS(ii)- jitter < t_MC  & t_DS(ii) + jitter > t_MC));
                    if ~isempty(index)
                        c_A = c_A + 1;          %Total number of the template is found 
                        CN_A_DS = [CN_A_DS MC]; %the cluster number in agreement
                        TW_A = cat(3,TW_A,TW_ds_cor{i}(:,:,ii)); %the waveform in agreement
                        t_A  = [t_A t_DS(ii)]; %the timeindex in agreement
                        bool = 0;
                    end
                end
                if bool %if there is no spikes in MCLust there is in agreement is must be NSI_MC varaiable
                    c            = c + 1; %count the total number of NSI_MC for each cluster
                    t_NSI_MC     = [t_NSI_MC t_DS(ii)]; %the time index for the NSI_MC
                    TW_NSI_MC    = cat(3,TW_NSI_MC,TW_ds_cor{i}(:,:,ii)); %the waveform NSI_MClust 
                end
            end
            CN_NSI_MC_h(i)    = c;          %not seen in any of the motehod template
            CN_A_DS_h{i}      = CN_A_DS;    %clusterholderT
            CW_A_h{i}         = TW_A;       %the waveform in agreement
            t_A_h{i}          = t_A;
            CN_A_h{i}         = c_A;
            t_NSI_MC_h{i}     = t_NSI_MC;
            CW_NSI_MS_h{i}    = TW_NSI_MC;
        end
        CN_NSI_DS_h       = {};CN_A_MC_h= {};CW_NSI_DS_h = {}; t_NSI_DS_h        = {};
        
        for i = 1:size(t_c,2) 
            c = 0;
            t_ms = t_c{i};% + par.time_Shift;
            CW_NSI_DS = [];t_NSI_DS = [];CN_A_MC = [];
            for ii = 1:length(t_ms)
                %clusterSeen_MC = [];
                bool = 1;
                for MC = 1:size(t_DS_c,2)
                    
                    t_ds = t_DS_c{MC};
                    index = floor(find(t_ms(ii)- jitter < t_ds  & t_ms(ii) + jitter > t_ds));
                    if ~isempty(index)
                        CN_A_MC = [CN_A_MC MC];
                        bool = 0;
                    end
                end
                if bool
                    c = c + 1;
                    t_NSI_DS     = [t_NSI_DS t_ms(ii)];
                    try
                    CW_NSI_DS  = cat(3,CW_NSI_DS,T_cor{i}(:,:,ii));
                    catch
                    end
                end
                
            end
            CN_NSI_DS_h{i}       = c;
            CN_A_MC_h{i}         = CN_A_MC;
            CW_NSI_DS_h{i}       = CW_NSI_DS;
            t_NSI_DS_h{i}        = t_NSI_DS;
        end
        
        mid.TW_A         = CW_A_h;      %the waveform in agreement
        mid.TW_NSI_ds    = CW_NSI_DS_h;
        mid.TW_NSI_ms    = CW_NSI_MS_h;
        mid.S_TT_A       = CN_A_h;
        mid.S_TT_NSI_mc  = CN_NSI_MC_h;
        mid.S_TT_NSI_ds  = CN_NSI_DS_h;
        mid.tS_A         = t_A_h;
        mid.tS_NSI_ds    = t_NSI_DS_h;
        mid.tS_NSI_mc    = t_NSI_MC_h;
        mid.cn_ds        = CN_A_DS_h;
        mid.cn_mc        = CN_A_MC_h;
        
        [datum] = table_confusion(par,datum,mid,bd_idx,i_path);
        [datum] = table_NCC(par,datum,mid,bd_idx,i_path);
        %[datum] = table_NSSD(par,datum,mid,bd_idx);
    end
    
end

%extraCheckTime(par,rez,datum,4);



