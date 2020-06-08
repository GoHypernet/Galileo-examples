# Tuflow example
This is example comes from the Tuflow example that can be found here: https://wiki.tuflow.com/

The file called 'Dockerfile' is the configuration file required for Galileo to run Tuflow. It must be located
in the parent directory of you model. It takes 2 parameters: the name subdirectory where your .bat processing file is located (via the environment variable RUNS_DIR)
and the name of the .bat processing file (via the environment variable TUFLOW_BAT). 

The paths to the single and double precision executables are preset and available through the environment variables: EXE_iSP and EXE_iDSP. If you have the variables set in your .bat file, be sure to comment them out.  

This folder can be dropped directly into the Galileo interface onto a windows compatible station and will begin execution automatically. It is a rather large file tree so upload time is on the order of a couple of minutes.