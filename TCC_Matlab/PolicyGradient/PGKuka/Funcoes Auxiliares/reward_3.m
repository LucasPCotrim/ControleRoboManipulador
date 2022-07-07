function f = reward_3(s, s_new)
% Função que recebe o estado novo do sistema e retorna a recompensa
% associada, ou seja, a recompensa por ter tomado a ação a no estado
% s_antigo de modo que s_novo = dynamics(s_antigo,a).

% Input: s - Estado em que o sistema se encontra.
% Output: f - Recompensa associada à transição entre estado anterior e
% atual.
global setpoint;
global obstacle;
global winBonus;
global obstaclePenalty;
global JointBoundaryPenalty;
global TableCollisionPenalty;
global terminate;
global BoundaryError;
global robot;

%mid = (obstacle+setpoint)/2;

% Old State
q = deg2rad([s(1:5); 0]);
tform = getTransform(robot,q,'tool0','base');
    
x = tform(1,4);
y = tform(2,4);
z = tform(3,4);
p = [x;y;z];

% New State
q_new = deg2rad([s_new(1:5); 0]);
tform_new = getTransform(robot,q_new,'tool0','base');
    
x_new = tform_new(1,4);
y_new = tform_new(2,4);
z_new = tform_new(3,4);
p_new = [x_new;y_new;z_new];

d_p_obs = distance(p,obstacle);
d_p_setp = distance(p,setpoint);

d_p_obs_new = distance(p_new,obstacle);
d_p_setp_new = distance(p_new,setpoint);


setpoint_bonus = 0;
collisionPenalty = 0;
obstacle_penalty = 0;

% Verify whether action violates joint boundaries.
% ------------------------------------------------
if(BoundaryError == false) % Action ok: No Penalty
    boundaryPenalty = 0;
else % Action violates boundaries: JointBoundaryPenalty
    terminate = true;
    boundaryPenalty = JointBoundaryPenalty;
end

% Verify Table Collision
% -------------------------
if (tableCollision(p_new) == true)
    collisionPenalty = collisionPenalty + TableCollisionPenalty;
    disp('Hit Table!')
    terminate = true;
end

% Verify Setpoint Reached
% ------------------------
if (d_p_setp_new < 0.15)
    setpoint_bonus = winBonus;
    disp('Reached Setpoint!')
    terminate = true;
end

% Verify Obstacle Hit
% ------------------------
if (d_p_obs_new < 0.15)
    r_obs = 0;
    obstacle_penalty = obstaclePenalty;
    disp('Hit Obstacle!')
    terminate = true;
elseif (d_p_obs_new < 0.5)
    if (d_p_obs_new < d_p_obs)
        r_obs = -1;
    elseif (d_p_obs_new > d_p_obs)
        r_obs = 1;
    else
        r_obs = 0;
    end
else
    r_obs = 0;
end

% Dot Product
if (p_new(1) == p(1) && p_new(2) == p(2) && p_new(3) == p(3))
    r_setp = 0;
else
    vetor_p_p_new = p_new - p;
    vetor_p_p_new = vetor_p_p_new/norm(vetor_p_p_new);

    vetor_p_setp = setpoint - p;
    vetor_p_setp = vetor_p_setp/norm(vetor_p_setp);

    dot_product = dot(vetor_p_p_new,vetor_p_setp);
    r_setp = 2*dot_product;
end

% Reward
f = (r_setp + r_obs) + setpoint_bonus + obstacle_penalty + boundaryPenalty + collisionPenalty;
end
