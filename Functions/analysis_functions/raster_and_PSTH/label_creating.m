function [label_str] = label_creating(name,m,g)

for i = 1:numel(name)
    if m == 1
        label_str{1,i} = name{i};
    end
    if m == 2
        label_str{1,i} = strcat(name{i},' - before ');
        label_str{2,i} = strcat(name{i},' - after ');
    end
    
end
if ~isempty(g.event)
    for i = 1:numel(name)
        if m == 1
            label_str{1,i} = strcat(label_str{1,i},' - ',g.event);
        else
            label_str{1,i} = strcat(label_str{1,i},' - ',g.event);
            label_str{2,i} = strcat(label_str{2,i},' - ',g.event);
        end
    end
end



label_str = reshape(label_str,size(label_str,1)*size(label_str,2),1);
end

