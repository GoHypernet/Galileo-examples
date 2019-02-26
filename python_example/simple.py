import numpy as np
import pickle
import os

n = 1500
A = np.random.rand(n,n)
b = np.random.rand(n,1)

x = np.linalg.solve(A,b)

print(x)

os.mkdir("exampledir")

pickle.dump(x,open("results.txt",'wb'))
