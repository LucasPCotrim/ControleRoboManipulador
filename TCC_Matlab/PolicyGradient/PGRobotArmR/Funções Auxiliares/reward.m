function f = reward(s)
    % IN: state.
    % OUT: reward r(s)
    global setp;
    global obst;
    global L;
    global winBonus;
    global terminate;
    theta = s(1);
    
    x = L*cosd(theta);
    y = L*sind(theta);
    p = [x; y];
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
    
    f = 200*(-(distance(p,setp)) + (distance(p,obst))) + bonus;
end