From julia
RUN julia -e 'import Pkg; Pkg.add("LightGraphs")' && \
    julia -e 'import Pkg; Pkg.add("DataFrames")' && \
    julia -e 'import Pkg; Pkg.add("SpecialFunctions")' && \
    julia -e 'using LightGraphs' && \
    julia -e 'using DataFrames'
COPY . .
ENTRYPOINT ["julia","project1.jl","small.csv","bayesnetwork.gph"]