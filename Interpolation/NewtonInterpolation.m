function [C,y] = NewtonInterpolation(x0,y0,x)
%牛顿插值
%C:多项式系数向量(幂从大到小),y:根据x预测的值
%(x0,y0)数据点,x:需要预测的点的x值
%   此处显示详细说明
n=length(x0);
D=zeros(n,n);%差商表矩阵初始化
D(:,1)=reshape(y0,[n,1]);%第一列为一阶差商
for i=2:n
   for j=i:n
      D(j,i)=(D(j,i-1)-D(j-1,i-1))/(x0(j)-x0(j-i+1)); 
   end
end
C=D(n,n);%an
for i=n-1:-1:1
   C=conv(C,poly(x0(i)));
   m=length(C);
   C(m)=C(m)+D(i,i);
end
t(1,:)=ones(1,length(x));
x=reshape(x,1,length(x));%巧用范德蒙系数矩阵批量计算y值
for i=1:n-1
    t(i+1,:)=x.^i;
end
y=flip(C)*t;
end

