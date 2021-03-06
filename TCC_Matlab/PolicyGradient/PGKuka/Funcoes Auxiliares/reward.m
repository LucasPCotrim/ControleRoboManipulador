function f = reward(s, b_error)
% Fun??o que recebe o estado novo do sistema e retorna a recompensa
% associada, ou seja, a recompensa por ter tomado a a??o a no estado
% s_antigo de modo que s_novo = dynamics(s_antigo,a).

% Input: s - Estado em que o sistema se encontra.
% Input: ik_error - Flag que indica que houve erro na cinem?tica inversa
% (ponto fora do espa?o de trabalho).
% Output: f - Recompensa associada ? transi??o entre estado anterior e
% atual.
global setpoint;
global obstacle;
global winBonus;
global obstaclePenalty;
global JointBoundaryPenalty;
global TableCollisionPenalty;
global terminate;
global robot;

%mid = (obstacle+setpoint)/2;

q = deg2rad([s(1:5); 0]);
tform = getTransform(robot,q,'tool0','base');
    
x = tform(1,4);
y = tform(2,4);
z = tform(3,4);
p = [x;y;z];


setpoint_bonus = 0;
collisionPenalty = 0;

% Verify whether action violates joint boundaries.
% ------------------------------------------------
if(b_error == false) % Action ok: No Penalty
    boundaryPenalty = 0;
else % Action violates boundaries: JointBoundaryPenalty
    terminate = true;
    boundaryPenalty = JointBoundaryPenalty;
end

% Verify Table Collision
% -------------------------
if (tableCollision(p) == true)
    collisionPenalty = TableCollisionPenalty;
    disp('Hit Table!')
    terminate = true;
end

% Verify Setpoint Reached
% ------------------------
if (distance(p,setpoint) < 0.15)
    setpoint_bonus = winBonus;
    disp('Reached Setpoint!')
    terminate = true;
end

% Setpoint
% ---------
r_setp = -1.2*(distance(p,setpoint))^2;

% Obstacle
% ---------
if (distance(p,obstacle) < 0.15)
    r_obs = obstaclePenalty;
    disp('Hit Obstacle!')
    terminate = true;
elseif (distance(p,obstacle) >= 1.5)
    r_obs = 0;
else
    r_obs = -( 1/distance(p,obstacle) - 1/1.5 )^2;
end



f = 150*(r_setp + r_obs + 0.987891343397203) + setpoint_bonus + boundaryPenalty + collisionPenalty;

end



