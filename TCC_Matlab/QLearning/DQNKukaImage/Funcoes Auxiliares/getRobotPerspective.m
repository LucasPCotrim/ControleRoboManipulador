function [im1,im2] = getRobotPerspective(S)
% Função que recebe o estado S do sistema e retorna duas imagens em
% perspectiva pre-processadas para serem utilizadas como entrada da rede
% convolucional.

im1 = getRobotImage(S,[0 0 10],[0.8 0 1]);
im2 = getRobotImage(S,[1.1 8 2],[0.8 0 1]);
end

