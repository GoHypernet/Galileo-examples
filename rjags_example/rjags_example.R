#Example from: https://www.rensvandeschoot.com/tutorials/rjags-how-to-get-started/

require(rjags)
require(coda)

#1b. Load data:
data <- read.table("regression.txt")

#1c. Split data in vectors for each variable, create a vector that holds
#    the length of the data (N)

y <- data[,1]
x1 <- data[,2]
x2 <- data[,3]
n <- nrow(data)

#1d. Define initial values for the model parameters of interest

model.inits <- list(tau=1, beta0=1, beta1=0, beta2=0)

#1e. Specify number of iterations and number of burn-in iterations (that will not be included
#    for posterior)

iterations <- 100000
burnin <- floor(iterations/2)
chains <- 2

#-----------------------------------------------------------------------------------------
##############
# Exercise 2 #
##############

#2a. Run JAGS model. The txt file holds the Bugs model input (excluding
#    data and inits parts). Data is a list of the vectors you specified above.
#    N.chains are the number of chains you specified above.

model.fit <- jags.model(file="Regression2JAGS.txt",
                        data=list(n=n, y=y, x1=x1, x2=x2),
                        inits=model.inits, n.chains = chains)

#2b. Run the model for a certain number of MCMC iterations and extract random samples from the
#    posterior distribution of parameters of interest.
#    First specify the model object and then c() the parameters you would like to have
#    information on. N.iter is the number of iterations to monitor. We specified this number above.

model.samples <- coda.samples(model.fit, c("beta0", "beta1", "beta2",
                                           "R2B", "s2"), n.iter=iterations)

#2c. Summary estimates of the parameters
summary(window(model.samples, start = burnin))

#2d. Plots of the posterior distributions of the parameters.
plot(model.samples, trace=FALSE,  density = TRUE)
     
     
     