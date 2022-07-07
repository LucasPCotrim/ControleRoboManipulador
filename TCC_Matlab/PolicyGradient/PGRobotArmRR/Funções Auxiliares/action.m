% Action chosen given state and NN (policy_function)
function f = action (NN_obj, state)
    global A;
    NN_obj = NN_obj.NN_set_inputs(state);
    NN_obj = NN_obj.NN_evaluate_outputs();
    r = rand;
    [Outputs_sorted, I_sorted] = sort(NN_obj.Outputs);
    if (r < Outputs_sorted(1))
        a = A(I_sorted(1),:);
    elseif (r >= Outputs_sorted(1) && r < Outputs_sorted(2)+Outputs_sorted(1))
        a = A(I_sorted(2),:);
    elseif (r >= Outputs_sorted(2) && r < Outputs_sorted(3)+Outputs_sorted(2)+Outputs_sorted(1))
        a = A(I_sorted(3),:);
    elseif (r >= Outputs_sorted(3) && r < Outputs_sorted(4)+Outputs_sorted(3)+Outputs_sorted(2)+Outputs_sorted(1))
        a = A(I_sorted(4),:);
    elseif (r >= Outputs_sorted(4) && r < Outputs_sorted(5)+Outputs_sorted(4)+Outputs_sorted(3)+Outputs_sorted(2)+Outputs_sorted(1))
        a = A(I_sorted(5),:);
    elseif (r >= Outputs_sorted(5) && r < Outputs_sorted(6)+Outputs_sorted(5)+Outputs_sorted(4)+Outputs_sorted(3)+Outputs_sorted(2)+Outputs_sorted(1))
        a = A(I_sorted(6),:);
    elseif (r >= Outputs_sorted(6) && r < Outputs_sorted(7)+Outputs_sorted(6)+Outputs_sorted(5)+Outputs_sorted(4)+Outputs_sorted(3)+Outputs_sorted(2)+Outputs_sorted(1))
        a = A(I_sorted(7),:);
    elseif (r >= Outputs_sorted(7) && r < Outputs_sorted(8)+Outputs_sorted(7)+Outputs_sorted(6)+Outputs_sorted(5)+Outputs_sorted(4)+Outputs_sorted(3)+Outputs_sorted(2)+Outputs_sorted(1))
        a = A(I_sorted(8),:);
    else
        a = A(I_sorted(9),:);
    end
    
    f = a;
end
