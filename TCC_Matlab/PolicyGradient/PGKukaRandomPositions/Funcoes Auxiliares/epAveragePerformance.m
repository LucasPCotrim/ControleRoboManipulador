function f = epAveragePerformance(trajectories)
% Fun��o que recebe conjunto de trajet�rias e retorna performance m�dia.

global Ntrajs;

sum = 0;
for j = 1:Ntrajs
    sum = sum + trajectories.trajs(j).G(1);
end
avg = sum/Ntrajs;
f = avg;
end

