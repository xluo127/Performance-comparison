using BenchmarkTools, InMemoryDatasets, Random

ds = Dataset(rand(1:100, 10^7, 5),:auto)

# Select rows with at least a value 1.
@btime byrow(ds, any, :, by = isone)

# Select rows that all values are 1.
@btime byrow(ds, all, :, by = isone)

# A broadcasting way to do the same job.
@btime any.(isone, eachrow(ds))
@btime all.(isone, eachrow(ds))

# Some special functions can be applied, too.
byrow(ds, cumsum, :)

# Apply different functions to different columns, respectively.

@btime byrow(ds, all, 1:2, by = [>(30), <(40)])

# Filter observations based on all values in a column by using the modify! function.
modify!(ds, 1:2 .=> (x -> x .+ 2) .=> [:_tmp1, :_tmp2])
_tmp = byrow(ds, <, r"_tm")
dst = ds[disallowmissing(_tmp), :]

# To keep only original columns.
select!(dst, 1:5)

# The mask function.
mask(ds, (x) -> x > 50, :)
