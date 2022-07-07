classdef transition
    properties
        s;
        a;
        r;
        s_new;
        i_timestep;
        terminate;
    end
    
    methods
        function obj = transition(state,action,reward,new_state,timestep,is_final)
            obj.s = state;
            obj.a = action;
            obj.r = reward;
            obj.s_new = new_state;
            obj.i_timestep = timestep;
            obj.terminate = is_final;
        end
    end
end

