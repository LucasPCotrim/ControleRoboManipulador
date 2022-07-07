classdef tau
    properties
        tau_S;
        tau_A;
        tau_R;
        G;
        i_final;
    end
    
    methods
        function obj = tau(f,g,h,i,j)
            obj.tau_S = f;
            obj.tau_A = g;
            obj.tau_R = h;
            obj.G = i;
            obj.i_final = j;
        end
        
    end
end

