function [dydb1, dydw1, dydb2, dydw2, dydb3, dydw3] = partialDerivatives(net, x)
% Função que recebe a rede feedforward completamente conectada net e
% retorna a derivada de suas saídas com relação a cada um dos pesos.
% Input: net - Objeto da classe Neural Network com dados da rede
% Output: dwb - Matriz que contém as derivadas parciais (dy_k/dw(L)_ij)
input_size = net.inputs{1}.size;
n_layers = net.numLayers;
output_size = net.outputs{n_layers}.size;

x_norm = normalizeInputs(x);

dwb = defaultderiv('de_dwb',net,x_norm,zeros(output_size,1));

% Layer 1
%--------------------------------------------------------------------------
% Bias
a = 1;
b = a + size(net.b{1},1) - 1;
dydb1 = -dwb(a:b,:);
% Weights
a = b + 1;
b = a + numel(net.IW{1}) - 1;
dydw1 = -dwb(a:b,:);

% Layer 2
%--------------------------------------------------------------------------
% Bias
a = b + 1;
b = a + size(net.b{2},1) - 1;
dydb2 = -dwb(a:b,:);
% Weights
a = b + 1;
b = a + numel(net.LW{2,1}) - 1;
dydw2 = -dwb(a:b,:);

% Layer 3
%--------------------------------------------------------------------------
% Bias
a = b + 1;
b = a + size(net.b{3},1) - 1;
dydb3 = -dwb(a:b,:);
% Weights
a = b + 1;
b = a + numel(net.LW{3,2}) - 1;
dydw3 = -dwb(a:b,:);

end

