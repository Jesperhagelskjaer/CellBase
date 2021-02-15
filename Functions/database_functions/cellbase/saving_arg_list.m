function [f,saving] = saving_arg_list(f)

saving = 0;
idx = strcmp(f{1},'save');
if any(idx)
    saving = 1;
    f{1}(idx) = [];
end
    

end

