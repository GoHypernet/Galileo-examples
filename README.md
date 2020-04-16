# Galileo application example repository for GPUs 

This repository contains examples of how to run jobs on GPU machines in Galileo.  

The first example, check_gpu_example, performs no computations but instead returns the 
hardware information of the machine it was deployed to in the output.txt file. The hardware 
information is aquired by running the nvidia-smi command in the Dockerfile entrypoint. 

The seconnd example, small_tf_gpu_example, performs a short running gradient descent optimization 
problem using the official tensorflow base image for gpu platforms. See the Dockerfile in this folder
for the entrypoint of the calculation. 