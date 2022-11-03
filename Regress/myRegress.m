function [w,stats] = myRegress(x,y)
%回归拟合
%x是一个矩阵，列为特征，行为样本 
%y是样本值
%w为拟合的系数（包括在最后的常数项）
%stats为对该方法拟合程度的评价，含有各种分析数据（如ftest,ptest），详见亚太2021C参考论文
[m,n]=size(x);
if m==1
    x=reshape(x,n,m);
    tem=m;
    m=n;
    n=tem;
end
y=reshape(y,length(y),1);
x=[x ones(m,1)];
w=(x'*x)\(x'*y);

stats.f.degOfFreedom=[n,m-1-n,m-1];%依次为回归，残差，总计，以下统计量大多也是这个顺序
stats.f.SSR=sum((x*w-mean(y)).^2);
stats.f.SST=sum((y-mean(y)).^2);
stats.f.SSE=stats.f.SST-stats.f.SSR;
stats.f.MSR=stats.f.SSR/stats.f.degOfFreedom(1);
stats.f.MSE=stats.f.SSE/stats.f.degOfFreedom(2);
stats.f.F=stats.f.MSR/stats.f.MSE;
stats.f.p=1-fcdf(stats.f.F,n,m-n-1);

c=x'*x;%求正规方程组的系数矩阵
c=inv(c);%c的逆接下来有大用
stats.t.stdErr=zeros(n+1,1);%标准误（常数项和其他变量的）
stats.t.stdErr(1)=sqrt(c(n+1,n+1)*stats.f.MSE);%常数项
for i=1:n
   stats.t.stdErr(i+1)= sqrt(c(i,i)*stats.f.MSE);
end
temp=[w(n+1); w(1:n)];
stats.t.T=temp./stats.t.stdErr;
stats.t.p=(1-tcdf(abs(stats.t.T),m-n-1))*2;
end

