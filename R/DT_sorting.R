library(data.table)
library(tictoc)

sort_time <- function(df, dt){
t1 = system.time(df[order(df[, 1]), ])
t2 = system.time(df[order(df[, 1], df[, 2]), ])
t3 = system.time(df[order(df[, 1], df[, 2], df[, 3], df[, 4], df[, 5]), ])

t4 = system.time(dt[order(x1)])
t5 = system.time(dt[order(x1, x2)])
t6 = system.time(dt[order(x1, x2, x3, x4, x5)])

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
tic("setkey_x1")
setkey(dt, x1)
toc()

dt = dtc
tic("setkey_x1-x2")
setkey(dt, x1, x2)
toc()

dt = dtc
tic("setkey_x1-x5")
setkey(dt, x1, x2, x3, x4, x5)
toc()

dt = dtc
tic("setorder_x1")
setorder(dt, x1)
toc()

dt = dtc
tic("setorder_x1-x2")
setorder(dt, x1, x2)
toc()

dt = dtc
tic("setorder_x1-x5")
setorder(dt, x1, x2, x3, x4, x5)
toc()
