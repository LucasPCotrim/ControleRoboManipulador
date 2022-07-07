%% Example reinforcement learning - Policy Gradient-learning Robot Arm R (1DoF) %%
%---------------------------------------------------------------------------------%
close all;
clear all;
clc;

tic;

%% SETTINGS

%%%Length of Robot Arm
global L;
L = 25;

%%%Set Point
global x_setp;
global y_setp;
global setp;
x_setp = L*cosd(130);
y_setp = L*sind(130);
setp = [x_setp; y_setp];
%%%Obstacle
global x_obst;
global y_obst;
global obst;
x_obst = L*cosd(230);
y_obst = L*sind(230);
obst = [x_obst; y_obst];

% Time step t
global t;
t = 1;

%Delta Theta
global delta_theta;
delta_theta = 0.1;

%%% Gradient Ascent Learning Rate
global alpha;
alpha = 0.01;

%%% Bonus for reaching set-point
global winBonus
winBonus = 100;  % Option to give a very large bonus when the system reaches the desired state).
global terminate;
terminate = false;

%%%Initial State
theta_0 = 0; % Start every episode facing right.
global s_0;
s_0 = [theta_0; x_setp; y_setp; x_obst; y_obst];

global maxEpi;
maxEpi = 50; % Maximum number of Episodes
global T;
T = 5000; % Maximum number of (st,at,rt+1), t=1...T-1, tuples in an episode (size of trajectory)

global gamma; % Discount Factor for value Gt of state st.
gamma = 0.3;

% Actions
global A;
A = [1 0 -1]; % Only 3 options: Increment clockwise, stop, increment counter-clockwise

% Aproximate Performace Measure J
J = zeros(maxEpi,1);
averageRewards = zeros(maxEpi,1);

%% Set up the Robot Plot
panel = figure;
panel.Position = [100 170 1000 400];
panel.Color = [0.9 0.9 0.9];

hold on
%Braço Robótico
f_braco = plot(0,0,'Color',[0.3 0.3 0.8],'LineWidth',8);
%Articulação
f_articulacao = plot(0,0,'.','Color',[0.3 0.3 0.3],'MarkerSize',40);
%Set-Point
f_setp = plot(x_setp,y_setp,'.','Color',[0.3 0.8 0.3],'MarkerSize',40);
%Obstáculo
f_obst = plot(x_obst,y_obst,'.','Color',[0.8 0.3 0.3],'MarkerSize',40);

f_bola = plot(30,0,'.k','MarkerSize',50);

%Área de trabalho circular
h = rectangle('Position',[-L -L 2*L 2*L],'Curvature',[1,1], 'Linestyle', '--', 'EdgeColor', [0.5 0.5 0.5]);

ax = f_braco.Parent;
%ax.XTick = [];
%ax.YTick = [];
ax.Box = 'on';
ax.Position = [0.13 0.11 0.775 0.815];
ax.Clipping = 'off';

axis equal
axis([-1.5*L 1.5*L -1.5*L 1.5*L]);
grid on

hold off

set(f_braco,'XData',[0 L*cosd(theta_0)]);
set(f_braco,'YData',[0 L*sind(theta_0)]);
%% Policy Network
% Initialize neural network (policy pi)
pi_NN = generate_piNN(5,10,3);
pi_NN = pi_NN.NN_set_inputs(s_0);
pi_NN_0 = pi_NN;


for episode = 1:maxEpi
    avg_r = 0;
    sum_r = 0;
    cont_r = 0;
    
    initial_state = s_0;
    [tau_S, tau_A, tau_R, G, i_final] = generate_episode (pi_NN, initial_state);
    for t = 1:i_final %Plot episode trajectory
        if ~ishandle(panel)
            break;
        end
        theta = tau_S(t,1);
        a = tau_A(t,1);
        
        r = tau_R(t,1);
        sum_r = sum_r + r;
        cont_r = cont_r + 1;
        
        set(f_braco,'XData',[0 L*cosd(theta)]);
        set(f_braco,'YData',[0 L*sind(theta)]);
        %str = sprintf("episode %d: T = %d", episode, t);
        %annotation('textbox',[0.2 0.5 0.3 0.3],'String',str,'FitBoxToText','on');
        title(['PGRobotArmR: Episode ', num2str(episode), '.']);
        if (a == -1)
            set(f_bola,'XData',30);
            set(f_bola,'YData',-10);
        elseif (a == 1)
            set(f_bola,'XData',30);
            set(f_bola,'YData',10);
        else
            set(f_bola,'XData',30);
            set(f_bola,'YData',0);
        end
        pause(0.00000001)
    end
    avg_r = sum_r/cont_r;
    disp(avg_r);
    averageRewards(episode) = avg_r;
    J(episode) = G(1);
    
    pi_NN = gradient_ascent(pi_NN, tau_S, tau_A, G, i_final);
end

figure(2)
scatter(1:maxEpi,J, '.')
hold on
plot(1:maxEpi,J);
title('Performance J')
xlabel('Episode i')
ylabel('J = E[r(\tau_i)]')
hold off

figure(3)
scatter(1:maxEpi,averageRewards, '.')
hold on
plot(1:maxEpi,averageRewards);
title('Average Rewards')
xlabel('Episode')
ylabel('(1/T) \Sigma r')
hold off

toc;
