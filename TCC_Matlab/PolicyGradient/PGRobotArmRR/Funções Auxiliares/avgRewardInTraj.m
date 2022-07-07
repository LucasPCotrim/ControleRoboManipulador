function f = avgRewardInTraj(tau)
sum_r = 0;
cont = 0;

for i = 1:tau.i_final
    sum_r = sum_r + tau.tau_R(i);
    cont = cont + 1;
end

avg = sum_r / cont;
f = avg;

end