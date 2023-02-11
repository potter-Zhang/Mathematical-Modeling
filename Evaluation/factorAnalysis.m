function [a,coef,con,k,myTable] = factorAnalysis(x,keys)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明
%   x原始数据，行为样本，列为特征,keys为对应样本的关键字序列（可以没有）
%   a:因子载荷矩阵,coef:因子得分的估计系数(公共因子关于xi的系数:fi=Σaijxi)
%   con:公共因子的贡献率,k:选择的公共因子个数（前几个）,myTable:关键字，第一公共因子的打分，第二...，综合分数
%   对于给定的样本矩阵x0，用公式x0*coef*con'就可以得到综合分数了,其中x0*coef为k个公共因子的打分
bzhx=zscore(x);
r=corrcoef(bzhx);
[vec1,tz1,con1]=pcacov(r);
s=0;
for i=1:length(r)
    s=s+con1(i);
    if s>80
        break;
    end
end
k=i;%k=2;
f1=repmat(sign(sum(vec1)),size(vec1,1),1);
vec1=vec1.*f1;
a=vec1*sqrt(diag(tz1));
am=rotatefactors(a(:,1:k),'method','varimax');
p=sum(am.^2);
con=p/sum(p);
coef=r\am;
score=bzhx*coef;
Tscore=score*con';
[STscore,id]=sort(Tscore,'descend');
if nargin==1
    myTable=table(id,score,STscore,'VariableNames',{'关键字','公共因子的打分','综合分数'});
else
    myTable=table(keys(id)',score(id,:),STscore,'VariableNames',{'关键字','公共因子的打分','综合分数'});
end

end