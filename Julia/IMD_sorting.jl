using BenchmarkTools, InMemoryDatasets, Random

ds = Dataset(Matrix{Int32}(rand(1:100, 10^6, 5)),:auto)

@btime sort(ds, 1)
@btime sort(ds, 1:2)
@btime sort(ds, 1:5)

@btime sortperm(ds, 1)
@btime sortperm(ds, [1, 2])
@btime sortperm(ds, [1, 2, 3, 4, 5])

@btime groupby(ds, 1)
@btime groupby(ds, 1:2)
@btime groupby(ds, 1:5)

ds = Dataset(Matrix{Int32}(rand(1:100, 10^7, 5)),:auto)

@btime sort(ds, 1)
@btime sort(ds, 1:2)
@btime sort(ds, 1:5)

@btime sortperm(ds, 1)
@btime sortperm(ds, [1, 2])
@btime sortperm(ds, [1, 2, 3, 4, 5])

@btime groupby(ds, 1)
@btime groupby(ds, 1:2)
@btime groupby(ds, 1:5)

# Set format for one column.

f(x) = abs(x - 30)
setformat!(ds, 1 => f) # Then you can see the format by getformat(ds, 1).

@btime groupby(ds, 1, mapformats = true) # By default mapformats = true.
@btime groupby(ds, 1:2)
@btime groupby(ds, 1:5)

ds = Dataset(Matrix{Int32}(rand(1:100, 6*10^7, 5)),:auto)

@time sort(ds, 1)
@time sort(ds, 1:2)
@time sort(ds, 1:5)

@time sortperm(ds, 1)
@time sortperm(ds, [1, 2])
@time sortperm(ds, [1, 2, 3, 4, 5])

@time groupby(ds, 1)
@time groupby(ds, 1:2)
@time groupby(ds, 1:5)

@time sortperm(ds, [1, 2, 3, 4, 5], alg = QuickSort)
@time sortperm(ds, [1, 2, 3, 4, 5], stable = false)
@time sortperm(ds, [1, 2, 3, 4, 5], alg = QuickSort, stable = false)
