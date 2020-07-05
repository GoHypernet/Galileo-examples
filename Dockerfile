FROM hypernetlabs/simulator:namd
COPY . .
ENTRYPOINT ["namd2","+ppn","4","+setcpuaffinity","+idlepoll","apoa1.namd"]