function f = net_output(net,s)
% Função que recebe input da rede, normaliza segundo a range de cada campo,
% chama a rede e retorna a saída.
s_norm = normalizeInputs(s);

f = net(s_norm);
end




