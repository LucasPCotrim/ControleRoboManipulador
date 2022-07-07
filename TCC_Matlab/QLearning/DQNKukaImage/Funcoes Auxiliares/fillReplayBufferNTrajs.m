function f = fillReplayBufferNTrajs(transitionBuffer,dqn,epoch_index,eps_init)
% Função que recebe um Replay Buffer de Transições vazio e uma rede dqn e
% retorna o buffer com experiência gerada pela rede dqn
global S_0;
global Q;
global A;
global T;
global epsilonDecay;
global terminate;
global Ntrajs;
global epochBuffer;
global gamma; 

n = 1;
fprintf('Fill Replay Buffer with %d trajectories... \n', Ntrajs);
for tr_index = 1:Ntrajs
    if (tr_index == 1 || rem(tr_index,10) == 0)
        fprintf('Trajectory: %d \n', tr_index);
    end
    s = S_0;
    epsilon = eps_init;
    
    tau_S = zeros(T-1,length(S_0));
    tau_A = zeros(T-1,size(A,2));
    tau_R = zeros(T,1);
    tau_R(1,1) = 0;
    tau_Q = zeros(T-1,6);
    G = zeros(T-1,1);
    i_final = T-1;
    
    for i = 1:T
        tau_S(i,:) = s;
        tau_Q(i,:) = Q;
        
        a = action(dqn,s,epsilon);
        tau_A(i,:) = a;
        
        s_new = dynamics(s,a);
        r = reward_3(s,s_new);
        tau_R(i+1,1) = r;
        
        current_transition = transition(s,a,r,s_new,i,terminate);
        transitionBuffer.transitions(n) = current_transition;
        transitionBuffer.n_transitions = n;
        n = n+1;
        
        if (terminate == true)
            tau_S(i+1,:) = s;
            i_final = i;
            terminate = false;
            break;
        end
        
        s = s_new;
        epsilon = epsilon*epsilonDecay;
    end
    
    G(i_final,1) = tau_R(i_final+1,1);
    for t = (i_final-1):-1:1
        G(t,1) = tau_R(t+1,1) + gamma*G(t+1,1);
    end
    traj = tau(tau_S,tau_A,tau_R,tau_Q,G,i_final);
    
    % Store trajectory in epoch
    epochBuffer.eps(epoch_index).trajs(tr_index) = traj;
    
end
f = transitionBuffer;
end

