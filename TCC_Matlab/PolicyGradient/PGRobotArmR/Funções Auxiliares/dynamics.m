function f = dynamics(s, a)
    % IN: current state s, action a
    % OUT: next state s_new
    global delta_theta;
    global x_setp;
    global y_setp;
    global x_obst;
    global y_obst;
    
    aux = s(1) + a*delta_theta;
    if (aux > 180)
        f = [aux - 360; x_setp; y_setp; x_obst; y_obst];
    elseif (aux <= -180)
        f = [aux + 360; x_setp; y_setp; x_obst; y_obst];
    else
        f = [aux; x_setp; y_setp; x_obst; y_obst];
    end
end