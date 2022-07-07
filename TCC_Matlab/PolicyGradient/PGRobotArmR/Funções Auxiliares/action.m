function f = action (NN_obj, state)
    global A;
    NN_obj = NN_obj.NN_set_inputs(state);
    NN_obj = NN_obj.NN_evaluate_outputs();
%     r = rand;
%     [Outputs_sorted, I_sorted] = sort(NN_obj.Outputs);
%     if (r < Outputs_sorted(1))
%         f = A(I_sorted(1));
%     elseif (r >= Outputs_sorted(1) && r < Outputs_sorted(2)+Outputs_sorted(1))
%         f = A(I_sorted(2));
%     else
%         f = A(I_sorted(3));
%     end
    i = RouletteWheelSelection(transpose(NN_obj.Outputs));
    f = A(i);
end