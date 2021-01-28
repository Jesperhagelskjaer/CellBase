function [varargout] = compare_Dsort_MCLUST(cellid,varargin)

%in
%add_analysis(@compare_Dsort_MCLUST,0,'property_names',{'test'},'arglist',{});
%add_analysis(@compare_Dsort_MCLUST,1,'property_names',{'test'},'arglist',{'cells',[614:650]});
%add_analysis(@compare_Dsort_MCLUST,1,'property_names',{});

%delanalysis(@compare_Dsort_MCLUST)
global f

if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    prs          = inputParser;
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'plotting',1)          % plot the data
    addParameter(prs,'rezName','rezfinalK') % name of the rez file
    addParameter(prs,'type','bandpass')   % filtering
    addParameter(prs,'direction',2)       % 1 -> forward, 2 -> forward and backswards
    addParameter(prs,'filter',1)          % filtering
    addParameter(prs,'fsslow',8000)       % filtering
    addParameter(prs,'fshigh',300)        % filtering
    addParameter(prs,'fs',30000) %        % the recording system hertz
    addParameter(prs,'order',3) %         % the order of the filter
    addParameter(prs,'useBitmVolt',1)     % converts from bits to volts
    addParameter(prs,'xAxis',[-15 15])    % The range to cut for the template building
    addParameter(prs,'invert',0)          % Invert the electrical signal
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~]  = cellid2tags(cellid);
idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
POS        = findcellpos('animal',r,'session',s);

if POS(1) == idx || all(size(dataOld) == 0) 
    [dataF,timestamps] = loading_and_preprocessing(r,s,'ephys');
end

[Templates,tSpikes,W_Spikes] = template_dsort(dataF);

[TSpikes_mc] = loadMClust(t_start);

varargout{1}.test = 1;

end

