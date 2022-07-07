function f = plotAverageRewards(ep_buffer)
% Fun��o que recebe buffer de �pocas e plota as recompensas m�dias obtidas
% em cada trajet�ria.
global Ntrajs;

averageRewards = zeros(1,ep_buffer.n_eps);
for i = 1:ep_buffer.n_eps
    sum = 0;
    avg = 0;
    for j = 1:Ntrajs
        sum = sum + averageRewardInTrajectory(ep_buffer.eps(i).trajs(j));
    end
    avg = sum/double(Ntrajs);
    averageRewards(i) = avg;
end

figure
plot(1:ep_buffer.n_eps,averageRewards);
hold on;
scatter(1:ep_buffer.n_eps,averageRewards,'.');
title('DQNKuka: Average Rewards')
xlabel('Epoch')
ylabel('(1/T) \Sigma r')
hold off
f = averageRewards;
end
