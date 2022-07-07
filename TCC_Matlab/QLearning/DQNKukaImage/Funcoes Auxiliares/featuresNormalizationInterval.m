function [minimum,maximum] = featuresNormalizationInterval(net_conv)
% Função que determina o intervalo utilizado para normalização de features
% a partir de conjunto de frames gerados em diferentes estados do sistema.
global S_0;

m = 0;
M = 0;

for i = -20:5:20
    for j = -20:5:20
        for k = -20:5:20
            S = S_0 + [i;j;k;0;0;0;0;0;0;0;0];
            im = getRobotImage(S,[10 -3 4],[0.8 0 1]);
            features = activations(net_conv,im,'pool5');
            features = reshape(features,25088,1);
            current_max = max(features);
            current_min = min(features);
            if (current_max>M)
                M = current_max;
            end
            if (current_min<m)
                m = current_min;
            end
        end
    end
end

minimum = m;
maximum = M;
end

