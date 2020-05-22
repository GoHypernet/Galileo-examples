# Tuflow example
This is example comes from the Tuflow example that can be found here: https://wiki.tuflow.com/

The file called 'Dockerfile' is the configuration file required for Galileo to run Tuflow. It must be located
in the parent directory of you model. It takes 2 parameters: the name subdirectory where your .bat processing file is located 
and the name of the .bat processing file. 

The paths to the single and double precision executables are given by the environment variables: EXE_iSP and EXE_iDSP. These are 
preset in the container environment. 

This folder can be dropped directly into the Galileo interface onto a windows compatible station and will begin execution automatically. 