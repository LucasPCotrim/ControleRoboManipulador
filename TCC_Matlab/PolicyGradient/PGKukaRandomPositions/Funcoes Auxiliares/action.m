function f = action(net,s)
% Função que recebe a rede neural da política de ações e o estado atual e
% retorna a ação a ser tomada, realizando o processo de escolha por meio de
% roleta, com probabilidades de cada ação dadas pela saída da rede.

% Input: net - Rede Neural que representa a política de ações do agente.
% Input: x - Estado atual no qual o agente se encontra.
global A;

y = net_output(net,s);
action_index = rouletteWheelSelection(y);
f = A(action_index,:);
end

