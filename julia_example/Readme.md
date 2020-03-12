# Bayesian Network training via Julia 
This example uses the Julia Language to train a Bayesian network.
There are 3 candidate dataset to choose from.

The smallest dataset represents passenger data from the Titantic 
and tries to determine what attributes best predict a passengers 
survival. It runs in a few minutes. 

The largest dataset comes from a Kagel Competition and represents 
unkown relationships between unkown parameters. It runs for several
hours. 

The output is a csv file representing the nodes and edges of the 
trained Bayesian Network. 