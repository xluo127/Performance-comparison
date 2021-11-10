file = "D:/study/2021-S2/791/.julia/dev/db-benchmark/G1_1e6_1e1_0_0.csv"

pretty_sci = function(x) {
  tmp<-strsplit(as.character(x), "+", fixed=TRUE)[[1L]]
  if(length(tmp)==1L) {
    paste0(substr(tmp, 1L, 1L), "e", nchar(tmp)-1L)
  } else if(length(tmp)==2L){
    paste0(tmp[1L], as.character(as.integer(tmp[2L])))
  }
}

# makes scalar string to store in "chk" field, check sum of arbitrary number of measures
make_chk = function(values){
  x = sapply(values, function(x) paste(format(x, scientific=FALSE), collapse="_"))
  gsub(",", "_", paste(x, collapse=";"), fixed=TRUE)
}

# bash 'ps -o rss'
memory_usage = function() {
  return(NA_real_) # disabled because during #110 system() kills the scripts
  cmd = paste("ps -o rss", Sys.getpid(), "| tail -1")
  ans = tryCatch(system(cmd, intern=TRUE, ignore.stderr=TRUE), error=function(e) NA_character_)
  as.numeric(ans) / (1024^2) # GB units
}

# join task RHS tables for LHS data name
join_to_tbls = function(data_name) {
  x_n = as.numeric(strsplit(data_name, "_", fixed=TRUE)[[1L]][2L])
  y_n = setNames(c(x_n/1e6, x_n/1e3, x_n), c("small","medium","big"))
  sapply(sapply(y_n, pretty_sci), gsub, pattern="NA", x=data_name)
}

library(data.table)
x = fread(file, showProgress=FALSE, stringsAsFactors=TRUE, na.strings="")
#x = readRDS(file)
#setDT(x)
print(nrow(x))

task_init = proc.time()[["elapsed"]]
cat("grouping...\n")

all_t = numeric(5)

question = "median v3 sd v3 by id4 id5" # q6
all_t[1] = system.time(print(dim(ans<-x[, .(median_v3=median(v3, na.rm=TRUE), sd_v3=sd(v3, na.rm=TRUE)), by=.(id4, id5)])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(median_v3), sum(sd_v3))])[["elapsed"]]
#write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time(print(dim(ans<-x[, .(median_v3=median(v3, na.rm=TRUE), sd_v3=sd(v3, na.rm=TRUE)), by=.(id4, id5)])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(median_v3), sum(sd_v3))])[["elapsed"]]
#write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "max v1 - min v2 by id3" # q7
all_t[2] = system.time(print(dim(ans<-x[, .(range_v1_v2=max(v1, na.rm=TRUE)-min(v2, na.rm=TRUE)), by=id3])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(bit64::as.integer64(range_v1_v2)))])[["elapsed"]]
#write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time(print(dim(ans<-x[, .(range_v1_v2=max(v1, na.rm=TRUE)-min(v2, na.rm=TRUE)), by=id3])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(bit64::as.integer64(range_v1_v2)))])[["elapsed"]]
#write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "largest two v3 by id6" # q8
all_t[3] = system.time(print(dim(ans<-x[order(-v3, na.last=NA), .(largest2_v3=head(v3, 2L)), by=id6])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(largest2_v3))])[["elapsed"]]
#write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time(print(dim(ans<-x[order(-v3, na.last=NA), .(largest2_v3=head(v3, 2L)), by=id6])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(largest2_v3))])[["elapsed"]]
#write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "regression v1 v2 by id2 id4" # q9
all_t[4] = system.time(print(dim(ans<-x[, .(r2=cor(v1, v2, use="na.or.complete")^2), by=.(id2, id4)])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(r2))])[["elapsed"]]
#write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time(print(dim(ans<-x[, .(r2=cor(v1, v2, use="na.or.complete")^2), by=.(id2, id4)])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(r2))])[["elapsed"]]
#write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

question = "sum v3 count by id1:id6" # q10
all_t[5] = system.time(print(dim(ans<-x[, .(v3=sum(v3, na.rm=TRUE), count=.N), by=id1:id6])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(v3), sum(bit64::as.integer64(count)))])[["elapsed"]]
#write.log(run=1L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
rm(ans)
t = system.time(print(dim(ans<-x[, .(v3=sum(v3, na.rm=TRUE), count=.N), by=id1:id6])))[["elapsed"]]
#m = memory_usage()
chkt = system.time(chk<-ans[, .(sum(v3), sum(bit64::as.integer64(count)))])[["elapsed"]]
#write.log(run=2L, task=task, data=data_name, in_rows=nrow(x), question=question, out_rows=nrow(ans), out_cols=ncol(ans), solution=solution, version=ver, git=git, fun=fun, time_sec=t, mem_gb=m, cache=cache, chk=make_chk(chk), chk_time_sec=chkt, on_disk=on_disk)
print(head(ans, 3))
print(tail(ans, 3))
rm(ans)

cat(sprintf("grouping finished, took %.0fs\n", proc.time()[["elapsed"]]-task_init))

all_t

#if( !interactive() ) q("no", status=0)