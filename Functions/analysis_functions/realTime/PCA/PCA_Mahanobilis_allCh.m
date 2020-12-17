function [] = PCA_Mahanobilis_allCh(W_spikes_RT,W_spikes_on_a)
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

global f

center = 400;   % center for the alignment of the waveform

%the data is cell arrays (time x channel x trace)

data                             = W_spikes_on_a;
%W_spikes_RT(1:f.extra-1,:,:)     = [];
%W_spikes_RT(end-f.extra:end,:,:) = [];
data{end+1}                      = W_spikes_RT;

if f.spline
    rg = (abs(f.xAxis(1))+3)*4:(abs(f.xAxis(1))+9)*4;
else
    rg = abs(f.xAxis(1))+abs(f.shift)-3:abs(f.xAxis(1))+abs(f.shift)+3;
end

if strcmp(f.alignment,'min')
    %find the index which to align each channel with different minimum pr.
    
    %many many traces in total (smarter method???)
    [lgt,count] = deal(0);
    c           = [];
    range       = f.PCA_cut(1):f.PCA_cut(2);
    
    for cl = 1:size(data,2)
        lgt = lgt + size(data{cl},3);
    end
    
    % Create the matrix for the shifted traces
    shiftMatrix = zeros(center*4,32,lgt);
    
    
    for cl = 1:size(data,2)
        si = size(data{cl},1)*4-4;  %(!)
        for i = 1:size(data{cl},3)
            count = count + 1;
            
            %Finds the mimimum value of the trace over the four channels
            if f.spline
                holder = spline(1:size(data{cl}(:,:,i),1),data{cl}(:,:,i)',1:0.25:size(data{cl}(:,:,i),1))'; %(!)
            else
                holder = data{cl}(:,:,i);
            end
            if cl == size(data,2)
                [value,~] = min(min(holder(rg,:)));
                [m, ~]    = find(holder == value);  
            else
                [value,~] = min(min(holder));
                [m, ~]    = find(holder == value); 
            end

            
            start = center - m(1); %(1) if is index more than one index having the value take the first value
     
            shiftMatrix(start:start+si,:,count) = holder;  %holder for the corrected traces
         
        end
        c = [c ones(1,size(data{cl},3))*cl]; %coloring the scatter plot
        shiftMatrix_cell{cl} = shiftMatrix(center+range,:,c == cl);
    end
end

%cutting out the non-excential part of the waveform
shiftMatrix = shiftMatrix(center+range,:,:);

for cl = 1:size(data,2)
    if cl == size(data,2)
        template_RT  = mean(shiftMatrix(:,:,c == cl),3);
    else
        Templates(:,:,cl) = mean(shiftMatrix(:,:,c == cl),3);
    end
    PCA_calculation('one tem PCA',shiftMatrix_cell,c,cl,'single');
end

%plotting the channels where the templates are defined on by the PCA method


[score,chs] = PCA_calculation('All tem PCA',shiftMatrix,c,1,'all');

plotting_templates(template_RT,Templates,chs)

%clustering_method(score,shiftMatrix(:,chs,:),c)

%[score,chs] = PCA_calculation(shiftMatrix,c,4);


for i = 1:size(data,2)
    score_h{i} = score(logical(c == i),1:3);
end

% Calculates the differente seperation variable
for m = 1:size(data,2)
    for n = 1:size(data,2)
        mahal_d(m,n) = mahal(mean(score_h{m}),score_h{n}); %Compute the squared Euclidean distance of each observation in Y from the mean of X .
    end
    index1 = find(c == m);
    index2 = find(c ~= m);
    mahal_sorted = sort(mahal(score(index2,1:3),score(index1,1:3)));
    L(m) = sum(1-chi2cdf(mahal_sorted,3)); %L-isolation (standard normal distribution)
    L_ratio(m) = L(m)/length(index1);% Lratio-isolation
    fprintf('\ncluster %d: L ratio - %2.2f\n',m,L_ratio(m) );
    if (mahal_sorted < length(index1)) %isolation distance: only defined if there is equal or more cluster points than cluster compared to
        fprintf('cluster %d: - Isolation distance failed due to to few points in other clusters\n',m );
        d_isolation(m) = nan;
    else
        d_isolation(m) = mahal_sorted(length(index1));
        fprintf('cluster %d: Isolation distance -  %0.2f\n',m,d_isolation(m) );
    end
end

end