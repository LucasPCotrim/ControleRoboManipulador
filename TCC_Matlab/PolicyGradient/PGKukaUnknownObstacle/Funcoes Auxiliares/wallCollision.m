function f = wallCollision(p)
% Fun��o que recebe a posi��o do efetuador e retorna true caso haja colis�o com a
% parede de posi��o desconhecida e false caso contr�rio.

global table_length;
global table_width;
global table_thickness;

global xtable_orig;
global ytable_orig;
global ztable_orig;

global y_u_obs;
global height_u_obs;
global width_u_obs;

f = false;
if ((p(2) >= y_u_obs-2*width_u_obs)&&(p(2) <= y_u_obs + 4*width_u_obs))
    if ((p(3) >= ztable_orig)&&(p(3) <= ztable_orig+table_thickness+height_u_obs+4*width_u_obs))
        if ((p(1) >= xtable_orig-2*width_u_obs)&&(p(1) <= xtable_orig+table_width+2*width_u_obs))
            f = true;
        end
    end
end
end