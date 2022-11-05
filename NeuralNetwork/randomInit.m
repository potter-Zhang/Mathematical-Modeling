function [thetaVec, triangle] = randomInit(layer, epsilon)
% 随机初始化thetaVec和triangle
% layer.num是层的个数
% layer.units是一个数组，每一元素代表每一层的神经元个数

thetaVec = containers.Map('KeyType', 'int32', 'ValueType', 'any');
triangle = containers.Map('KeyType', 'int32', 'ValueType', 'any');

for i = 1 : layer.num - 1
    thetaVec(i) = rand(layer.units(i + 1), layer.units(i) + 1) * (2 * epsilon) - epsilon;
    triangle(i) = zeros(size(thetaVec(i)));
end

end