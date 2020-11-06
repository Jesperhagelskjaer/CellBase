function [label_str] = label_creating(name,m)

for i = 1:numel(name)
    if m == 1
        label_str{i,1} = name{i};
    else
        label_str{i,1} = strcat(name{i},' - before');
        label_str{i,2} = strcat(name{i},' - after');
    end 
end

end

