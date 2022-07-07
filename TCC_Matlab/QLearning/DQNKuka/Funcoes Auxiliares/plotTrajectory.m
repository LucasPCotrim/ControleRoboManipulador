function [x,y,z] = plotTrajectory(tau)
% Função que recebe uma trajetória tau e exibe a simulação visual associada.

% Input: tau - Objeto da classe tau que representa a trajetória do robô.
global robot;
global Q_0;
global x_sp;
global y_sp;
global z_sp;
global setpoint;
global x_obs;
global y_obs;
global z_obs;
global obstacle;

x_sp = tau.tau_S(1,6);
y_sp = tau.tau_S(1,7);
z_sp = tau.tau_S(1,8);
setpoint = [x_sp;y_sp;z_sp];

x_obs = tau.tau_S(1,9);
y_obs = tau.tau_S(1,10);
z_obs = tau.tau_S(1,11);
obstacle = [x_obs;y_obs;z_obs];

panel2 = figure('NumberTitle', 'off', 'Name', 'Visualização de Trajetória');
panel2.Position = [500 70 800 600];
axis2 = show(robot,Q_0,'Visuals','on');
axis2.CameraTargetMode = 'Manual';
axis2.CameraTarget = [0 0 1];
axis2.CameraPositionMode = 'Manual';
axis2.CameraPosition = [12 12 7];
axis2.XLim = [-3 3];
axis2.YLim = [-3 3];
axis2.ZLim = [-3 3];
hold on
plotTable();

x = zeros(tau.i_final,1);
y = zeros(tau.i_final,1);
z = zeros(tau.i_final,1);
pause(0.00000001);
for i = 1:tau.i_final
    q = deg2rad(transpose(tau.tau_Q(i,:)));
    show(robot,q, 'PreservePlot', false, 'Visuals','on');
    pause(0.00000001);
    
    tform = getTransform(robot,q,'tool0','base');
    
    x(i) = tform(1,4);
    y(i) = tform(2,4);
    z(i) = tform(3,4);
end

plot3(axis2,x,y,z,'LineWidth',2);
hold off

end


