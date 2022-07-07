%% Example reinforcement learning - Policy Gradient-learning Robot Arm R (1DoF) %%
%---------------------------------------------------------------------------------%
close all;
clear all;
clc;

tic;

%% SETTINGS

%%%Length of Robot Arms
global L1;
global L2;
L1 = 15;
L2 = 10;
L = L1+L2;

%%%Set Point
global x_setp;
global y_setp;
global setp;
x_setp = 0.9*L*cosd(130);
y_setp = 0.9*L*sind(130);
setp = [x_setp y_setp];
%%%Obstacle
global x_obst;
global y_obst;
global obst;
x_obst = L*cosd(230);
y_obst = L*sind(230);
obst = [x_obst y_obst];

%Delta Theta
global delta_theta;
delta_theta = 0.1;

%%% Gradient Ascent Learning Rate
global alpha;
alpha = 0.0005;

% Time step t
global t;
t = 1;

%%% Bonus for reaching set-point
global winBonus
winBonus = 600;  % Option to give a very large bonus when the system reaches the desired state.
global terminate;
terminate = false;
%%%Initial State ( Start every episode facing right ).
theta1_0 = 0; 
theta2_0 = 0;
global s_0;
s_0 = [theta1_0; theta2_0; x_setp; y_setp; x_obst; y_obst];


global maxEpi;
maxEpi = 50; % Maximum number of Episodes
global episode;
episode = 1;
global T;
T = 3000; % Maximum number of (st,at,rt+1), t=1...T-1, tuples in an episode (size of trajectory)
global N_trajectories;
N_trajectories = 20;

global gamma; % Discount Factor for return Gt of state st.
gamma = 0.3;

% Actions
global A;
A = [1 1; 1 0; 1 -1; 0 1; 0 0; 0 -1; -1 1; -1 0; -1 -1]; % Only 3 options for each motor: Increment counter-clockwise, stop, increment clockwise


%% Set up the Robot Plot
global panel;
panel = figure;
panel.Position = [100 170 1000 400];
panel.Color = [0.9 0.9 0.9];

hold on
%Braço Robótico 1
global f_braco1;
f_braco1 = plot(0,0,'Color',[0.3 0.3 0.8],'LineWidth',8);
%Braço Robótico 2
global f_braco2;
f_braco2 = plot(0,0,'Color',[0.3 0.3 0.8],'LineWidth',8);
%Articulações
%Articulação1
global f_articulacoes;
f_articulacoes = plot(0,0,'.','Color',[0.3 0.3 0.3],'MarkerSize',40);
%Articulação2
x_art2 = L1*cosd(s_0(1));
y_art2 = L1*sind(s_0(1));
set(f_articulacoes, 'XData', [0 x_art2]);
set(f_articulacoes, 'YData', [0 y_art2]);
%Set-Point
f_setp = plot(x_setp,y_setp,'.','Color',[0.3 0.8 0.3],'MarkerSize',40);
%Obstáculo
f_obst = plot(x_obst,y_obst,'.','Color',[0.8 0.3 0.3],'MarkerSize',40);

global f_bola1;
global f_bola2;
f_bola1 = plot(28,0,'.k','MarkerSize',10);
f_bola2 = plot(32,0,'.k','MarkerSize',10);

%Área de trabalho circular
L = L1+L2;
h = rectangle('Position',[-L -L 2*L 2*L],'Curvature',[1,1], 'Linestyle', '--', 'EdgeColor', [0.5 0.5 0.5]);

ax = f_braco1.Parent;
%ax.XTick = [];
%ax.YTick = [];
ax.Box = 'on';
ax.Position = [0.13 0.11 0.775 0.815];
ax.Clipping = 'off';

axis equal
axis([-1.5*L 1.5*L -1.5*L 1.5*L]);
grid on

hold off

set(f_braco1,'XData',[0 L1*cosd(s_0(1))]);
set(f_braco1,'YData',[0 L1*sind(s_0(1))]);

set(f_braco2,'XData',[L1*cosd(s_0(1))    L1*cosd(s_0(1))+L2*cosd(s_0(1) + s_0(2))]);
set(f_braco2,'YData',[L1*sind(s_0(1))    L1*sind(s_0(1))+L2*sind(s_0(1) + s_0(2))]);
%% Policy Network
% Initialize neural networks (policy pi)
pi_NN = generate_pi_NN(6,50,9);
pi_NN = pi_NN.NN_set_inputs(s_0);
pi_NN_0 = pi_NN;

AvgRewards = zeros(1,maxEpi);
Performances = zeros(1,maxEpi);
for episode = 1:maxEpi
    disp(['Episode: ', num2str(episode)]);
    initial_state = s_0;
    trajectories = generate_episode(pi_NN, initial_state, N_trajectories);
    
    % Escolhe melhor trajetória
    i_best = 1;
    J_best = trajectories.trajs(1).G(1);
    for traj_index = 1:N_trajectories
        if (trajectories.trajs(traj_index).G(1) > J_best)
            i_best = traj_index;
            J_best = trajectories.trajs(traj_index).G(1);
        end
    end
    disp(['Performance J: ', num2str(J_best)])
    tau = trajectories.trajs(i_best);
    Performances(episode) = J_best;
    
    avg = avgRewardInTraj(tau);
    disp(['Average Reward: ', num2str(avg)])
    AvgRewards(episode) = avg;
    
    plot_trajectory(tau);
    
    pi_NN = gradient_ascent(pi_NN, tau.tau_S, tau.tau_A, tau.G, tau.i_final);
end

figure()
plot(1:maxEpi,Performances);
hold on
scatter(1:maxEpi,Performances,'.');
title('PGRobotArmRR: Performances per Epoch');
xlabel('Epoch');
ylabel('Performance J');
hold off

figure()
plot(1:maxEpi,AvgRewards,'LineWidth',1);
hold on
scatter(1:maxEpi,AvgRewards,'.');
title('PGRobotArmRR: Average Reward per Epoch');
xlabel('Epoch');
ylabel('Average Reward');
hold off

toc;

