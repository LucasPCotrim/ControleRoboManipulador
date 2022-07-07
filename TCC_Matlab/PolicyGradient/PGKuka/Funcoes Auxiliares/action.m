function f = action(net,s)
% Fun��o que recebe a rede neural da pol�tica de a��es e o estado atual e
% retorna a a��o a ser tomada, realizando o processo de escolha por meio de
% roleta, com probabilidades de cada a��o dadas pela sa�da da rede.

% Input: net - Rede Neural que representa a pol�tica de a��es do agente.
% Input: x - Estado atual no qual o agente se encontra.
global A;

y = net_output(net,s);
action_index = rouletteWheelSelection(y);
f = A(action_index,:);
end

