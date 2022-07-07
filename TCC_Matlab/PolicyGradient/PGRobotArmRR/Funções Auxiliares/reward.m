%%% Reward Function %%%
function f = reward(s)
    % IN: state.
    % OUT: reward r(s)
    global setp;
    global obst;
    global L1;
    global L2;
    global winBonus;
    global terminate;
    x = L1*cosd(s(1)) + L2*cosd(s(1)+s(2));
    y = L1*sind(s(1)) + L2*sind(s(1)+s(2));
    p = [x; y];
    if (distance(p,setp) < 4)
        bonus = winBonus;
        %disp('Reached Setpoint!')
        terminate = true;

    elseif (distance(p,obst) < 5)
        bonus = -winBonus;
        %disp('Hit Obstacle!')
        terminate = true;

    else
        bonus = 0;
        terminate = false;
    end
    
    f = 5*(-(distance(p,setp)) + (distance(p,obst)) + bonus);
end