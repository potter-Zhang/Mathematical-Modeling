function [S,E,I,R] = SEIR(N,S0,E0,I0,R0,a,b,r,y,k)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
%   a：潜伏者转化为感染者的概率，它可以估计为已知的平均潜伏期Y的倒数，即a=1/Y
%   b：一个易感者和一个感染者接触，他被传染的概率
%   r：感染者接触易感者的人数
%   y：感染者康复的概率，可以由平均的康复期D的倒数决定，即y=1/D
%   k: 模拟的时间间隔数
%   S,E,I,R:Susceptible(易感者)-Exposed(潜伏者)-Infected(感染者)-Removed(康复者)的模拟人数
%   S0,E0,I0,R0:各类人群的初始人数
%   可对N,S,E,I,R进行拓展，拓展成多维行向量

if N~=S0+E0+I0+R0
    ME=MException("myComponent:inputError","各群体人数有误");
    throw(ME);
end
if(k<=0)
    ME=MException("myComponent:inputError","参数k错误");
    throw(ME);
end

n=length(N);
S0=reshape(S0,1,n);
E0=reshape(E0,1,n);
I0=reshape(I0,1,n);
R0=reshape(R0,1,n);
S=zeros(k+1,n);
E=zeros(k+1,n);
I=zeros(k+1,n);
R=zeros(k+1,n);
S(1,:)=S0;E(1,:)=E0;I(1,:)=I0;R(1,:)=R0;

for i=1:k
    temp1=r*b.*I(i,:).*S(i,:)./N;
    temp2=a*E(i,:);
    temp3=y*I(i,:);
    S(i+1,:)=S(i,:)-temp1;
    E(i+1,:)=E(i,:)+temp1-temp2;
    I(i+1,:)=I(i,:)+temp2-temp3;
    R(i+1,:)=R(i,:)+temp3;
end

end