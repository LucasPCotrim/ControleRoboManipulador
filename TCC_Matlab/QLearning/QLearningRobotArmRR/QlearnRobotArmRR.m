%% Example reinforcement learning - Q-learning Robot Arm RR (2DoF) %%
%-------------------------------------------------------------------%
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

%%%Initial State (Start every episode facing right).
global s_0;
s_0 = [0 0];

%%%Set Point
global x_setp;
global y_setp;
global setp;
x_setp = (L1+L2)*cosd(180);
y_setp = (L1+L2)*sind(180);
setp = [x_setp y_setp];
%%%Obstacle
global x_obst;
global y_obst;
global obst;
x_obst = 0.9*(L1+L2)*cosd(90);
y_obst = 0.9*(L1+L2)*sind(90);
obst = [x_obst y_obst];

%%% Confidence in new trials?
learnRate = 0.99; % How is new value estimate weighted against the old (0-1). 1 means all new and is ok for no noise situations.

%%% Exploration vs. exploitation
% Probability of picking random action vs estimated best action
epsilon_0 = 1; % Initial value
epsilon = epsilon_0;
epsilonDecay = 0.9995; % Decay factor per iteration.

%%% Future vs present value
discount = 0.3; % When assessing the value of a state & action, how important is the value of the future states?

%%% Inject some noise?
successRate = 1; % How often do we do what we intend to do?
% E.g. What if I'm trying to turn left, but noise causes
% me to turn right instead. This probability (0-1) lets us
% try to learn policies robust to "accidentally" doing the
% wrong action sometimes.

winBonus = 8000;  % Option to give a very large bonus when the system reaches the desired state.

maxEpi = 100; % Maximum number of Episodes
maxit = 5000; % Maximum number of Actions taken in an Episode
% Actions
A = transpose(combvec([1 0 -1], [1 0 -1])); % Only 3 options for each motor: Increment counter-clockwise, stop, increment clockwise
 
%% Discretize State-Space
%%%Discretization of state space
global delta_theta1;
global delta_theta2;
delta_theta1 = 1;
delta_theta2 = 1;
theta1 = 0:delta_theta1:(360-delta_theta1);
theta2 = 0:delta_theta2:(360-delta_theta2);

%Generate a state list
S = zeros(length(theta1)*length(theta2), 2);
index = 1;
for j = 1:length(theta1)
    for k = 1:length(theta2)
        S(index,1) = theta1(j);
        S(index,2) = theta2(k);
        index = index+1;
    end
end
S_visited = zeros(length(S), 1);

% Generate R (rewards of states)
R = zeros(length(S),length(A));
for a_ind = 1:length(A)
    for i = 1:length(S)
        R(i,a_ind) = reward_3(S(i,:),A(a_ind,:));
    end
end
% Initialize Q matrix
Q = R;
%Q = rand(length(S),length(A));

%% Set up the Robot Plot
panel = figure;
panel.Position = [100 170 1000 400];
panel.Color = [0.9 0.9 0.9];

hold on
%Braço Robótico1
f_braco1 = plot(0,0,'Color',[0.3 0.3 0.8],'LineWidth',8);

%Braço Robótico2
f_braco2 = plot(0,0,'Color',[0.3 0.3 0.8],'LineWidth',8);

%Articulações
%Articulação1
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

%Aux1
f_aux1 = plot(28,0,'.','Color',[0.3 0.3 0.3],'MarkerSize',5);
%Aux2
f_aux2 = plot(32,0,'.','Color',[0.3 0.3 0.3],'MarkerSize',5);

%Área de trabalho
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


%% Start learning!

