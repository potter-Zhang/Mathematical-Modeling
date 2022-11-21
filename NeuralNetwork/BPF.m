function [ytp] = BPF(x, y, layer, thetaVec, biasVec)
f = @tansig;
g = @transigDer;

% normalization
x=2 * (x-min(x, [], 2))./(max(x, [], 2)-min(x, [], 2)) - ones(size(x));

layer.num = layer.num + 2;
layer.units = [size(x, 1), layer.units, size(y, 1)];

% initialization
a = containers.Map('KeyType', 'int32', 'ValueType', 'any');
z = containers.Map('KeyType', 'int32', 'ValueType', 'any');

% forward
a(1) = x;
for i = 1 : layer.num - 1
    z(i + 1) = thetaVec(i) * a(i) + biasVec(i);
    a(i + 1) = f(z(i + 1));
end

afinal = a(layer.num);
ytp = (afinal + ones(size(afinal))).* (max(y, [], 2) - min(y, [], 2)) ./ 2 + min(y, [], 2);
end