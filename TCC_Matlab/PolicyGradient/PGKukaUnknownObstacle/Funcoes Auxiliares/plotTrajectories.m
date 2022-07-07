function plotTrajectories(taus)
% Função que recebe um episódio e plota todas trajetórias

for i = 1:numel(taus.trajs)
   plotTrajectory(taus.trajs(i)); 
end

end

