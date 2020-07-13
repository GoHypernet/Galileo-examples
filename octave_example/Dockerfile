# "official" GNU octave base image
FROM mtmiller/octave

# this is how packages are installed 
RUN octave --no-gui --eval "pkg install -forge io"
RUN octave --no-gui --eval "pkg install -forge statistics"
RUN octave --no-gui --eval "pkg install -forge dataframe"

# run as the user "galileo" with associated working directory
RUN useradd -ms /bin/bash galileo
USER galileo
WORKDIR /home/galileo

# copy into working directory and can octave executable
COPY . .
ENTRYPOINT ["octave","octave_example.m"]
