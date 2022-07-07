classdef episodes
    properties
        eps = [];
        n_eps = 0;
    end
    
    methods
        function obj = episodes(n_eps,n_trajs_per_episode)
            obj = obj.create_episode(n_eps,n_trajs_per_episode);
        end
        
        function obj = create_episode(obj,N,n_trajs_per_episode)
            for i = 1:N
                if ~isempty(obj.eps)
                    obj.eps(end+1) = trajectories(n_trajs_per_episode);
                    obj.n_eps = obj.n_eps + 1;
                else
                    obj.eps = trajectories(n_trajs_per_episode);
                    obj.n_eps = 1;
                end
            end
        end
    end
end

