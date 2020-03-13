# Bayesian Network training via Julia 
This example uses the Julia Language to train a Bayesian network.
There are 3 candidate dataset to choose from.

The smallest dataset contains passenger data from the Titantic 
disaster and tries to determine what attributes best predict if 
a passenger survived the sinking. It runs in a few seconds. 

The medium size dataset contains 4898 observations of wine 
characteristics that try to predict the quality of wine. This 
example runs in a few minutes

The largest dataset comes from a Kaggle Competition and contains
10000 observations of unkown variables. It runs for several
hours. 

The output is a csv file representing the nodes and edges of the 
trained Bayesian Network. 