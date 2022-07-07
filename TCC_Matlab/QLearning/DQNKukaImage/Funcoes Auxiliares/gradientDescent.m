function f = gradientDescent(dqn,transitions_batch)
% Função que recebe a rede neural que representa a política de ações e as
% trajetórias de um episódio e retorna a rede neural com pesos atualizados.
global gamma; 
global alpha;
global T;

input_dim = size(dqn.IW{1,1},2);
layer1_dim = size(dqn.IW{1,1},1);
layer2_dim = size(dqn.LW{2,1},1);
layer3_dim = size(dqn.LW{3,2},1);
output_dim = layer3_dim;

dLdIW = zeros(layer1_dim,input_dim);
dLdbW1 = zeros(layer1_dim,1);
dLdbW2 = zeros(layer2_dim,1);
dLdbW3 = zeros(layer3_dim,1);
dLdLW21 = zeros(layer2_dim,layer1_dim);
dLdLW32 = zeros(layer3_dim,layer2_dim);

N = numel(transitions_batch);

fprintf('gradientDescent... \n')
for i = 1:N %For each transition
    if(i==1 || rem(i,10) == 0)
        fprintf('%d ',i);
    end
    
    s = transitions_batch(i).s;
    
    a = transitions_batch(i).a;
    a_index = actionIndex(a);
    
    % Get frame from state s
    [img_s1, img_s2] = getRobotPerspective(s);
    % Normalize Images and reshape (flatten)
    img_s_norm = normalizeImage([img_s1 img_s2]);
    s_img = reshape(img_s_norm,input_dim,1);
    % Apply Fully Connected DQN Network
    q_values = net_output(dqn,s_img);
    q = q_values(a_index);
    
    r = transitions_batch(i).r;
    
    s_new = transitions_batch(i).s_new;
    
    if (transitions_batch(i).terminate == true || transitions_batch(i).i_timestep == T)
        target = r;
    else
        target = r + gamma*maxQ(dqn,s_new);
    end
    
    err = target - q;
    %---------------------------------------------------------------------------------
    % Partial Derivatives
    [dydb1, dydw1, dydb2, dydw2, dydb3, dydw3] = partialDerivatives(dqn,s_img);

    % Bias Layer 1
    dLdbW1(:,1) = dLdbW1(:,1) + err*(-dydb1(:,a_index));
    % Layer 1
    a_aux = 1;
    b_aux = layer1_dim;
    for j = 1:input_dim
        dLdIW(:,j) = dLdIW(:,j) + err*(-dydw1(a_aux:b_aux,a_index));
        a_aux = b_aux + 1;
        b_aux = a_aux + layer1_dim - 1;
    end
    % Bias Layer 2
    dLdbW2(:,1) = dLdbW2(:,1) + err*(-dydb2(:,a_index));
    % Layer 2
    a_aux = 1;
    b_aux = layer2_dim;
    for j = 1:layer1_dim
        dLdLW21(:,j) = dLdLW21(:,j) + err*(-dydw2(a_aux:b_aux,a_index));
        a_aux = b_aux + 1;
        b_aux = a_aux + layer2_dim - 1;
    end
    % Bias Layer 3
    dLdbW3(:,1) = dLdbW3(:,1) + err*(-dydb3(:,a_index));
    % Layer 3
    a_aux = 1;
    b_aux = layer3_dim;
    for j = 1:layer2_dim
        dLdLW32(:,j) = dLdLW32(:,j) + err*(-dydw3(a_aux:b_aux,a_index));
        a_aux = b_aux + 1;
        b_aux = a_aux + layer3_dim - 1;
    end
    %-----------------------------------------------------------------------------------
end

% theta <- theta - alpha*del_theta(L(theta))
dqn.IW{1,1} = dqn.IW{1,1} - (1/N)*alpha*dLdIW;
dqn.b{1,1} = dqn.b{1,1} - (1/N)*alpha*dLdbW1;
dqn.LW{2,1} = dqn.LW{2,1} - (1/N)*alpha*dLdLW21;
dqn.b{2,1} = dqn.b{2,1} - (1/N)*alpha*dLdbW2;
dqn.LW{3,2} = dqn.LW{3,2} - (1/N)*alpha*dLdLW32;
dqn.b{3,1} = dqn.b{3,1} - (1/N)*alpha*dLdbW3;

fprintf('\n');

f = dqn;
end

