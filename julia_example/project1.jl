using LightGraphs
using DataFrames
import Printf
import Random
import Core
import SpecialFunctions.lgamma

"""
    write_gph(dag::DiGraph, idx2names, filename)

Takes a DiGraph, a Dict of index to names and a output filename to write the graph in `gph` format.
"""
function write_gph(dag::DiGraph, idx2names, filename)
    open(filename, "w") do io
        for edge in edges(dag)
            Printf.@printf(io, "%s, %s\n", idx2names[src(edge)], idx2names[dst(edge)])
        end
    end
end

function local_search(data::DataFrame, dag::DiGraph, f_score)

    println("local optimization...")
    col_nms   = names(data)
    (no,nvar) = size(data)
    
    new_score = f_score(dag, col_nms, data)
    cur_score = new_score - 1
    println("starting score: $(new_score)")
    while new_score > cur_score
        cur_score = new_score
        cur_best  = cur_score
        new_src   = 0
        new_dst   = 0
        rmv_edg   = false
        for e in edges(dag)
            source = src(e)
            destin = dst(e)
            # first try removing the edge
            rem_edge!(dag,e)
            if !is_cyclic(dag)
                new_score = f_score(dag, col_nms, data)
                if new_score > cur_best
                    cur_best = new_score
                    new_src  = source
                    new_dst  = destin
                    rmv_edg  = true
                end
            end
            # then try reversing the edge
            add_edge!(dag,destin,source)
            if !is_cyclic(dag)
                new_score = f_score(dag, col_nms, data)
                if new_score > cur_best
                    cur_best = new_score    
                    new_src  = destin
                    new_dst  = source
                    rmv_edg  = false
                end
            end
            # then put edge back where it was
            rem_edge!(dag,destin,source)
            add_edge!(dag,source,destin)
        end
        if cur_best > cur_score
            if rmv_edg
                println("Removing Edge, $(new_src)->$(new_dst)")
                rem_edge!(dag, new_src, new_dst)
            else
                println("Reversing Edge, $(new_dst)->$(new_src)")
                rem_edge!(dag, new_dst, new_src)
                add_edge!(dag, new_src, new_dst)
            end
            new_score = cur_best
        end
    end
end

function K2_search(data::DataFrame, dag::DiGraph, f_score)
    println("Greedy optimization...")
    # Get the number of discrete values each vertex can take
    col_nms     = names(data) 
    max_num_par = 8 
    (no,nvar)   = size(data)

    # First, for loop over variable ordering
    ordering  = Random.shuffle(1:nvar)
    #ordering = 1:nvar
    current_best_score = f_score(dag, col_nms, data)
    for i in ordering
        # Second, for loop over parents for current vertex
        candidates = Set(1:nvar)
        # don't let vertex be its own parent
        pop!(candidates,i)
        # add parents to i until we reach max number of parents
        # or adding another parent causes the objective to decrease
        println("Var: $(i)")
        while length(inneighbors(dag, i)) < max_num_par
            # find best variable to add from candidates
            new_var = 0
            for j in candidates
                add_edge!(dag, j, i)
                # if it creates a cycle, remove it
                if is_cyclic(dag)
                    println("Removing cycle, $(j)->$(i)")
                    rem_edge!(dag, j, i)
                    pop!(candidates, j)
                    continue
                end
                new_score = f_score(dag, col_nms, data, i, j, current_best_score)
                rem_edge!(dag, j, i)
                # if the new parent increases the objective
                # store it and record new best score
                if new_score > current_best_score 
                    current_best_score = new_score
                    new_var = j
                end 
            end
            # after checking all candidates, if we have new one add it
            # otherwise break from while loop
            if new_var != 0
               println("Adding edge, $(new_var)->$(i)")
               add_edge!(dag, new_var, i)
               pop!(candidates, new_var)
            else
               break
            end
        end
    end
end

