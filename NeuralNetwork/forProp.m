function [a, z] = forProp(thetaVec, x, fun)
% thetaVec是一堆权重矩阵
% x是一个向量
% y是根据神经网络预测的输出
z = containers.Map('KeyType', 'int32', 'ValueType', 'any');
a = containers.Map('KeyType', 'int32', 'ValueType', 'any');

if ~isa(fun, 'function_handle')
    disp('fun 必须是个函数')
   
    return;
end

if ~isa(thetaVec, 'containers.Map')
    disp('thetaVec 必须是containers.Map');
   
    return;
end

x = reshape(x, length(x), 1);

a(1) = x;
for i = 1 : thetaVec.Count
    x = [1; x];
    x = fun(thetaVec(i) * x);
    z(i + 1) = x;
    a(i + 1) = fun(x);
end
end