% Number of episodes or "resets"
trajs = zeros(2,maxit+1,maxEpi);
for episode = 1:maxEpi
    sum_r = 0;
    avg_r = 0;
    cont = 0;
    s = s_0; % Reset the pendulum on new episode.
    trajs(:,1,episode) = s;
    epsilon = 0.97^(episode-1)*epsilon_0;
    [~,sIdx] = min(sum((S - repmat(s, [size(S,1) 1])).^2, 2));
    S_visited(sIdx) = 1;
    % Number of actions we're willing to try before a reset
    for g = 1:maxit
        % Stop if the figure window is closed.
        if ~ishandle(panel)
            break;
        end
        %% PICK AN ACTION
        % Interpolate the state within our discretization (ONLY for choosing
        % the action. We do not actually change the state by doing this!)
        [~,sIdx] = min(sum((S - repmat(s, [size(S,1) 1])).^2, 2));
        S_visited(sIdx) = 1;
        % Choose an action:
        % EITHER 1) pick the best action according the Q matrix (EXPLOITATION). OR
        %2) Pick a random action (EXPLORATION)
        if (rand()>epsilon || episode == maxEpi) && rand()<=successRate % Pick according to the Q-matrix, if it's the last episode or we succeed with the rand()>epsilon check. Fail the check if our action doesn't succeed (i.e. simulating noise)
            [~,aIdx] = max(Q(sIdx,:)); % Pick the action the Q matrix thinks is best
            if ( norm( Q(sIdx,:) - repmat(Q(sIdx,aIdx),[1, length(A)])) < 0.001 )
                aIdx = randi(length(A),1); % Random action!
            end
        else
            aIdx = randi(length(A),1); % Random action!
        end
%         for aux = 1:length(A)
%             s_new_aux = dynamics(s,A(aux,:));
%             [~,s_new_aux_Idx] = min(sum((S - repmat(s_new_aux, [size(S,1) 1])).^2, 2));
%             if(S_visited(s_new_aux_Idx)==0)
%                 aIdx = aux; %Explore unknown states
%                 break
%             end
%         end
        
        
        a = A(aIdx,:);
        if (a(1) == -1)
            set(f_aux1,'XData',28);
            set(f_aux1,'YData',-10);
        elseif (a(1) == 1)
            set(f_aux1,'XData',28);
            set(f_aux1,'YData',10);
        else
            set(f_aux1,'XData',28);
            set(f_aux1,'YData',0);
        end
        
        if (a(2) == -1)
            set(f_aux2,'XData',32);
            set(f_aux2,'YData',-10);
        elseif (a(2) == 1)
            set(f_aux2,'XData',32);
            set(f_aux2,'YData',10);
        else
            set(f_aux2,'XData',32);
            set(f_aux2,'YData',0);
        end
        
        
        %% STEP DYNAMICS FORWARD
        % Step the dynamics forward with our new action choice
        
        s_new = dynamics(s,a);
        s = s_new; % Old state = new state
        trajs(:,g+1,episode) = s;
        
        %% UPDATE Q-MATRIX
        
        % End condition for an episode
        p = [L1*cosd(s(1))+L2*cosd(s(1)+s(2))   L1*sind(s(1))+L2*sind(s(1)+s(2))];
        if distance(p, setp) < 3 % If we've reached the setpoint end this episode.
            terminate = true;
            bonus = winBonus; % Give a bonus for getting there.
        elseif distance(p, obst) < 3 %If we've hit the obstacle end this episode.
            terminate = true;
            bonus = -winBonus; % Give a penalty for getting there.
        else
            bonus = 0;
            terminate = false;
        end
        
        [~,snewIdx] = min(sum((S - repmat(s, [size(S,1) 1])).^2, 2)); % Interpolate again to find the new state the system is closest to.
        
        if episode ~= maxEpi % On the last iteration, stop learning and just execute. Otherwise...
            sum_r = sum_r + R(snewIdx,aIdx)+bonus;
            cont = cont+1;
            % Update Q
            Q(sIdx,aIdx) = (1-learnRate)*Q(sIdx,aIdx) + learnRate*( R(snewIdx,aIdx) + discount*max(Q(snewIdx,:)) + bonus );
            
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
        x_art2 = L1*cosd(s(1));
        y_art2 = L1*sind(s(1));
        
        set(f_braco1,'XData',[0 x_art2]);
        set(f_braco1,'YData',[0 y_art2]);
        
        set(f_braco2, 'XData', [x_art2   x_art2+L2*cosd(s(1)+s(2))]);
        set(f_braco2, 'YData', [y_art2   y_art2+L2*sind(s(1)+s(2))]);
        
        %Articulações
        set(f_articulacoes, 'XData', [0 x_art2]);
        set(f_articulacoes, 'YData', [0 y_art2]);
        title(['QLearningRobotArmRR: Episode ',num2str(episode),'.']);
        
        % End this episode if we've hit the goal point or obstacle.
        if terminate
            break;
        end
        pause(0.00000001)
    end
    avg_r = sum_r/cont;
    AverageRewards(episode) = avg_r;
