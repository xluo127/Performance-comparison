file = "D:/study/2021-S2/791/.julia/dev/db-benchmark/G1_1e6_1e1_0_0.csv"

using Printf; # sprintf macro to print in non-scientific format
using Pkg;
#using DataFrames;
using InMemoryDatasets;
using CSV;
using Statistics; # mean function

function make_chk(x)
  n = length(x)
  res = ""
  for i = 1:n
    res = string(res, i==1 ? "" : ";", @sprintf("%0.3f", x[i]))
  end
  res
end;

function memory_usage()
  pid = getpid()
  s = read(pipeline(`ps -o rss $pid`,`tail -1`), String)
  parse(Float64, replace(s, "\n" => "")) / (1024^2)
end;

function join_to_tbls(data_name)
  x_n = Int(parse(Float64, split(data_name, "_")[2]))
  y_n = [x_n/1e6, x_n/1e3, x_n]
  y_n = [replace(@sprintf("%.0e", y_n[1]), r"[+]0?"=>""), replace(@sprintf("%.0e", y_n[2]), r"[+]0?"=>""), replace(@sprintf("%.0e", y_n[3]), r"[+]0?"=>"")]
  [replace(data_name, "NA" => y_n[1]), replace(data_name, "NA" => y_n[2]), replace(data_name, "NA" => y_n[3])]
end;

#DataFrames.precompile(true)
#InMemoryDatasets.precompile(true)

task = "groupby";
solution = "juliadf";
fun = "by";
cache = true;
on_disk = false;

#x = CSV.read(file, DataFrame, types=[PooledString, PooledString, PooledString, Int32, Int32, Int32, Int32, Int32, Float64], threaded=false);
x = CSV.read(file, Dataset, types=[PooledString, PooledString, PooledString, Int32, Int32, Int32, Int32, Int32, Float64], threaded=false);

all_t = Vector{Float64}(undef, 5)
in_rows = size(x, 1);
println(in_rows); flush(stdout);

task_init = time();
print("grouping...\n"); flush(stdout);

question = "median v3 sd v3 by id4 id5"; # q6
GC.gc(false);
all_t[1] = @elapsed (ANS = combine(groupby(x, [:id4, :id5]), :v3 => median∘skipmissing => :median_v3, :v3 => std∘skipmissing => :sd_v3); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = [sum(ANS.median_v3), sum(ANS.sd_v3)];
#write_log(1, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
ANS = 0;
GC.gc(false);
t = @elapsed (ANS = combine(groupby(x, [:id4, :id5]), :v3 => median∘skipmissing => :median_v3, :v3 => std∘skipmissing => :sd_v3); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = [sum(ANS.median_v3), sum(ANS.sd_v3)];;
#write_log(2, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
println(first(ANS, 3));
println(last(ANS, 3));
ANS = 0;

question = "max v1 - min v2 by id3"; # q7
GC.gc(false);
function f7(v1, v2)
    maximum(skipmissing(v1))-minimum(skipmissing(v2))
end
fmax(v) = maximum(skipmissing(v))
fmin(v) = minimum(skipmissing(v))
all_t[2] = @elapsed (ANS = combine(groupby(x, :id3), [:v1, :v2] => ((v1, v2) -> maximum(skipmissing(v1))-minimum(skipmissing(v2))) => :range_v1_v2); println(size(ANS)); flush(stdout));
# byrow(x, f7, [:v1, :v2])
#m = memory_usage();
chkt = @elapsed chk = sum(ANS.range_v1_v2);
#write_log(1, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
ANS = 0;
GC.gc(false);
t = @elapsed (ANS = combine(groupby(x, :id3), [:v1, :v2] => ((v1, v2) -> maximum(skipmissing(v1))-minimum(skipmissing(v2))) => :range_v1_v2); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = sum(ANS.range_v1_v2);
#write_log(2, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
println(first(ANS, 3));
println(last(ANS, 3));
ANS = 0;

question = "largest two v3 by id6"; # q8
GC.gc(false);
all_t[3] = @elapsed (ANS = combine(groupby(dropmissing(x, :v3), :id6), :v3 => (x -> partialsort!(x, 1:min(2, length(x)), rev=true)) => :largest2_v3); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = sum(ANS.largest2_v3);
#write_log(1, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
ANS = 0;
GC.gc(false);
t = @elapsed (ANS = combine(groupby(dropmissing(x, :v3), :id6), :v3 => (x -> partialsort!(x, 1:min(2, length(x)), rev=true)) => :largest2_v3); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = sum(ANS.largest2_v3);
#write_log(2, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
println(first(ANS, 3));
println(last(ANS, 3));
ANS = 0;

question = "regression v1 v2 by id2 id4"; # q9
function cor2(x, y) ## 73647e5a81d4b643c51bd784b3c8af04144cfaf6
    nm = @. !ismissing(x) & !ismissing(y)
    return count(nm) < 2 ? NaN : cor(view(x, nm), view(y, nm))
end
GC.gc(false);
all_t[4] = @elapsed (ANS = combine(groupby(x, [:id2, :id4]), [:v1, :v2] => ((v1,v2) -> cor2(v1, v2)^2) => :r2); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = sum(skipmissing(ANS.r2));
#write_log(1, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
ANS = 0;
GC.gc(false);
t = @elapsed (ANS = combine(groupby(x, [:id2, :id4]), [:v1, :v2] => ((v1,v2) -> cor2(v1, v2)^2) => :r2); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = sum(skipmissing(ANS.r2));
#write_log(2, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
println(first(ANS, 3));
println(last(ANS, 3));
ANS = 0;

question = "sum v3 count by id1:id6"; # q10
GC.gc(false);
all_t[5] = @elapsed (ANS = combine(groupby(x, [:id1, :id2, :id3, :id4, :id5, :id6]), :v3 => sum∘skipmissing => :v3, :v3 => length => :count); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = [sum(ANS.v3), sum(ANS.count)];
#write_log(1, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
ANS = 0;
GC.gc(false);
t = @elapsed (ANS = combine(groupby(x, [:id1, :id2, :id3, :id4, :id5, :id6]), :v3 => sum∘skipmissing => :v3, :v3 => length => :count); println(size(ANS)); flush(stdout));
#m = memory_usage();
chkt = @elapsed chk = [sum(ANS.v3), sum(ANS.count)];
#write_log(2, task, data_name, in_rows, question, size(ANS, 1), size(ANS, 2), solution, ver, git, fun, t, m, cache, make_chk(chk), chkt, on_disk);
println(first(ANS, 3));
println(last(ANS, 3));
ANS = 0;

print(@sprintf "grouping finished, took %.0fs\n" (time()-task_init)); flush(stdout);

all_t