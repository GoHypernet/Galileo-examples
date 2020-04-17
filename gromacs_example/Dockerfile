#The line below determines the build image to use from a public or private repo in DockerHub
FROM hypernetlabs/simulator:gromacs

#This line determines where to copy project files from, and where to copy them to
COPY . .

#This command starts execution.
ENTRYPOINT ["bash","rungmx.sh"]





