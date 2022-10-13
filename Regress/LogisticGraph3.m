function [] = LogisticGraph3(label,x,w)
%logistic画图
%   此处显示详细说明
for i=1:length(x)
    if(label(i)) 
        scatter3(x(i,1),x(i,2),x(i,3),5,'g','filled');
    else
        scatter3(x(i,1),x(i,2),x(i,3),5,'r','filled');
    end
    hold on;
end
largest=abs(max(max(x)));
interval=largest/50;
[x1,x2]=meshgrid(-largest:interval:largest);
x3=zeros(101,101);
for i=1:101
    for j=1:101
        x3(i,j)=(-w(1)-w(2)*x1(i,j)-w(3)*x2(i,j))/w(4);
    end
end
hold on;
mesh(x1,x2,x3);
end

