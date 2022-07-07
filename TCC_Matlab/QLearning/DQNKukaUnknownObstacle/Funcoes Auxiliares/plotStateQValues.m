function f = plotStateQValues(dqn,s)
% Função que recebe rede DQN e estado e plota os valores Q de cada ação em
% um mesmo gráfico para aquele estado.
global output_dim;

y = net_output(dqn,s);
figure
plot(1:output_dim,y');
hold on
scatter(1:output_dim,y','.');
hold off

f = y;
end
