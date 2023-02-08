function [xpre] = myArima(x,prenum)
%xxx=input("请输入已有的数据x");%
%prenum=input("请输入要预测的数目");%
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
x=reshape(x,length(x),1);
m1=length(x);
subplot(2,2,1);
plot(x);
title('原始数据图像');
subplot(2,2,2);
autocorr(x,length(x)-1);
title('自相关函数图像');
%打断点
ok=1;
while(ok)
    s=input("请输入步差分阶数以消除周期性");
    if(s>=1)
        y={[]};
        for i=s+1:m1
            y{1,1}=[y{1,1} x(i)-x(i-s)];
        end
    else
        y={x'};
    end
    d=input("请输入阶差分系数以消除趋势");
    if(d>=1)
        x1=diff(y{1,1});
        y{1,2}=x1(end);
        for i=1:d-1
            x1=diff(x1);
            if(i==d-1)
                break;
            end
            y{1,i+2}=x1(end);
        end
    else
        x1=y{1,1};
    end
    m2=length(x1);
    subplot(2,2,3);
    plot(x1);
    title("差分后序列图像");
    subplot(2,2,4);
    autocorr(x1,length(x1)-1);
    title("自相关函数图像");
    %打断点
    adf=input("是否进行ADF检验，查看平稳性(h1为1才是平稳),1/0(y/n)");
    %disp("adf="+adf);
    if(adf)
        [h1,p1,adf,ljz]=adftest(x1');
        disp("h1="+h1);disp("p1="+p1);disp("adf="+adf);disp("ljz="+ljz);
    end
    ok=input("是否结束差分？1/0/(y/n)");
    %disp(ok==1);
    if ok==1
        ok=0;
    else 
        if ok==0
            ok=1;
        end
    end
end
disp("接下来进行白噪声检验(p值越小，则越不像白噪声)...");
%yanchi=[6,12,18];
yanchi=[6,12];
[~,pValue,Qstat,CriticalValue]=lbqtest(x1,'lags',yanchi);
fprintf('%15s%15s%15s','延迟阶数','卡方统计量','p值');
fprintf('\n');
for i=1:length(yanchi)
    fprintf('%18f%19f%19f',yanchi(i),Qstat(i),pValue(i));
    fprintf('\n');
end
some=input("截个图，按回车就继续进行");
x1=x1';
LOGL=zeros(6,6);
PQ=zeros(6,6);
for p=0:5
    for q=0:5
        model=arima(p,0,q);
        try
            [fit,~,logL]=estimate(model,x1);
        catch
            fprintf("arima(%1d,%1d,%1d)拟合时有问题\n",p,0,q);
            logL=NaN;
        end
        LOGL(p+1,q+1)=logL;
        PQ(p+1,q+1)=p+q;
    end
end
LOGL=reshape(LOGL,36,1);
PQ=reshape(PQ,36,1);
[aic,bic]=aicbic(LOGL,PQ+1,m2);
disp("接下来用AICBIC方法对模型系数(p,q)进行检验，以确定最合适的系数(p:0-5,q:0-5)");
disp("接下来会出现AIC和BIC矩阵，最好选择AIC或BIC值最小的，并且p,q尽量最小");
fprintf('AIC为:\n');
reshape(aic,6,6)
fprintf('BIC为:\n')
reshape(bic,6,6)
[~,aicno]=min(aic);
aicc=floor(aicno/6);
aicr=mod(aicno,6);
if aicr==0
    aicr=6;
else
    aicc=aicc+1;
end
[~,bicno]=min(bic);
bicc=floor(bicno/6);
bicr=mod(bicno,6);
if bicr==0
    bicr=6;
else
    bicc=bicc+1;
end
fprintf('AIC推荐p,q:  %d   %d\n',aicr,aicc);
fprintf('BIC推荐p,q:  %d   %d\n',bicr,bicc);
p=input("所以你选择的p是");
q=input("所以你选择的q是");
model=arima(p,0,q);
m=estimate(model,x1);
disp("模型是：");
fprintf('(1');
for i=1:p
    if(-m.AR{1,i}>0)
        fprintf('+%sB^%d',-m.AR{1,i},i);
    else
        if -m.AR{1,i}<0
            fprintf('%sB^%d',-m.AR{1,i},i);
        end
    end
end
fprintf(')(1-B)^%d(1-B^%d)(xt+%f)=(1',d,s,m.Constant);
for i=1:q
    if(-m.MA{1,i}>0)
        fprintf('+%sB^%d',-m.MA{1,i},i);
    else
        if -m.MA{1,i}<0
            fprintf('%sB^%d',-m.MA{1,i},i);
        end
    end
end
fprintf(')εt\n');
z=iddata(x1);
pre=armax(z,[p,q]);
e=resid(pre,z);
%e.OutputData
[H,pValue]=lbqtest(e.OutputData,'lags',6);
yf=forecast(m,prenum,'Y0',x1);
for i=1:d
    if i==1
        if i~=d
            yhat=y{1,d-i+1}+cumsum(yf);
        else
            yhat=y{1,d-i+1}(end)+cumsum(yf);
        end
    else
        if i==d
            yhat=y{1,1}(end)+cumsum(yhat);
        else
            yhat=y{1,d-i+1}+cumsum(yhat);
        end
    end
end
if(s==0)
    if d~=0
        xpre=yhat;
    else
        xpre=yf;
    end
else
    for j=1:prenum
        x(m1+j)=yhat(j)+x(m1+j-s);
    end
    xpre=x(m1+1:end);
end
%xpre%
end