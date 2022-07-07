function f = maxQ(dqn,s)
% Função que recebe a dqn e o estado s e retorna o maior valor de Q(s,a')
% para todo a'.
global input_dim;

% Get frame from state s
[img_s1, img_s2] = getRobotPerspective(s);
% Normalize Images and reshape (flatten)
img_s_norm = normalizeImage([img_s1 img_s2]);
s_img = reshape(img_s_norm,input_dim,1);
% Apply Fully Connected DQN Network
y = net_output(dqn,s_img);
[m,~] = max(y);

f = m;
end

