#The line below determines the build image to use
FROM hypernetlabs/stata:16

# for serial stata, use this line to call the stata executable
ENV STATA stata

# for stata to run in parallel, uncomment this line to run stata-mp (if you're not licensed for MP, this won't run)
#ENV STATA stata-mp

# set the name of the .do file
ENV DOFILE=carsdata

COPY . .
