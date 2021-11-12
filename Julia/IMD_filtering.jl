using BenchmarkTools, InMemoryDatasets, Random

ds = Dataset(rand(1:100, 10^7, 5),:auto)

# Select rows with at least a value 1.
@btime byrow(ds, any, :, by = isone) # 44.092 ms (114 allocations: 9.55 MiB)

# Select rows that all values are 1.
@btime byrow(ds, all, :, by = isone) # 43.837 ms (114 allocations: 9.55 MiB)

# A broadcasting way to do the same job.
@btime any.(isone, eachrow(ds)) # 10.403 s (147034307 allocations: 2.92 GiB)
@btime all.(isone, eachrow(ds)) # 2.168 s (30302664 allocations: 617.70 MiB)

# Some special functions can be applied, too.
byrow(ds, cumsum, :)

# Apply different functions to different columns, respectively.

@btime byrow(ds, all, 1:2, by = [>(30), <(40)]) # 18.921 ms (65 allocations: 9.54 MiB)

# Filter observations based on all values in a column by using the modify! function.
modify!(ds, 1:2 .=> (x -> x .+ 2) .=> [:_tmp1, :_tmp2])
_tmp = byrow(ds, <, r"_tm")
dst = ds[disallowmissing(_tmp), :]

# To keep only original columns.
select!(dst, 1:5)

# The mask function.
mask(ds, (x) -> x > 50, :)