function f = net_output(dqn,features)
% Função que recebe input da rede, normaliza segundo a range de cada campo,
% chama a rede e retorna a saída.
% f_norm = normalizeInputs(f);

f = dqn(features);
end




