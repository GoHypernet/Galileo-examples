#The line below determines the build image to use

FROM hyperdyne/simulator:hecras

#This is where you will set your Galileo volume to be located

ENV OUTPUT_DIRECTORY="C:\Users\Public\Output"

#Be sure to place this Dockerfile in the directory containing your .prj file

COPY . ${RAS_BASE_DIR}\\${RAS_EXPERIMENT}