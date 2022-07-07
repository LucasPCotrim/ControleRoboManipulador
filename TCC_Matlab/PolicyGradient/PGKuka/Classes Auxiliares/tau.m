classdef tau
    properties
        tau_S;
        tau_A;
        tau_R;
        tau_Q;
        G;
        i_final;
    end
    
    methods
        function obj = tau(f,g,h,i,j,k)
            obj.tau_S = f;
            obj.tau_A = g;
            obj.tau_R = h;
            obj.tau_Q = i;
            obj.G = j;
            obj.i_final = k;
        end
        
    end
end

