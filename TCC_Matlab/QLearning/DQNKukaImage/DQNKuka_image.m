%% Deep Q Network Kuka Image (DQNkukaImage) - Deep Q-learning Kuka Robot Arm 5R (5DoF) %%
%---------------------------------------------------------------------------------------%
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
y_sp = 0.45;
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
y_obs = -0.55;
z_obs = 0.75;
obstacle = [x_obs; y_obs; z_obs];
global obstacle_width;
obstacle_width = 0.1;

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


% Variação Angular Delta Theta (em graus)
global delta_theta;
delta_theta = 1;

% Bonus for reaching set-point
global winBonus;
winBonus = 20;  % Option to give a very large bonus when the system reaches the desired state).
global obstaclePenalty;
obstaclePenalty = -20;
% Flag to determine end of trajectory (setpoint or obstacle has been reached)
global terminate;
terminate = false;
global BoundaryError;
BoundaryError = false;
% Penalty for reaching boundary of robot's work volume.
global JointBoundaryPenalty;
JointBoundaryPenalty = -10;
% Penalty for table collision.
global TableCollisionPenalty;
TableCollisionPenalty = -20;

% Actions
global A;
A = createActionSpace();

% Number of Episodes
global maxEpoch;
maxEpoch = 300;
% Number of Trajectories in Replay Buffer
global Ntrajs;
Ntrajs = 10;
% Number of Timesteps in one trajectory
global T;
T = 70; % Maximum number of (st,at,rt+1), t=1...T-1, tuples in a trajectory (size of trajectory)

% Discount Factor for return Gt of state st.
global gamma; 
gamma = 0.3;
% Learning Rate alpha
global alpha;
alpha = 0.005;
%%% Exploration vs. exploitation (Epsilon-greedy)
% Probability of picking random action vs estimated best action
global epsilon_0;
global epsilonDecay;
epsilon_0 = 1; % Initial value
epsilonDecay = 0.999; % Decay factor per iteration.

% Replay Buffer Max Size and mini batch size
global replayBufferSize;
global miniBatchSize;
replayBufferSize = Ntrajs*T;
miniBatchSize = 200;

% Number of pixels in frames used as states
global imgNumPixels;
imgNumPixels = 24;

% DQN Network Parameters
global input_dim;
global n_layers;
global output_dim;

input_dim = imgNumPixels*imgNumPixels*3*2;
n_layers = 3;
output_dim = 243;

% Convolutional Neural Network (VGG16)
% net_conv = vgg16;

%% Initial Q Neural Network
dqn = createDQN(input_dim,n_layers,output_dim);
view(dqn);
dqn_0 = dqn;

%% Create Transition Buffer, Epoch Buffer and Policy Buffer
transition_buffer = transitionBuffer(replayBufferSize);

policies = policies(maxEpoch);

global epochBuffer;
epochBuffer = episodes(maxEpoch,Ntrajs);

InitStateQValues = zeros(output_dim,1,maxEpoch);

%% DQN Algorith
dqn_cont = 1;
for ep_index = 1:maxEpoch
    tic;
    fprintf('--------Epoch %d... --------\n',ep_index);
    epochBuffer.n_eps = ep_index;
    Q = Q_0;
    s = S_0;
    epsilon = (0.995^(ep_index-1))*epsilon_0;
    % epsilon = epsilon_0;
    
    % Store current network
    if(rem(ep_index,50) == 0 || ep_index == 1)
       policies.networks(dqn_cont).policy = dqn;
       dqn_cont = dqn_cont + 1;
    end
    
    % Fill Replay Buffer with NTrajs trajectories
    transition_buffer = fillReplayBufferNTrajs(transition_buffer,dqn,ep_index,epsilon);
    
    % Sample mini batch and train
    transitions_batch = transition_buffer.sampleMiniBatch(miniBatchSize);
    dqn = gradientDescent(dqn,transitions_batch);
    
    % Clear Replay Buffer
    transition_buffer = transition_buffer.clearBuffer();
    
    % Plot Greedy Trajectory
    InitStateQValues(:,1,ep_index) = plotStateQValues(dqn,S_0);
    plotGreedyTrajectory(dqn,S_0);
    
    % Average Rewaard In Epoch
    avg_reward = averageRewardInEpoch(epochBuffer.eps(ep_index));
    fprintf('Average Reward in Epoch = %d \n',avg_reward);
    toc;
end

