function [newTriangle] = backProp(y, thetaVec, triangle, a, z, funder)
% 反向传播
% y是实际的样本预测值，ytp是神经网络的正向传播的预测值
% funder是fun的导函数
% triangle是累加的误差
% newTriange是更新的误差
if ~isa(thetaVec, 'containers.Map')
    disp('thetaVec 必须是containers.Map');
    return;
end
if ~isa(triangle, 'containers.Map')
    disp('triangle 必须是containers.Map');
    return;
end
y=reshape(y,length(y),1);

delta = containers.Map('KeyType', 'int32', 'ValueType', 'any');
newTriangle = containers.Map('KeyType', 'int32', 'ValueType', 'any');


count = thetaVec.Count;
delta(count + 1) = a(count + 1)-y;

for i = count : -1 : 2
    temp=thetaVec(i);
    delta(i) = temp(:,2:end)' * delta(i + 1) .* funder(a(i), z(i));
end

for i = 1 : count
    newTriangle(i) = triangle(i) + delta(i + 1) * [1; a(i)]';
end


end
