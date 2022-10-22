function [y] = Normalization(X, label)
% 将x进行标准化之后输出为y
% X为一个矩阵，每一列为不同的指标，每一行为不同的样本
% label表示每个指标是否是越大越优型（越大越优型用1表示，否则用0表示）

[m,n]=size(X);
y = zeros(m, n);

%标准化
for i=1:n
    xi=X(:,i);
    if(max(xi)~=min(xi))
        if(label(i))
            y(:,i)=(xi-min(xi))/(max(xi)-min(xi));
        else
            y(:,i)=(max(xi)-xi)/(max(xi)-min(xi)); 
        end
    end
end
end