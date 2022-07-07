classdef trajectories
    properties
        trajs = [];
    end
    
    methods
        function obj = trajectories(n_trajs)
            obj = obj.create_trajs(n_trajs);
        end
        
        function obj = create_trajs(obj,N)
            for i = 1:N
                if ~isempty(obj.trajs)
                    obj.trajs(end+1) = tau(0,0,0,0,0);
                else
                    obj.trajs = tau(0,0,0,0,0);
                end
            end
        end
    end
end

