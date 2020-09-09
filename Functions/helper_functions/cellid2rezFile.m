function [varargout] = cellid2rezFile(cellid,varargin)

%add_analysis(@cellid2rezFile,1,'property_names',{'ID'},'arglist',{'name','rezFinalK'})

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

[r,s,tetrode,neuron] = cellid2tags(cellid);
name = strcat('TT',num2str(tetrode),'_',num2str(neuron),'.mat');
load(fullfile(path,r,s,name),'tSpikes');
TT_spikes = length(tSpikes);

load(fullfile(path,r,s,f.name));

thl = tabulate(rez.st(:,8));
template_in_idx   = find(thl(:,2) ==  TT_spikes);
ID = [];

if (size(template_in_idx,1) == 1) %if only one neuron have the same number of spikes
    ID = template_in_idx;
else
    for j = 1:size(template_in_idx,1)
        ch = rez.Chan{template_in_idx(j)};
        for i = 1:length(ch)
            if any(ch(i)== (1:4)*(tetrode+1))
                ID =  [ID template_in_idx(j)];
                break
            end
        end
    end
    if length(ID) > 1 %checking if there is still more than 1 ID there must be an error somewhere
        ID = nan;
    end
end

varargout{1}.ID = ID;

end

