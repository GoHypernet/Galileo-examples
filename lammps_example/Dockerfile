FROM hypernetlabs/simulator:lammps
COPY . .
ENTRYPOINT ["mpirun","-np","1","lmp","-in","in.nemd.2d"]
