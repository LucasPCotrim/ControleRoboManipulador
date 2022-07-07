function f = distance(a,b)
% Fun��o que retorna a dist�ncia Euclidiana entre dois pontos.
% Input: a - Ponto A.
% Input: b - Ponto B.
% Output: f - Dist�ncia entre p1 e p2 (espa�o tridimensional).

f = sqrt( (a(1)-b(1))^2 + (a(2)-b(2))^2 + (a(3)-b(3))^2 );
end

