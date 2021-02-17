function [varargout] = calculations_based_on_rez(cellid,varargin)

%add_analysis(@calculations_based_on_rez,1,0,'property_names',{'NSSD','NCC'},'arglist',{});
%add_analysis(@calculations_based_on_rez,1,0,'property_names',{'NSSD','NCC'},'arglist',{'cells',[150]});
%delanalysis(@calculations_based_on_rez)
global f
global CELLIDLIST

if (cellid == 0)
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'NCC',1)  % Which method to compare [NCC/NSSD]
    addParameter(prs,'NSSD',1)  % Which method to compare [NCC/NSSD]
    addParameter(prs,'rezfinal','rezFinal')  % Which method to compare [NCC/NSSD]
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
load(fullfile(getpref('cellbase','datapath'),r,s,strcat(f.rezfinal,'.mat')));

idx                = find(findcellpos('animal',r,'session',s) == findcellstr(CELLIDLIST',cellid));
Templates          = rez.M_template;
template           = Templates(:,:,idx);
Templates(:,:,idx) = nan;        %removing the main template

[NSSD,NCC] = deal([]);
if f.NCC
    [NSSD,~] = norm_Sum_of_squred_diff(template,Templates); %(!use channels from The PCA analysis)
end
if f.NSSD
    [NCC,~]  = norm_cross_correlation(template,Templates);
end


varargout{1}.NSSD = NSSD;
varargout{1}.NCC  = NCC;
end

