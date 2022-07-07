function f = plotAveragePerformance(episodeBuffer)
% Fun��o que recebe buffer de epis�dios e retorna lista de valores m�dios
% das performances de cada epis�dio.
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


