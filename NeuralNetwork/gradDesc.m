function newThetaVec = gradDesc(thetaVec, D, alpha)
% 梯度下降函数
%   

for i = 1 : thetaVec.Count
    thetaVec(i) = thetaVec(i) - alpha * D(i);
end

newThetaVec = thetaVec;

end