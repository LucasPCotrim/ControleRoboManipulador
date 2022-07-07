function f = generate_piNN(x,y,z)
% Função que gera política de ações pi equilibrada
global s_0;
while(1)
    pi_NN = NN(x,y,z);
    pi_NN = pi_NN.NN_set_inputs(s_0);
    pi_NN = pi_NN.NN_evaluate_outputs();
    if (pi_NN.Outputs(1)<0.35 && pi_NN.Outputs(2)<0.35 && pi_NN.Outputs(3)<0.35)
        break;
    end
end
f = pi_NN;
end

