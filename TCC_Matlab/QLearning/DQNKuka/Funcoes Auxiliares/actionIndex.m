function f = actionIndex(a)
% Função que retorna o índice de uma ação a partir de seu vetor.
% (Por exemplo: actionIndex([1 1 1 1 1 1])) = 1)

global A;
[Lia, Locb] = ismember(a,A,'rows');
if(Lia)
    f = Locb;
else
    f = 0;
end
end

