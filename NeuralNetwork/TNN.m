function [thetaVec] = TNN(x,y,num,count,alpha,theta)
%三层BP神经网络
%x是输入矩阵,y是输出矩阵,num是隐藏层神经元的数量,count是训练次数,alpha是学习率
%thetaVec.w1是输入层到隐藏层的权重矩阵,thetaVec.w2是隐藏层到输出层的权重矩阵
%thetaVec.b1是输入层到隐藏层的偏置,thetaVec.b2是隐藏层到输出层的偏置

%归一化
x=x';
y=y';
x=2*(x-min(x))./(max(x)-min(x))-ones(size(x));
y=2*(y-min(y))./(max(y)-min(y))-ones(size(y));

%初始化thetaVec
if(nargin==6)
    thetaVec=theta;
else
    thetaVec.w1=rand(size(x,1),num)*2-1;
    thetaVec.w2=rand(num,size(y,1))*2-1;
    thetaVec.b1=rand(num,1)*2-1;
    thetaVec.b2=rand(size(y,1),1)*2-1;
end

m=size(x,2);%样本数

for iteration=1:count

%     w1=zeros(size(thetaVec.w1));
%     w2=zeros(size(thetaVec.w2));
%     b1=zeros(size(thetaVec.b1));
%     b2=zeros(size(thetaVec.b2));
for each=1:m

    xx=x(:,each);
    yy=y(:,each);
%前向传播
%输入层到隐藏层
hide=tansig(thetaVec.w1'*xx+thetaVec.b1);

%隐藏层到输出层
output=thetaVec.w2'*hide+thetaVec.b2';
%反向传播
error=yy-output;
tmp=alpha*hide.*(1-hide).*(thetaVec.w2*error);
% w1=w1+(thetaVec.w1+xx*tmp')/m;
% w2=w2+(thetaVec.w2+alpha*hide*error')/m;
% b1=b1+(thetaVec.b1+tmp)/m;
% b2=b2+(thetaVec.b2+alpha*error)/m;
thetaVec.w1=thetaVec.w1+xx*tmp';
thetaVec.w2=thetaVec.w2+alpha*hide*error';
thetaVec.b1=thetaVec.b1+tmp;
thetaVec.b2=thetaVec.b2+alpha*error;

%disp(size(error));
%for i=1:m
%     tmp=alpha*hide(:,m).*(1-hide(:,m)).*(thetaVec.w2'*error(:,m));
%     thetaVec.w1=thetaVec.w1+x(m,:)'*tmp;
%     %disp(size(x(m,:)'*tmp));%
%     thetaVec.w2=thetaVec.w2+alpha*hide(:,m)*error(:,m)';
%     thetaVec.b1=thetaVec.b1+tmp;
%     thetaVec.b2=thetaVec.b2+alpha*error(:,m);
    
%end

end
% thetaVec.w1
% thetaVec.w2
% thetaVec.b1
% thetaVec.b2
% thetaVec.w1=thetaVec.w1+w1;
% thetaVec.w2=thetaVec.w2+w2;
% thetaVec.b1=thetaVec.b1+b1;
% thetaVec.b2=thetaVec.b2+b2;
end

end
