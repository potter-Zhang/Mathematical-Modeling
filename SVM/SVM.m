function [w, b, wxtp] = SVM(x, y, xtp, method, cof, c)
% support vector machine支持向量机, 苏联vapkin的杰作
% 其中x是一个矩阵, 每一列是不同的特征，每一行是不同的样本
% y是一个向量, 是x对应的标签，只能是正负一
% xtp是需要预测的x, 每一列是不同的特征，每一行是不同的样本
% method是选择的kernel trick方法, cof是对应方法需要的参数。具体可以参见Kernel函数
% c为对应的软间隔的参数，c越大，间隔容忍度越小
% 返回值w为权重向量, b为一个偏移量数字，w' * x + b = 0即为求出的分割超平面
% wxtp = w * xtp(解决无限维的预测问题)

% 求解对偶问题解决, 先计算aij = yi*yj*kernel(xi*xj)
[m, n] = size(x);

a = zeros(m, m);

for i = 1 : m
    for j = 1 : m
        a(i, j) = y(i) * y(j) * Kernel(x(i, :), x(j, :), method, cof);
    end
end

% 使用二次规划函数求解lamda
y = reshape(y, 1, m);
f = -ones(m, 1);
H = a;
temp=[c*ones(m,1),Inf(m,1)];%用于下一行的三目运算
lambda = quadprog(H, f, [], [], y, 0, zeros(m, 1), temp(:,(c==0)+1));

% lamda处理
epsilon = 1e-8;
for i = 1 : m
    if abs(lambda(i)) < epsilon
        lambda(i) = 0;
    end
end

% 利用lambda求解w
w = zeros(1, n);

for i = 1 : m
    w = w + y(i) * lambda(i) * x(i, :);
end

% 求出wxtp
[mm,~] = size(xtp);
wxtp = zeros(1, mm);
for j = 1 : mm
    for i = 1 : m
        wxtp(j) = wxtp(j) + lambda(i) * y(i) * Kernel(x(i, :), xtp(j, :), method, cof);
    end
end

% 将w改为列向量
w = w';


% 找到第一个支撑向量求解b

u = 0;
for i = 1 : m
    if lambda(i) ~= 0
        for j = 1 : m
            u = u + lambda(j) * y(j) * Kernel(x(i, :), x(j, :), method, cof);
        end
        b = y(i) - u;
        break;
    end
end


end