# this function calculates score by updating old score
function bayes_score(dag::DiGraph, nms, data, vert, newPar, bscore)

    rem_edge!(dag, newPar, vert)
    nvars = length(nms)
    r_vec = Core.Array{Int}(undef,0)
    for var = 1:nvars
        push!(r_vec, maximum(data[:,var]))
    end

    # first subtract the previous contribution from this vertex
    parents = inneighbors(dag,vert)
    num_par = length(parents)
    pstate  = ones(Int, 1, num_par)
    maxpval = r_vec[parents]
    # get the number of parent states
    q = 1
    for i = 1:num_par
        q *= maxpval[i]
    end
    subData = Core.Array{DataFrame}(undef,num_par)
    if num_par == 0
        push!(subData, data)
    else
        subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
        # pre-sort data
        for p1 = num_par-1:-1:1
            df = subData[p1+1]
            subData[p1] = df[df[parents[p1]] .== pstate[p1], :]
        end
    end 
    for j = 1:q
        mij0 = 0
        aij0 = 0
        inner_score = 0
        # loop over the variables possible states
        for k = 1:r_vec[vert]
            sd = subData[1]
            (mijk,dummy) = size(sd[sd[vert] .== k, :])
            aijk = 1
            mij0 += mijk
            aij0 += aijk
            inner_score += (lgamma(aijk + mijk) - lgamma(aijk))
        end
        inner_score += (lgamma(aij0) - lgamma(aij0 + mij0))
        bscore -= inner_score
        # increment the state vector
        for i = 1:num_par
            if i == 1
                pstate[i] += 1
            end
            if pstate[i] > maxpval[i]
                if i < num_par
                    pstate[i+1] += 1
                end
                pstate[i] = 1
                if num_par > 1
                    # first resort next level
                    if i == num_par
                        subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
                    elseif i == num_par - 1
                        subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
                        df = subData[num_par]
                        subData[i] = df[df[parents[i]] .== pstate[i], :]
                    else
                        df = subData[i+2]
                        subData[i+1] = df[df[parents[i+1]] .== pstate[i+1], :]
                        df = subData[i+1]
                        subData[i] = df[df[parents[i]] .== pstate[i], :]
                    end
                    #then filter down
                    for p1 = i-1:-1:2
                        df = subData[p1+1]
                        subData[p1] = df[df[parents[p1]] .== pstate[p1], :]
                    end
                end
            end
            supData = DataFrame
            if num_par > 1
               supData = subData[2]
            else
               supData = data
            end
            (x,c) = size(supData)
            subData[1] = supData[ supData[parents[1]] .== pstate[1], :]
        end
    end

    # then add the new contribution
    nvars = length(nms)
    r_vec = Core.Array{Int}(undef,0)
    for var = 1:nvars
        push!(r_vec, maximum(data[:,var]))
    end

    # first subtract the previous contribution from this vertex
    add_edge!(dag, newPar, vert)
    parents = inneighbors(dag,vert)
    num_par = length(parents)
    pstate  = ones(Int, 1, num_par)
    maxpval = r_vec[parents]
    # get the number of parent states
    q = 1
    for i = 1:num_par
        q *= maxpval[i]
    end
    subData = Core.Array{DataFrame}(undef,num_par)
    if num_par == 0
        push!(subData, data)
    else
        subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
        # pre-sort data
        for p1 = num_par-1:-1:1
            df = subData[p1+1]
            subData[p1] = df[df[parents[p1]] .== pstate[p1], :]
        end
    end 
    for j = 1:q
        mij0 = 0
        aij0 = 0
        inner_score = 0
        # loop over the variables possible states
        for k = 1:r_vec[vert]
            sd = subData[1]
            (mijk,dummy) = size(sd[sd[vert] .== k, :])
            aijk = 1
            mij0 += mijk
            aij0 += aijk
            inner_score += (lgamma(aijk + mijk) - lgamma(aijk))
        end
        inner_score += (lgamma(aij0) - lgamma(aij0 + mij0))
        bscore += inner_score
        # increment the state vector
        for i = 1:num_par
            if i == 1
                pstate[i] += 1
            end
            if pstate[i] > maxpval[i]
                if i < num_par
                    pstate[i+1] += 1
                end
                pstate[i] = 1
                if num_par > 1
                    # first resort next level
                    if i == num_par
                        subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
                    elseif i == num_par - 1
                        subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
                        df = subData[num_par]
                        subData[i] = df[df[parents[i]] .== pstate[i], :]
                    else
                        df = subData[i+2]
                        subData[i+1] = df[df[parents[i+1]] .== pstate[i+1], :]
                        df = subData[i+1]
                        subData[i] = df[df[parents[i]] .== pstate[i], :]
                    end
                    #then filter down
                    for p1 = i-1:-1:2
                        df = subData[p1+1]
                        subData[p1] = df[df[parents[p1]] .== pstate[p1], :]
                    end
                end
            end
            supData = DataFrame
            if num_par > 1
               supData = subData[2]
            else
               supData = data
            end
            (x,c) = size(supData)
            subData[1] = supData[ supData[parents[1]] .== pstate[1], :]
        end
    end

    return bscore
