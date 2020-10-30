
clc
clear all
close all
loadcb
%% create abs max for the coefficients 
% idx_M = 15;
% j = 0;
% for i = 1:size(TheMatrix,1)
%     if ~isnan(TheMatrix{i,idx_M})
%         j = j + 1;
%         coef(j,:) = TheMatrix{i,idx_M};
%     end
% end
% 
% test2 = [sum(coef,1)];
% sum(sum(coef(:,12:end)))
% 
% for i = 1:66   
%     %fprintf('%d\n',numel(find(coef_nz(:,i) ~= 0)))
%     fprintf('%d\n',test2(i))
%     if mod(i,11) == 0
%         fprintf('\n\n')
%     end 
% end
%%
idx_M = 15;

for i = 1:size(TheMatrix,1)
     test2 = find(TheMatrix{i,idx_M}) < 0.05; 
     if sum(any(test2 ~= 0))
         6
     end
end
%%
idx_M = 16;
for i = 1:size(TheMatrix,1)

     test2 = find(TheMatrix{i,idx_M}) < 0.05; 
     if sum(any(test2 ~= 0))
         6
     end
end

