function f = plotStateQValues(dqn,s)
% Função que recebe rede DQN e estado e plota os valores Q de cada ação em
% um mesmo gráfico para aquele estado.
global output_dim;
global input_dim;

% Get frames from state s
[img_s1, img_s2] = getRobotPerspective(s);
% Normalize Images and reshape (flatten)
img_s_norm = normalizeImage([img_s1 img_s2]);
s_img = reshape(img_s_norm,input_dim,1);
% Apply Fully Connected DQN Network
y = net_output(dqn,s_img);

figure
plot(1:output_dim,y');
hold on
scatter(1:output_dim,y','.');
hold off

f = y;
end

