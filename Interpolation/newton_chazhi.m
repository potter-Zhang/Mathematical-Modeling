function [YY,y]=newton_chazhi(X,Y,x,M)
%输入为：X-插值点的x轴向量
%Y-插值点的y轴向量
%需要求解的x变量
%M为多项式次数,若要很准确，则取length(X)-1
%输出YY为差分表
%y是x对应的因变量
m=length(X);
YY=zeros(m);
YY(:,1)=Y;
%求查分表
for i=2:m
    for j=i:m
        YY(j,i)=(YY(j,i-1)-YY(j-1,i-1))/(X(j)-X(j-i+1));
    end
end
y=ones(1,length(x))*Y(1);
%计算newton插值公式
for k=1:length(x)
    for i=1:M
        xl=1;
        for j=1:i
            xl=xl*(x(k)-X(j));
        end
    y(k)=y(k)+xl*YY(i+1,i+1);
    end    
end
end

