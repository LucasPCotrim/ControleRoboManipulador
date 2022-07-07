function plotTable()
    global table_length;
    global table_width;
    global table_height;
    global table_thickness;
    global xtable_orig;
    global ytable_orig;
    global ztable_orig;
    
    global x_sp;
    global y_sp;
    global z_sp;
    
    global x_obs;
    global y_obs;
    global z_obs;
    
    global setpoint_width;
    global obstacle_width;
    
    color_table = [0.8 0.8 0.8];
    color_feet = [0.1 0.1 0.1];
    
    %table
    cube_plot([xtable_orig ytable_orig ztable_orig],table_width,table_length,table_thickness,color_table);
    
    %feet
    feet_width = 0.025;
    feet_height = table_height;
    x_1 = xtable_orig;
    y_1 = ytable_orig;
    z_1 = ztable_orig - feet_height;
    cube_plot([x_1 y_1 z_1],feet_width,feet_width,feet_height,color_feet);
    
    x_2 = x_1;
    y_2 = y_1 + table_length - feet_width;
    z_2 = z_1;
    cube_plot([x_2 y_2 z_2],feet_width,feet_width,feet_height,color_feet);
    
    x_3 = x_2 + table_width - feet_width;
    y_3 = y_2;
    z_3 = z_2;
    cube_plot([x_3 y_3 z_3],feet_width,feet_width,feet_height,color_feet);
    
    x_4 = x_3;
    y_4 = y_1;
    z_4 = z_3;
    cube_plot([x_4 y_4 z_4],feet_width,feet_width,feet_height,color_feet);
    
    
    % Ground
    % cube_plot([-3 -3 0-0.05],6,6,0.05,[1 1 1]);
    
    % Obstacle
    x_obs_plot = x_obs - 0.5*obstacle_width;
    y_obs_plot = y_obs - 0.5*obstacle_width;
    z_obs_plot = z_obs - 0.5*obstacle_width;
    cube_plot([x_obs_plot y_obs_plot z_obs_plot], obstacle_width, obstacle_width, obstacle_width, [0.6 0.1 0.1])
    
    % Set-Point
    x_sp_plot = x_sp - 0.5*setpoint_width;
    y_sp_plot = y_sp - 0.5*setpoint_width;
    z_sp_plot = z_sp - 0.5*setpoint_width;
    cube_plot([x_sp_plot y_sp_plot z_sp_plot], setpoint_width, setpoint_width, setpoint_width, [0.1 0.6 0.1])
end
