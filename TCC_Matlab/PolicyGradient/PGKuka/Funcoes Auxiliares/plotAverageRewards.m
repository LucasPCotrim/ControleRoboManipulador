function f = plotAverageRewards(episodeBuffer)
% Fun��o que recebe buffer de epis�dios e plota e retorna lista de valores
% m�dios das recompensas de cada epis�dio.

global Ntrajs;
N = episodeBuffer.n_eps;

averageRewards = zeros(1,N);
for i = 1:N
    sum = 0;
    for j = 1:Ntrajs
        i_final = episodeBuffer.eps(i).trajs(j).i_final;
        sum_r = 0;
        for t = 2:i_final+1
            sum_r = sum_r + episodeBuffer.eps(i).trajs(j).tau_R(t);
        end
        avg_r = sum_r/i_final;
        sum = sum + avg_r;
    end
    avg = sum/Ntrajs;
    averageRewards(i) = avg;
end
figure
plot(1:N,averageRewards);
f = averageRewards;
