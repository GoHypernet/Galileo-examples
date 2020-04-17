# Gromacs GPU example

This folder contains a ready-to-run gromacs example for GPU platforms.

The shell script, rungmx.sh, contains the commands to run for your analysis. 

The Dockerfile runs this shell script on container startup. In order for you to modify this example 
for your own analysis, copy rungmx.sh and Dockerile to your project folder and edit the command in rungmx.sh 
as needed. 