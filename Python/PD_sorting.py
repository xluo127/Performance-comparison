import numpy as np
import pandas as pd
from random import randint
import timeit

x = [[randint(1, 101) for i in range(0, 5)] for j in range(0, 10**6)]
df = pd.DataFrame(x, columns = ['x1', 'x2', 'x3', 'x4', 'x5'])
df.astype('int32').dtypes
all_t_1e6 = []

t_start = timeit.default_timer()
df.sort_values(by = ['x1'])
t = timeit.default_timer() - t_start
all_t_1e6.append(t)

t_start = timeit.default_timer()
df.sort_values(by = ['x1', 'x2'])
t = timeit.default_timer() - t_start
all_t_1e6.append(t)

t_start = timeit.default_timer()
df.sort_values(by = ['x1', 'x2', 'x3', 'x4', 'x5'])
t = timeit.default_timer() - t_start
all_t_1e6.append(t)

print(all_t_1e6)

x = [[randint(1, 101) for i in range(0, 5)] for j in range(0, 10**7)]
df = pd.DataFrame(x, columns = ['x1', 'x2', 'x3', 'x4', 'x5'])
df.astype('int32').dtypes
all_t_1e7 = []

t_start = timeit.default_timer()
df.sort_values(by = ['x1'])
t = timeit.default_timer() - t_start
all_t_1e7.append(t)

t_start = timeit.default_timer()
df.sort_values(by = ['x1', 'x2'])
t = timeit.default_timer() - t_start
all_t_1e7.append(t)

t_start = timeit.default_timer()
df.sort_values(by = ['x1', 'x2', 'x3', 'x4', 'x5'])
t = timeit.default_timer() - t_start
all_t_1e7.append(t)

print(all_t_1e7)

# Apply a function on a column.
df['x1'] = df['x1'].apply(lambda x: abs(x - 30))
all_t_1e7_format = []

t_start = timeit.default_timer()
df.sort_values(by = ['x1'])
t = timeit.default_timer() - t_start
all_t_1e7_format.append(t)

t_start = timeit.default_timer()
df.sort_values(by = ['x1', 'x2'])
t = timeit.default_timer() - t_start
all_t_1e7_format.append(t)

t_start = timeit.default_timer()
df.sort_values(by = ['x1', 'x2', 'x3', 'x4', 'x5'])
t = timeit.default_timer() - t_start
all_t_1e7_format.append(t)

print(all_t_1e7)
