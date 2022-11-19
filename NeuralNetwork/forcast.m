function [output] = forcast(test, x,y, thetaVec)
%UNTITLED6 此处提供此函数的摘要
%   此处提供详细说明
test=test';
x=x';
y=y';
test=2*(test-min(x))./(max(x)-min(x))-ones(size(test));

output=zeros(size(y,1),size(test,2));
for each=1:size(test,2)
    xx=test(:,each);
hide=tansig(thetaVec.w1'*xx+thetaVec.b1);

%隐藏层到输出层
output(each)=thetaVec.w2'*hide+thetaVec.b2';
end

output = (output + ones(size(output))) .* (max(y) - min(y)) / 2 + min(y);
output=output';
end