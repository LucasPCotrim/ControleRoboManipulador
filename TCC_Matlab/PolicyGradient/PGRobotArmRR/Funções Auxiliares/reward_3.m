function f = reward_3(s, a)
% Função que recebe o estado novo do sistema e retorna a recompensa
% associada, ou seja, a recompensa por ter tomado a ação a no estado
% s_antigo de modo que s_novo = dynamics(s_antigo,a).

% Input: s - Estado em que o sistema se encontra.
% Output: f - Recompensa associada à transição entre estado anterior e
% atual.
global setp;
global obst;
global L1;
global L2;
global winBonus;
global terminate;

x = L1*cosd(s(1)) + L2*cosd(s(1)+s(2));
y = L1*sind(s(1)) + L2*sind(s(1)+s(2));
p = [x; y];

s_new = dynamics(s, a);

x_new = L1*cosd(s_new(1)) + L2*cosd(s_new(1)+s_new(2));
y_new = L1*sind(s_new(1)) + L2*sind(s_new(1)+s_new(2));
p_new = [x_new; y_new];

% d_p_obs = distance(p,obst);
% d_p_setp = distance(p,setp);
% 
% d_p_obs_new = distance(p_new,obst);
% d_p_setp_new = distance(p_new,setp);

if (distance(p_new,setp') < 3)
    bonus = winBonus;
    %disp('Reached Setpoint!')
    terminate = true;

elseif (distance(p_new,obst) < 4)
    bonus = -winBonus;
    %disp('Hit Obstacle!')
    terminate = true;

else
    bonus = 0;
    terminate = false;
end

% Dot Product
if (a(1) == 0 || a(2) == 0)
    r_setp = 0;
    r_obs = 0;
else
    vetor_p_p_new = p_new - p;
    vetor_p_p_new = vetor_p_p_new/norm(vetor_p_p_new);

    vetor_p_setp = setp' - p;
    vetor_p_setp = vetor_p_setp/norm(vetor_p_setp);
    
    vetor_p_obs = obst' - p;
    vetor_p_obs = vetor_p_obs/norm(vetor_p_obs);

    dot_product_setp = dot(vetor_p_p_new,vetor_p_setp);
    r_setp = 2*dot_product_setp;
    
    dot_product_obs = dot(vetor_p_p_new,vetor_p_obs);
    r_obs = -dot_product_obs;
end

% Reward
f = 100*(r_setp + r_obs) + bonus;
end
