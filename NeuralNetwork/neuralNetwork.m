% 随机初始化thetaVec
[thetaVec, triangle] = randomInit(layer, epsilon);
tmp = triangle;

% 前后向反复传播学习
flag=0;
for j = 1 : count
%     if flag==0 && j>0.9*count && alpha<0.5
%         alpha=10*alpha;
%         flag=1;
%     end
    for i = 1 : m
        [a, z] = forProp(thetaVec, x(i, :), fun);
        triangle = backProp(y(i, :), thetaVec, triangle, a, z, funder);
        %ytp(i, :) = a(thetaVec.Count+1)';
    end
    D = calGrad(triangle, thetaVec, m, lambda);
    %gradVec = gradApprox(@costFunction, thetaVec, x, y, lambda);
    %checkGrad(D, gradVec);
    thetaVec = gradDesc(thetaVec, D, alpha);
    triangle = tmp;
    %disp(size(triangle(1)));disp(size(thetaVec(1)));disp(size(triangle(2)));disp(size(thetaVec(2)))%
end



end
