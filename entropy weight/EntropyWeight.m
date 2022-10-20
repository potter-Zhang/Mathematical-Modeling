function [w,s] = EntropyWeight(X,label)
%熵权法定权
%X为一个矩阵，每一列为不同的指标，每一行为不同的样本
%label表示每个指标是否是越大越优型（越大越优型用1表示，否则用0表示）
%w为每个指标的权重，s为各样本综合得分
%   此处显示详细说明
xx=X;%保留原来的X，使得s使用原来的X进行计算，而不是标准化后的
[m,n]=size(X);
%标准化
for i=1:n
    xi=X(:,i);
    if(max(xi)~=min(xi))
        if(label(i))
            X(:,i)=(xi-min(xi))/(max(xi)-min(xi));
        else
            X(:,i)=(max(xi)-xi)/(max(xi)-min(xi)); 
        end
    end
end

p=X./(sum(X,1));
e=-1/log(m)*sum(p.*ln(p));
d=1-e;
w=d/sum(d);
s=xx*w';
end

function y=ln(x)
    [m,n]=size(x);
    y=zeros(m,n);
    for i=1:m
        for j=1:n
            if(x(i,j)==0) 
                y(i,j)=0;
            else
                y(i,j)=log(x(i,j));
            end
        end
    end
end
