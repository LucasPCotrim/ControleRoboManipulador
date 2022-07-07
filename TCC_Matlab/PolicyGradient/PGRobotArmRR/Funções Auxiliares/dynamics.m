%%% Dynamics Function %%%
function f = dynamics(s, a)
    % Pendulum with motor at the joint dynamics
    % IN: current state s, action a
    % OUT: next state s_new
    global delta_theta;
    global x_setp;
    global y_setp;
    global x_obst;
    global y_obst;
    
    aux1 = s(1) + a(1)*delta_theta;
    if (aux1 > 180)
        aux1 = aux1 - 360;
    elseif (aux1 <= -180)
        aux1 = aux1 + 360;
    else
    end
    
    aux2 = s(2) + a(2)*delta_theta;
    if (aux2 > 180)
        aux2 = aux2 - 360;
    elseif (aux2 <= -180)
        aux2 = aux2 + 360;
    else
    end
    
    f = [aux1; aux2; x_setp; y_setp; x_obst; y_obst];
end
