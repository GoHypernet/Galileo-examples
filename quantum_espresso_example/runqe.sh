#!/bin/bash
mpirun -np 1 pw.x < pw.methane.in
mpirun -np 1 turbo_davidson.x < turbo_davidson.methane.in 
mpirun -np 1 turbo_spectrum.x < turbo_spectrum.methane.in