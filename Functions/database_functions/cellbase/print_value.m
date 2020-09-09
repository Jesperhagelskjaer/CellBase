function [] = print_value(Lpropnames,holder,g)

for i = 1:Lpropnames %(!)
    for j = 1:numel(holder{i})
        fprintf('%s\n',g.property_names{i}+ ": " + num2str(holder{i}(j)))
    end
end

end

