function f = normalizeImage(f)
% Função que recebe os features de um frame e os retorna normalizados

%%%%%% Display captured frames %%%%%%
% panel3 = figure;
% panel3.Position = [500 70 600 600];
% imshow(f);
% close(panel3);

f_normalizado = (1/255)*double(f);

f = f_normalizado;
end

