function [thetaVec, biasVec] = BPNNF(x, y, layer, lambda, alpha, count, option, oldThetaVec, oldBiasVec)
% BPNNF: implements neural network
% x is a m * Q matrix
% y is a n * Q matrix 
% where Q is number of samples, and m, n are dimentions of input and output
% layer is a struct, layer.num is number of hidden layers, layer.units
% specify numbers of neurons in each hidden layer, respectively
% lambda is the coefficient of regulization term
% alpha is learning rate
% count is number of iteration
% option is about adaptive learning rate algorithms, option.method choose
% methods and option.cof give the corresponding coefficients
% oldThetaVec and oleBiasVec are the parameter you want to train again
% return thetaVec and biasVec, which are weight matrix and bias parameters

% activation function and its derivative function
f = @ReLU;
g = @ReLUDer;
h = @simple;

% adaptive learning rate algorithms options
if (nargin >= 7)
switch(option.method)
    case 'AdaGrad'
        h = @AdaGrad;
    case 'RMSProp'
        h = @RMSProp;
    case 'Adam'
        h = @Adam;


    
end
else
    option.cof = 0;
end

% normalization

%x = range * (x-min(x, [], 2))./(max(x, [], 2)-min(x, [], 2)) - (range / 2) * ones(size(x));

%y = range * (y-min(y, [], 2))./(max(y, [], 2)-min(y, [], 2)) - (range / 2) * ones(size(y));
%y = y .* 100;
% add input and output layers
layer.num = layer.num + 2;
layer.units = [size(x, 1), layer.units, size(y, 1)];


% initialization
originalX = x;
originalY = y;
seq = 1 : (size(x, 2) / 50);
a = containers.Map('KeyType', 'int32', 'ValueType', 'any');
z = containers.Map('KeyType', 'int32', 'ValueType', 'any'); 
thetaVec = containers.Map('KeyType', 'int32', 'ValueType', 'any');
biasVec = containers.Map('KeyType', 'int32', 'ValueType', 'any');  
thetaGrad = containers.Map('KeyType', 'int32', 'ValueType', 'any');
biasGrad = containers.Map('KeyType', 'int32', 'ValueType', 'any');
r = containers.Map('KeyType', 'int32', 'ValueType', 'any');
s = containers.Map('KeyType', 'int32', 'ValueType', 'any');

for i = 1 : layer.num - 1
    thetaVec(i) = rand(layer.units(i + 1), layer.units(i));
    biasVec(i) = rand(layer.units(i + 1), 1);
    thetaGrad(i) = zeros(size(thetaVec(i)));
    biasGrad(i) = zeros(size(biasVec(i)));
    r(i) = zeros(size(thetaGrad(i)));
    r(i + layer.num - 1) = zeros(size(biasGrad(i)));
    s(i) = zeros(size(thetaGrad(i)));
    s(i + layer.num - 1) = zeros(size(biasGrad(i)));
end

if nargin == 9
    thetaVec = oldThetaVec;
    biasVec = oldBiasVec;
end

% number of samples
Q = size(x, 2);
volume = Q;

for iteration = 1 : count
x = originalX(:, seq);
y = originalY(:, seq);
Q = size(x, 2);
%if (mod(iteration, 10) == 0)
seq = mod(seq + length(seq) - 1, volume) + 1;
%end


% forward
a(1) = x;
for i = 1 : layer.num - 1
    z(i + 1) = thetaVec(i) * a(i) + biasVec(i);
    %disp(z(i + 1))
    if i ~= layer.num - 1
        a(i + 1) = f(z(i + 1));
    else 
        a(i + 1) = net(z(i + 1));
    end
end

% predicted values
afinal = a(layer.num);
disp("准确率为："+test(afinal, y, 0));

% display cost
%disp('cost = ');
%disp(sum(sum((-y .* log(afinal)))) / Q);
%plot(iteration, sum(sum((afinal - y) .^ 2)), 'r*');
%hold on;

% bcak propagation
cost = -y + afinal;%afinal(:, i) - y(:, i) ;
for j = layer.num - 1 : -1 : 1
    fDer = g(a(j + 1), z(j + 1));      
    
    if j == layer.num - 1
        thetaGrad(j) = thetaGrad(j) + cost * a(j)' / Q;
        biasGrad(j) = biasGrad(j) + cost * ones(Q, 1) / Q;       
    else
        thetaGrad(j) = thetaGrad(j) + (cost .* fDer) * a(j)' / Q;
        biasGrad(j) = biasGrad(j) + (cost .* fDer) * ones(Q, 1) / Q;
    end
    if j == layer.num - 1
        cost =  thetaVec(j)' * cost;
    else
        cost =  thetaVec(j)' * (cost .* fDer);
    end
end


% gradient descent
for i = 1 : layer.num - 1
    [thetaGrad(i), r(i), s(i)] = h(thetaGrad(i), alpha, r(i), s(i), option.cof, iteration);
    [biasGrad(i), r(i + layer.num - 1), s(i + layer.num - 1)] = h(biasGrad(i), alpha, r(i + layer.num - 1), s(i + layer.num - 1), option.cof, iteration);
    thetaVec(i) = thetaVec(i) + thetaGrad(i) + lambda * thetaVec(i) / Q;
    biasVec(i) = biasVec(i) + biasGrad(i) + lambda * biasVec(i) / Q;
    thetaGrad(i) = zeros(size(thetaGrad(i)));
    biasGrad(i) = zeros(size(biasGrad(i)));
end
end
end

function [deltaGrad, newR, newS]  = simple(g, alpha, r, s, ~, ~)
    deltaGrad = -alpha * g;
    newR = r;
    newS = s;
end

function [deltaGrad, newR, newS] = AdaGrad(g, alpha, r, s, ~, ~) 
    newR = r + g.^2;
    deltaGrad = -(alpha ./ (1e-7 + sqrt(newR))) .* g;  
    newS = s;
end

function [deltaGrad, newR, newS] = RMSProp(g, alpha, r, s, p, ~)
    newR = p * r + (1 - p) * g.^2;
    deltaGrad = -(alpha ./ sqrt(1e-6 + newR)) .* g;   
    newS = s;
end

function [deltaGrad, newR, newS] = Adam(g, alpha, r, s, cof, t)
    newS = cof(1) * s + (1 - cof(1)) * g;
    newR = cof(2) * r + (1 - cof(2)) * g.^2;
    sEst = newS / (1 - cof(1).^t);
    rEst = newR / (1 - cof(2).^t);
    deltaGrad = -alpha * (sEst ./ (sqrt(rEst) + 1e-8));
    
end




