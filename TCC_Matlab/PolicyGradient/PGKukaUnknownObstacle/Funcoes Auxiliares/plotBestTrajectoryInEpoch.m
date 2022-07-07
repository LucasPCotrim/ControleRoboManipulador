function plotBestTrajectoryInEpoch(taus)
% Fun��o que recebe um conjunto de trajet�rias correspondente a uma �poca e
% plot a melhor trajet�ria.
global Ntrajs;
best_perf = taus.trajs(1).G(1);
best_traj = 1;
for i = 2:Ntrajs
    if (taus.trajs(i).G(1) > best_perf)
        best_perf = taus.trajs(i).G(1);
        best_traj = i;
    end
end

plotTrajectory(taus.trajs(best_traj));
end

