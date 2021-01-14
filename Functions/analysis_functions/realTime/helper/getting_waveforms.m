function [] = getting_waveforms(cellid,dataF,Timestamps)
global f
[r,s,~,~]        = cellid2tags(cellid);
fullNameEvent    = fullfile(getpref('cellbase','datapath'),r,s,'Events.nev');
[TTLs,TTLs_time] = loadEvent(fullNameEvent);
TTL_value        = unique(TTLs);
TTL_value        = TTL_value(ismember(TTL_value,f.TTL));


for j = TTL_value
    Ch = 1:32;
    [wSpikes_RT,template,~] = creating_templates_RT(dataF,Timestamps,TTLs_time,TTLs==j);
    
    if f.ch_validation
        
        shiftMatrix  = spike_alignment({wSpikes_RT},Ch);
        [PCA_matrix] = normalisation_spikes(shiftMatrix);
        [explained]  = deal(zeros(size(PCA_matrix,1),32));
        [ch]        = deal([]);
        
        [~,Explained] = random_template_noise(dataF,10000,100);
        for i = Ch
            [~,~,~,~,explained(:,i)] = pca(squeeze(PCA_matrix(:,i,:))');
        end
        for i = Ch 
            if sum(explained(end-17:end,i),1) > sum(Explained(end-17:end,i),1) || explained(1,i) > 70 
                ch       = [ch i];
            end
        end
        Ch = ch;
    end
    
    
    for ch = Ch
        data = squeeze(wSpikes_RT(:,ch,:));
        figure
        plot(data)
        title(['Ch - ',num2str(ch),' --- ','TTL - ',num2str(j)]);xlabel('Time'),ylabel('Voltage [uV]')
    end
    
end

if f.plotting
    for ch = 1:32
        figure
        plot(template(:,ch))
        title('mean template: ch - ',num2str(ch))
    end
end



end

