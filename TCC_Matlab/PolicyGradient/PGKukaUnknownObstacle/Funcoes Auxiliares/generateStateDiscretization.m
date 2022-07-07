function f = generateStateDiscretization()
% Função que retorna conjunto de estados (apenas posições angulares dos
% cinco primeiros graus de liberdade do robô) em torno da posição inicial.

global robot;

%Set Point
global x_sp;
global y_sp;
global z_sp;
%Obstacle
global x_obs;
global y_obs;
global z_obs;

n = 10;

a1 = mapminmax(1:15,rad2deg(robot.getBody('link_1').Joint.PositionLimits(1))/n,...
     rad2deg(robot.getBody('link_1').Joint.PositionLimits(2))/n);
norm_a1 = mapminmax([rad2deg(robot.getBody('link_1').Joint.PositionLimits(1)), a1, rad2deg(robot.getBody('link_1').Joint.PositionLimits(2))],-1,1);
norm_a1 = norm_a1(2:16);
 
a2 = mapminmax((1:15),rad2deg(robot.getBody('link_2').Joint.PositionLimits(1))/n,...
     rad2deg(robot.getBody('link_2').Joint.PositionLimits(2))/n);
norm_a2 = mapminmax([rad2deg(robot.getBody('link_2').Joint.PositionLimits(1)), a2, rad2deg(robot.getBody('link_2').Joint.PositionLimits(2))],-1,1);
norm_a2 = norm_a2(2:16);

a3 = mapminmax(1:15,0,30);
norm_a3 = mapminmax([rad2deg(robot.getBody('link_3').Joint.PositionLimits(1)), a3, rad2deg(robot.getBody('link_3').Joint.PositionLimits(2))],-1,1);
norm_a3 = norm_a3(2:16);

a4 = mapminmax(1:4,rad2deg(robot.getBody('link_4').Joint.PositionLimits(1))/(6*n),...
     rad2deg(robot.getBody('link_4').Joint.PositionLimits(2))/(6*n));
norm_a4 = mapminmax([rad2deg(robot.getBody('link_4').Joint.PositionLimits(1)), a4, rad2deg(robot.getBody('link_4').Joint.PositionLimits(2))],-1,1);
norm_a4 = norm_a4(2:5);

a5 = mapminmax(1:4,rad2deg(robot.getBody('link_5').Joint.PositionLimits(1))/(6*n),...
     rad2deg(robot.getBody('link_5').Joint.PositionLimits(2))/(6*n));
norm_a5 = mapminmax([rad2deg(robot.getBody('link_5').Joint.PositionLimits(1)), a5, rad2deg(robot.getBody('link_5').Joint.PositionLimits(2))],-1,1);
norm_a5 = norm_a5(2:5);

x_sp_norm = mapminmax([-2, x_sp, 2],-1,1);
x_sp_norm = x_sp_norm(2);

y_sp_norm = mapminmax([-2, y_sp, 2],-1,1);
y_sp_norm = y_sp_norm(2);

z_sp_norm = mapminmax([-2, z_sp, 2],-1,1);
z_sp_norm = z_sp_norm(2);

x_obs_norm = mapminmax([-2, x_obs, 2],-1,1);
x_obs_norm = x_obs_norm(2);

y_obs_norm = mapminmax([-2, y_obs, 2],-1,1);
y_obs_norm = y_obs_norm(2);

z_obs_norm = mapminmax([-2, z_obs, 2],-1,1);
z_obs_norm = z_obs_norm(2);
 
f = combvec(norm_a1,norm_a2,norm_a3,norm_a4,norm_a5,x_sp_norm,y_sp_norm,z_sp_norm,...
    x_obs_norm,y_obs_norm,z_obs_norm);
end

