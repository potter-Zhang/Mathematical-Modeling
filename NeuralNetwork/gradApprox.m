function [gradVec] = gradApprox(costFunction, theta, y, ytp, lambda, epsilon)
% 梯度检查函数，
% 其中costFunction是代价函数，theta是需要求的导函数的自变量（可以是一个向量）
% epsilon是极小的偏移，函数使用双侧偏移近似
% epsilon的默认值
if nargin < 6
    epsilon = 1e-4;
end
gradVec = containers.Map('KeyType', 'int32', 'ValueType', 'any');

if (~isa(costFunction, 'function_handle'))
    disp("costFunction必须是计算权重的函数");
    %gradVec = null(n, 1);
    return;
end

num = theta.Count;


% 计算gradVec

for i = 1 : num
    [m, n] = size(theta(i));
    tmp = zeros(m, n);
    for j = 1 : m
        for k = 1 : n
            tmpPos=theta;
            tmpNeg=theta;
            tempPos = theta(i);
            tempNeg = theta(i);
            tempPos(j, k) = tempPos(j, k) + epsilon;
            tempNeg(j, k) = tempNeg(j, k) - epsilon;
            tmpPos(i)=tempPos;
            tmpNeg(i)=tempNeg;
            tmp(j, k) = (costFunction(tmpPos, y, ytp, lambda) - costFunction(tmpNeg, y, ytp, lambda)) / (2 * epsilon);
             
        end
        
    end
    gradVec(i) = tmp;
    disp(i);
end
end