function [mahal_d,d_isolation] = PCA_Mahanobilis_allCh(W_spikes_RT,W_spikes_on_a,dataF,TTL)
%07/04/2019
%made by Jesper Hagelskjær Ph.D.
%the length for the cut to take into the PCA calculation before and after
%the alignment peak

%Note - AC must be negative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paper - Quantitative measures of cluster quality for use in extracellular recordings
% isolation distance bound [0 inf] larger is better
% l_ratio bound [0 inf] smaller is better
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%the data is cell arrays (time x channel x trace)
global f
data         = W_spikes_on_a;
data{end+1}  = W_spikes_RT;


c = [];
for cl = 1:size(data,2) %used for color coling the spikes belonging to which neuorn
    c = [c; ones(size(data{cl},3),1)*cl];
end

if f.purity
    Chs = [];
    for cl = 1:size(data,2)
        [score{cl},chs_start{cl}] = PCA_calculation2('template PCA','single',data,cl,[]);
        Chs = [Chs chs_start{cl}];
    end
    Chs = unique(Chs);
end

if ~isempty(TTL) %used for real-time classification
    if f.std_plotting
        for i = 1:numel(data)-1
            Chs      = unique([chs_start{end},chs_start{i}]);
            template = data{end}(:,Chs,:);
            ref      = data{i}(:,Chs,:);
            figure('Name',['JS TTL ',num2str(TTL),' and DS cl - ',num2str(i)]);
            hold on
            for idx = 1:numel(Chs)
                subplot(1,numel(Chs),idx)
                stdshade_sorting(squeeze(template(:,idx,:)),'r',[],[],[],[],[])
                stdshade_sorting(squeeze(ref(:,idx,:)),'b',[],[],[],[],[])
                title(['ch - ', num2str(Chs(idx))])
                xlabel('time');ylabel('Voltage')
            end
            h = findobj(gcf,'type','axes');
            for k = 1:numel(Chs)
                yi=get(h(1:numel(Chs)),'YLim');
            end
            if iscell(yi)
                Max = max(cellfun(@max,yi,'uni',true));
                Min = min(cellfun(@min,yi,'uni',true));
                set(h(1:numel(Chs)),'YLim',[Min Max]);
            end
            
        end
    end
end

if f.All
    [score]  = PCA_calculation2('Templates PCA','all',data,[],Chs);
    for i = 1:size(data,2)
        score_h{i} = score(logical(c == i),1:3);
    end
end

% Calculates the differente seperation variable
for m = 1:numel(data)
    for n = 1:size(data,2)
        mahal_d(m,n) = mahal(mean(score_h{m}),score_h{n}); %Compute the squared Euclidean distance of each observation in Y from the mean of X .
    end
    mahal_vector(m) = mahal(mean(score_h{end}),score_h{n});
    
    index1 = find(c == m);
    index2 = find(c ~= m);
    mahal_sorted = sort(mahal(score(index2,1:3),score(index1,1:3)));
    L(m) = sum(1-chi2cdf(mahal_sorted,3)); %L-isolation (standard normal distribution)
    L_ratio(m) = L(m)/length(index1);% Lratio-isolation
    %fprintf('\ncluster %d: L ratio - %2.2f\n',m,L_ratio(m) );
    if (length(mahal_sorted) < length(index1)) %isolation distance: only defined if there is equal or more cluster points than cluster compared to
        %fprintf('cluster %d: - Isolation distance failed due to to few points in other clusters\n',m );
        d_isolation(m) = nan;
    else
        d_isolation(m) = mahal_sorted(length(index1));
        %fprintf('cluster %d: Isolation distance -  %0.2f\n',m,d_isolation(m) );
    end
end

end