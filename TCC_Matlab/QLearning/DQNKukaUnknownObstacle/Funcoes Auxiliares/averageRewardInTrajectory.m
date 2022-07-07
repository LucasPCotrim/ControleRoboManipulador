function f = averageRewardInTrajectory(tau)
% Função que recebe uma trajetória tau e retorna o valor médio das
% recompensas obtidas ao longo dela.

i_final = tau.i_final;

sum_r = 0;
for t = 2:i_final+1
    sum_r = sum_r + tau.tau_R(t);
end
avg_r = sum_r/i_final;

f = avg_r;
end
