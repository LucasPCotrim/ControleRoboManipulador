function f = distance(a,b)
% Função que retorna a distância Euclidiana entre dois pontos.
% Input: a - Ponto A.
% Input: b - Ponto B.
% Output: f - Distância entre p1 e p2 (espaço tridimensional).

f = sqrt( (a(1)-b(1))^2 + (a(2)-b(2))^2 + (a(3)-b(3))^2 );
end

