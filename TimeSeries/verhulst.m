function [P, f] = verhulst(x)
% 灰色预测GM(2, 1)
% P为求解出的参数, f是预测函数
% x应该是m*1的向量, m为样本个数

[m, n] = size(x);
originalX = x;
x0 = x(1, :);

% add up
for i = 2 : m
    x(i) = x(i) + x(i - 1);
end

% mean
z = zeros(m - 1, n);
for i = 1 : m - 1
    z(i, :) = (x(i, :) + x(i + 1, :)) / 2;
end

% solve
B = [-z z.^2];
Y = originalX(2 : end, :);

P = (B' * B) \ B' * Y;

g = @(t) (P(1) .* x0) ./ ((P(2) .* x0) + (P(1) - P(2) .* x0) .* exp(P(1) .* (t - 1)));
f = @(t) recover(g(t));

% testing
t = 1 : m;
t = t';
xtp = f(t);
xtp
S1 = std(originalX - xtp);
S2 = std(originalX);

C = S1 / S2;

disp('C = ');
disp(C);

if C < 0.35
    disp('优');
elseif C  < 0.5
    disp('合格');
elseif C < 0.65
    disp('勉强合格');
else 
    disp('不合格');
end



end

function [y] = recover(x)
    y = zeros(size(x));
    y(1) = x(1);
    for i = 2 : length(x)
        y(i) = x(i) - x(i - 1);
    end
end