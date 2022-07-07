function f = reward(s)
% Função que recebe o estado novo do sistema e retorna a recompensa
% associada, ou seja, a recompensa por ter tomado a ação a no estado
% s_antigo de modo que s_novo = dynamics(s_antigo,a).

% Input: s - Estado em que o sistema se encontra.
% Output: f - Recompensa associada à transição entre estado anterior e
% atual.
global setpoint;
global obstacle;
global winBonus;
global JointBoundaryPenalty;
global TableCollisionPenalty;
global terminate;
global robot;
global BoundaryError;

%mid = (obstacle+setpoint)/2;

q = deg2rad([s(1:5); 0]);
tform = getTransform(robot,q,'tool0','base');
    
x = tform(1,4);
y = tform(2,4);
z = tform(3,4);
p = [x;y;z];

bonus = 0;
% Verify Table Collision
% -------------------------
if (tableCollision(p) == true)
    collisionPenalty = TableCollisionPenalty;
    disp('Hit Table!')
    terminate = true;
else
    collisionPenalty = 0;
    % Verify Setpoint & Obstacle
    % ---------------------------
    % Setpoint Reached Bonus
    % ------------------------
    if (distance(p,setpoint) < 0.15)
        bonus = winBonus;
        disp('Reached Setpoint!')
        terminate = true;
    % Obstacle Hit Penalty
    % ------------------------
    elseif (distance(p,obstacle) < 0.15)
        bonus = -winBonus/2;
        disp('Hit Obstacle!')
        terminate = true;   
    % No Bonus or Penalty
    % ------------------------
    else
        bonus = 0;
        terminate = false;
    end
end

% Verify Action that violates joint boundaries.
% ------------------------------------------------
if(BoundaryError == false) % Action ok: No Penalty
    boundaryPenalty = 0;
else % Action violates boundaries: JointBoundaryPenalty
    terminate = true;
    boundaryPenalty = JointBoundaryPenalty;
    BoundaryError = false;
end

f = 0.1*(-1.2*(distance(p,setpoint))^2 + (distance(p,obstacle))^2) + bonus + boundaryPenalty + collisionPenalty;



