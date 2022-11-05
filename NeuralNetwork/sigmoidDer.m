function [y] = sigmoidDer(a, ~)
% a = sigmoid(z)
% 求sigmoid导函数

y = a.*(1 - a);
end