function [varargout] = similarity_template_spike(cellid,path,varargin)

% add_analysis(@similarity_template_spike,1,'mandatory',{'D:\recording'},'property_names',{'AUC','idx'},'arglist',{'rez','rezFinalK','whitening','y'});

%To Do
%check up on cluster identity
global CELLIDLIST
persistent dataW

idx_p              = find(strcmp(varargin,'property_names'));
method             = varargin{idx_p+1};
varargin(idx_p+1)  = [];varargin(idx_p)       = [];
varargin           = [varargin{:}];

prs = inputParser;
errorMsg = 'Value must be positive, scalar, and numeric.';
validationFcn = @(x) assert(isnumeric(x) && isscalar(x) && (x > 0),errorMsg);

addRequired(prs,'cellid',@(cellid) iscellid((cellid)) || (cellid) == 0)
addRequired(prs,'path',@ischar) %
addParameter(prs,'fshigh',300,validationFcn)
addParameter(prs,'slow',8000,validationFcn)
addParameter(prs,'fs',30000,validationFcn)
addParameter(prs,'rez','rezFinal')
addParameter(prs,'whitening','n',@ischar)
addParameter(prs,'NCC_threshold',0.6)
addParameter(prs,'voltage_threshold',75)
addParameter(prs,'plotting',0)
addParameter(prs,'range',[-5:7])

parse(prs,cellid,path,varargin{:})
g = prs.Results;
if (g.cellid == 0)
    varargout{1}.prs = prs;
    return
end

[r,s,~,~] = cellid2tags(g.cellid);
POS = findcellpos('animal',r,'session',s); %(!) find faster method
cluster = findcellstr(CELLIDLIST',g.cellid); % CELLIDLIST must be column vector
cluster = find(cluster == POS);

load(fullfile(g.path,r,s,g.rez));
path = fullfile(g.path,r,s);
Template_all = rez.M_template;

error          = 0;
if cluster ~= 1 && isnan(dataW(1,1))
    error = 1;
end

if cluster == 1 || isempty(dataW)
    [b1, a1] = butter(3, [g.fshigh/g.fs,g.slow/g.fs]*2, 'bandpass');
    [channel_start] = find_number_of_files(path)+1; %when channels start with at 17 but the tetrode will start at 1
    i = 1;
    for channel = channel_start:32+channel_start-1
        if i == 1
            full_name          = fullfile(path,sprintf('100_CH%d.continuous',channel_start));
            [d, timestamps, ~] = load_open_ephys_data_faster(full_name);
            dataW = zeros(length(timestamps),32,'single');
            d = single(d);
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
    if strcmp(g.whitening,'y')
        [dataW] = whitening_the_data(dataW);
    end
end

if error
    AUC   = nan;
    dataW = nan;
else
    range        = [-10:50];
    Idx          = rez.st(logical(rez.st(:,8)==cluster),1);
    Template_spk = nan(numel(range),32,numel(Idx));
    
    for i = 1:numel(Idx)
        Template_spk(:,:,i)      = dataW(Idx(i)+range,:);
    end
    
    Template       = mean(Template_spk,3);
    Template_cl    = Template;
    Template_cl(logical(Template_cl > -g.voltage_threshold & Template_cl < g.voltage_threshold)) = 0;
    channals_nzero = any(Template_cl ~= 0);
    tt             = sum(channals_nzero);
    
    main_cl = nan(numel(Idx),sum(channals_nzero));
    range = g.range;
    for i = 1:numel(Idx)
        main_cl(i,:) = sum((dataW(Idx(i)+range,channals_nzero) - Template_cl(20+range,channals_nzero)).^2);
    end
    
    sim = nan(size(Template_all,3),1);
    for i = 1:size(Template_all,3)
        sim(i) = max(max(normxcorr2_mex(double(Template_all(:,:,cluster)),double(Template_all(:,:,i)),'full')));
    end

    [idx_sim] = find(sim >= g.NCC_threshold);
    idx_sim(idx_sim == cluster) = [];
    
    AUC = nan(length(idx_sim),1);
    for j = 1:length(idx_sim)
        Idx = rez.st(logical(rez.st(:,8)==idx_sim(j)),1);
        score_sub = nan(numel(Idx),sum(channals_nzero));
        for i = 1:numel(Idx)
            score_sub(i,:) = sum((dataW(Idx(i)+range,channals_nzero) - Template_cl(20+range,channals_nzero)).^2);
        end
        Labels = [zeros(numel(score_sub(:,1)),1);ones(numel(main_cl(:,1)),1)];
        Data   = [score_sub;main_cl];
        % [SVMModel, info] = fitclinear(Data',Labels','ObservationsIn','columns','GradientTolerance',1e-8,'solver','sgd');
        % [label,score] = predict(SVMModel,Data);
        % cl = fitcsvm(Data,Labels,'KernelFunction','rbf','BoxConstraint',Inf,'OutlierFraction',0.01);
        % cl = fitcsvm(Data,Labels,'KernelFunction','linear','BoxConstraint',Inf,'OutlierFraction',0.01);
        cl = fitcsvm(Data,Labels,'KernelFunction','linear','OutlierFraction',0.01,'Standardize','on');
        [label,score] = predict(cl,Data);
        
        [~,~,~,AUC(j)] = perfcurve(Labels,score(:,1),'0');
        if AUC(j) < 0.9
            b = 2;
        end
        if g.plotting
            figure
            if tt == 1
                subplot(2,1,1)
                plot(Data,[],Labels)
                subplot(2,1,2)
                plot(Data,[],label)
            elseif  tt == 2
                subplot(2,1,1)
                scatter(Data(:,1),Data(:,2),1,Labels)
                subplot(2,1,2)
                scatter(Data(:,1),Data(:,2),1,label)
            elseif tt >= 3 %(!) make better
                subplot(2,1,1)
                scatter3(Data(:,1),Data(:,2),Data(:,3),[],Labels)
                subplot(2,1,2)
                scatter3(Data(:,1),Data(:,2),Data(:,3),[],label)
            end
            figure
            Idx = [cluster; idx_sim];
            for i = 1:length(Idx)
                subplot(2,2,i)
                surf(Template_all(14:29,:,Idx(i)))
            end
            
            %legend(['ref';'main'])
            close all
        end
    end
end

varargout{1}.AUC = AUC;
varargout{1}.idx = idx_sim;
end


