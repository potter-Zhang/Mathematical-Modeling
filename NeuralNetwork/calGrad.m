function [gradientVec] = calGrad(triangle, thetaVec, mm, lambda)
% 计算梯度向量gradientVec
% triangles是累加的误差
% thetaVec是一堆权重矩阵，用于正则化部分
% mm是样本数量, lambda是costFunciton里面的lambda，正则化系数

gradientVec = containers.Map('KeyType', 'int32', 'ValueType', 'any');
count = thetaVec.Count;

for l = 1 : count
    [m, n] = size(thetaVec(l));
    tmp = 1 / mm * triangle(l);
    theta = thetaVec(l);
    for i = 1 : m
        for j = 2 : n
            tmp(i, j) = tmp(i, j) + lambda * theta(i, j);  
        end
    end
    gradientVec(l) = tmp;
end
end