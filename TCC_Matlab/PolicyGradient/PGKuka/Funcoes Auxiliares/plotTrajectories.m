function plotTrajectories(taus)
% Fun��o que recebe um epis�dio e plota todas trajet�rias

for i = 1:numel(taus.trajs)
   plotTrajectory(taus.trajs(i)); 
end

end

