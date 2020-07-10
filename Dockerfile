FROM hypernetlabs/simulator:namd
COPY . .
# this command uses 4 MPI processes and all available GPUs
ENTRYPOINT ["namd2","+ppn","4","+setcpuaffinity","+idlepoll","apoa1.namd"]
