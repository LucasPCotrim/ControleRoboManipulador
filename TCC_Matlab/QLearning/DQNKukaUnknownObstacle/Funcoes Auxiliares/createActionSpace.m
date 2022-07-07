function A = createActionSpace()
% Função que retorna a matriz com o conjunto de todas ações possíveis a
% serem tomadas pelo agente.

GL1 = [1 0 -1];
GL2 = [1 0 -1];
GL3 = [1 0 -1];
GL4 = [1 0 -1];
GL5 = [1 0 -1];

[gl_1, gl_2, gl_3, gl_4, gl_5] = ndgrid(GL1, GL2, GL3, GL4, GL5);
Aux = [gl_1(:) gl_2(:) gl_3(:) gl_4(:) gl_5(:)];

Actions = zeros(243,5);
for i = 1:5
    Actions(:,i) = Aux(:,6-i);
end
A = Actions;
end

