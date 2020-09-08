function [varargout] = NSSD_simularity_score(cellid,varargin)
%add_analysis(@NSSD_simularity_score,1,'property_names',{'score'})

%delanalysis(@NSSD_simularity_score)

persistent f

method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'name','rezFinalK',@ischar)   % path to the data
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

path     = f.path;

[r,s,tetrode,neuron] = cellid2tags(cellid);                      %  (!)
name = strcat('TT',num2str(tetrode),'_',num2str(neuron),'.mat');
full_path = fullfile(path,r,s,name);
load(full_path,'tSpikes');
TT_spikes = length(tSpikes);

load(fullfile(path,r,s,f.name));

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
    
    if NCCScore > score
        score = NCCScore;
    end
end

varargout{1}.score = score;


end

