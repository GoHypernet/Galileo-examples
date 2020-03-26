import tensorflow as tf
import numpy as np
from functions import fastLS

import tensorflow as tf
mnist = tf.keras.datasets.mnist

# pull the MNIST dataset
(x_train, y_train),(x_test, y_test) = mnist.load_data()

# get the size of the training and testing datasets
train_examples = x_train.shape[0]
test_examples  = x_test.shape[0]

rows = x_train.shape[1]
cols = x_train.shape[2]

# choose which digit we'd like to predict
label = 3
print("building linear estimator to detect the digit: ", label)

# set the target to binary label -1 and 1 
y_train = y_train.astype(int)
y_test = y_test.astype(int)
y_train[(y_train != label)] = -1
y_test[(y_test != label)]   = -1
y_train[(y_train == label)] =  1
y_test[(y_test == label)]   =  1

# reshape the data for matrix operations
x_train = x_train.reshape(train_examples,rows*cols)
x_test = x_test.reshape(test_examples,rows*cols)

# perform least squares regression
k = 20
print("Using a subspace of size: ", k)
sol = fastLS(x_train,y_train,k)

# use predictor on test data to get predicted data
y_pred = np.matmul(x_test,sol)

# clean the predicted data
y_pred[(y_pred > 0)] =  1
y_pred[(y_pred < 0)] = -1

# compute the error vector
res = y_test - y_pred

# compute the accuracy on the training set
nwrong = res[(np.absolute(res) > 0.001)].shape[0]
ntot = res.shape[0]
print("The linear classifier predicted ", ntot - nwrong," correctly out of ", ntot)
print("The error rate is ", (nwrong/ntot)," percent")