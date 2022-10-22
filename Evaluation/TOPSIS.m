function [y] = TOPSIS(x, label, method)
% TOPSIS方法
% x是一个矩阵，每一列为不同的指标，每一行为不同的样本
% label表示每个指标是否是越大越优型（越大越优型用1表示，否则用0表示）
% method是需要调用的计算权重的方法

% 检查method是否为函数句柄
if (~isa(method, 'function_handle'))
    disp("method必须是计算权重的函数");
    y = -1;
    return;
end

[m, n] = size(x);

% 根据method计算权重
[w, ~] = method(x, label);

% 标准化
x = Normalization(x, label);

% 计算综合评分
w = repmat(w, m, 1);
r = x.* w;

% 计算正理想解和负理想解
Sdp = max(r);
Sdn = min(r);

% 计算每个样本和正负理想解的欧式距离
Edp = sqrt(sum((r - Sdp).^2, 2));
Edn = sqrt(sum((r - Sdn).^2, 2));

% 算出y(yita)
y = Edn ./ (Edp + Edn);
end
