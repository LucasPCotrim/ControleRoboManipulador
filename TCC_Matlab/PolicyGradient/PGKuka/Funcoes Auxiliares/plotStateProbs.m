function plotStateProbs(net,s)
% Função que recebe rede DQN e estado e plota os valores Q de cada ação em
% um mesmo gráfico para aquele estado.
global output_dim;

y = net_output(net,s);
figure
plot(1:output_dim,y');
hold on
scatter(1:output_dim,y','.');
title('PGKuka: Probabilidades de ações em estado inicial \pi(a|s_0)')
xlabel('Ação a_i')
ylabel('Probabilidade \pi(a_i|s_0)')

hold off
end

