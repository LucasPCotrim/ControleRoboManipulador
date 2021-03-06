%% Policy Gradient Kuka (PGkuka) - Policy Gradient-learning Kuka Robot Arm 6R (5DoF) %%
%-------------------------------------------------------------------------------------%
clear all;
close all;
clc;

%% SETTINGS

%Set Point
global x_sp;
global y_sp;
global z_sp;
global setpoint;
x_sp = 1.05;
y_sp = 0.70;
z_sp = 0.75;
setpoint = [x_sp; y_sp; z_sp];
global setpoint_width;
setpoint_width = 0.1;

%Obstacle
global x_obs;
global y_obs;
global z_obs;
global obstacle;
x_obs = 1.05;
y_obs = -0.70;
z_obs = 0.75;
obstacle = [x_obs; y_obs; z_obs];
global obstacle_width;
obstacle_width = 0.1;

% Unknown Obstacle (Wall)
global y_u_obs;
global height_u_obs;
global width_u_obs;
y_u_obs = 0.30;
height_u_obs = 0.5;
width_u_obs = 0.025;


% Table
global table_length;
global table_width;
global table_height;
global table_thickness;
table_length = 2;
table_width = 0.8;
table_height = 0.7;
table_thickness = 0.05;

global xtable_orig;
global ytable_orig;
global ztable_orig;
xtable_orig = 0.7;
ytable_orig = -0.5*table_length;
ztable_orig = table_height - table_thickness;

% Robot (RigidBodyTree)
global robot;
robot = importrobot('kr16_2.urdf');
robot.DataFormat = 'column';
showdetails(robot)

% Initial and Current Robot Configuration (degrees)
global Q_0;
global Q;
Q_0 = rad2deg(robot.homeConfiguration);
Q = Q_0;

% Initial State Vector:
% (q1_1,q2_0,q3_0,q4_0,q5_0,x_sp,y_sp,z_sp,x_obs,y_obs,z_obs)
global S_0;
S_0 = cat(1,Q_0(1:5),setpoint,obstacle);
tform_0 = getTransform(robot,Q_0,'tool0','base');
euler_angles_0 = rad2deg(tform2eul(tform_0,'ZYX'));


% Varia??o Angular Delta Theta (em graus)
global delta_theta;
delta_theta = 1;

% Bonus for reaching set-point
global winBonus;
winBonus = 1500;  % Option to give a very large bonus when the system reaches the desired state).
global obstaclePenalty;
obstaclePenalty = -1500;
% Flag to determine end of trajectory (setpoint or obstacle has been reached)
global terminate;
terminate = false;
global BoundaryError;
BoundaryError = false;
% Penalty for reaching boundary of robot's work volume.
global JointBoundaryPenalty;
JointBoundaryPenalty = -1500;
% Penalty for table collision.
global TableCollisionPenalty;
TableCollisionPenalty = -1500;
% Penalty for wall collision
global WallCollisionPenalty;
WallCollisionPenalty = -1500;

% Policy Network Parameters
global input_dim;
global n_layers;
global output_dim;

input_dim = 11;
n_layers = 3;
output_dim = 243;

% Actions
global A;
A = createActionSpace();

% Number of Episodes
global maxEpi;
maxEpi = 100;
% Number of trajectories in one Episode
global Ntrajs;
Ntrajs = 1;
% Number of Timesteps in one trajectory
global T;
T = 80; % Maximum number of (st,at,rt+1), t=1...T-1, tuples in a trajectory (size of trajectory)
global t;
t = 1; % Current Timestep of current trajectory

% Discount Factor for return Gt of state st.
global gamma; 
gamma = 0.3;
% Learning Rate alpha
global alpha;
alpha = 0.0004;

%% Episode Buffer and Policies Buffer
epochBuffer = epochs(maxEpi,Ntrajs);
policies = policies(maxEpi);

%% Initial Policy NN
%net = createNN(input_dim,n_layers,output_dim);
net = findBalancedPolicy();
view(net)

%% REINFORCE Algorith
% [net, tau] = findGoodPolicy(100);

fprintf('------------ Epoch %d ------------ \n',1);
policies.networks(1).policy = net;
plotStateProbs(net,S_0);
taus = generateEpoch(net,S_0);
epochBuffer.eps(1) = taus;
avg = epAveragePerformance(epochBuffer.eps(1));
fprintf('Average Perormance J = %d... \n',avg);
%plotTrajectories(taus);
plotBestTrajectoryInEpoch(taus)

for i = 2:maxEpi
    % Train New Policy
    net = gradientAscent(policies.networks(i-1).policy,epochBuffer.eps(i-1));
    fprintf('------------ Epoch %d ------------ \n',i);
    % Store Network
    policies.networks(i).policy = net;
    plotStateProbs(net,S_0);
    % Simulate Epoch
    taus = generateEpoch(net,S_0);
    % Store Epoch
    epochBuffer.n_eps = i;
    epochBuffer.eps(i) = taus;
    % Display Performance Estimate
    avg = epAveragePerformance(epochBuffer.eps(i));
    fprintf('Average Perormance J = %d... \n',avg);
    % Plot Episode Trajectories
    %plotTrajectories(taus);
    plotBestTrajectoryInEpoch(taus)
end

