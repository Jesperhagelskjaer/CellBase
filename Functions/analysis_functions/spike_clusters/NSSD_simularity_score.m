function [score] = NSSD_simularity_score(cellid,path,rez_name)
%addanalysis(@NSSD_simularity_score,'property_names',{'score'},'mandatory',{'D:/recording','rezFinalK'})

prs = inputParser;
addRequired(prs,'cellid',@iscellid) % cell ID
addRequired(prs,'path',@ischar)   % path to the data
addRequired(prs,'rez_name',@ischar)   % path to the data
parse(prs,cellid,path,rez_name)

path     = prs.Results.path;

[r,s,tetrode,neuron] = cellid2tags(prs.Results.cellid);
name = strcat('TT',num2str(tetrode),'_',num2str(neuron),'.mat');
full_path = fullfile(path,r,s,name);
load(full_path,'tSpikes');
TT_spikes = length(tSpikes);

fullfile_rez = fullfile(path,r,s,prs.Results.rez_name);
load(fullfile_rez);

thl = tabulate(rez.st(:,8));
All_templates = rez.M_template(:,:,:);
template_in_idx   = find(thl(:,2) ==  TT_spikes);
template_in = All_templates(:,:,template_in_idx);
template_in = double(template_in(:));
score = -1;
for i = 1:size(All_templates,3)
    if i == template_in_idx
        continue
    end
    template_ref = double(All_templates(:,:,i));
    template_ref = [zeros(20,1); template_ref(:); zeros(20,1)];
    NCCScore = max(max(normxcorr2_mex(template_in,template_ref)));
    %R = corr2(template_in,All_templates(:,:,i))
    if NCCScore > score
        score = NCCScore;
    end
end
end

