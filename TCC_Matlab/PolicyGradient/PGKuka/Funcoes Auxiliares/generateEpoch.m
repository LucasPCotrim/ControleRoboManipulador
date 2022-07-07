function f = generateEpoch(net,s_0)
% Fun��o que recebe a rede neural da pol�tica de a��es e o estado inicial
%e retorna conjunto de trajet�rias do epis�dio.

global Ntrajs;
taus = trajectories(Ntrajs);

for i = 1:Ntrajs
    if(i==1)
        fprintf('Generating Trajectory %d... \n',i);
    elseif(rem(i,10)==0)
        fprintf('Generating Trajectory %d... \n',i);
    end
    current_tau = generateTrajectory(net,s_0);
    taus.trajs(i) = current_tau;
end
f = taus;
end



