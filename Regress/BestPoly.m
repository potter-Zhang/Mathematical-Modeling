function [cor,y1,p] = BestPoly(x,y,pre)
%多项式拟合最佳次数
%(x,y)为给定的数据，pre为所需相关系数精度（0~1）
%cor为相关系数，y1为拟合的y值，p为系数向量
%   此处显示详细说明
i=1;
cor=0;
while(cor<pre)
   p=polyfit(x,y,i);
   y1=polyval(p,x);
   cor=min(min(corrcoef(y,y1)));
   i=i+1;
end
end

