function [thetaVec] = neuralNetwork(layer, x, y, count, alpha, lambda, fun, funder, epsilon)
% 神经网络
% count是训练次数
% alpha是学习率
% 参数详见具体调用函数

y=reshape(y,length(y),1);
[m, ~] = size(x);

% 随机初始化thetaVec
[thetaVec, triangle] = randomInit(layer, epsilon);
tmp = triangle;

% 前后向反复传播学习
for j = 1 : count
    for i = 1 : m
        [a, z] = forProp(thetaVec, x(i, :), fun);
        triangle = backProp(y(i, :), thetaVec, triangle, a, z, funder);
        ytp(i, :) = a(thetaVec.Count+1)';
    end
    D = calGrad(triangle, thetaVec, m, lambda);
    gradVec = gradApprox(@costFunction, thetaVec, y, ytp, lambda);
    triangle = tmp;
end



end
