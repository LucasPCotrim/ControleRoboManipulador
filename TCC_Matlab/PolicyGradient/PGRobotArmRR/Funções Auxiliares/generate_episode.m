function f = generate_episode(NN_obj,initial_state,N_trajs)
    global T;
    global gamma;
    global terminate;
    
    taus = trajectories(N_trajs);
    
    for trajectory_index = 1:N_trajs
        
        tau_S = zeros(T-1,length(initial_state));
        tau_A = zeros(T-1,2);
        tau_R = zeros(T,1);
        tau_R(1,1) = 0;
        G = zeros(T-1,1);
        
        i_final = T-1;
        s = initial_state;
        terminate = false;
        
        traj = tau(tau_S,tau_A,tau_R,G,i_final);
        
        for i = 1:T-1
            tau_S(i,:) = s;
            a = action (NN_obj, s);
            tau_A(i,:) = a;
            s_new = dynamics(s, a);
            tau_R(i+1,1) = reward_2(s,a);
            %tau_R(i+1,1) = reward_3(s,a);
            
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
        
        traj.tau_S = tau_S;
        traj.tau_A = tau_A;
        traj.tau_R = tau_R;
        traj.G = G;
        traj.i_final = i_final;
        
        taus.trajs(trajectory_index) = traj;
        
    end
    
    f = taus;
end

