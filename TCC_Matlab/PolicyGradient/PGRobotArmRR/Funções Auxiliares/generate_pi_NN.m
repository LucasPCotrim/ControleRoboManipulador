function f = generate_pi_NN(n_inputs,n_hidden,n_outputs)
    global s_0
    while(1)
        pi_NN = NN(n_inputs,n_hidden,n_outputs);
        pi_NN = pi_NN.NN_set_inputs(s_0);
        pi_NN = pi_NN.NN_evaluate_outputs();
        if (pi_NN.Outputs(1)>(2/9))
            continue;
        elseif (pi_NN.Outputs(2)>(2/9))
            continue;
        elseif (pi_NN.Outputs(3)>(2/9))
            continue;
        elseif (pi_NN.Outputs(4)>(2/9))
            continue
        elseif (pi_NN.Outputs(5)>(2/9))
            continue;
        elseif (pi_NN.Outputs(6)>(2/9))
            continue;
        elseif (pi_NN.Outputs(7)>(2/9))
            continue;
        elseif (pi_NN.Outputs(8)>(2/9))
            continue;
        elseif (pi_NN.Outputs(9)>(2/9))
            continue;
        end
        break;
    end
    f = pi_NN;
end

