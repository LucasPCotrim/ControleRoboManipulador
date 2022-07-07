function plotStateProbs(net,s)
% Fun��o que recebe rede DQN e estado e plota os valores Q de cada a��o em
% um mesmo gr�fico para aquele estado.
global output_dim;

y = net_output(net,s);
figure
plot(1:output_dim,y');
hold on
scatter(1:output_dim,y','.');
title('PGKuka: Probabilidades de a��es em estado inicial \pi(a|s_0)')
xlabel('A��o a_i')
ylabel('Probabilidade \pi(a_i|s_0)')

hold off
end

