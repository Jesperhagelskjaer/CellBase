function [data1] = splitting_data_set(data,g)


%Change the class of data from matrix into a cell
%if splitting value is set, the data is also split into the two different session
if ~isempty(g.splitDataSet)
    data1{1,1} = false(numel(data),1); %(!)
    data1{1,2} = false(numel(data),1);  %(!)
    data1{1,1}(1:g.splitDataSet)     = data(1:g.splitDataSet);
    data1{1,2}(g.splitDataSet+1:end) = data(g.splitDataSet+1:end);
else
    data1{1}    = data; 
end

