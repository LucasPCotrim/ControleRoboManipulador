robot = importrobot('kr16_2.urdf');
robot.DataFormat = 'column';

% clearVisual(robot.Base);
% clearVisual(robot.getBody('link_1'));
% clearVisual(robot.getBody('link_2'));
% clearVisual(robot.getBody('link_3'));
% clearVisual(robot.getBody('link_4'));
% clearVisual(robot.getBody('link_5'));
% clearVisual(robot.getBody('link_6'));

% tform = eul2tform([pi/2, 0, 0], 'XYZ');
% addVisual(robot.Base, "Mesh", 'base_link.stl', tform);
% tform = eul2tform([pi/2, 0, 0], 'XYZ');
% addVisual(robot.getBody('link_1'), "Mesh", 'link_1.stl', tform);
% tform = eul2tform([pi/2, 0, 0], 'XYZ')*eul2tform([0, 0, pi/2], 'XYZ');
% addVisual(robot.getBody('link_2'), "Mesh", 'link_2.stl', tform);
% tform = eul2tform([pi/2, 0, 0], 'XYZ');
% addVisual(robot.getBody('link_3'), "Mesh", 'link_3.stl', tform);
% tform = eul2tform([pi/2, 0, 0], 'XYZ');
% addVisual(robot.getBody('link_4'), "Mesh", 'link_4.stl', tform);
% tform = eul2tform([pi/2, 0, 0], 'XYZ');
% addVisual(robot.getBody('link_5'), "Mesh", 'link_5.stl', tform);
% tform = eul2tform([pi/2, 0, 0], 'XYZ');
% addVisual(robot.getBody('link_6'), "Mesh", 'link_6.stl', tform);

panel = figure(1);
panel.Position = [80 80 800 600];
axis = show(robot);
axis.CameraTargetMode = 'Manual';
axis.CameraTarget = [0 0 1];
axis.CameraPositionMode = 'Manual';
axis.CameraPosition = [14 14 8];
axis.XLim = [-3 3];
axis.YLim = [-3 3];
axis.ZLim = [-3 3];
hold on

Q = robot.homeConfiguration;
show(robot,Q);
hold on
for i = Q(1,1):0.1:robot.getBody('link_1').Joint.PositionLimits(2)
    q = [i; 0.1*i; -0.6*i; 0; 0; 0];
    show(robot, q, 'PreservePlot', false);
    axis.CameraPosition = [14-0.9*i 14-0.9*i 8-0.9*i];
    pause(0.000000001)
end

for i = robot.getBody('link_1').Joint.PositionLimits(2):-0.1:Q(1,1)
    q = [i; 0.1*i; -0.6*i; 0; 0; 0];
    show(robot, q, 'PreservePlot', false);
    pause(0.000000001)
end

hold off

