
trials = 500;
data   = 25;
matrix_wrong = zeros(trials,data)

for i = 1:size(matrix(),1)
    test = matrix_wrong(i,:)*matrix_wrong
end