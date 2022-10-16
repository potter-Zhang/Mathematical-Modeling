function [w] = softmax(x, y, p, alpha, count, xt, yt)
% softmax分类
% x是n*m的矩阵，n是样本个数，m是特征数量
% y是标签
% p是类别个数
% alpha是学习率， count是学习次数
% w是权重矩阵(m + 1) * p
% xt是测试集数据， yt是测试集答案

y = reshape(y, length(y), 1);

% y转为热编码
[n, m] = size(x);
label = zeros(n, p);
for i = 1 : n
    label(i, y(i) + 1) = 1;
end

% 常数项
x = [ones(n, 1), x];

% 开始学习
w = ones(p, m + 1);
for i = 1 : count
    w = w + alpha * (label - net(x*w'))'*x / n;
    disp("准确率为："+test(xt,yt,w'));
end

% w转置
w = w';

end