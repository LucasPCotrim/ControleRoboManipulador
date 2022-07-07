function plotStateProbs(net,s)
% Fun��o que recebe rede DQN e estado e plota os valores Q de cada a��o em
% um mesmo gr�fico para aquele estado.
global output_dim;

y = net_output(net,s);
figure
plot(1:output_dim,y');
hold on
scatter(1:output_dim,y','.');
hold off
end

