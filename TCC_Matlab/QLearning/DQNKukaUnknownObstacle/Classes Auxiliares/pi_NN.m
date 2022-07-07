classdef pi_NN
    properties
        policy;
    end
    
    methods
        function obj = pi_NN()
            obj.policy = feedforwardnet(1);
        end
        
    end
end
