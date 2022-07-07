function f = actionIndex(a)
% Fun��o que retorna o �ndice de uma a��o a partir de seu vetor.
% (Por exemplo: actionIndex([1 1 1 1 1 1])) = 1)

global A;
[Lia, Locb] = ismember(a,A,'rows');
if(Lia)
    f = Locb;
else
    f = 0;
end
end

