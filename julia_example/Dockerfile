#The line below determines the build image to use
FROM julia:1.4

# run as the user "galileo" with associated working directory
RUN useradd -ms /bin/bash galileo
USER galileo
WORKDIR /home/galileo

#The next block determines what dependencies to load
RUN julia -e 'import Pkg; Pkg.add("CSV")'
RUN julia -e 'import Pkg; Pkg.add("DataFrames")'
RUN julia -e 'import Pkg; Pkg.add("GLM")'
RUN julia -e 'import Pkg; Pkg.add("RDatasets")'
RUN julia -e 'import Pkg; Pkg.add("StatsBase")'

#This line determines where to copy project files from, and where to copy them to
COPY . .

#The entrypoint is the command used to start your project
ENTRYPOINT ["julia","julia_example.jl"]
