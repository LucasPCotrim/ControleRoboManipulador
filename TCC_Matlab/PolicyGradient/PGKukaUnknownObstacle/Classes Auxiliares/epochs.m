classdef epochs
    properties
        eps = [];
        n_eps = 0;
    end
    
    methods
        function obj = epochs(n_eps,n_trajs_per_epoch)
            obj = obj.create_epoch(n_eps,n_trajs_per_epoch);
        end
        
        function obj = create_epoch(obj,N,n_trajs_per_epoch)
            for i = 1:N
                if ~isempty(obj.eps)
                    obj.eps(end+1) = trajectories(n_trajs_per_epoch);
                    obj.n_eps = obj.n_eps + 1;
                else
                    obj.eps = trajectories(n_trajs_per_epoch);
                    obj.n_eps = 1;
                end
            end
        end
    end
end

