function [y] = net(x)
% net 将预测输出根据softmax函数转化到0-1之间
% x为预测输出
maxval = max(x, [], 2); %求出每一行最大值

y = exp(x - maxval);
y = y./sum(y, 2);
end