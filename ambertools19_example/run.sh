#!/bin/sh
mpirun -np 4 sander.MPI -i md.in -c dhfr.crd -p dhfr.prmtop -o dhfr.md.out -r dhfr.md.rst -inf dhfr.md.inf -x dhfr.md.nc -O
