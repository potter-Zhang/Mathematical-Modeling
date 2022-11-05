function [] = checkGrad(D, gradVec)
% 检查两个map是否差很多

if ~isa(D, 'containers.Map') || ~isa(gradVec, 'containers.Map')
    disp('参数必须是containers.Map');   
    return;
end

disp('start checking...');

for i = 1 : D.Count
    d=D(i);
    g=gradVec(i);
    [m,n]=size(d);
    for j=1:m
        for k=1:n
            if(abs((d(j,k)-g(j,k))/g(j,k))>1e-2)
                disp(j);
                disp(k);
                break;
            end
        end
    end
end

disp('end of check');

end