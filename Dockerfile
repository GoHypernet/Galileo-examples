FROM hypernetlabs/simulator:swmm5.1.14
COPY . .
# put the name of your input file here without the .inp extension
ENV SWMMFILE=Example9
# Do you want all your input files returned? 0 = no, 1 = yes
ENV RETURNINPUT=1