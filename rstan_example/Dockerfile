#The line below determines the build image to use

FROM rocker/r-apt:bionic

#Install RStan from binary
RUN R -e 'options(Ncpus = 6)'
RUN add-apt-repository -y "ppa:marutter/rrutter3.5"
RUN add-apt-repository -y "ppa:marutter/c2d4u3.5"
RUN apt update && apt install -y r-cran-rstan

#This line determines where to copy project files from, and where to copy them to

COPY . .

#The entrypoint is the command used to start your project

ENTRYPOINT ["Rscript","8schools.R"]