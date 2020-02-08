@time using StatisticalRethinking, StanSample
@time using DataFrames, CSV, StatsBase
using KernelDensity, MonteCarloMeasurements
@time using StatsPlots

ProjDir = @__DIR__

df = CSV.read(rel_path("..", "data", "Howell1.csv"), delim=';')

# Use only adults

df2 = filter(row -> row[:age] >= 18, df);
mean_weight = mean(df2[:, :weight]);
df2[!, :weight_c] = df2[:, :weight] .- mean_weight;
first(df2, 5)

# Define the Stan language model

weightsmodel = "
data {
 int < lower = 1 > N; // Sample size
 vector[N] height; // Predictor
 vector[N] weight; // Outcome
}

parameters {
 real alpha; // Intercept
 real beta; // Slope (regression coefficients)
 real < lower = 0 > sigma; // Error SD
}

model {
 height ~ normal(alpha + weight * beta , sigma);
}

generated quantities {
} 
";

# Define the SampleModel.

sm = SampleModel("weights", weightsmodel);

# Input data

heightsdata = Dict("N" => length(df2[:, :height]), 
	"height" => df2[:, :height], "weight" => df2[:, :weight_c]);

# Sample using cmdstan

rc = stan_sample(sm, data=heightsdata);

if success(rc)

	# Describe the draws
	df = read_samples(sm; output_format=:dataframe)

	# ### snippet 4.37

	# Plot regression line using means and observations

	scatter(df2[:, :weight_c], df2[:, :height], lab="Observations",
	  ylab="height [cm]", xlab="weight[kg]")
	xi = -16.0:0.1:18.0
	yi = mean(df[:, :alpha]) .+ mean(df[:, :beta])*xi;
	plot!(xi, yi, lab="Regression line")
	savefig("$ProjDir/Fig-37-43.2.png")

	# ### snippet 4.44

	println()
	q = quap(df)
	display(q)

end

# End of `clip-37-44.jl`