function [f,g] = findGoodPolicy(numTries)
% Função que inicializa aleatoriamente diversas redes neurais e retorna
% aquela correspondente à melhor política de ações

global input_dim;
global n_layers;
global output_dim;

global S_0;

net_best = createNN(input_dim,n_layers,output_dim);
tau_best = generateTrajectory(net_best,S_0);
Performance_best = tau_best.G(1);
fprintf('Policy number: %d , Performance: %d \n',1,Performance_best);

for i = 2:numTries
    net = createNN(input_dim,n_layers,output_dim);
    tau = generateTrajectory(net,S_0);
    Performance = tau.G(1);
    
    fprintf('Policy number: %d , Performance: %d \n',i,Performance);
    
    if(Performance > Performance_best)
        net_best = net;
        Performance_best = Performance;
        tau_best = tau;
    end
    
    fprintf('Best Performance: %d  \n',Performance_best);
end
f = net_best;
g = tau_best;
end


