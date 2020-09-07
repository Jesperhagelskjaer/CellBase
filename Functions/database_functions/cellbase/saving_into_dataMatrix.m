function [TheMatrix] = saving_into_dataMatrix(TheMatrix,Lpropnames,property_values,g,cellnum,columns)

for i = 1:Lpropnames %(!)
    holder{i} = property_values.(g.property_names{i});
    %struct2cell(property_values)
end
if (g.add == 1)
    TheMatrix(cellnum,columns) = holder;
else
    for i = 1:Lpropnames %(!)
        fprintf('%s: %f\n',g.property_names{i}, holder{i})    % (create a print function)
    end
end

end

