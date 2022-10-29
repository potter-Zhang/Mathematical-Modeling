function [w,cr] = AHPWeight(x)
%   层次分析法比重
%   x为成对比较阵（矩阵包含了准则层各指标重要性之间的比例）
%   w是各指标的比重，cr是一致性检验的结果（要求小于0.1）
RI= [0         0    0.5800    0.9000    1.1200    1.2400    1.3200    1.4100    1.4500];
n=length(x);
[vec,val]=eig(x);
lambda=max(diag(val));
num=find(diag(val)==lambda);
w=vec(:,num)/sum(vec(:,num));
cr=(lambda-n)/(n-1)/RI(n);
end