function value = Kernel(x1, x2, method, cof)
% kernel 
% x1和x2是两个需要做内积的向量，method是选择的内积方法
% value是返回的内积结果
% method有
% 'linear'(普通内积),
% 'poly'(多项式kernel函数, K(x1, x2) = (c + x1*x2)^d, 参数c, d需要在cof中给出
% 'rbf'(高斯kernel函数, K(x1, x2) = exp(-gamma*(x1 - x2)^2), 参数gamma需要在cof中给出
x1 = reshape(x1, length(x1), 1);
x2 = reshape(x2, length(x2), 1);
switch lower(method)
    case 'linear'
        value = x1' * x2;
    case 'poly'
        value = (cof(1) + x1' * x2) ^ cof(2);
    case 'rbf'
        value = exp(-cof(1) * sum((x1 - x2).^2));
end

end