#The line below determines the build image to use
FROM rocker/r-apt:bionic

#The next block determines what dependencies to load
RUN R -e 'options(Ncpus = 4)'

#There are two ways to install packages - this method installs from source
RUN R -e 'install.packages("parallel")'

#This method installs from binaries and is faster but not every package has a binary
#RUN apt-get update && apt-get install -y -qq r-cran-parallel

#This line determines where to copy project files from, and where to copy them to
COPY . .

#The entrypoint is the command used to start your project
ENTRYPOINT ["Rscript","rMonteCarlo.R"]