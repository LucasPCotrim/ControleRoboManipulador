function plotBestTrajectories(episodeBuffer)
% Fun��o que recebe buffer de epis�dios e plota melhor trajet�ria de cada
% epis�dio, com base na Performance J (G(1)).
global Ntrajs;
N = episodeBuffer.n_eps;

for i = 1:N
    best_perf = episodeBuffer.eps(i).trajs(1).G(1);
    best_traj = 1;
    for j = 2:Ntrajs
        if (episodeBuffer.eps(i).trajs(j).G(1) > best_perf)
            best_perf = episodeBuffer.eps(i).trajs(j).G(1);
            best_traj = j;
        end
    end
    plotTrajectory(episodeBuffer.eps(i).trajs(best_traj));
end

