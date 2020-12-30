function [waveforms_cut] = cutting_waveforms(Waveforms)

global f

waveforms_cut = {};
rgt           = f.PCA_cut(1):f.PCA_cut(2);
for i = 1:numel(Waveforms)
    waveforms          = Waveforms{i};
    Template_mean      = mean(waveforms,3);         
    [value]            = min(Template_mean(:));
    [idx_t, ~]         = find(Template_mean == value);
    waveforms_cut{i}   = waveforms(rgt+idx_t,:,:);
end

end
