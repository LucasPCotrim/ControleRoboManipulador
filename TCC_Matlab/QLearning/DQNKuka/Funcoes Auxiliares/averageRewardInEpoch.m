function f = averageRewardInEpoch(trajectories)
% Fun��o que recebe uma �poca (conjunto de trajet�rias) e retorna a
% recompensa m�dia obtida ao longo de todas as transi��es em todas
% trajet�rias.

N = numel(trajectories.trajs);

sum_r = 0;
for i = 1:N
    sum_r = sum_r + averageRewardInTrajectory(trajectories.trajs(i));
end
avg = sum_r/N;
f = avg;
end

