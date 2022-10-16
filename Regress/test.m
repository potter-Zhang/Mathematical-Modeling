%测试函数
function p=test(x,y,w)
[n, ~] = size(x);

  x = [ones(n, 1), x];

  y_hat=net(x*w);
  [~,index]=max(y_hat,[],2);
  sum=0;
  for i=1:length(y)
      if index(i)==y(i)+1
          sum=sum+1;
      end
  end
  p=sum/length(y);
  sum
end