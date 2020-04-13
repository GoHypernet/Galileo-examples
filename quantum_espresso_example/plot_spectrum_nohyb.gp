set terminal post eps enhanced solid color "Helvetica" 20
set output "Methane_spectrum.eps"
set xrange [7.0:13.0]
set yrange [0:0.6]
set xtics 0.0, 1.0
set xlabel "{/Symbol w} (eV)"
set ylabel "Intensity (arb. units)"
plot "Methane.plot.dat" u ($1)*13.6:($2)*0.03 w l lw 2 title 'turbo-davidson.x (nohybrid)'
