function f = tableCollision(p)
% Função que recebe a posição do efetuador e retorna true caso haja colisão com a
% mesa e fale caso contrário.

global table_length;
global table_width;
global table_thickness;

global xtable_orig;
global ytable_orig;
global ztable_orig;

f = false;
if ((p(3) >= ztable_orig)&&(p(3) <= ztable_orig+table_thickness+0.03))
    if ((p(2) >= ytable_orig)&&(p(2) <= ytable_orig+table_length))
        if ((p(1) >= xtable_orig)&&(p(1) <= xtable_orig+table_width))
            f = true;
        end
    end
end
end

