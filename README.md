# Reinforcement Learning Control of Robot Manipulator

### Authors: 
- Lucas Pereira Cotrim (lucas.cotrim@usp.br)
- Marcos Menon José (marcos.jose@usp.br)
- Eduardo Lobo Lustosa Cabral (lcabral@ipen.br)

## Introduction

Reinforcement Learning Framework for simulation-based positioning control of various robotic manipulators. Two main RL algorithms are implemented: REINFORCE and DQN. For each project, the main file is "<project_name>.m", for example: DQNKuka.m.

For more information please refer to the article "Reinforcement Learning Control of Robot Manipulator" and to the bachelor thesis "Controle de Robô Manipulador com Aprendizado por Reforço", currently available in portuguese.


## REINFORCE (Policy Iteration) Projects:

- **PGRobotArmR**: 1-DoF robot.

- **PGRobotArmRR**: 2-DoF robot.

- **PGKuka**: Kuka robot (5 controllable DoF).

- **PGKukaUnknownObstacle**: Kuka robot in environment with unknown obstacle (Wall).

- **PGKukaRandomPositions**: Kuka robot trained for generic goal and obstacle positions.


## Q-Learning (Value Function Iteration) Projects:

- **QLearningRobotArmR**: 1-DoF robot.

- **QLearningRobotArmRR**: 2-DoF robot.

- **DQNKuka**: Kuka robot (5 controllable DoF).

- **DQNKukaUnknownObstacle**: Kuka robot in environment with unknown obstacle (Wall).

- **DQNKukaRandomPositions**: Kuka robot trained for generic goal and obstacle positions.

- **DQNKukaImage**: Kuka robot DQN agent trained with image-based states.
