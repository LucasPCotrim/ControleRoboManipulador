classdef transitionBuffer    
    properties
        transitions = [];
        n_transitions = 0;
    end
    
    methods
        % Constructor
        function obj = transitionBuffer(n_transitions)
            obj = obj.createTransitionsArray(n_transitions);
        end
        
        function obj = createTransitionsArray(obj,N)
            for i = 1:N
                if ~isempty(obj.transitions)
                    obj.transitions(end+1) = transition(zeros(11,1),zeros(1,5),0,zeros(11,1),0,false);
                    obj.n_transitions = obj.n_transitions + 1;
                else
                    obj.transitions = transition(zeros(11,1),zeros(1,5),0,zeros(11,1),0,false);
                    obj.n_transitions = 1;
                end
            end
        end
        
        % Amotra mini batch aleatório
        function f = sampleMiniBatch(obj,n)
            rand_indexes = randi([1 obj.n_transitions],1,n);
            aux = obj.transitions(rand_indexes);
            
            % Armazena necessariamente transições iniciais e terminais
            cont_term = 0;
            for i = 1:obj.n_transitions
                if (obj.transitions(i).terminate == true)
                    cont_term = cont_term + 1;
                    aux(cont_term) = obj.transitions(i);
                end
            end
            cont_init = cont_term;
            for i = 1:obj.n_transitions
                if (obj.transitions(i).i_timestep == 1)
                    cont_init = cont_init + 1;
                    aux(cont_init) = obj.transitions(i);
                end
            end
            f = aux;
        end
        
        % Armazena transição no final do buffer
        function f = appendTransition(obj,transition)
            obj = obj.deleteLastTransition();
            obj.transitions(obj.n_transitions) = transition;
            f = obj;
        end
        
        % Armazena deleta última transição
        function f = deleteLastTransition(obj)
            for i = 1:obj.n_transitions-1
                obj.transitions(i) = obj.transitions(i+1);
            end
            obj.transitions(obj.n_transitions) = transition(zeros(11,1),zeros(1,5),0,zeros(11,1),0,false);
            f = obj;
        end
        
        % Limpa buffer
        function f = clearBuffer(obj)
            for i = 1:obj.n_transitions
                obj.transitions(i) = transition(zeros(11,1),zeros(1,5),0,zeros(11,1),0,false);
            end
            obj.n_transitions = 0;
            f = obj;
        end
    end
end

