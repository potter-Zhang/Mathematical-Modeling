function [jVal] = costFunction(thetaVec, y, ytp, lambda)
% 代价函数
% thetaVec是一坨权重矩阵
% ytp是htheta(x), y是样本值, y和ytp是矩阵，行是样本，列是神经网络输出个数
% lambda是正则化系数

% 检查thetaVec

if ~isa(thetaVec, 'containers.Map')
    disp('thetaVec 必须是containers.Map');
    jVal = -1;
    return;
end

[m, ~] = size(y);
jVal = 0;
for i = 1 : thetaVec.Count
    jVal = jVal + sum(sum(thetaVec(i).^2));
end

jVal = jVal * lambda / 2;

for i = 1 : m
    jVal = jVal - sum(y(i, :) .* log(ytp(i, :)) + (1 - y(i, :)) .* log(1 - ytp(i, :)));
end

jVal = jVal / m;

end