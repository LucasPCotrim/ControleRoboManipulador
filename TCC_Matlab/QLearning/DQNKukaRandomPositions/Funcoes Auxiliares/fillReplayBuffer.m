function f = fillReplayBuffer(transitionBuffer,dqn)
% Função que recebe um Replay Buffer de Transições vazio e uma rede dqn e
% retorna o buffer com experiência gerada pela rede dqn
global S_0;
global T;
global epsilon_0;
global epsilonDecay;
global replayBufferSize;
global terminate;
terminate = false;
n = 1;
while (n <= replayBufferSize)
    shufflePositions();
    s = S_0;
    epsilon = epsilon_0;
    for i = 1:T
        a = action(dqn,s,epsilon);
        s_new = dynamics(s,a);
        r = reward_3(s,s_new);
        
        current_transition = transition(s,a,r,s_new,i,terminate);
        transitionBuffer.transitions(n) = current_transition;
        
        s = s_new;
        epsilon = epsilon*epsilonDecay;
        n = n + 1;
        if (n > replayBufferSize || terminate == true)
            if (terminate == true)
                terminate = false;
            end
            break;
        end
    end
end

f = transitionBuffer;
end

