function f = findBalancedPolicy()
% Função que retorna uma rede neural correspondente a uma política
% equilibrada, com probabilidades de mesma ordem de grandeza para
% diferentes ações.

global input_dim;
global n_layers;
global output_dim;

global S_0;

balanced = false;
%i = 1;
while(balanced == false)
    %disp(i);
    net = createNN(input_dim,n_layers,output_dim);
    output = net_output(net,S_0);
    m = max(output);
    if(m < 0.018)
        balanced = true;
    end
    %i = i+1;
end
f = net;
end

