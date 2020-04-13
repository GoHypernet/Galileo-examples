# Example 7 from Quantum Espresso GitLab Repository: Calculation of the absorption spectrum of methane molecule (CH4) with hybrid pseudo-potential using the turbo_davidson.x code

 1. Run the SCF ground-state calculation

    ```
    mpirun -np 8 pw.x < pw.methane.in > pw.methane.out
    ```

 2. Run the turboDavidson calculation

    ```
    mpirun -np 8 turbo_davidson.x < turbo_davidson.methane.in > turbo_davidson.methane.out
    ```

 3. Run the spectrum calculation

    ```
    mpirun -np 8 turbo_spectrum.x < turbo_spectrum.methane.in > turbo_spectrum.methane.out
    ```

 4. Plot the spectrum using "gnuplot" and the script "plot_spectrum_nohyb.gp". 
    You should obtain the no-hybrid spectrum.

    ```
    gnuplot -> load 'plot_spectrum_nohyb.gp'
    evince Methane_spectrum.eps
    ```


 5. Switch on the hybrid pseudo-potential (B3LYP) 
    and see how changes the absorption spectrum of methane.

    Make the following modifications in the input files:
    
    ```
    * In the file 'pw.methane.in' add in SYSTEM block input_dft = 'B3LYP'
    * In the file 'turbo_davidson.methane.in'  set  d0psi_rs = .true.
    ```

    Once these modifications are done, repeat steps 1, 2, 3, and use the script "plot_spectrum_hyb.gp"
    to plot the spectrum.     

   
