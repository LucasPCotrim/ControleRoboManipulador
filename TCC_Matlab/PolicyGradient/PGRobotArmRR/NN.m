classdef NN
    properties
        Inputs;
        W1;
        A1;
        Z1;
        W2;
        A2;
        Outputs;
    end
    methods
        function obj = NN(number_inputs, number_neurons_hidden, number_outputs) %Constructor (init random weights)
            obj.W1 = 2*rand(uint16(number_neurons_hidden),uint16(number_inputs) + 1)-1;
            obj.W2 = 2*rand(uint16(number_outputs), uint16(number_neurons_hidden) + 1)-1;
        end
        
        function obj = NN_setweights(obj,W1,W2)
            obj.W1 = W1;
            obj.W2 = W2;
        end
        
        function obj = NN_set_inputs(obj,X)
            aux = zeros(length(X)+1,1);
            aux(1,1) = 1;
            for i = 1:length(X)
                aux(i+1,1) = X(i,1);
            end
            aux(2,1) = aux(2,1)/180;
            aux(3,1) = aux(3,1)/180;
            aux(4,1) = aux(4,1)/25;
            aux(5,1) = aux(5,1)/25;
            aux(6,1) = aux(6,1)/25;
            aux(7,1) = aux(7,1)/25;
            obj.Inputs = aux;
        end
        
        function obj = NN_evaluate_outputs(obj)
            a1 = obj.W1 * obj.Inputs;
            z1 = zeros(length(a1)+1,1);
            z1(1,1) = 1;
            z1(2:end,1) = sigmoid(a1);
            a2 = obj.W2 * z1;
            obj.A1 = a1;
            obj.Z1 = z1;
            obj.A2 = a2;
            obj.Outputs = softmax(a2);
        end
        
        function f = NN_partial_derivative_2(obj,k,j) %d(y_k)/d(w2_k,j)
            f = obj.Z1(j) * obj.Outputs(k) * (1 - obj.Outputs(k));
        end
        
        function f = NN_partial_derivative_1(obj,k,j,i) %d(y_k)/d(w1_j,i)
            dzj_dwji = sigmoid(obj.A1(j))*(1 - sigmoid(obj.A1(j))) * obj.Inputs(i);
%             if (ReLu(obj.A1(j)) > 0)
%                 dzj_dwji = obj.Inputs(i);
%             else
%                 dzj_dwji = 0;
%             end
            
            if (k == 1)
                aux1 = obj.Outputs(k)*(1 - obj.Outputs(k)) * obj.W2(1,j) * dzj_dwji;
                aux2 = -obj.Outputs(2)*obj.Outputs(k) * obj.W2(2,j) * dzj_dwji;
                aux3 = -obj.Outputs(3)*obj.Outputs(k) * obj.W2(3,j) * dzj_dwji;
                f = aux1 + aux2 + aux3;
            elseif (k == 2)
                aux1 = -obj.Outputs(1)*obj.Outputs(k) * obj.W2(1,j) * dzj_dwji;
                aux2 = obj.Outputs(k)*(1 - obj.Outputs(k)) * obj.W2(2,j) * dzj_dwji;
                aux3 = -obj.Outputs(3)*obj.Outputs(k) * obj.W2(3,j) * dzj_dwji;
                f = aux1 + aux2 + aux3;
            else
                aux1 = -obj.Outputs(1)*obj.Outputs(k) * obj.W2(1,j) * dzj_dwji;
                aux2 = -obj.Outputs(2)*obj.Outputs(k) * obj.W2(2,j) * dzj_dwji;
                aux3 = obj.Outputs(k)*(1 - obj.Outputs(k)) * obj.W2(3,j) * dzj_dwji;
                f = aux1 + aux2 + aux3;
            end
        end
    end
end

function f = softmax(Z)
    aux = zeros(length(Z),1);
    for i = 1:length(Z)
        aux(i,1) = exp(Z(i));
    end
    f = aux/sum(aux);
end

function f = sigmoid(A)
    aux = zeros(length(A),1);
    for i = 1:length(aux)
        aux(i) = 1/(1+exp(-A(i)));
    end
    f = aux;
end

function f = ReLu(A)
    aux = zeros(length(A),1);
    for i = 1:length(aux)
        vec = [0, A(i)];
        aux(i) = max(vec);
    end
    f = aux;
end