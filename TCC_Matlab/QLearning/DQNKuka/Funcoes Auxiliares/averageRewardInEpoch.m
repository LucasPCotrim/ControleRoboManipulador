function f = averageRewardInEpoch(trajectories)
% Função que recebe uma época (conjunto de trajetórias) e retorna a
% recompensa média obtida ao longo de todas as transições em todas
% trajetórias.

N = numel(trajectories.trajs);

sum_r = 0;
for i = 1:N
    sum_r = sum_r + averageRewardInTrajectory(trajectories.trajs(i));
end
avg = sum_r/N;
f = avg;
end

