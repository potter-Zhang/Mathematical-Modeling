function [con,fea,new] = PCA(x)
%PCA(Principal Component Analysis) 主成分分析
%x为一个矩阵，每一列为不同的指标，每一行为不同的样本
%con各主成分的贡献率（从小到大），fea特征向量矩阵（对应于con）
%new为一个矩阵，每一列为不同的主成分指标，每一行为不同的样本
%   此处显示详细说明
%z=zscore(x);去中心化后又除了方差
z=x-mean(x);
r=cov(z);
[fea,lamdiag]=eig(r);%lamdiag为特征值对角矩阵
lam=zeros(1,length(lamdiag));%lam为包含特征值的数组
for i=1:length(r)
    lam(i)=lamdiag(i,i);
end
con=lam/sum(lam);
new=z*fea;
end

