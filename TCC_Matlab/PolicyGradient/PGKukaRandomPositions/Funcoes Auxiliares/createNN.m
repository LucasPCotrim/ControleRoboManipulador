function NeuralNetwork = createNN(InputSize,NLayers,OutputSize)
%CreateNN: Função para criação de feedforward fully connected neural
%network
numInputs = 1;
numLayers = NLayers;
biasConnect = ones(numLayers,1);
inputConnect = zeros(numLayers,numInputs);
inputConnect(1,:) = ones(1,numInputs);
layerConnect = zeros(numLayers,numLayers);
for i = 1:numLayers-1
    layerConnect(i+1,i) = 1;
end
outputConnect = zeros(1,numLayers);
outputConnect(1,end) = 1;

net =  network(numInputs,numLayers,biasConnect,inputConnect,layerConnect,outputConnect);

for i = 1:numInputs
    net.inputWeights{1,i}.initFcn = 'rands';
end
for i = 1:numLayers-1
    net.layerWeights{i+1,i}.initFcn = 'rands';
end
for i = 1:numLayers
    net.biases{i,1}.initFcn = 'rands';
end

for i = 1:numInputs
    net.inputs{i}.size = InputSize;
end
for i = 1:numLayers
    %net.layers{i}.transferFcn = 'poslin';
    net.layers{i}.initFcn = 'initwb';
    
    net.layers{i}.transferFcn = 'satlins';
%   net.layers{i}.initFcn = 'initnw';
    
    net.layers{i}.size = 300;
end
net.layers{1}.size = 100;

net.layers{numLayers}.size = OutputSize;
net.layers{numLayers}.transferFcn = 'softmax';

net = init(net);

% Xavier Weight Initialization
net.IW{1,1} = net.IW{1,1}*(sqrt(6)/sqrt(InputSize+net.layers{1}.size));
net.LW{2,1} = net.LW{2,1}*(sqrt(6)/sqrt(net.layers{1}.size+net.layers{2}.size));
net.LW{3,2} = net.LW{3,2}*(sqrt(6)/sqrt(net.layers{2}.size+net.layers{3}.size));

NeuralNetwork = net;
end


