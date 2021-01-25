noquote("REGRESSION EXAMPLE")

library(parallel)

noquote("Let's run a simple regression with the mtcars dataset and make a plot, which will be saved in the filesys folder")

mtcars <- read.csv("mtcars.csv")
model1 <- lm(mpg ~ wt, data = mtcars)
summary(model1)

jpeg('regression_fit.jpg')
plot(mtcars$wt, mtcars$mpg, main="Results", xlab="Car Weight ", ylab="Miles Per Gallon ", pch=19)
abline(lm(mtcars$mpg~mtcars$wt), col="red") # regression line (y~x)
lines(lowess(mtcars$wt,mtcars$mpg), col="blue") # lowess line (x,y)
dev.off()

noquote("MONTE CARLO EXAMPLE")

noquote("Let's load a library")



noquote("What is the probability that the sum of rolling two fair dice is at least 7?")
noquote("We can work out the answer (0.583), but let's prove it with simulation")
noquote("We'll write a function that simulates trials of dice throws and returns TRUE if at least 7")

throws <- function(numberDice, numberSides, targetValue, numberTrials){
  apply(matrix(sample(1:numberSides, numberDice*numberTrials, replace=TRUE), nrow=numberDice), 2, sum) >= targetValue
}

noquote("Let's try 50,000 trials, record the system time, & calculate the mean of the outcomes")
set.seed(1)
system.time(outcomes1 <- throws(2, 6, 7, 50000))
mean(outcomes1)

noquote("pretty close but we're still a little off -- let's try running in parallel")

parallelThrows <- function(numberDice, numberSides, targetValue, trialIndices){
  sapply(1:length(trialIndices), function(x) sum(sample(1:numberSides, numberDice, replace=TRUE)) >= targetValue)
}

noquote("Let's try 1 million throws, record the system time, & calculate the mean of the outcomes")
set.seed(1)
system.time(outcomes2 <- pvec(mc.cores = (detectCores()-2), 1:1000000, function(x) parallelThrows(2, 6, 7, x)))
mean(outcomes2)

noquote("As you can see, the result is much more accurate, and the run didn't take very long")
