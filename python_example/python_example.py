#load all dependencies

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels
import patsy
import time
import random


from statsmodels.formula.api import ols

print("Run a simple OLS regression")

#read in the data
d1 = pd.read_csv("mtcars.csv")

#look at the shape of the data
d1.shape
d1.head()

#visualize the data

sns.distplot(d1['wt'])
plt.savefig("data")
plt.show()
plt.close()

sns.regplot(x="mpg", y="wt", data=d1)

#save the plot
plt.savefig("regression")
plt.show()
plt.close()

#run ols
model = ols("mpg ~ wt", data=d1)
results = model.fit()

#examine the results
print(results.summary())

print("Run a simple Monte Carlo")

def rollSix(N, dice, sixes):
    M = 0                     #rolls equal to six
    for i in range(N):        # repeat N experiments
        six = 0               # number of sixes
        for j in range(dice):
            r = random.randint(1, 6)
            if r == 6:
               six += 1
        if six >= sixes:
            M += 1
    p = float(M)/N
    return p

print("Show that the probability of rolling a 6 is .166 by simulating throwing a die 1 million ties and calculating the ratio of sixes")

time0 = time.perf_counter()
print("probability =", rollSix(N=1000000, dice=1, sixes=1))
time1 = time.perf_counter()
print('CPU time:', time1-time0)
