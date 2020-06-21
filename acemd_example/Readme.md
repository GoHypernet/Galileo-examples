# Acellera ACEMD3 example
This example comes preinstalled with the acemd3 software when installed via Anaconda (see https://software.acellera.com/docs/latest/acemd3/tutorial.html for more details). The number of timesteps has been modified so that the example runs in a couple of minutes. 

To run acemd3 in Galileo, place a dockerfile referencing the hypernetlabs/simulator:acemd3 base image at the top of your project directory  and ensure that the file you are passing to the acemd3 simulator is called 'input' with no extension (just as in this example).

When you download the results, in the filesys folder you will find your output files in the /home/galileo subdirectory. 