end
figure()
plot(1:maxEpi, AverageRewards);
hold on
scatter(1:maxEpi, AverageRewards,'.');
title('QLearningRobotArmRR: Average Reward');
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
    % IN: current state s = [s(1) s(2)], action a = [a(1) a(2)].
    % OUT: next state s_new.
    global delta_theta1;
    global delta_theta2;
    
    s1_new = s(1) + a(1)*delta_theta1;
    if (s1_new < 0)
        s1_new = 360 + s1_new;
    elseif (s1_new >= 360)
        s1_new = s1_new - 360;
    end
    
    s2_new = s(2) + a(2)*delta_theta2;
    if (s2_new < 0)
        s2_new = 360 + s2_new;
    elseif (s2_new >= 360)
        s2_new = s2_new - 360;
    end
    
    f = [s1_new s2_new];
end

%%% Reward Function %%%
function f = reward(s)
% IN: states s = [s(1) s(2)]
% OUT: reward r(s)
global setp;
global obst;
global L1;
global L2;
x = L1*cosd(s(1))+L2*cosd(s(1)+s(2));
y = L1*sind(s(1))+L2*sind(s(1)+s(2));
p = [x y];


f = -distance(p,setp) + distance(p,obst);
end

function f = reward_2(s,a)
% IN: states s = [s(1) s(2)]
% OUT: reward r(s)
global setp;
global obst;
global L1;
global L2;
x = L1*cosd(s(1))+L2*cosd(s(1)+s(2));
y = L1*sind(s(1))+L2*sind(s(1)+s(2));
p = [x y];

s_new = dynamics(s, a);
x_new = L1*cosd(s_new(1))+L2*cosd(s_new(1)+s_new(2));
y_new = L1*sind(s_new(1))+L2*sind(s_new(1)+s_new(2));
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

if (a(1) == 0 && a(2) == 0)
    r_setp = 0;
    r_obst = 0;
end

f = r_setp + 0.7*r_obst;
end


function f = reward_3(s,a)
% IN: states s = [s(1) s(2)]
% OUT: reward r(s)
global setp;
global obst;
global L1;
global L2;
x = L1*cosd(s(1))+L2*cosd(s(1)+s(2));
y = L1*sind(s(1))+L2*sind(s(1)+s(2));
p = [x y];

s_new = dynamics(s, a);
x_new = L1*cosd(s_new(1))+L2*cosd(s_new(1)+s_new(2));
y_new = L1*sind(s_new(1))+L2*sind(s_new(1)+s_new(2));
p_new = [x_new y_new];

% Dot Product
if (a(1) == 0 || a(2) == 0)
    r_setp = 0;
    r_obst = 0;
else
    vetor_p_p_new = p_new - p;
    vetor_p_p_new = vetor_p_p_new/norm(vetor_p_p_new);

    vetor_p_setp = setp - p;
    vetor_p_setp = vetor_p_setp/norm(vetor_p_setp);
    
    vetor_p_obs = obst - p;
    vetor_p_obs = vetor_p_obs/norm(vetor_p_obs);

    dot_product_setp = dot(vetor_p_p_new,vetor_p_setp);
    r_setp = 2*dot_product_setp;
    
    dot_product_obs = dot(vetor_p_p_new,vetor_p_obs);
    r_obst = -dot_product_obs;
end

f = r_setp + 0.7*r_obst;
end


