function [P, f] = GM(x)
% x的每一行是一个样本
[m, n] = size(x);

% Y
x0 = x(1, :);
Y = x(2 : end, :);

% add up
for i = 2 : m
    x(i, :) = x(i - 1, :) + x(i, :);
end

% mean
z = zeros(m - 1, n);
for i = 1 : m - 1
    z(i, :) = (x(i, :) + x(i + 1, :)) / 2;
end

% solve

B = [-z ones(m - 1, 1)];

P = (B' * B) \ B' * Y;

% function

f = @(t) (1 - exp(P(1))) .* (x0 - P(2) / P(1)) .* exp(-P(1) * (t - 1));
end