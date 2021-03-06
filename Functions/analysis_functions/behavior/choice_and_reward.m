function [varargout] = choice_and_reward(cellid,varargin)

%   Examples:
%add_analysis(@choice_and_reward,1,'property_names',{'CH','RH','NRH','Indices_to_erase'})
%add_analysis(@choice_and_reward,1,'property_names',{'CH','RH',NRH,'Indices_to_erase'},'arglist',{'cells',[1 15 30 45 50]});
%add_analysis(@choice_and_reward,0,'property_names',{'CH','RH','NRH'},'arglist',{})
%add_analysis(@choice_and_reward,0,'property_names',{'Indices_to_erase'})

%delanalysis(@choice_and_reward)

% created (JH) 2020-07-20

global CELLIDLIST

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    parse(prs,varargin{:})
       
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

[RH, NRH, CH, Indices_to_erase] = deal([]);
if POS(1) == idx
    TE                              = loadcb(cellid,'TrialEvents');
    [RH, CH, NRH, Indices_to_erase] = Collect_Reward_Choice_History(TE);
end

varargout{1}.RH               = RH;
varargout{1}.CH               = CH;
varargout{1}.NRH              = NRH;
varargout{1}.Indices_to_erase = Indices_to_erase;
end

