function f = plotAveragePerformance(episodeBuffer)
% Função que recebe buffer de episódios e retorna lista de valores médios
% das performances de cada episódio.
global Ntrajs;
N = episodeBuffer.n_eps;

averagePerformances = zeros(1,N);
for i = 1:N
    sum = 0;
    for j = 1:Ntrajs
        sum = sum + episodeBuffer.eps(i).trajs(j).G(1);
    end
    avg = sum/Ntrajs;
    averagePerformances(i) = avg;
end
figure
plot(1:N,averagePerformances);
f = averagePerformances;


