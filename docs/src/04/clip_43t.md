

```julia
using StatisticalRethinking
gr(size=(500,500));

Turing.setadbackend(:reverse_diff)

ProjDir = rel_path("..", "chapters", "04")
cd(ProjDir)
```

    loaded


    ┌ Warning: Package Turing does not have CmdStan in its dependencies:
    │ - If you have Turing checked out for development and have
    │   added CmdStan as a dependency but haven't updated your primary
    │   environment's manifest file, try `Pkg.resolve()`.
    │ - Otherwise you may need to report an issue with Turing
    │ Loading CmdStan into Turing from project dependency, future warnings for Turing are suppressed.
    └ @ nothing nothing:840
    WARNING: using CmdStan.Sample in module Turing conflicts with an existing identifier.


### snippet 4.43


```julia
howell1 = CSV.read(rel_path("..", "data", "Howell1.csv"), delim=';')
df = convert(DataFrame, howell1);
```

Use only adults


```julia
df2 = filter(row -> row[:age] >= 18, df);
```

Center the weight observations and add a column to df2


```julia
mean_weight = mean(df2[:weight])
df2 = hcat(df2, df2[:weight] .- mean_weight)
rename!(df2, :x1 => :weight_c); # Rename our col :x1 => :weight_c
```

Extract variables for Turing model


```julia
y = convert(Vector{Float64}, df2[:height]);
x = convert(Vector{Float64}, df2[:weight_c]);
```

Define the regression model


```julia
@model line(y, x) = begin
    #priors
    alpha ~ Normal(178.0, 100.0)
    beta ~ Normal(0.0, 10.0)
    s ~ Uniform(0, 50)

    #model
    mu = alpha .+ beta*x
    for i in 1:length(y)
      y[i] ~ Normal(mu[i], s)
    end
end;
```

Draw the samples


