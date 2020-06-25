FROM mtmiller/octave
RUN octave --no-gui --eval "pkg install -forge io"
RUN octave --no-gui --eval "pkg install -forge statistics"
RUN octave --no-gui --eval "pkg install -forge dataframe"
COPY . .
ENTRYPOINT ["octave","octave_example.m"]
