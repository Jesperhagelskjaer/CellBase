function [varargout] = similarity_template_spike(cellid,varargin)

% add_analysis(@similarity_template_spike,1,'property_names',{'AUC','idx'},'arglist',{'rez','rezFinalK','whitening','n','method','svm','plotting',1});

% add_analysis(@similarity_template_spike,99,'property_names',{'AUC','idx'},'arglist',{'rez','rezFinalK','cells',[2:400],'plotting',0});
% delanalysis(@similarity_template_spike)
%To Do
%check up on cluster identity
global CELLIDLIST
global TheMatrix
persistent dataW
persistent f
persistent POS_old



if (cellid == 0)
    method       = varargin{1};
    varargin(1)  = [];
    varargin     = [varargin{:}];
    
    prs = inputParser;
    errorMsg = 'Value must be positive, scalar, and numeric.';
    validationFcn = @(x) assert(isnumeric(x) && isscalar(x) && (x > 0),errorMsg);
    
    addParameter(prs,'path',getpref('cellbase').datapath,@ischar) %
    addParameter(prs,'fshigh',300,validationFcn)
    addParameter(prs,'slow',8000,validationFcn)
    addParameter(prs,'fs',30000,validationFcn)
    addParameter(prs,'rez','rezFinal')
    addParameter(prs,'whitening','n',@ischar)
    addParameter(prs,'NCC_threshold',0.6)
    addParameter(prs,'voltage_threshold',0,@(x) x > 0 && isscalar(x))
    addParameter(prs,'plotting',0)
    addParameter(prs,'range',[-5:7])
    addParameter(prs,'method','svm',@ischar)
    parse(prs,varargin{:})
    f = prs.Results;
    
    varargout{1}.prs = prs;
    return
end

