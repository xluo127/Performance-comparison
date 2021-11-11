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

data.frame(df_time = c(t1[["elapsed"]], t2[["elapsed"]], t3[["elapsed"]]), dt_time = c(t4[["elapsed"]], t5[["elapsed"]], t6[["elapsed"]]))
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

# setkey & setorder in data.table
dtc = copy(dt)

df = data.frame(x1 = sample.int(100, 6e7, replace = T),
                x2 = sample.int(100, 6e7, replace = T),
                x3 = sample.int(100, 6e7, replace = T),
                x4 = sample.int(100, 6e7, replace = T),
                x5 = sample.int(100, 6e7, replace = T))
dt = data.table(df)

dt = dtc
microbenchmark(setkey(dt, x1), unit = "s")

dt = dtc
microbenchmark(setkey(dt, x1, x2), unit = "s")

dt = dtc
microbenchmark(setkey(dt, x1, x2, x3, x4, x5), unit = "s")

dt = dtc
microbenchmark(setorder(dt, x1), unit = "s")

dt = dtc
microbenchmark(setorder(dt, x1, x2), unit = "s")

dt = dtc
microbenchmark(setorder(dt, x1, x2, x3, x4, x5), unit = "s")
