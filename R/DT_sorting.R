library(data.table)
library(microbenchmark)

sort_time <- function(df, dt){
r = microbenchmark(df[order(df[, 1]), ], unit = "s")
t1 = summary(r)$mean
r = microbenchmark(df[order(df[, 1], df[, 2]), ], unit = "s")
t2 = summary(r)$mean
r = microbenchmark(df[order(df[, 1], df[, 2], df[, 3], df[, 4], df[, 5]), ], unit = "s")
t3 = summary(r)$mean
  
r = microbenchmark(dt[order(x1)], unit = "s")
t4 = summary(r)$mean
r = microbenchmark(dt[order(x1, x2)], unit = "s")
t5 = summary(r)$mean
r = microbenchmark(dt[order(x1, x2, x3, x4, x5)], unit = "s")
t6 = summary(r)$mean

data.frame(df_time = c(t1, t2, t3), dt_time = c(t4, t5, t6))
}

sort_time_large <- function(df, dt){
t1 = system.time(df[order(df[, 1]), ])
t2 = system.time(df[order(df[, 1], df[, 2]), ])
t3 = system.time(df[order(df[, 1], df[, 2], df[, 3], df[, 4], df[, 5]), ])

t4 = system.time(dt[order(x1)])
t5 = system.time(dt[order(x1, x2)])
t6 = system.time(dt[order(x1, x2, x3, x4, x5)])

data.frame(df_time = c(t1[["elapsed"]], t2[["elapsed"]], t3[["elapsed"]]), dt_time = c(t4[["elapsed"]], t5[["elapsed"]], t6[["elapsed"]]))
}

format_sort_time <- function(dt, format){
r = microbenchmark(dt[order(format(x1))], unit = "s")
t4 = summary(r)$mean
r = microbenchmark(dt[order(format(x1), x2)], unit = "s")
t5 = summary(r)$mean
r = microbenchmark(dt[order(format(x1), x2, x3, x4, x5)], unit = "s")
t6 = summary(r)$mean

data.frame(dt_time = c(t4, t5, t6))
}

df = data.frame(x1 = sample.int(100, 1e6, replace = T),
                x2 = sample.int(100, 1e6, replace = T),
                x3 = sample.int(100, 1e6, replace = T),
                x4 = sample.int(100, 1e6, replace = T),
                x5 = sample.int(100, 1e6, replace = T))
dt = data.table(df)

sort_time(df, dt)

df = data.frame(x1 = sample.int(100, 1e7, replace = T),
                x2 = sample.int(100, 1e7, replace = T),
                x3 = sample.int(100, 1e7, replace = T),
                x4 = sample.int(100, 1e7, replace = T),
                x5 = sample.int(100, 1e7, replace = T))
dt = data.table(df)

sort_time(df, dt)

# Apply a function on a column.

f = function(x) abs(x - 30)
format_sort_time(dt, f)

df = data.frame(x1 = sample.int(100, 6e7, replace = T),
                x2 = sample.int(100, 6e7, replace = T),
                x3 = sample.int(100, 6e7, replace = T),
                x4 = sample.int(100, 6e7, replace = T),
                x5 = sample.int(100, 6e7, replace = T))
dt = data.table(df)

sort_time_large(df, dt)

# Consider the case that we have previous sorted information.
setorder(dt, x1, x2, x3, x4, x5)

(t = system.time(dt[order(x1, x2, x3)]))
