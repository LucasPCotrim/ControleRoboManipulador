function f = normalizeInputs(s)
% Função que recebe um estado do sistema e retorna o estado normalizado

global xtable_orig;
global ytable_orig;

global table_length;
global table_width;
global table_height;

q1 = s(1);
q2 = s(2);
q3 = s(3);
q4 = s(4);
q5 = s(5);
x_sp = s(6);
y_sp = s(7);
z_sp = s(8);
x_obs = s(9);
y_obs = s(10);
z_obs = s(11);

q1_aux = mapminmax([-30, q1, 40],-1,1);
q2_aux = mapminmax([-20, q2, 40],-1,1);
q3_aux = mapminmax([-30, q3, 50],-1,1);
q4_aux = mapminmax([-40, q4, 40],-1,1);
q5_aux = mapminmax([-40, q5, 40],-1,1);

x_sp_aux = mapminmax([xtable_orig, x_sp, xtable_orig+table_width],-1,1);
y_sp_aux = mapminmax([ytable_orig, y_sp, ytable_orig+table_length],-1,1);
z_sp_aux = mapminmax([table_height, z_sp, table_height+0.5],-1,1);

x_obs_aux = mapminmax([xtable_orig, x_obs, xtable_orig+table_width],-1,1);
y_obs_aux = mapminmax([ytable_orig, y_obs, ytable_orig+table_length],-1,1);
z_obs_aux = mapminmax([table_height, z_obs, table_height+0.5],-1,1);

s_normalizado = [q1_aux(2);q2_aux(2);q3_aux(2);q4_aux(2);q5_aux(2);...
                 x_sp_aux(2);y_sp_aux(2);z_sp_aux(2);...
                 x_obs_aux(2);y_obs_aux(2);z_obs_aux(2)];
f = s_normalizado;
end

