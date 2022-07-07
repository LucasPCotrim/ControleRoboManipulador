classdef policies
    properties
        networks = [];
    end
    
    methods
        function obj = policies(n_networks)
            obj = obj.create_policies(n_networks);
        end
        
        function obj = create_policies(obj,N)
            for i = 1:N
                if ~isempty(obj.networks)
                    obj.networks(end+1) = pi_NN();
                else
                    obj.networks = pi_NN();
                end
            end
        end
    end
end

