
using InMemoryDatasets, Sog, Random, BenchmarkTools

# The old version.
function  f0(ds, cols::Vector, ::Val{T}; mapformats = true) where T
    colsidx = IMD.index(ds)[cols]

    ranges = Vector{T}(undef, nrow(ds))
    ranges_cpy = copy(ranges)
    ranges[1] = 1
    ranges_cpy[1] = 1
    last_valid_index = 1

    for j in 1:length(colsidx)
        if mapformats
            _f = getformat(ds, colsidx[j])
        else
            _f = identity
        end
        last_valid_index = f0!(IMD._columns(ds)[colsidx[j]], _f , ranges, ranges_cpy, last_valid_index)
    end
    return colsidx, ranges, last_valid_index
end

f0(ds, cols::UnitRange, ::Val{T}; mapformats = true) where T = f0(ds, collect(cols), Val(T), mapformats = mapformats)

function f0!(x, format, ranges, ranges_cpy, last_valid_index)
    cnt = 1
    @inbounds for j in 1:last_valid_index
        lo = ranges_cpy[j]
        j == last_valid_index ? hi = length(x) : hi = ranges_cpy[j + 1] - 1
        ranges[cnt] = lo
        cnt += 1
        @inbounds for i in lo:(hi - 1)
            if !isequal(format(x[i]), format(x[i+1]))
                ranges[cnt] = i + 1
                cnt += 1
            end
        end
    end
    @inbounds for j in 1:(cnt - 1)
        ranges_cpy[j] = ranges[j]
    end
    return cnt - 1
end

# The new one (can be found in src/other/utils.jl).
f1 = IMD._find_starts_of_groups

ds = Dataset(rand(1:100,1000000,8), :auto) # With many groups.

groupby!(ds, 1:3)

colsidx = 1:2

@btime f0(ds, colsidx, Val{Int32}())
@btime f1(ds, colsidx, Val{Int32}()) # About as twice faster than the previous one.

r0 = f0(ds, colsidx, Val{Int32}()) # 4.687 ms (12 allocations: 7.63 MiB)
r1 = f1(ds, colsidx, Val{Int32}()) # 1.992 ms (54 allocations: 4.77 MiB)

r0 == r1 # To make sure we get the same result.

ds = Dataset(rand(1:5,1000000,8), :auto) # With few groups.

groupby!(ds, 1:3)

colsidx = 1:2

@btime f0(ds, colsidx, Val{Int32}())
@btime f1(ds, colsidx, Val{Int32}()) # About as twice faster than the previous one.

r0 = f0(ds, colsidx, Val{Int32}()) # 4.437 ms (11 allocations: 7.63 MiB)
r1 = f1(ds, colsidx, Val{Int32}()) # 1.960 ms (54 allocations: 4.77 MiB)

r0 == r1 # To make sure we get the same result.