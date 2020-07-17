#!/bin/bash
mpirun -np $(nproc) pw.x < pw.methane.in
mpirun -np $(nproc) turbo_davidson.x < turbo_davidson.methane.in 
mpirun -np $(nproc) turbo_spectrum.x < turbo_spectrum.methane.in
