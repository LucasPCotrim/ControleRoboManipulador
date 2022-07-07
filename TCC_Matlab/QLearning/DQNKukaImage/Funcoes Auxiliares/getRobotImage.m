function f = getRobotImage(S,CameraPosition,CameraTarget)
% Função que recebe o estado do sistema (posições das juntas do robô,
% do setpoint e do obstáculo) e retorna uma imagem do estado.
global robot;
global imgNumPixels;

q = [deg2rad(S(1:5));0];

panel2 = figure('NumberTitle', 'off', 'Name', 'Visualização de Trajetória', 'visible', 'off');
panel2.Position = [500 70 600 600];
axis2 = show(robot,q,'Visuals','on');
axis2.CameraTargetMode = 'Manual';
axis2.CameraTarget = CameraTarget;
axis2.CameraPositionMode = 'Manual';
axis2.CameraPosition = CameraPosition;
axis2.XLim = [-3 3];
axis2.YLim = [-3 3];
axis2.ZLim = [-3 3];
hold on
plotTable();
hold off

% Capture Frame
F = getframe(panel2);

% Close Figure
close(panel2);

img = frame2im(F);
img = imresize(img,[imgNumPixels imgNumPixels]);

% Pre-process frame (change background color from white to black)
redChannel = img(:,:,1);
greenChannel = img(:,:,2);
blueChannel = img(:,:,3);
thresholdValue = 150; % Whatever you define white as.
whitePixels = redChannel > thresholdValue & greenChannel > thresholdValue & blueChannel > thresholdValue;
redChannel(whitePixels) = 0;
greenChannel(whitePixels) = 0;
blueChannel(whitePixels) = 0;
img = cat(3, redChannel, greenChannel, blueChannel);
%img(1:20,150:224,:) = 0;

f = img;
end

