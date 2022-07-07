function f = plotAverageRewards(ep_buffer)
% Função que recebe buffer de épocas e plota as recompensas médias obtidas
% em cada trajetória.
global Ntrajs;

averageRewards = zeros(1,ep_buffer.n_eps);
for i = 1:ep_buffer.n_eps
    sum = 0;
    avg = 0;
    for j = 1:Ntrajs
        sum = sum + averageRewardInTrajectory(ep_buffer.eps(i).trajs(j));
    end
    avg = sum/Ntrajs;
    averageRewards(i) = avg;
end

figure
plot(1:ep_buffer.n_eps,averageRewards,'LineWidth',1.5);
hold on;
scatter(1:ep_buffer.n_eps,averageRewards,'.');
title('DQNKukaImage: Recompensas Médias')
xlabel('Época')
ylabel('(1/T) \Sigma r')
xlim([0 ep_buffer.n_eps])
hold off;
f = averageRewards;
end
