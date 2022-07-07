function f = reward_2(s,a)
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

if (distance(p_new,setp) < 4)
    bonus = winBonus;
    %disp('Reached Setpoint!')
    terminate = true;

elseif (distance(p_new,obst) < 5)
    bonus = -winBonus;
    %disp('Hit Obstacle!')
    terminate = true;

else
    bonus = 0;
    terminate = false;
end

if(distance(p_new,setp) < distance(p,setp))
    r_setp = 1;
elseif (distance(p_new,setp) > distance(p,setp))
    r_setp = -1;
end

if(distance(p_new,obst) < distance(p,obst))
    r_obst = -1;
elseif (distance(p_new,obst) > distance(p,obst))
    r_obst = 1;
end

if (a(1) == 0 && a(2) == 0)
    r_setp = 0;
    r_obst = 0;
end

f = 100*(r_setp + 0.7*r_obst) + bonus;
end

