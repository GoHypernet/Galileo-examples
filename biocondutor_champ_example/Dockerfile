#Hypernet Labs has prebuilt a biocondutor container with the ChAMP package preinstalled 
FROM hypernetlabs/bioconductor_docker_champ

#The next block determines what dependencies to load
RUN R -e 'options(Ncpus = 4)'

# run as the user "galileo" with associated working directory
RUN useradd -ms /bin/bash galileo
USER galileo
WORKDIR /home/galileo

# You can still install any other dependencies you need as if it was a normal R environment

#This line determines where to copy project files from, and where to copy them to
COPY . .

#The entrypoint is the command used to start your project
ENTRYPOINT ["Rscript","EXAMPLE.R"]
