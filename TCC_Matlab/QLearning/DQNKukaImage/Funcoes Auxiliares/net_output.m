function f = net_output(dqn,features)
% Fun��o que recebe input da rede, normaliza segundo a range de cada campo,
% chama a rede e retorna a sa�da.
% f_norm = normalizeInputs(f);

f = dqn(features);
end




