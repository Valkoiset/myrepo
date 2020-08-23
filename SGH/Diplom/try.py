

import gym

env = gym.make("Taxi-v2").env

env.render()

env.reset()  # reset environment to a new, random state
env.render()

print("Action Space {}".format(env.action_space))
print("State Space {}".format(env.observation_space))
