using BenchmarkTools, InMemoryDatasets, Random

ds = Dataset(Matrix{Int32}(rand(1:100, 10^6, 5)),:auto)

@btime sort(ds, 1) # 27.153 ms (325 allocations: 56.29 MiB)
@btime sort(ds, 1:2) # 44.862 ms (10722 allocations: 65.58 MiB)
@btime sort(ds, 1:5) # 104.352 ms (11290 allocations: 79.93 MiB)

@btime sortperm(ds, 1) # 7.525 ms (177 allocations: 13.37 MiB)
@btime sortperm(ds, [1, 2]) # 17.945 ms (10579 allocations: 22.65 MiB)
@btime sortperm(ds, [1, 2, 3, 4, 5]) # 82.761 ms (11148 allocations: 37.00 MiB)

@btime groupby(ds, 1) # 6.655 ms (182 allocations: 13.37 MiB)
@btime groupby(ds, 1:2) # 16.536 ms (10570 allocations: 22.65 MiB)
@btime groupby(ds, 1:5) # 72.984 ms (11145 allocations: 37.00 MiB)

ds = Dataset(Matrix{Int32}(rand(1:100, 10^7, 5)),:auto)

@btime sort(ds, 1) # 694.089 ms (334 allocations: 562.70 MiB)
@btime sort(ds, 1:2) # 1.089 s (15610 allocations: 659.27 MiB)
@btime sort(ds, 1:5) # 1.736 s (22056 allocations: 817.67 MiB)

@btime sortperm(ds, 1) # 73.290 ms (179 allocations: 133.53 MiB)
@btime sortperm(ds, [1, 2]) # 279.950 ms (15466 allocations: 230.10 MiB)
@btime sortperm(ds, [1, 2, 3, 4, 5]) # 886.158 ms (21913 allocations: 388.51 MiB)

@btime groupby(ds, 1) # 71.968 ms (186 allocations: 133.53 MiB)
@btime groupby(ds, 1:2) # 275.271 ms (15467 allocations: 230.12 MiB)
@btime groupby(ds, 1:5) # 899.192 ms (21888 allocations: 388.51 MiB)

ds = Dataset(Matrix{Int32}(rand(1:100, 6*10^7, 5)),:auto)

@time sort(ds, 1) # 5.597680 seconds (337 allocations: 3.297 GiB, 2.64% gc time)
@time sort(ds, 1:2) # 9.558984 seconds (20.73 k allocations: 3.913 GiB, 5.00% gc time)
@time sort(ds, 1:5) # 14.285691 seconds (1.02 M allocations: 4.708 GiB, 3.86% gc time)

@time sortperm(ds, 1) # 1.239196 seconds (182 allocations: 801.101 MiB, 4.93% gc time)
@time sortperm(ds, [1, 2]) # 2.228781 seconds (20.58 k allocations: 1.399 GiB, 16.32% gc time)
@time sortperm(ds, [1, 2, 3, 4, 5]) # 7.333075 seconds (1.02 M allocations: 2.194 GiB, 1.82% gc time)

@time groupby(ds, 1) # 1.192719 seconds (188 allocations: 801.102 MiB, 51.13% gc time)
@time groupby(ds, 1:2) # 1.892664 seconds (20.58 k allocations: 1.399 GiB, 2.38% gc time)
@time groupby(ds, 1:5) # 7.475217 seconds (1.02 M allocations: 2.194 GiB, 5.21% gc time)

@time sortperm(ds, [1, 2, 3, 4, 5], alg = QuickSort) # 8.133483 seconds (318.88 k allocations: 2.165 GiB, 1.64% gc time, 11.39% compilation time)
@time sortperm(ds, [1, 2, 3, 4, 5], stable = false) # 7.201158 seconds (1.02 M allocations: 2.194 GiB, 4.07% gc time)
@time sortperm(ds, [1, 2, 3, 4, 5], alg = QuickSort, stable = false) # 6.726987 seconds (21.16 k allocations: 2.149 GiB, 5.33% gc time)

dsc = copy(ds)
@btime sort!(dsc, 1:5) # 165.256 ns (3 allocations: 208 bytes)
dsc = copy(ds)
@btime groupby!(dsc, 1:5) # 235.392 ns (4 allocations: 336 bytes)
