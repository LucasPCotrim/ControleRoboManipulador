%% Example reinforcement learning - Q-learning Robot Arm R (1DoF) %%
%------------------------------------------------------------------%
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
x_setp = L*cosd(120);
y_setp = L*sind(120);
setp = [x_setp y_setp];
%%%Obstacle
global x_obst;
global y_obst;
global obst;
x_obst = L*cosd(230);
y_obst = L*sind(230);
obst = [x_obst y_obst];

%%% Confidence in new trials?
learnRate = 0.99; % How is new value estimate weighted against the old (0-1). 1 means all new and is ok for no noise situations.

%%% Exploration vs. exploitation
% Probability of picking random action vs estimated best action
epsilon_0 = 1; % Initial value
epsilonDecay = 0.9999; % Decay factor per iteration.
epsilon = epsilon_0;

%%% Future vs present value
discount = 0.3; % When assessing the value of a state & action, how important is the value of the future states?

%%% Inject some noise?
successRate = 1; % How often do we do what we intend to do?
% E.g. What if I'm trying to turn left, but noise causes
% me to turn right instead. This probability (0-1) lets us
% try to learn policies robust to "accidentally" doing the
% wrong action sometimes.

winBonus = 800000;  % Option to give a very large bonus when the system reaches the desired state (pendulum upright).

s_0 = 0; % Start every episode facing right.

maxEpi = 50; % Maximum number of Episodes
maxit = 5000; % Maximum number of Actions taken in an Episode
% Actions
A = [1 0 -1]; % Only 3 options: Increment counter-clockwise, stop, increment clockwise

%% Discretize State-Space
%%%Discretization of state space
global delta_theta;
delta_theta = 0.1;
theta = 0:delta_theta:(360-delta_theta);

%Generate a state list
S = zeros(length(theta),1);
for i = 1:length(theta)
    S(i,1) = theta(i);
end

%Alternative way to generate Q Matrix
R1 = zeros(length(S),1);
for i = 1:length(S)
    %R1(i,1) = reward(S(i),A(1));
    R1(i,1) = reward_2(S(i),A(1));
end
R2 = zeros(length(S),1);
for i = 1:length(S)
    %R2(i,1) = reward(S(i),A(2));
    R2(i,1) = reward_2(S(i),A(2));
end
R3 = zeros(length(S),1);
for i = 1:length(S)
    %R3(i,1) = reward(S(i),A(3));
    R3(i,1) = reward_2(S(i),A(3));
end
Q = [R1 R2 R3]; %+ 0.05*rand(length(S),length(A));
%Q = 20*rand(length(S),length(A));

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

f_bola = plot(0,0,'.k','MarkerSize',50); % Pendulum axis point

%Área de trabalho
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

set(f_braco,'XData',[0 L*cosd(s_0)]);
set(f_braco,'YData',[0 L*sind(s_0)]);

%% Start learning!

