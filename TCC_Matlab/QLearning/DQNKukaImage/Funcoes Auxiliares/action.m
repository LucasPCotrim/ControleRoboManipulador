function f = action(dqn,s,prob)
% Função que retorna a ação a ser tomada dada a DQN, o estado s e a
% probabilidade epsilon-greedy de se tomar uma ação aleatória.
global A;
global output_dim;
global input_dim;

if (rand > prob)
    % Get frames from state s
    [img_s1, img_s2] = getRobotPerspective(s);
    % Normalize Images and reshape (flatten)
    img_s_norm = normalizeImage([img_s1 img_s2]);
    s_img = reshape(img_s_norm,input_dim,1);
    % Apply Fully Connected DQN Network
    y = net_output(dqn,s_img);
    % Determine best action given state s
    [~,a_index] = max(y);
else
    a_index = randi([1 output_dim]);
end

f = A(a_index,:);
end
