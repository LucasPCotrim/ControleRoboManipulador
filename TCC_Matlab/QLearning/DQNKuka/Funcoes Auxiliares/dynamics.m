function f = dynamics(s,a)
% Função que recebe o estado atual e a ação tomada e retorna o próximo
% estado do robô.

% Input: s - Estado atual.
% Input: a - Ação a ser executada.
% Output: f - Estado novo após execução da ação a.

global robot;
global Q;
global delta_theta;
global x_sp;
global y_sp;
global z_sp;
global x_obs;
global y_obs;
global z_obs;
global BoundaryError;
BoundaryError = false;

% Current State
q1 = s(1);
q2 = s(2);
q3 = s(3);
q4 = s(4);
q5 = s(5);

% Action to be taken (1, 0, -1)
a1 = a(1);
a2 = a(2);
a3 = a(3);
a4 = a(4);
a5 = a(5);

% New State
q1_new = q1 + a1*delta_theta;
q2_new = q2 + a2*delta_theta;
q3_new = q3 + a3*delta_theta;
q4_new = q4 + a4*delta_theta;
q5_new = q5 + a5*delta_theta;

q_new = [q1_new;q2_new;q3_new;q4_new;q5_new;0];
Q = q_new;

s_new = [q1_new;q2_new;q3_new;q4_new;q5_new;x_sp;y_sp;z_sp;x_obs;y_obs;z_obs];

if (q1_new < rad2deg(robot.getBody('link_1').Joint.PositionLimits(1)) || q1_new > rad2deg(robot.getBody('link_1').Joint.PositionLimits(2)))
    BoundaryError = true;
elseif (q2_new < rad2deg(robot.getBody('link_2').Joint.PositionLimits(1)) || q2_new > rad2deg(robot.getBody('link_2').Joint.PositionLimits(2)))
    BoundaryError = true;
elseif (q3_new < rad2deg(robot.getBody('link_3').Joint.PositionLimits(1)) || q3_new > rad2deg(robot.getBody('link_3').Joint.PositionLimits(2)))
    BoundaryError = true;
elseif (q4_new < rad2deg(robot.getBody('link_4').Joint.PositionLimits(1)) || q4_new > rad2deg(robot.getBody('link_4').Joint.PositionLimits(2)))
    BoundaryError = true;
elseif (q5_new < rad2deg(robot.getBody('link_5').Joint.PositionLimits(1)) || q5_new > rad2deg(robot.getBody('link_5').Joint.PositionLimits(2)))
    BoundaryError = true;
end

if (BoundaryError == true)
    disp('Boundary Error!')
    disp(s_new)
end

f = s_new;
end

