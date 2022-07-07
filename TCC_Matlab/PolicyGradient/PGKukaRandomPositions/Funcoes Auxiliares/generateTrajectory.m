function f = generateTrajectory(net,s_0)
% Função que recebe a política de ações e o estado inicial, simula e
% retorna os parâmetros da trajetória percorrida segundo a polítia de
% ações.

% Input: net - Rede Neural que representa a política de ações utilizada.
% Input: s_0 - Estado Inicial.
% Output: f - Objeto da classe tau que contém dados da trajetória
% percorrida.

global A;
global T;
global gamma;
global terminate;
global Q;
global Q_0;
global t;

tau_S = zeros(T-1,length(s_0));
tau_A = zeros(T-1,size(A,2));
tau_R = zeros(T,1);
tau_R(1,1) = 0;
tau_Q = zeros(T-1,6);
G = zeros(T-1,1);

i_final = T-1;
s = s_0;
terminate = false;

traj = tau(tau_S,tau_A,tau_R,tau_Q,G,i_final);
for t = 1:T-1
    tau_S(t,:) = s;
    tau_Q(t,:) = Q;
    a = action(net, s);
    tau_A(t,:) = a;
    s_new = dynamics(s, a);
    tau_R(t+1,1) = reward_3(s,s_new);
    
    s = s_new;

    if terminate
        tau_S(t+1,:) = s;
        i_final = t;
        break;
    end
end
Q = Q_0;

G(i_final,1) = tau_R(i_final+1,1);
for t = (i_final-1):-1:1
    G(t,1) = tau_R(t+1,1) + gamma*G(t+1,1);
end

traj.tau_S = tau_S;
traj.tau_A = tau_A;
traj.tau_R = tau_R;
traj.tau_Q = tau_Q;
traj.G = G;
traj.i_final = i_final;

f = traj;
end

