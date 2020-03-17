#The line below determines the build image to use

FROM hypernetlabs/stata:16

COPY . /data

#The entrypoint is the command used to start your project

ENTRYPOINT ["/usr/local/stata16/stata-mp","/data/carsdata.do"]