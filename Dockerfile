#The line below determines the build image to use

FROM hypernetlabs/simulator:q-e

#This line determines where to copy project files from, and where to copy them to
COPY . .

ENTRYPOINT ["bash","runqe.sh"]