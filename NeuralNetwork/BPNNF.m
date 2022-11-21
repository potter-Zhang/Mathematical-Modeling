function [thetaVec, biasVec] = BPNNF(x, y, layer, alpha, count)
% x is a m * Q matrix
% y is a n * Q matrix 
% where Q is number of samples

f = @tansig;
g = @transigDer;

% normalization
x=2 * (x-min(x, [], 2))./(max(x, [], 2)-min(x, [], 2)) - ones(size(x));
%tmpy = y;
y=2 * (y-min(y, [], 2))./(max(y, [], 2)-min(y, [], 2)) - ones(size(y));

layer.num = layer.num + 2;
layer.units = [size(x, 1), layer.units, size(y, 1)];

% initialization
a = containers.Map('KeyType', 'int32', 'ValueType', 'any');
z = containers.Map('KeyType', 'int32', 'ValueType', 'any');
thetaVec = containers.Map('KeyType', 'int32', 'ValueType', 'any');
biasVec = containers.Map('KeyType', 'int32', 'ValueType', 'any');
thetaGrad = containers.Map('KeyType', 'int32', 'ValueType', 'any');
biasGrad = containers.Map('KeyType', 'int32', 'ValueType', 'any');

for i = 1 : layer.num - 1
    thetaVec(i) = rand(layer.units(i + 1), layer.units(i));
    biasVec(i) = rand(layer.units(i + 1), 1);
    thetaGrad(i) = zeros(size(thetaVec(i)));
    biasGrad(i) = zeros(size(biasVec(i)));
end

for iteration = 1 : count
    
% forward
a(1) = x;
for i = 1 : layer.num - 1
    z(i + 1) = thetaVec(i) * a(i) + biasVec(i);
    a(i + 1) = f(z(i + 1));
end

% backward
afinal = a(layer.num);

disp('cost = ');
disp(sum(sum((afinal - y) .^ 2)));
%y=2*(y-min(y, [], 2))./(max(y, [], 2)-min(y, [], 2))-ones(size(y));
%disp('ytp = ');
%disp(afinal);
%disp((afinal + ones(size(afinal))).* (max(tmpy, [], 2) - min(tmpy, [], 2)) ./ 2 + min(tmpy, [], 2));

for i = 1 : size(x, 2)
    cost = afinal(:, i) - y(:, i);
    for j = layer.num - 1 : -1 : 1
        tmpa = a(j + 1);
        tmpz = z(j + 1);
        fDer = g(tmpa(:, i), tmpz(:, i));
        tmpa = a(j);
        thetaGrad(j) = thetaGrad(j) + (cost .* fDer) * tmpa(:, i)';
        biasGrad(j) = biasGrad(j) + (cost .* fDer);
        cost =  thetaVec(j)' * cost .* fDer;
    end
end

% gradient descent
for i = 1 : layer.num - 1
    thetaVec(i) = thetaVec(i) - alpha * thetaGrad(i);
    biasVec(i) = biasVec(i) - alpha * biasGrad(i);
    thetaGrad(i) = zeros(size(thetaGrad(i)));
    biasGrad(i) = zeros(size(biasGrad(i)));
end

end
end

