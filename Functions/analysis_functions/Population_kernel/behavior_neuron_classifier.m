function [varargout] = behavior_neuron_classifier(cellid,varargin)
% NOTE!!!!!!!!!!!!!!
% The trial input - both in reward, and no_reward, both the left and right side is used.
% This will in make the trial_input collinear leading to that the coefficients is not-directly related to
% the firing of the neuron for the given trial input. (This have been made after
% the wish of Duda Kvitsiani).
%
% Example:
% add_analysis(@behavior_neuron_classifier,1,'property_names',{'F1_score_macro','idx_trial'},'arglist',{})
% add_analysis(@behavior_neuron_classifier,0,'property_names',{'F1_score_macro','idx_trial'},'arglist',{})
% delanalysis(@behavior_neuron_classifier)
%
% created (JH) 2020-07-20

global TheMatrix
global CELLIDLIST
global f

method       = varargin{1};

if (cellid == 0)
    
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    addParameter(prs,'data',{'reward','no_reward'})
    addParameter(prs,'ref',1,@(x) x == true || x == false)
    addParameter(prs,'trials',11,@(x) x > 0)
    
    parse(prs,varargin{:})
    
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

idx_neuron = findcellstr(CELLIDLIST',cellid);
[r,s,~,~] = cellid2tags(cellid);
POS = findcellpos('animal',r,'session',s); %(!) find faster method

Idx2 = findanalysis('Indices_to_erase');
if ~all(Idx2)
    fprintf("addanalysis(@choice_and_reward,1,'property_names',{'CH','RH','Indices_to_erase'})\n")
else
    remove_index = TheMatrix{POS(1),Idx2};
end

if ~isnan(remove_index)
    
    Idx1 = findanalysis(@history_reward_choice);
    if ~all(Idx1)
        fprintf("addanalysis(@history_reward_choice,1,'property_names',{'R_trial','C_trial'})\n")
    else
        R  = TheMatrix{POS(1),findanalysis('R_trial')};
        C  = TheMatrix{POS(1),findanalysis('C_trial')};
        NR = TheMatrix{POS(1),findanalysis('NR_trial')};
        
        R(:,1) = []; %The first is the anticipation of reward
        NR(:,1) = []; %The first is the anticipation of reward
        if (size(R,2) > f.trials)
            R(:,end-(size(R,2) - f.trials):end-1) = [];
        end
        if (size(C,2) > f.trials)
            C(:,end-(size(C,2) - f.trials):end) = [];
        end
        if (size(NR,2) > f.trials)
            NR(:,end-(size(NR,2) - f.trials)) = [];
        end
    end
    
    Idx1 = findanalysis(@behaviour_neurons_kernels);
    if ~all(Idx1)
        fprintf("add_analysis(@behaviour_neurons_kernels,1,'property_names',{'B_trial_neuron','p_trial_neuron','AUC','P','stability','h'},'arglist',{'loops',25})\n")
    else
        coeffs  = TheMatrix{idx_neuron,findanalysis('B_trial_neuron')};
    end
    
    Idx3 = findanalysis('CentralPortEpoch');
    if ~all(Idx3)
        fprintf("addanalysis(@average_firing_rate,1,'property_names',{'CentralPortEpoch'})\n")
    elseif isnan(remove_index)
        %will check for error in behavior -> will not create firing
    else
        Firing = TheMatrix{idx_neuron,Idx3};
        Firing(remove_index) = [];
    end
end

[F1_score_macro,idx_trial] = deal(nan);
if exist('Firing','var') && length(Firing) == size(R,1)
    % %IMPORTANT
    F = Firing;
    %F = zscore(Firing); %z_score pr columns (each neuron are centered to 0)
    
    if any(isnan(F))
        test = nan;
    else
        data = [];
        for i = 1:numel(f.data)
            switch f.data{i}
                case 'choice'
                    data = [data C == -1 C == 1];
                case 'reward'
                    data  = [data R == -1 R == 1];   %R_right
                case 'no_reward'
                    data  = [data NR == -1 NR == 1]; %no_reward
            end
        end
    end
    
    idx_test1 = 1:4;
    idx_test2 = 5:10;
    idx_test1_range  = [idx_test1 (10+idx_test1) (10*2+idx_test1) (10*3+idx_test1)];
    idx_tes2t_range  = [idx_test2 (10+idx_test2) (10*2+idx_test2) (10*3+idx_test2)];
    
    %if numel(unique(coeffs)) == 2
    if any(coeffs(idx_tes2t_range)) && ~any(coeffs(idx_test1_range))
        %coeffs = abs(coeffs);
        if max(abs(coeffs)) > 0.2 %&& 4* max(coeffs(coeffs<max(coeffs))) < max(abs(coeffs))
            [value, idx ] = max(abs(coeffs));
            main_firing = Firing(logical(data(:,idx)));
            ref_firing  = Firing(logical(~data(:,idx)));
            ground_truth = logical(data(:,idx));
            
            figure
            subplot(2,2,1)
            
            histogram(main_firing,30)
            hold on
            histogram(ref_firing,30)
            legend({'action','no action'})
            title('index method - firing rate')
            subplot(2,2,2)
            
            histogram(Firing(logical(C(:,mod(idx-1,size(R,2))+2))),30)
            hold on
            histogram(Firing(~logical(C(:,mod(idx-1,size(R,2))+2))),30)
            title('choice - firing rate')
            
            subplot(2,2,3)
            plot(coeffs)
            title('coefficients - kernels')
            
            SVMModel = fitcsvm(Firing,logical(data(:,idx)));
            SVMModel2 = fitcsvm(Firing,logical(C(:,mod(idx-1,size(R,2))+2)));
            CVMdl1 = crossval(SVMModel2,'leaveout','on');
            misclass1 = kfoldLoss(CVMdl1);
            disp(misclass1)
            [D, P, SE] = rocarea2(main_firing,ref_firing,'bootstrap',1000)
            
            perfcurve(logical(data(:,idx)),main_firing,'1')
            %                 if find(SVMModel.ClassNames == 1) == 1
            %                     class  = logical(SVMModel.Gradient < 0);
            %                     class2 = logical(SVMModel.Gradient > 0);
            %                 else
            %                     class  = logical(SVMModel.Gradient > 0);
            %                     class2 = logical(SVMModel.Gradient < 0);
            %                 end
            
            %                 CVMdl1 = crossval(SVMModel,'leaveout','on');
            %                 misclass1 = kfoldLoss(CVMdl1);
            %                 disp(misclass1)
            
            %
            %                 disp(sum(and(ground_truth,class))/sum(ground_truth))
            %                 disp(sum(and(~ground_truth,class2))/sum(~ground_truth))
            %sum(and(ground_truth,~class))/sum(~ground_truth)
            
            [predictedY,score] = resubPredict(SVMModel);
            subplot(2,2,4)
            title('confusion chart')
            cm = confusionchart(logical(data(:,idx)),predictedY,'RowSummary','row-normalized','ColumnSummary','column-normalized');
            con = cm.NormalizedValues;
            F1_score1 = 2 * con(1,1)/(2*con(1,1)+con(2,1)+con(1,2));
            F1_score2 = 2 * con(2,2)/(2*con(2,2)+con(2,1)+con(1,2));
            F1_score_macro = (F1_score1+F1_score2)/2;
            disp(F1_score_macro)
            idx_trial = mod(idx-1,size(R,2))+1;
            t = 1;
            
            %end
        end
    end
    
end
end

varargout{1}.F1_score_macro = F1_score_macro;
varargout{1}.idx_trial = idx_trial;


end





