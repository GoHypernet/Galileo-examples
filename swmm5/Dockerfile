FROM hypernetlabs/simulator:swmm
COPY . .
# put the engine version number to use, note: linux only supports 5.1.014 at this time
ENV VERSION="5.1.014"
# put the name of your input file here without the .inp extension
ENV SWMMFILE=Example9
# Do you want all your input files returned? 0 = no, 1 = yes
ENV RETURNINPUT=1