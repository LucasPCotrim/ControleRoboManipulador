function f = plotStateQValues(dqn,s)
% Função que recebe rede DQN e estado e plota os valores Q de cada ação em
% um mesmo gráfico para aquele estado.
global output_dim;

y = net_output(dqn,s);
figure
plot(1:output_dim,y');
hold on
scatter(1:output_dim,y','.');
title('DQNKuka\_RandomPositions: Q(s_0,a)')
xlabel('Action a_i')
ylabel('Q(s_0,a_i)')
hold off

f = y;
end