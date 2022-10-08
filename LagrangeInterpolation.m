function [y] = LagrangeInterpolation(x0,y0,x)
%插值法
%x0,y0是需要用函数去拟合的点
%x是要预测的点的x值,y是对应的函数值
%   此处显示详细说明
for i=1:length(x)
    s2=0;
   for j=1:length(x0)
        s1=1;
        for k=1:length(x0)
           if j==k
               continue            
           end
           s1= s1*(x(i)-x0(k))/(x0(j)-x0(k));
        end
        s2 = s2+s1*y0(j);
   end
   y(i)=s2;
end
end