[r,s,~,~] = cellid2tags(cellid);
POS = findcellpos('animal',r,'session',s); %(!) find faster method
%cluster = find(findcellstr(CELLIDLIST',cellid) == POS); % CELLIDLIST must be column vector

error = 0;
load_data = 1;
if all(ismember(POS_old, POS)) && ~isempty(dataW)
    if isnan(dataW(1,1))
        error = 1;
    else
        load_data = 0;
    end
end


Idx = findanalysis(@cellid2rezFile);
if ~all(Idx)
    fprintf("add_analysis(@cellid2rezFile,1,'property_names',{'ID'},'arglist',{'name','rezFinalK'})\n")
else
    idx_neuron = findcellstr(CELLIDLIST',cellid);
    cluster = TheMatrix{idx_neuron,Idx};
end

load(fullfile(f.path,r,s,f.rez));
path = fullfile(f.path,r,s);
Template_all = rez.M_template;

tic
if load_data && ~error
    [b1, a1] = butter(3, [f.fshigh/f.fs,f.slow/f.fs]*2, 'bandpass');
    [channel_start] = find_number_of_files(path)+1; %when channels start with at 17 but the tetrode will start at 1
    i = 1;
    
    for channel = channel_start:32+channel_start-1
        if i == 1
            [d] = load_ch_mex([path,'\'],num2str(channel));
            dataW = zeros(numel(d),32,'single');
        else
            [d] = load_ch_mex([path,'\'],num2str(channel));
        end
        if numel(d) ~= size(dataW,1)
            error = 1;
            break
        else
            d = FiltFiltM(b1, a1, d, 1);
            dataW(:,i) = d;
            i = i + 1;
        end
    end
    if strcmp(f.whitening,'y')
        [dataW] = whitening_the_data(dataW);
    end
end
toc
tic

[AUC,idx_sim] = deal(-1);
if error
    [AUC,idx_sim,dataW] = deal(nan);
else
    range        = [-10:50];
    Idx          = rez.st(logical(rez.st(:,8)==cluster),1);
    Template_spk = nan(numel(range),32,numel(Idx));
    
    for i = 1:numel(Idx)
        Template_spk(:,:,i)      = dataW(Idx(i)+range,:);
    end
    if -f.voltage_threshold == 0
        voltage_threshold = std(dataW)*3;
    else
        voltage_threshold  = f.voltage_threshold;
    end
    Template       = mean(Template_spk,3);
    Template_cl    = Template;
    Template_cl(logical(Template_cl > -voltage_threshold & Template_cl < voltage_threshold)) = 0;
    channals_nzero = any(Template_cl ~= 0);
    tt             = sum(channals_nzero);
    
    if tt
        main_cl = nan(numel(Idx),sum(channals_nzero));
        range = f.range;
        for i = 1:numel(Idx)
            main_cl(i,:) = sum((dataW(Idx(i)+range,channals_nzero) - Template_cl(11+range,channals_nzero)).^2);
        end
        
        sim = nan(size(Template_all,3),1);
        for i = 1:size(Template_all,3)
            sim(i) = max(max(normxcorr2_mex(double(Template_all(:,:,cluster)),double(Template_all(:,:,i)),'full')));
        end
        
        [idx_sim] = find(sim >= f.NCC_threshold);
        idx_sim(idx_sim == cluster) = [];
        
        AUC = nan(length(idx_sim),1);
        holder_tem = Template_cl(11+range,channals_nzero);
        if isempty(AUC)
            [AUC,idx_sim] = deal(-1);
        else
            for j = 1:length(idx_sim)
                Labels = [];
                Idx = rez.st(logical(rez.st(:,8)==idx_sim(j)),1);
                score_sub = nan(numel(Idx),sum(channals_nzero));
                for i = 1:numel(Idx)
                    score_sub(i,:) = sum((dataW(Idx(i)+range,channals_nzero) - holder_tem).^2);
                end
                
                Labels(:,1) = [zeros(numel(score_sub(:,1)),1);ones(numel(main_cl(:,1)),1)];
                Data   = [score_sub;main_cl];
                if strcmpi(f.method,'svm')
                    %                 tic
                    %                 c = cvpartition(Labels(:,1),'KFold',10);
                    %                 info = struct('UseParallel',true,'CVPartition',c);
                    %                 Mdl = fitcsvm(Data,Labels(:,1),'KernelFunction','linear','OutlierFraction',0.01,'Standardize','on','OptimizeHyperparameters','none','HyperparameterOptimizationOptions',info);
                    %                 %Mdl = fitcsvm(Data,Labels,'KernelFunction','linear','BoxConstraint',Inf,'OutlierFraction',0.01);
                    %                 [Labels(:,2),score] = predict(Mdl,Data);
                    %                 toc
                    tic
                    info = struct('UseParallel',true);
                    Mdl = fitcsvm(Data,Labels(:,1),'KernelFunction','linear','OutlierFraction',0.01,'Standardize','on','OptimizeHyperparameters','none','HyperparameterOptimizationOptions',info);
                    %Mdl = fitcsvm(Data,Labels,'KernelFunction','linear','BoxConstraint',Inf,'OutlierFraction',0.01);
                    [Labels(:,2),score] = predict(Mdl,Data);
                    toc
                    
                elseif strcmpi(f.method,'mnr')
                    Data = zscore(Data);
                    [b,~,~] = mnrfit(Data,categorical(Labels),'model','hierarchical');
                    Labels(:,2) = zeros(size(Data,1),1);
                    score = ones(size(Data,1),1)*b(1);
                    score = exp(sum(score + b(2:end)'.*Data(:,:),2));
                    %label(logical(score > 1)) = 1;
                    %Labels((logical(score > 1)),2) = 1;
                end
                [~,~,~,AUC(j)] = perfcurve(Labels(:,1) ,score(:,2),'1');
                if f.plotting
                    TF = ~any(isoutlier(Data)');
                    figure
                    for m = 1:2
                        if tt == 1
                            subplot(2,1,m)
                            plot(Data,Labels(:,m),'*')
                            %xlim([0 1])
                        elseif  tt == 2
                            subplot(2,1,m)
                            scatter3(Data(TF,1)/max(Data(TF,1)),Data(TF,2)/max(Data(TF,2)),Data(TF,3)/max(Data(TF,3)),30,Labels(TF,m))
                            xlim([0 1])
                            ylim([0 1])
                        elseif tt >= 3 %(!) make better
                            subplot(2,1,m)
                            scatter3(Data(TF,1)/max(Data(TF,1)),Data(TF,2)/max(Data(TF,2)),Data(TF,3)/max(Data(TF,3)),30,Labels(TF,m))
                            xlim([0 1])
                            ylim([0 1])
                            zlim([0 1])
                        end
                    end
                    figure
                    Idx = [cluster; idx_sim];
                    row = ceil(numel(Idx)/2);
                    for i = 1:length(Idx)
                        subplot(2,row,i)
                        surf(Template_all(14:29,:,Idx(i)))
                    end
                    
                    close all
                end
            end
        end
    end
end
toc
varargout{1}.AUC = AUC;
varargout{1}.idx = idx_sim;
POS_old          = POS;
end


