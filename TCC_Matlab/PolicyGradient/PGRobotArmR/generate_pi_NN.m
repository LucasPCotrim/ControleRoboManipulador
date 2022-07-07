global s_0;
pi_NN = NN(5,5,3);
while(1)
    pi_NN = NN(5,5,3);
    pi_NN = pi_NN.NN_set_inputs(s_0);
    pi_NN = pi_NN.NN_evaluate_outputs();
    if (pi_NN.Outputs(1)<0.35 && pi_NN.Outputs(2)<0.35 && pi_NN.Outputs(3)<0.35)
        break;
    end
end

