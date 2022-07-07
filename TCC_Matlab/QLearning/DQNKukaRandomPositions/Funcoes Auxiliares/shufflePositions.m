function shufflePositions()
% Função que modifica aleatoriamente as posições do setpoint e do obstáculo
global S_0;
global Q_0;

global x_sp;
global y_sp;
global z_sp;
global setpoint;
global setpoint_width;
global x_obs;
global y_obs;
global z_obs;
global obstacle;

global table_length;
global table_width;
global table_height;

global xtable_orig;
global ytable_orig;

x_sp_lim_inf = xtable_orig + setpoint_width;
x_sp_lim_sup = xtable_orig + table_width - setpoint_width;

y_sp_lim_inf = ytable_orig + setpoint_width;
y_sp_lim_sup = ytable_orig + table_length - setpoint_width;

z_sp_lim_inf = table_height + setpoint_width;
z_sp_lim_sup = 1;

too_close = true;
while(too_close)
    rng('shuffle');
    
    x_sp_random = (x_sp_lim_sup-x_sp_lim_inf).*rand() + x_sp_lim_inf;
    y_sp_random = (y_sp_lim_sup-y_sp_lim_inf).*rand() + y_sp_lim_inf;
    z_sp_random = (z_sp_lim_sup-z_sp_lim_inf).*rand() + z_sp_lim_inf;
    
    setpoint_random = [x_sp_random;y_sp_random;z_sp_random];
    
    x_obs_random = (x_sp_lim_sup-x_sp_lim_inf).*rand() + x_sp_lim_inf;
    y_obs_random = (y_sp_lim_sup-y_sp_lim_inf).*rand() + y_sp_lim_inf;
    z_obs_random = (z_sp_lim_sup-z_sp_lim_inf).*rand() + z_sp_lim_inf;
    
    obstacle_random = [x_obs_random;y_obs_random;z_obs_random];
    
    if (distance(setpoint_random,obstacle_random) > 12*setpoint_width)
        too_close = false;
    end
end

x_sp = x_sp_random;
y_sp = y_sp_random;
z_sp = z_sp_random;
setpoint = setpoint_random;

x_obs = x_obs_random;
y_obs = y_obs_random;
z_obs = z_obs_random;
obstacle = obstacle_random;

S_0 = cat(1,Q_0(1:5),setpoint,obstacle);
end
