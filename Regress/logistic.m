function [w] = logistic(label,x,alpha,count)
%logistic模型
%label标记,x为数据的特征（每行为特征值 1 x1 x2），alpha学习率, count学习次数，w为各种特征的比重
%   此处显示详细说明
label=reshape(label,length(label),1);
x=[ones(length(x(:,1)),1),x];%在x最左边加一列1
w=ones(length(x(1,:)),1);
for i=1:count
   w=w-alpha*x'*(sigmoid(x*w)-label); 
end
end

