using CSV, DataFrames, GLM, RDatasets, StatsBase
println("REGRESSION EXAMPLE")
println("Let's run a simple regression with the mtcars dataset and make a plot, which will be saved in the filesys folder.")

mtcars = DataFrame(CSV.File("mtcars.csv"))
model1 = lm(@formula(mpg ~ wt), mtcars)
println(model1)

# uncomment the block below to print an example of loading data from a package
# println("It is also possible to load data from a library.")
# println("Here are five example rows of the iris data set loaded from the RDatasets packages.")
# iris = dataset("datasets", "iris")
# println(first(iris, 5))

println("MONTE CARLO EXAMPLE")
println("What is the probability that the sum of rolling two fair dice is at least 7?")
println("We can work out the answer (0.583), but let's prove it with simulation.")
println("We'll write a function that simulates trials of dice throws and returns TRUE if at least 7.")

using Random

function throws(numberDice, numberSides, targetValue, numberTrials)
    trials = reshape(sample(1:numberSides, numberDice*numberTrials, replace=true), (numberDice, numberTrials))
    outcomes = Vector()
    for trial in eachcol(trials)
        if sum(trial) >= targetValue
            push!(outcomes, 1)
        else
            push!(outcomes, 0)
        end
    end
    return outcomes
end

Random.seed!(1800)

println("Let's try 50,000 trials, record the system time, & calculate the mean of the outcomes.")
@time estimate_50k = mean(throws(2, 6, 7, 50000))
println("The mean is: ", estimate_50k)

println("Pretty close but we're still a little off -- let's try 10 million throws, record the system time, & calculate the mean of the outcomes.")
@time estimate_10mil = mean(throws(2, 6, 7, 10000000))
println("The mean is: ", estimate_10mil)

println("As you can see, the result is much more accurate, and the run didn't take very long.")
