function [] = print_value(Lpropnames,holder,g)

for i = 1:Lpropnames %(!)
    for j = 1:numel(holder{i})
        if iscell(holder{i}(j))
            fprintf('%s\n',g.property_names{i}+ ": " + num2str(holder{i}{j}))
        else
            fprintf('%s\n',g.property_names{i}+ ": " + num2str(holder{i}(j)))
        end
    end
end

end

