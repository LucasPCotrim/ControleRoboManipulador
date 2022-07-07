function manualCommandTest()
% Função que permite o input de comandos manuais e observação da simulação
% resultante e de valores de recompensas obtidas.
global delta_theta;
global robot;
global Q_0;
global S_0;
global t;
q = Q_0;
s = S_0;
s_new = S_0;

panel2 = figure('NumberTitle', 'off', 'Name', 'Visualização de Trajetória');
panel2.Position = [500 70 800 600];
axis2 = show(robot,Q_0,'Visuals','on');
axis2.CameraTargetMode = 'Manual';
axis2.CameraTarget = [0 0 1];
axis2.CameraPositionMode = 'Manual';
axis2.CameraPosition = [12 12 7];
axis2.XLim = [-3 3];
axis2.YLim = [-3 3];
axis2.ZLim = [-3 3];
hold on
plotTable();
t = 1;
while (1)
    cmd = input('', 's');
    if (cmd == 'b')
        break;
    end
    switch(cmd)
        case '1'
            q(1) = q(1) + deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '2'
            q(1) = q(1) - deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '3'
            q(2) = q(2) + deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '4'
            q(2) = q(2) - deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '5'
            q(3) = q(3) + deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '6'
            q(3) = q(3) - deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '7'
            q(4) = q(4) + deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '8'
            q(4) = q(4) - deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '9'
            q(5) = q(5) + deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        case '0'
            q(5) = q(5) - deg2rad(delta_theta);
            show(robot, q, 'PreservePlot', false);
            s_new(1:5) = rad2deg(q(1:5));
            r = reward_3(s,s_new);
            s = s_new;
            fprintf('reward %d: \n',r);
            t = t+1;
        otherwise
            disp('Comando Inválido');
    end

end

end

