function [f,g] = trainedInitialNetwork()
% Função que cria uma rede inicial e a treina para que as probabilidades de
% ações em estados próximos ao inicial sejam iguais.

global input_dim;
global n_layers;
global output_dim;


net = createNN(input_dim,n_layers,output_dim);

net.trainFcn = 'traingd';
net.trainParam.epochs = 3000;

x = generateStateDiscretization();

t = (1/output_dim)*ones(output_dim,1);
t = repmat(t,1,size(x,2));

[net,tr] = train(net,x,t);
%[net,tr] = train(net,x,t,'useGPU','yes');

f = net;
g = tr;
end

