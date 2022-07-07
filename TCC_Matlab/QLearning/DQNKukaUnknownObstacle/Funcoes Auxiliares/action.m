function f = action(dqn,s,prob)
% Função que retorna a ação a ser tomada dada a DQN, o estado s e a
% probabilidade epsilon-greedy de se tomar uma ação aleatória.
global A;
global output_dim;

if (rand > prob)
    y = net_output(dqn,s);
    [~,a_index] = max(y);
else
    a_index = randi([1 output_dim]);
end

f = A(a_index,:);
end