```julia
chn = sample(line(y, x), Turing.NUTS(1000, 0.65));
```

    ┌ Info: [Turing] looking for good initial eps...
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/samplers/support/hmc_core.jl:246
    [NUTS{Turing.FluxTrackerAD,Any}] found initial ϵ: 0.1
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/samplers/support/hmc_core.jl:291
    [32m[NUTS] Sampling...  0%  ETA: 0:56:29[39m┌ Warning: Numerical error has been found in gradients.
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:154
    ┌ Warning: grad = [-15.6867, -81.5773, NaN]
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:155
    ┌ Warning: Numerical error has been found in gradients.
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:154
    ┌ Warning: grad = [-12.5335, 7.33779, NaN]
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:155
    [32m[NUTS] Sampling...  3%  ETA: 0:04:33[39m
    [34m  ϵ:         0.8470967451647406[39m
    [34m  α:         0.5000000000001107[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling...  5%  ETA: 0:03:02[39m
    [34m  ϵ:         0.12722222245030354[39m
    [34m  α:         0.39738373904468827[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling...  6%  ETA: 0:02:40[39m
    [34m  ϵ:         0.10018418160283973[39m
    [34m  α:         0.9609897663274202[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m┌ Warning: Numerical error has been found in gradients.
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:154
    ┌ Warning: grad = [-1.4844, 2.78248, NaN]
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:155
    
    
    
    [32m[NUTS] Sampling...  7%  ETA: 0:02:22[39m
    [34m  ϵ:         0.09694897274931887[39m
    [34m  α:         0.8359324640959703[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling...  9%  ETA: 0:02:08[39m
    [34m  ϵ:         0.03675403932780125[39m
    [34m  α:         0.9872307945950234[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 10%  ETA: 0:01:53[39m
    [34m  ϵ:         0.054510338272609114[39m
    [34m  α:         0.9448832844123188[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m┌ Warning: Numerical error has been found in gradients.
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:154
    ┌ Warning: grad = [4.65084, -31.0158, NaN]
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/core/ad.jl:155
    
    
    
    [32m[NUTS] Sampling... 12%  ETA: 0:01:41[39m
    [34m  ϵ:         0.038331414464152516[39m
    [34m  α:         1.0[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 13%  ETA: 0:01:39[39m
    [34m  ϵ:         0.04491546740677374[39m
    [34m  α:         0.6273296315204835[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 15%  ETA: 0:01:35[39m
    [34m  ϵ:         0.018769531524153414[39m
    [34m  α:         0.9972454456808398[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 15%  ETA: 0:01:36[39m
    [34m  ϵ:         0.038760406946372845[39m
    [34m  α:         0.9648245453894606[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 17%  ETA: 0:01:30[39m
    [34m  ϵ:         0.04287201051892066[39m
    [34m  α:         0.959020248025123[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 18%  ETA: 0:01:30[39m
    [34m  ϵ:         0.014907511535341[39m
    [34m  α:         0.9899504565558238[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 19%  ETA: 0:01:26[39m
    [34m  ϵ:         0.021462675594256568[39m
    [34m  α:         0.9979841848726891[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 21%  ETA: 0:01:23[39m
    [34m  ϵ:         0.04796229470953636[39m
    [34m  α:         0.9284079582643243[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 22%  ETA: 0:01:21[39m
    [34m  ϵ:         0.04554178003943905[39m
    [34m  α:         0.8662309636647146[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 23%  ETA: 0:01:19[39m
    [34m  ϵ:         0.02208450146541473[39m
    [34m  α:         0.854756729701029[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 25%  ETA: 0:01:14[39m
    [34m  ϵ:         0.025041047742156833[39m
    [34m  α:         0.9914857364798048[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 26%  ETA: 0:01:14[39m
    [34m  ϵ:         0.030694676962245693[39m
    [34m  α:         0.9816514296368362[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 28%  ETA: 0:01:12[39m
    [34m  ϵ:         0.017399211010948844[39m
    [34m  α:         0.9788476614926991[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 29%  ETA: 0:01:11[39m
    [34m  ϵ:         0.03968586335262802[39m
    [34m  α:         0.8734545180836566[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 30%  ETA: 0:01:09[39m
    [34m  ϵ:         0.021612325379460128[39m
    [34m  α:         0.99213392943807[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 31%  ETA: 0:01:06[39m
    [34m  ϵ:         0.0488093355255209[39m
    [34m  α:         0.6793180567247832[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 32%  ETA: 0:01:05[39m
    [34m  ϵ:         0.024775647883757693[39m
    [34m  α:         0.9682272477692[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 34%  ETA: 0:01:04[39m
    [34m  ϵ:         0.033370899184546984[39m
    [34m  α:         1.0[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 36%  ETA: 0:01:01[39m
    [34m  ϵ:         0.02306296308703978[39m
    [34m  α:         0.9780281108387675[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 37%  ETA: 0:01:00[39m
    [34m  ϵ:         0.024679770974614875[39m
    [34m  α:         0.9990957648299956[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 39%  ETA: 0:00:57[39m
    [34m  ϵ:         0.06287477050298765[39m
    [34m  α:         0.719341691576455[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 40%  ETA: 0:00:56[39m
    [34m  ϵ:         0.030897621037628064[39m
    [34m  α:         0.985460246756624[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 42%  ETA: 0:00:53[39m
    [34m  ϵ:         0.05324342913820704[39m
    [34m  α:         0.6103088251628731[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 44%  ETA: 0:00:51[39m
    [34m  ϵ:         0.042897147552825636[39m
    [34m  α:         0.9604995303421351[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 45%  ETA: 0:00:49[39m
    [34m  ϵ:         0.05641726701844395[39m
    [34m  α:         0.9809768236934134[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 46%  ETA: 0:00:49[39m
    [34m  ϵ:         0.016197881155897764[39m
    [34m  α:         0.999249275734108[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 47%  ETA: 0:00:49[39m
    [34m  ϵ:         0.015347293175373915[39m
    [34m  α:         0.9996025523541063[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 48%  ETA: 0:00:48[39m
    [34m  ϵ:         0.0689735151103134[39m
    [34m  α:         0.7788940229805242[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 48%  ETA: 0:00:48[39m
    [34m  ϵ:         0.041972869961319305[39m
    [34m  α:         0.9045969073329609[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 50%  ETA: 0:00:46[39m
    [34m  ϵ:         0.016768355669444103[39m
    [34m  α:         0.9939093334720341[39m
    [A┌ Info:  Adapted ϵ = 0.04757565184611793, std = [1.0, 1.0, 1.0]; 500 iterations is used for adaption.
    └ @ Turing /Users/rob/.julia/packages/Turing/NuLQp/src/samplers/adapt/adapt.jl:91
    
    
    
    [32m[NUTS] Sampling... 51%  ETA: 0:00:45[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9644418092354927[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 53%  ETA: 0:00:42[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.8529645977075473[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 54%  ETA: 0:00:41[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9929165638715568[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 56%  ETA: 0:00:40[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.7728169329797817[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 57%  ETA: 0:00:38[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9204727176767489[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 58%  ETA: 0:00:38[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9075692689562513[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 59%  ETA: 0:00:37[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9608320148523671[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 61%  ETA: 0:00:35[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9254816051938016[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 62%  ETA: 0:00:33[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9999067679144981[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 64%  ETA: 0:00:32[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9051907325636555[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 65%  ETA: 0:00:31[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.7759984724984546[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 66%  ETA: 0:00:30[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.6480203400641713[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 68%  ETA: 0:00:29[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9482339167732441[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 69%  ETA: 0:00:27[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9811417162905937[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 70%  ETA: 0:00:26[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9846869571783018[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 72%  ETA: 0:00:25[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.8217904406115908[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 73%  ETA: 0:00:24[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         1.0[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 74%  ETA: 0:00:23[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.5486004475178139[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 75%  ETA: 0:00:22[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.978005959881214[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 76%  ETA: 0:00:21[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         1.0[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 77%  ETA: 0:00:21[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         1.0[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 78%  ETA: 0:00:19[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.865339286095292[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 80%  ETA: 0:00:18[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.5562128909551285[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 82%  ETA: 0:00:16[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9904145444548179[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 83%  ETA: 0:00:15[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         1.0[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 84%  ETA: 0:00:14[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.668628877429569[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 85%  ETA: 0:00:13[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9882595305338556[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 86%  ETA: 0:00:12[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9117808684347759[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 88%  ETA: 0:00:10[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.450335244620412[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 89%  ETA: 0:00:09[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.856546444973213[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 91%  ETA: 0:00:08[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         1.0[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 92%  ETA: 0:00:07[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.7820511957463132[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 94%  ETA: 0:00:05[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9935086819347967[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 96%  ETA: 0:00:04[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9746996768490805[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 97%  ETA: 0:00:02[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9982689574727237[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    
    [32m[NUTS] Sampling... 99%  ETA: 0:00:01[39m
    [34m  ϵ:         0.04757565184611793[39m
    [34m  α:         0.9130042954479018[39m
    [A4m  pre_cond:  [1.0, 1.0, 1.0][39m
    
    


    [NUTS] Finished with
      Running time        = 84.69045090500005;
      #lf / sample        = 0.002;
      #evals / sample     = 20.541;
      pre-cond. metric    = [1.0, 1.0, 1.0].


    [32m[NUTS] Sampling...100% Time: 0:01:25[39m


Describe the chain result


```julia
describe(chn)
```

    Iterations = 1:1000
    Thinning interval = 1
    Chains = 1
    Samples per chain = 1000
    
    Empirical Posterior Estimates:
                  Mean           SD        Naive SE       MCSE         ESS    
       alpha   149.86287402  18.73102262 0.5923269439  4.454619991   17.680789
        beta     0.91134078   0.15243175 0.0048203151  0.005965292  652.961363
      lf_num     0.00200000   0.06324555 0.0020000000  0.002000000 1000.000000
           s     8.22568497  10.25393979 0.3242580474  2.981304046   11.829571
     elapsed     0.08469045   0.18119540 0.0057299017  0.004829523 1000.000000
     epsilon     0.09051160   0.21427988 0.0067761248  0.034883408   37.733317
          lp -1169.34562655 295.96301362 9.3591722620 78.988684551   14.039289
    eval_num    20.54100000  19.99314995 0.6322389145  0.741917111  726.192353
      lf_eps     0.09051160   0.21427988 0.0067761248  0.034883408   37.733317
    
    Quantiles:
                   2.5%           25.0%           50.0%           75.0%           97.5%    
       alpha    97.732573814   154.271156335   154.521976173   154.718578787   155.05219408
        beta     0.741786059     0.871728256     0.904007884     0.938702544     1.14437351
      lf_num     0.000000000     0.000000000     0.000000000     0.000000000     0.00000000
           s     4.778389919     4.996805562     5.130510511     5.293976868    49.88124591
     elapsed     0.010419415     0.034812192     0.039396167     0.107931440     0.28094056
     epsilon     0.017397664     0.047575652     0.047575652     0.060576912     0.47502791
          lp -1946.653952461 -1084.583053954 -1083.462228242 -1082.833407723 -1082.27739273
    eval_num     4.000000000    10.000000000    10.000000000    22.000000000    70.00000000
      lf_eps     0.017397664     0.047575652     0.047575652     0.060576912     0.47502791
    


Compare with a previous result


```julia
clip_43s_example_output = "

Iterations = 1:1000
Thinning interval = 1
Chains = 1,2,3,4
Samples per chain = 1000

Empirical Posterior Estimates:
         Mean        SD       Naive SE       MCSE      ESS
alpha 154.597086 0.27326431 0.0043206882 0.0036304132 1000
 beta   0.906380 0.04143488 0.0006551430 0.0006994720 1000
sigma   5.106643 0.19345409 0.0030587777 0.0032035103 1000

Quantiles:
          2.5%       25.0%       50.0%       75.0%       97.5%
alpha 154.0610000 154.4150000 154.5980000 154.7812500 155.1260000
 beta   0.8255494   0.8790695   0.9057435   0.9336445   0.9882981
sigma   4.7524368   4.9683400   5.0994450   5.2353100   5.5090128
";
```

Example result for Turing with centered weights (appears biased)


```julia
clip_43t_example_output = "

Iterations = 1:1000
Thinning interval = 1
Chains = 1
Samples per chain = 1000

Empirical Posterior Estimates:
              Mean            SD        Naive SE        MCSE         ESS
   alpha   153.14719937  10.810424888 0.3418556512  1.4582064846   54.960095
    beta     0.90585034   0.079704618 0.0025204813  0.0016389693 1000.000000
  lf_num     0.00200000   0.063245553 0.0020000000  0.0020000000 1000.000000
       s     6.00564996   5.329796821 0.1685429742  0.8996190097   35.099753
 elapsed     0.09374649   0.099242518 0.0031383240  0.0055587373  318.744897
 epsilon     0.07237568   0.136671220 0.0043219234  0.0087528107  243.814242
      lp -1112.05625117 171.984325602 5.4386219075 28.3846353549   36.712258
eval_num    20.27200000  20.520309430 0.6489091609  1.1679058181  308.711044
  lf_eps     0.07237568   0.136671220 0.0043219234  0.0087528107  243.814242

";
```

Plot the regerssion line and observations


```julia
xi = -15.0:0.1:15.0
yi = mean(chn[:alpha]) .+ mean(chn[:beta])*xi

scatter(x, y, lab="Observations", xlab="weight", ylab="height")
plot!(xi, yi, lab="Regression line")
```




![svg](output_20_0.svg)



End of `clip_43t.jl`

*This notebook was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*