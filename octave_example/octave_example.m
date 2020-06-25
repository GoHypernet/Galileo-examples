pkg load dataframe
pkg load io
pkg load statistics
disp("REGRESSION EXAMPLE")
disp("Let's run a simple regression with the mtcars dataset and make a plot, which will be saved in the filesys folder.")

mtcars = dataframe("mtcars.csv");
X = [ones(length(mtcars.wt), 1), mtcars.wt]; % add column of 1s to regressor matrix
[b, bint, r, rint, stats] = regress(mtcars.mpg, X);
# print regression output
disp(" --Coefficients-- ")
disp(sprintf("Intercept: %f", b(1)))
disp(sprintf("Beta: %f", b(2)))
disp(" --95% coefficient confidence intervals-- ")
disp(sprintf("Intercept lower: %f", bint(1,1)))
disp(sprintf("Intercept upper: %f", bint(1,2)))
disp(sprintf("Beta lower: %f", bint(2,1)))
disp(sprintf("Beta upper: %f", bint(2,2)))
disp(" --Statistics-- ")
disp(sprintf("R-squared: %f", stats(1)))
disp(sprintf("F-statistic: %f", stats(2)))
disp(sprintf("p-value for full model: %f", stats(3)))
disp(sprintf("Estimated error variance: %f", stats(4)))

# plot regression results
y_hat = b(1) + b(2)*mtcars.wt;
figure;
scatter(mtcars.wt, mtcars.mpg, "r");
hold on; % overlay regression line on existing scatter plot
plot(mtcars.wt, y_hat, "-");
legend('Training data', 'Linear regression');
title ("Regression Results");
xlabel ("Car Weight (in 1000 of lbs)");
ylabel ("Miles per Gallon");
saveas(1, "reg_results.png", "png");

# import data from an external source
disp("USING DATA FROM AN ONLINE SOURCE")
url = "https://courses.washington.edu/b517/Datasets/string.txt";
raw_data = urlread(url);
rows = strsplit(raw_data);
rows(1) = []; % exclude headers;
rows(1) = [];
rows(length(rows)) = []; % exclude footer;
clean_rows = transpose(reshape(transpose(rows), 2, 21)); % format data for plotting
float_data = cellfun(@str2double, clean_rows); % convert to floats
disp("Example data:")
disp(float_data);
figure(2);
scatter(float_data(:,1), float_data(:,2));
title ("External Data");
xlabel ("x");
ylabel ("y");
saveas(2, "ex_results.png", "png");

disp("MONTE CARLO EXAMPLE")
disp("What is the probability that the sum of rolling two fair dice is at least 7?")
disp("We can work out the answer (0.583), but let's prove it with simulation.")
disp("We'll write a function that simulates trials of dice throws and returns TRUE if at least 7.")

function retval = throws (numberDice, numberSides, targetValue, numberTrials)
  trials = randi(numberSides, numberDice, numberTrials);
  retval = sum(trials) >= targetValue;
endfunction

rand("seed", 1800) % set random seed for reproducibility
disp("Let's try 50,000 trials, record the system time, & calculate the mean of the outcomes.")
tic ();
estimate_50k = mean(throws(2, 6, 7, 50000));
disp(sprintf("The mean is: %f", estimate_50k))
disp(sprintf("Elapsed time: %f", toc ()));

disp("Pretty close but we're still a little off -- let's try 10 million throws, record the system time, & calculate the mean of the outcomes.")
tic ();
estimate_10mil = mean(throws(2, 6, 7, 10000000));
disp(sprintf("The mean is: %f", estimate_10mil))
disp(sprintf("Elapsed time: %f", toc ()));

disp("As you can see, the result is much more accurate, and the run didn't take very long.")