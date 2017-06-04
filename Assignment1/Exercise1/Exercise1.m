load('Data.mat');
%Input
%v
%w

%Output
%x
%y
%theta


k = 5;
p_max = 6;
p_min = 1;


kFolds(Input, Output, p_min, p_max, k);
