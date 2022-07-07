% Trajectory tau given current policy NN_obj and state initial_state.
function [f, g, h, i, j] = generate_episode (NN_obj, initial_state) %Returns trajectory tau given current policy NN_obj and state initial_state.
    global T;
    global gamma;
    global terminate;
    
    tau_S = zeros(T-1,length(initial_state));
    tau_A = zeros(T-1,1);
    tau_R = zeros(T,1);
    tau_R(1,1) = 0;
    G = zeros(T-1,1);
    
    i_final = T-1;
    s = initial_state;
    terminate = false;
    for i = 1:T-1
        tau_S(i,:) = s;
        a = action (NN_obj, s);
        tau_A(i,1) = a;
        s_new = dynamics(s, a);
        %tau_R(i+1,1) = reward(s_new);
        tau_R(i+1,1) = reward_2(s,a);
        
        s = s_new;
        
        if terminate
            tau_S(i+1,:) = s;
            i_final = i;
            break;
        end
    end
    
    G(i_final,1) = tau_R(i_final+1,1);
    for i = (i_final-1):-1:1
        G(i,1) = tau_R(i+1,1) + gamma*G(i+1,1);
    end
    
    f = tau_S;
    g = tau_A;
    h = tau_R;
    i = G;
    j = i_final;
end