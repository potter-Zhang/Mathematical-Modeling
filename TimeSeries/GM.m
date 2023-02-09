function [P, f] = GM(x)
% each row of x is a sample
% x should be m * 1
[m, n] = size(x);

% Y
x0 = x(1, :);
originalX = x;
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
% f = @(t) (1 - exp(P(1))) .* (x0 - P(2) / P(1)) .* exp(-P(1) * (t - 1));
g = @(t) (x0 - P(2) / P(1)) .* exp(-P(1) .* (t - 1)) + P(2) / P(1);
f = @(t) recover(g(t));

% testing
t = 1 : m;
t = t';
xtp = f(t);

if n == 1
    S1 = sqrt(sum((originalX - xtp) .^ 2) / m);
    S2 = sqrt(sum((originalX - mean(originalX)) .^ 2) / m);
else
    S1 = sqrt(sum(sum((originalX - xtp) .^ 2)) / m);
    S2 = sqrt(sum(sum((originalX - mean(originalX))) .^ 2) / m);
end
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