end

# this function calculates score from scratch
function bayes_score(dag::DiGraph, nms, data)

    nvars = length(nms)
    r_vec = Core.Array{Int}(undef,0)
    for var = 1:nvars
        push!(r_vec, maximum(data[:,var]))
    end
    
    # loop over vertices in the digraph 
    bscore = 0
    for vert in vertices(dag) 
        parents = inneighbors(dag,vert)
        num_par = length(parents)
        pstate  = ones(Int, 1, num_par)
        maxpval = r_vec[parents]
        # get the number of parent states
        q = 1
        for i = 1:num_par
            q *= maxpval[i]
        end
        subData = Core.Array{DataFrame}(undef,num_par)
        if num_par == 0
            push!(subData, data)
        else
            subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
            # pre-sort data
            for p1 = num_par-1:-1:1
                df = subData[p1+1]
                subData[p1] = df[df[parents[p1]] .== pstate[p1], :]
            end
        end
        # loop over each of the parent states
        for j = 1:q
            mij0 = 0
            aij0 = 0
            inner_score = 0
            # loop over the variables possible states
            for k = 1:r_vec[vert]
                sd = subData[1]
                (mijk,dummy) = size(sd[sd[vert] .== k, :])
                aijk = 1
                mij0 += mijk
                aij0 += aijk
                inner_score += (lgamma(aijk + mijk) - lgamma(aijk))
            end
            inner_score += (lgamma(aij0) - lgamma(aij0 + mij0))
            bscore += inner_score
            # increment the state vector
            for i = 1:num_par
                if i == 1
                    pstate[i] += 1
                end
                if pstate[i] > maxpval[i]
                    if i < num_par 
                        pstate[i+1] += 1
                    end
                    pstate[i] = 1
                    if num_par > 1 
                        # first resort next level    
                        if i == num_par
                            subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
                        elseif i == num_par - 1
                            subData[num_par] = data[data[parents[num_par]] .== pstate[num_par], :]
                            df = subData[num_par]
                            subData[i] = df[df[parents[i]] .== pstate[i], :]
                        else
                            df = subData[i+2]
                            subData[i+1] = df[df[parents[i+1]] .== pstate[i+1], :]
                            df = subData[i+1]
                            subData[i] = df[df[parents[i]] .== pstate[i], :]
                        end
                        #then filter down
                        for p1 = i-1:-1:2
                            df = subData[p1+1]
                            subData[p1] = df[df[parents[p1]] .== pstate[p1], :]
                        end 
                    end
                end
                supData = DataFrame
                if num_par > 1
                   supData = subData[2]
                else
                   supData = data
                end
                (x,c) = size(supData)
                subData[1] = supData[ supData[parents[1]] .== pstate[1], :]
            end
        end
    end
    return bscore
end

function compute(infile, outfile)
   
    println("Reading data from file: $(infile)") 
    # First, read the comma delimited data file
    data = readtable(infile);

    # Then get number of variables and observations
    (n_obs,n_vert) = size(data)
    println("There are $(n_obs) measurements")

    # Get names of variables
    idx2names = names(data)

    println("initializing digraph with $(n_vert) nodes")
    # Initialize a directed graph with no edges
    dg = DiGraph(n_vert,0)
    @assert nv(dg) == n_vert

    println("learning graph structure...")
    # Pass data and initialized graph into function for structure learning
    myScoreFunc = bayes_score
    K2_search(data, dg, myScoreFunc)
    local_search(data, dg, myScoreFunc)
    graph_score = bayes_score(dg, idx2names, data)
    println("Done. Bayesian score: $(graph_score)")

    if is_cyclic(dg)
        println("graph is cyclic!")
    end

    println("Writing results to: $(outfile)\n")
    # write optimized graph to file
    write_gph(dg, idx2names, outfile)
end

if length(ARGS) != 2
    error("usage: julia project1.jl <infile>.csv <outfile>.gph")
end

inputfilename  = ARGS[1]
outputfilename = ARGS[2]

compute(inputfilename, outputfilename)
