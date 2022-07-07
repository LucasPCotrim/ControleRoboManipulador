function plotGreedyTrajectory(dqn,s_0)
% Função que recebe rede DQN e estado inicial e plota trajetória gerada
% pela rede escolhendo as ações com maiores Q-Values.
global Q_0;
global Q;
global S_0;
global T;
global terminate;
global A;
global gamma;

Q = Q_0;
s = s_0;

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

    a = action(dqn,s,0);
    tau_A(i,:) = a;

    s_new = dynamics(s,a);
    r = reward_2(s,s_new);
    tau_R(i+1,1) = r;

    if (terminate == true)
        tau_S(i+1,:) = s;
        i_final = i;
        terminate = false;
        break;
    end
    s = s_new;
end

G(i_final,1) = tau_R(i_final+1,1);
for t = (i_final-1):-1:1
    G(t,1) = tau_R(t+1,1) + gamma*G(t+1,1);
end
traj = tau(tau_S,tau_A,tau_R,tau_Q,G,i_final);

plotTrajectory(traj);
end

