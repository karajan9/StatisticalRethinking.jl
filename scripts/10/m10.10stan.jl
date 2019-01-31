using StatisticalRethinking
using Turing

Turing.setadbackend(:reverse_diff)

d = CSV.read(joinpath(dirname(Base.pathof(StatisticalRethinking)), "..", "data",
    "Kline.csv"), delim=';')
size(d) # Should be 10x5

# New col log_pop, set log() for population data
d[:log_pop] = map(x -> log(x), d[:population])

# New col contact_high, set binary values 1/0 if high/low contact
d[:contact_high] = map(x -> ifelse(x=="high", 1, 0), d[:contact])

# This is supposed to be a "bad" model since we take non-centered data for the
# predictor log_pop
@model m10_10stan(total_tools, log_pop, contact_high) = begin
    α ~ Normal(0, 100)
    βp ~ Normal(0, 1)
    βc ~ Normal(0, 1)
    βpc ~ Normal(0, 1)

    for i ∈ 1:length(total_tools)
        λ = exp(α + βp*log_pop[i] + βc*contact_high[i] +
            βpc*contact_high[i]*log_pop[i])
        total_tools[i] ~ Poisson(λ)
    end
end

posterior = sample(m10_10stan(d[:total_tools], d[:log_pop],
    d[:contact_high]), Turing.NUTS(3000, 1000, 0.95))
describe(posterior)
# Something is fishy with this (i.e., compare to Rethinking below)
# It could be due to the non-centered predictors since each run w/ Turing
# gives widely different posterior. Most likely Turing doesn't handle
# non-centered predictors very well?

# Rethinking
#     mean   sd  5.5% 94.5% n_eff Rhat
# a    0.94 0.37  0.36  1.53  3379    1
# bp   0.26 0.04  0.21  0.32  3347    1
# bc  -0.08 0.84 -1.41  1.23  2950    1
# bpc  0.04 0.09 -0.10  0.19  2907    1