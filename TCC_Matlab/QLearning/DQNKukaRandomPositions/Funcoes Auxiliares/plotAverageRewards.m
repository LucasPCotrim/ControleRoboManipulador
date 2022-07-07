function f = plotAverageRewards(ep_buffer)
% Fun��o que recebe buffer de �pocas e plota as recompensas m�dias obtidas
% em cada trajet�ria.
global maxEpoch;
for i = 1:maxEpoch
    if (ep_buffer.trajs(i).i_final==0)
        ep_final = i;
        break;
    end
end

averageRewards = zeros(1,ep_final);
for i = 1:ep_final
    averageRewards(i) = averageRewardInTrajectory(ep_buffer.trajs(i));
end

figure
plot(1:ep_final,averageRewards);
hold on;
scatter(1:ep_final,averageRewards,'.');
title('DQNKuka\_RandomPositions: Average Rewards')
xlabel('Epoch')
ylabel('(1/T) \Sigma r')
f = averageRewards;
end
