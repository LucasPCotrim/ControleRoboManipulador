function f = epAveragePerformance(trajectories)
% Função que recebe conjunto de trajetórias e retorna performance média.

global Ntrajs;

sum = 0;
for j = 1:Ntrajs
    sum = sum + trajectories.trajs(j).G(1);
end
avg = sum/Ntrajs;
f = avg;
end

