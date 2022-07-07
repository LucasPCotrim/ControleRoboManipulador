function f = reward_2(s,a)
% FUnção que recebe estado s e ação a e calcula recompensa r
% (função recompensa discreta sob aproximação ou distanciamento)
global setp;
global obst;
global L;
global winBonus;
global terminate;
theta = s(1);
x = L*cosd(theta);
y = L*sind(theta);
p = [x; y];

s_new = dynamics(s, a);
theta_new = s_new(1);
x_new = L*cosd(theta_new);
y_new = L*sind(theta_new);
p_new = [x_new; y_new];

if (distance(p_new,setp) < distance(p,setp))
    r_setp = 1;
elseif (distance(p_new,setp) > distance(p,setp))
    r_setp = -1;
end

if (distance(p_new,obst) < distance(p,obst))
    r_obst = -1;
elseif (distance(p_new,obst) > distance(p,obst))
    r_obst = 1;
end

if (a == 0)
    r_setp = 0;
    r_obst = 0;
end

if (distance(p,setp) < 1)
    bonus = winBonus;
    terminate = true;

elseif (distance(p,obst) < 2)
    bonus = -winBonus;
    terminate = true;

else
    bonus = 0;
    terminate = false;
end


f = 100*(r_setp + r_obst) + bonus;
end

