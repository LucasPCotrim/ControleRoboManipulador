function f = gradientAscent(net,trajectories)
% Função que recebe a rede neural que representa a política de ações e as
% trajetórias de um episódio e retorna a rede neural com pesos atualizados.
global gamma; 
global alpha;

input_dim = size(net.IW{1,1},2);
layer1_dim = size(net.IW{1,1},1);
layer2_dim = size(net.LW{2,1},1);
layer3_dim = size(net.LW{3,2},1);
output_dim = layer3_dim;

dJdIW = zeros(layer1_dim,input_dim);
dJdbW1 = zeros(layer1_dim,1);
dJdbW2 = zeros(layer2_dim,1);
dJdbW3 = zeros(layer3_dim,1);
dJdLW21 = zeros(layer2_dim,layer1_dim);
dJdLW32 = zeros(layer3_dim,layer2_dim);

N = numel(trajectories.trajs);

for i = 1:N
    if(i==1)
        fprintf('dJdwb for Trajectory %d... \n',i);
    elseif(rem(i,10)==0)
        fprintf('dJdwb for Trajectory %d... \n',i);
    end
    t_final = trajectories.trajs(i).i_final;
    for t = 1:t_final
        %fprintf('Timestep %d \n',t);
        s = transpose(trajectories.trajs(i).tau_S(t,:));
        a = trajectories.trajs(i).tau_A(t,:);
        a_index = actionIndex(a);
        Gt = trajectories.trajs(i).G(t,1);
        if(Gt > 15)
            Gt = 15;
        elseif (Gt < -15)
            Gt = -15;
        end
        y = net_output(net,s);
        output_t = y(a_index);
        %---------------------------------------------------------------------------------
        % Partial Derivatives
        [dydb1, dydw1, dydb2, dydw2, dydb3, dydw3] = partialDerivatives(net, s);
        
        % Bias Layer 1
        % dJdbW1(:,1) = dJdbW1(:,1) + (gamma^t)*Gt*dydb1(:,a_index)/output_t;
        dJdbW1(:,1) = dJdbW1(:,1) + Gt*dydb1(:,a_index)/output_t;
        % Layer 1
        a_aux = 1;
        b_aux = layer1_dim;
        for j = 1:input_dim
            % dJdIW(:,j) = dJdIW(:,j) + (gamma^t)*Gt*dydw1(a_aux:b_aux,a_index)/output_t;
            dJdIW(:,j) = dJdIW(:,j) + Gt*dydw1(a_aux:b_aux,a_index)/output_t;
            a_aux = b_aux + 1;
            b_aux = a_aux + layer1_dim - 1;
        end
        % Bias Layer 2
        % dJdbW2(:,1) = dJdbW2(:,1) + (gamma^t)*Gt*dydb2(:,a_index)/output_t;
        dJdbW2(:,1) = dJdbW2(:,1) + Gt*dydb2(:,a_index)/output_t;
        % Layer 2
        a_aux = 1;
        b_aux = layer2_dim;
        for j = 1:layer1_dim
            % dJdLW21(:,j) = dJdLW21(:,j) + (gamma^t)*Gt*dydw2(a_aux:b_aux,a_index)/output_t;
            dJdLW21(:,j) = dJdLW21(:,j) + Gt*dydw2(a_aux:b_aux,a_index)/output_t;
            a_aux = b_aux + 1;
            b_aux = a_aux + layer2_dim - 1;
        end
        % Bias Layer 3
        % dJdbW3(:,1) = dJdbW3(:,1) + (gamma^t)*Gt*dydb3(:,a_index)/output_t;
        dJdbW3(:,1) = dJdbW3(:,1) + Gt*dydb3(:,a_index)/output_t;
        % Layer 3
        a_aux = 1;
        b_aux = layer3_dim;
        for j = 1:layer2_dim
            % dJdLW32(:,j) = dJdLW32(:,j) + (gamma^t)*Gt*dydw3(a_aux:b_aux,a_index)/output_t;
            dJdLW32(:,j) = dJdLW32(:,j) + Gt*dydw3(a_aux:b_aux,a_index)/output_t;
            a_aux = b_aux + 1;
            b_aux = a_aux + layer3_dim - 1;
        end
        %-----------------------------------------------------------------------------------
    end
end

% theta <- theta + alpha*del_theta(J(theta))
net.IW{1,1} = net.IW{1,1} + (1/N)*alpha*dJdIW;
net.b{1,1} = net.b{1,1} + (1/N)*alpha*dJdbW1;
net.LW{2,1} = net.LW{2,1} + (1/N)*alpha*dJdLW21;
net.b{2,1} = net.b{2,1} + (1/N)*alpha*dJdbW2;
net.LW{3,2} = net.LW{3,2} + (1/N)*alpha*dJdLW32;
net.b{3,1} = net.b{3,1} + (1/N)*alpha*dJdbW3;

f = net;
end

