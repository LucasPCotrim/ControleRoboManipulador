function f = maxQ(dqn,s)
% Fun��o que recebe a dqn e o estado s e retorna o maior valor de Q(s,a')
% para todo a'.

y = net_output(dqn,s);
[m,~] = max(y);

f = m;
end

