function f = action(dqn,s,prob)
% Fun��o que retorna a a��o a ser tomada dada a DQN, o estado s e a
% probabilidade epsilon-greedy de se tomar uma a��o aleat�ria.
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
