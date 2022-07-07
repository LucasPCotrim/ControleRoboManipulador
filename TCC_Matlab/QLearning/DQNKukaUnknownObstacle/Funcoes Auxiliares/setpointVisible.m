function f = setpointVisible(p)
% Função que recebe posição p do efetuador e retorna true se existe um
% caminho em linha reta entre o efetuador e o setpoint que não passa por
% nenhum obstáculo
global setpoint;

global x_obs;
global y_obs;
global z_obs;
global obstacle;

visible = true;

for i = 0:0.005:1
    p_aux = (1-i)*p + i*setpoint;
    if (wallCollision(p_aux) == true || tableCollision(p_aux) == true ||...
        distance(p_aux,obstacle) < 0.1)
        visible = false;
        break;
    end
    if (distance(p_aux,setpoint) < 0.1)
        visible = true;
        break;
    end
end

f = visible;
end

