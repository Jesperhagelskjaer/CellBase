function [TheMatrix] = saving_into_dataMatrix(TheMatrix,Lpropnames,property_values,g,cellnum,columns)

for i = 1:Lpropnames %(!)
    holder{i} = property_values.(g.property_names{i});
end
if (g.add == 1)
    TheMatrix(cellnum,columns) = holder;
else
    for i = 1:Lpropnames %(!)
        for j = 1:numel(holder{i})
            fprintf('%s\n',g.property_names{i}+ ": " + num2str(holder{i}(j)))
        end
    end
end




end