AverageRewards = zeros(1,maxEpi);
% Number of episodes or "resets"
for episode = 1:maxEpi
    sum_r = 0;
    avg_r = 0;
    cont = 0;
    s = s_0; % Reset the pendulum on new episode.
    % Number of actions we're willing to try before a reset
    epsilon = 0.9^(episode-1)*epsilon_0;
    for g = 1:maxit
        % Stop if the figure window is closed.
        if ~ishandle(panel)
            break;
        end
        %% PICK AN ACTION
        % Interpolate the state within our discretization (ONLY for choosing
        % the action. We do not actually change the state by doing this!)
        [~,sIdx] = min((S - repmat(s, [size(S,1) 1])).^2);
        
        % Choose an action:
        % EITHER 1) pick the best action according the Q matrix (EXPLOITATION). OR
        % 2) Pick a random action (EXPLORATION)
        if (rand()>epsilon || episode == maxEpi) && rand()<=successRate % Pick according to the Q-matrix, if it's the last episode or we succeed with the rand()>epsilon check. Fail the check if our action doesn't succeed (i.e. simulating noise)
            [~,aIdx] = max(Q(sIdx,:)); % Pick the action the Q matrix thinks is best
        else
            aIdx = randi(length(A),1); % Random action!
        end
        a = A(aIdx);
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
        
        
        %% STEP DYNAMICS FORWARD
        % Step the dynamics forward with our new action choice
        
        s_new = dynamics(s,a);
        s = s_new; % Old state = new state
        
        
        %% UPDATE Q-MATRIX
        
        % End condition for an episode
        p = [L*cosd(s) L*sind(s)];
        if distance(p, setp) < 0.01 % If we've reached the setpoint end this episode.
            terminate = true;
            bonus = winBonus; % Give a bonus for getting there.
        elseif distance(p, obst) < 0.01 %If we've hit the obstacle end this episode.
            terminate = true;
            bonus = -winBonus; % Give a penalty for getting there.
        else
            bonus = 0;
            terminate = false;
        end
        
        [~,snewIdx] = min((S - repmat(s,[size(S,1), 1])).^2); % Interpolate again to find the new state the system is closest to.
        
        if episode ~= maxEpi % On the last iteration, stop learning and just execute. Otherwise...
            if (aIdx == 1)
                R = R1;
            elseif(aIdx == 2)
                R = R2;
            else
                R = R3;
            end
            sum_r = sum_r + R(snewIdx) + bonus;
            cont = cont+1;
            % Update Q
            Q(sIdx,aIdx) = (1-learnRate)*Q(sIdx,aIdx) + learnRate*( R(snewIdx) + discount*max(Q(snewIdx,:)) + bonus );
            
            % Lets break this down:
            %
            % We want to update our estimate of the global value of being
            % at our previous state s and taking action a. We have just
            % tried this action, so we have some information. Here are the terms:
            %   1) Q(sIdx,aIdx) AND later -Q(sIdx,aIdx) -- Means we're
            %      doing a weighting of old and new (see 2). Rewritten:
            %      (1-alpha)*Qold + alpha*newStuff
            %   2) learnRate * ( ... ) -- Scaling factor for our update.
            %      High learnRate means that new information has great weight.
            %      Low learnRate means that old information is more important.
            %   3) R(snewIdx) -- the reward for getting to this new state
            %   4) discount * max(Q(snewIdx,:)) -- The estimated value of
            %      the best action at the new state. The discount means future
            %      value is worth less than present value
            %   5) Bonus - I choose to give a big boost of it's reached the
            %      goal state. Optional and not really conventional.
        end
        
        
        % Decay the odds of picking a random action vs picking the
        % estimated "best" action. I.e. we're becoming more confident in
        % our learned Q.
        epsilon = epsilon*epsilonDecay;
        
        %% UPDATE PLOTS
        
        % Robot Arm state:
        set(f_braco,'XData',[0 L*cosd(s)]);
        set(f_braco,'YData',[0 L*sind(s)]);
        title(['QLearningRobotArmR Episode: ', num2str(episode), '.']);
        
        % End this episode if we've hit the goal point or obstacle.
        if terminate
            break;
        end
        pause(0.000001)
    end
    avg_r = sum_r/cont;
    AverageRewards(episode) = avg_r;
end

figure()
plot(1:maxEpi, AverageRewards);
hold on
scatter(1:maxEpi, AverageRewards,'.');
title('QLearningRobotArmR: Average Reward');
xlabel('Epoch');
ylabel('Average Reward');
hold off

toc;
%% Auxiliary Functions %%
%-----------------------%
%%% Distance Function %%%
function f = distance(p1, p2)
    f = sqrt((p1(1) - p2(1))^2 + (p1(2) - p2(2))^2);
end

%%% Dynamics Function %%%
function f = dynamics(s, a)
    % Pendulum with motor at the joint dynamics
    % IN: current state s, action a
    % OUT: next state s_new
    global delta_theta;
    aux = s + a*delta_theta;
    if (aux >= 360)
        f = aux - 360;
    elseif (aux < 0)
        f = 360 + aux;
    else
        f = aux;
    end
end

%%% Reward Function %%%
function f = reward(s,a)
% IN: state.
% OUT: reward r(s)
global setp;
global obst;
global L;
s_new = dynamics(s, a);

x_new = L*cosd(s_new);
y_new = L*sind(s_new);
p_new = [x_new y_new];

f = 20*(-distance(p_new,setp) + 0.7*distance(p_new,obst));
end

function f = reward_2(s,a)
% IN: current state s.
% IN: action taken a.
% OUT: reward r(s,a).
global setp;
global obst;
global L;
s_new = dynamics(s, a);

x = L*cosd(s);
y = L*sind(s);
p = [x y];

x_new = L*cosd(s_new);
y_new = L*sind(s_new);
p_new = [x_new y_new];

if(distance(p_new,setp) < distance(p,setp))
    r_setp = 1;
elseif (distance(p_new,setp) > distance(p,setp))
    r_setp = -1;
end

if(distance(p_new,obst) < distance(p,obst))
    r_obst = -1;
elseif (distance(p_new,obst) > distance(p,obst))
    r_obst = 1;
end

if (a == 0)
    r_setp = 0;
    r_obst = 0;
end

f = r_setp + 0.7*r_obst;
end


