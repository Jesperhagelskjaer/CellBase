function [varargout] = choice_and_reward(cellid,varargin)

%add_analysis(@choice_and_reward,1,'property_names',{'CH','RH','Indices_to_erase'})
%add_analysis(@choice_and_reward,1,'property_names',{'CH','RH','Indices_to_erase'},'arglist',{'cells',[1 15 30 45 50]});
%add_analysis(@choice_and_reward,0,'property_names',{'CH','RH'},'arglist',{'cells',{'D:\recording'})

%delanalysis(@choice_and_reward)

% created (JH) 2020-07-20

persistent f
global CELLIDLIST

method       = varargin{1};

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~] = cellid2tags(cellid);
idx_neuron = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
if idx_neuron > 1
    cellid_2    = CELLIDLIST(idx_neuron-1);
    [r2,s2,~,~] = cellid2tags(cellid_2{1});
else
    r2 = '';s2 = '';
end

directory = fullfile(f.path,r,s);
number_files = size(dir([directory, '\' '*FreeChoiceDyn*']),1);

if number_files == 1 %if multiple behavior files is not possible to find out which one to take
    if ~(strcmp(r,r2) && strcmp(s,s2))
        TE = loadcb(cellid,'TrialEvents');
        [RH, CH, Indices_to_erase] = Collect_Reward_Choice_History(TE);
        varargout{1}.RH               = single(RH);
        varargout{1}.CH               = single(CH);
        varargout{1}.Indices_to_erase = single(Indices_to_erase);
    else
        varargout{1}.RH               = [];
        varargout{1}.CH               = [];
        varargout{1}.Indices_to_erase = [];
    end
else
    varargout{1}.RH               = nan;
    varargout{1}.CH               = nan;
    varargout{1}.Indices_to_erase = nan;
end


