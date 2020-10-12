
clc
clear all
close all
loadcb
%% create abs max for the coefficients 

j = 0;
for i = 1:size(TheMatrix,1)
    if ~isnan(TheMatrix{i,13})
        j = j + 1;
        coef(j,:) = TheMatrix{i,13};
    end
end


idx_test1 = 1:4;
idx_test2 = 5:10;
idx_test1_range  = [idx_test1 (10+idx_test1) (10*2+idx_test1) (10*3+idx_test1)];
idx_tes2t_range  = [idx_test2 (10+idx_test2) (10*2+idx_test2) (10*3+idx_test2)];

j = 1;
coef_nz = [];
coef_zero = zeros(size(TheMatrix,1),40);
for i = 1:size(coef,1)
    if any(coef(i,:))
        coef_nz(j,:) = TheMatrix{i,13};
        [value, idx] = max(abs(TheMatrix{i,13})); 
        coef_zero(i,idx) = 1;        
        j = j + 1;
    end   
end
for i = 1:40   
    %fprintf('%d\n',numel(find(coef_nz(:,i) ~= 0)))
    fprintf('%d\n',numel(find(coef_zero(:,i) ~= 0)))
    if mod(i,10) == 0
        fprintf('\n\n')
    end 
end

%%
test_v_sum = [];
tt_v_uniqe = [];
for i = 1:size(coef,1)
    if numel(unique(coef(i,:))) > 1 
        if any(coef(i,idx_tes2t_range)) &&  ~any(coef(i,idx_test1_range))
            tt_v_uniqe = [tt_v_uniqe i];
        end
    end
end







%%
tt_sum_unique = 0;
figure
hold on
for i = 1:numel(tt_v_uniqe)
    %if TheMatrix{tt_v_uniqe(i),17} == 0
        tt_sum_unique = tt_sum_unique + 1;
        plot(coef(tt_v_uniqe(i),:))
    %end    
end




