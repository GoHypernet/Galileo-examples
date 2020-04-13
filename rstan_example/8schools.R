
#From https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

library("rstan") # observe startup messages
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

schools_dat <- list(J = 8, 
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

fit <- stan(file = '8schools.stan', data = schools_dat)

print(fit)
plot(fit)
pairs(fit, pars = c("mu", "tau", "lp__"))

la <- extract(fit, permuted = TRUE) # return a list of arrays 
mu <- la$mu 

### return an array of three dimensions: iterations, chains, parameters 
a <- extract(fit, permuted = FALSE) 

### use S3 functions on stanfit objects
a2 <- as.array(fit)
m <- as.matrix(fit)
d <- as.data.frame(fit)

#References

#Gelman, A., Carlin, J. B., Stern, H. S., and Rubin, D. B. (2003). 
#Bayesian Data Analysis, CRC Press, London, 2nd Edition.

#Stan Development Team. Stan Modeling Language User's Guide and Reference Manual.

#Gelfand, A. E., Hills S. E., Racine-Poon, A., and Smith A. F. M. (1990). 
#"Illustration of Bayesian Inference in Normal Data Models Using Gibbs Sampling", 
#Journal of the American Statistical Association, 85, 972-985.
