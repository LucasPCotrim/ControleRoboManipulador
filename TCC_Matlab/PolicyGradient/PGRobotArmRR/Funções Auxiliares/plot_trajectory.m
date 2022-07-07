function plot_trajectory(tau)
global panel;
global f_braco1;
global f_braco2;
global f_articulacoes;
global f_bola1;
global f_bola2;
global episode;

global L1;
global L2;

    for t = 1:tau.i_final
        if ~ishandle(panel)
            break;
        end

        a = tau.tau_A(t,:);

        theta1 = tau.tau_S(t,1);
        set(f_braco1,'XData',[0 L1*cosd(theta1)]);
        set(f_braco1,'YData',[0 L1*sind(theta1)]);

        theta2 = tau.tau_S(t,2);
        set(f_braco2,'XData',[L1*cosd(theta1)    L1*cosd(theta1)+L2*cosd(theta1 + theta2)]);
        set(f_braco2,'YData',[L1*sind(theta1)    L1*sind(theta1)+L2*sind(theta1 + theta2)]);

        x_art2 = L1*cosd(theta1);
        y_art2 = L1*sind(theta1);

        set(f_articulacoes, 'XData', [0 x_art2]);
        set(f_articulacoes, 'YData', [0 y_art2]);

        %str = sprintf("episode %d: T = %d", episode, t);
        %annotation('textbox',[0.2 0.5 0.3 0.3],'String',str,'FitBoxToText','on');

        if (a(1) == -1)
            set(f_bola1,'XData',28);
            set(f_bola1,'YData',-10);
        elseif (a(1) == 1)
            set(f_bola1,'XData',28);
            set(f_bola1,'YData',10);
        else
            set(f_bola1,'XData',28);
            set(f_bola1,'YData',0);
        end

        if (a(2) == -1)
            set(f_bola2,'XData',32);
            set(f_bola2,'YData',-10);
        elseif (a(2) == 1)
            set(f_bola2,'XData',32);
            set(f_bola2,'YData',10);
        else
            set(f_bola2,'XData',32);
            set(f_bola2,'YData',0);
        end
        title(['PGRobotArmRR: Episode ',num2str(episode), '.']);

        pause(0.00000001)
    end
end

