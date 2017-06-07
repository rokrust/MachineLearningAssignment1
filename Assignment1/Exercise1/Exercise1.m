%optimal values 4, 1 for k = 5 and k = 2

function par = Exercise1(k)
    load('Data.mat');

    p_max = 6;
    p_min = 1;

    [p, par] = kFolds(Input, Output, p_min, p_max, k);
end