#The line below determines the build image to use

FROM rocker/r-apt:bionic

#Install RStan from binary
RUN R -e 'options(Ncpus = 16)'
RUN apt update && apt install -y r-cran-rjags

#This line determines where to copy project files from, and where to copy them to

COPY . .

#The entrypoint is the command used to start your project

ENTRYPOINT ["Rscript","rjags_example.R"]