function f = gradient_ascent(NN_obj, tau_S, tau_A, G, i_final)% Update network weights (Gradient Ascent)
    global alpha;
    global gamma;
    global s_0;
    
    W2_new = NN_obj.W2;
    W1_new = NN_obj.W1;
    
    NN_obj = NN_obj.NN_set_inputs(s_0);
    NN_obj = NN_obj.NN_evaluate_outputs();
    
    i_max = length(NN_obj.Inputs);
    j_max = length(NN_obj.A1);
    for t = 1:i_final
        s = transpose(tau_S(t,:));
        NN_obj = NN_obj.NN_set_inputs(s);
        NN_obj = NN_obj.NN_evaluate_outputs();
        a = tau_A(t,:);
        switch a(1)
            case 1
                if (a(2) == 1)
                    k = 1;
                elseif(a(2) == 0)
                    k = 2;
                elseif(a(2) == -1)
                    k = 3;
                end
            case 0
                if (a(2) == 1)
                    k = 4;
                elseif(a(2) == 0)
                    k = 5;
                elseif(a(2) == -1)
                    k = 6;
                end
            case -1
                if (a(2) == 1)
                    k = 7;
                elseif(a(2) == 0)
                    k = 8;
                elseif(a(2) == -1)
                    k = 9;
                end
        end
        for j = 1:j_max
            W2_new(k,j) = NN_obj.W2(k,j) + alpha*(gamma^t)*G(t,1)*(NN_obj.NN_partial_derivative_2(k,j) / NN_obj.Outputs(k,1));
        end
        for j = 1:j_max
            for i = 1:i_max
                W1_new(j,i) = NN_obj.W1(j,i) + alpha*(gamma^t)*G(t,1)*(NN_obj.NN_partial_derivative_1(k,j,i) / NN_obj.Outputs(k,1));
            end
        end
        
        NN_obj.W2 = W2_new;
        NN_obj.W1 = W1_new;
    end
    f = NN_obj;
end