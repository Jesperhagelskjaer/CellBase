function [varargout] = CCG(cellid,varargin)

% add_analysis(@CCG,1,'property_names',{'Pvalue'},'arglist',{'data',{'C','R','NR' }})
% add_analysis(@CCG,0,'property_names',{'Pvalue_KS','Pvalue_W','spike_transmission'},'arglist',{'data',{'C','R','NR' }})
% delanalysis(@CCG)
global TheMatrix
global CELLIDLIST
persistent f
method       = varargin{1};
if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'event_EXIT','CenterPortExit',@isschar)
    addParameter(prs,'event_ENTRY','CenterPortEntry',@isschar)
    addParameter(prs,'data',{'R','NR'}) %(!)
    addParameter(prs,'trials',11,@(x) isscalar(x) && x > 0)%(!)
    addParameter(prs,'spikes',50, @(x) isscalar(x) && x > 0)
    addParameter(prs,'pvalue',0.05,@(x) isscalar(x) && x > 0)
    addParameter(prs,'display',false,@(s)islogical(s)|ismember(s,[0 1]))
    addParameter(prs,'resolution',1,@(x) isscalar(x) && x > 0)
    addParameter(prs,'interval',[10 10]) 
    if any(strcmpi(method,'Pvalue_KS')) || any(strcmpi(method,'Pvalue_W'))
        addParameter(prs,'p_interval',[0 5])
    end
     
    if any(strcmpi(method,'spike_transmission'))
        addParameter(prs,'factor',3,@(x) isscalar(x) && x > 0)
        addParameter(prs,'st_interval',[10 10]) %ms
    end
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    
    % checking if the necessary data already exist in the "TheMatrix"
    checking_freq();
    checking_indices_to_erase();
    return
end
[Pvalue_W,Pvalue_KS,] = deal(nan);
spike_transmission{1} = nan;
Idx = find(TheMatrix{findcellstr(CELLIDLIST',cellid),findanalysis('validation')});
if any(Idx)
    [r,s,~,~]  = cellid2tags(cellid);
    POS        = findcellpos('animal',r,'session',s); %(!) find faster method
    idx        = findcellstr(CELLIDLIST',cellid); % CELLIDLIST must be column vector
    remove_index = TheMatrix{POS(1),findanalysis('Indices_to_erase')};
    data = [];
    for i = 1:numel(f.data)
        switch f.data{i}
            case 'C'
                C  = TheMatrix{POS(1),findanalysis('C_trial')};
                C(:,end-(size(C,2) - f.trials)+1:end) = [];
                data = [data C == -1 C == 1];
            case 'R'
                R  = TheMatrix{POS(1),findanalysis('R_trial')};
                R(:,end-(size(R,2) - f.trials)+1:end) = [];
                data  = [data R == -1 R == 1];   %R_right
            case 'NR'
                NR = TheMatrix{POS(1),findanalysis('NR_trial')};
                NR(:,end-(size(NR,2) - f.trials)+1:end) = [];
                data  = [data NR == -1 NR == 1]; %no_reward
        end
    end
    data(:,1:11)  = [];
    Idx(Idx < 12) = [];
    Idx = Idx - 11;
    [Pvalue_W,Pvalue_KS] = deal(nan(numel(POS),numel(Idx)));
    [spike_transmission{1:numel(POS),1:numel(Idx)}] = deal(NaN);
    for j = 1:numel(Idx)
        idx_event = logical(data(:,Idx(j)));
        
        EVSpikes            = loadcb(cellid,'EventSpikes');
        times               = EVSpikes.event_stimes{1};
        times(remove_index) = [];
        x1                  = times(idx_event);
        x0                  = times(~idx_event);
        
        
        for m = 1:numel(POS)
            
            if ~strcmp(cellid,CELLIDLIST(POS(m))) && POS(m) > idx
                EVSpikes            = loadcb(CELLIDLIST(POS(m)),'EventSpikes');
                times               = EVSpikes.event_stimes{1};
                times(remove_index) = [];
                y1                  = times(idx_event);
                y0                  = times(~idx_event);
                
                data1   = calc_ccg(x1,y1,f);
                data0   = calc_ccg(x0,y0,f);
                c1      = data1/sum(data1);                        %normalisation
                c0      = data0/sum(data0);                        %normalisation
                
                
                if sum(data0) > f.spikes && sum(data1) > f.spikes
                    [~, Pvalue_KS(m,j)] = kstest2(c1,c0,'Alpha',f.pvalue); %testing for difference in shape of distribution
                    Pvalue_W(m,j)       = signrank(c1,c0,'Alpha',f.pvalue);
                    if f.display
                        if Pvalue_KS(m) < f.pvalue
                            range1 = ((-f.interval(1))+0.5):f.resolution:f.interval(2)-0.5;
                            figure
                            subplot(2,1,1)
                            bar(range1,c1)
                            title('1')
                            subplot(2,1,2)
                            bar(range1,c0)
                            title('0')
                            %close all
                        end
                    end
                    if any(strcmpi(method,'spike_transmission'))
                        idx1 = f.interval(1)-f.st_interval(1)+1;
                        idx2 = f.st_interval(1)+f.interval(1)-f.st_interval(1);
                        b0_std = f.factor*std(data0(idx1:idx2));
                        b1_std = f.factor*std(data1(idx1:idx2));
                        b0_ave = mean(data0(idx1:idx2));
                        b1_ave = mean(data1(idx1:idx2));
                        
                        idx1 = f.interval(1)+1;
                        idx2 = f.interval(1)+f.st_interval(1);
                        h0 = (b0_ave - b0_std > data0(idx1:idx2) | b0_ave + b0_std < data0(idx1:idx2));
                        h1 = (b1_ave - b1_std > data1(idx1:idx2) | b1_ave + b1_std < data1(idx1:idx2));
                        spike_transmission{m,j} = [h0; h1];
                    end
                end
            end
        end
    end
end

varargout{1}.Pvalue_KS          = Pvalue_KS;
varargout{1}.Pvalue_W           = Pvalue_W;
varargout{1}.spike_transmission = spike_transmission;
end




