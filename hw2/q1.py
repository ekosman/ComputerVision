from numpy.random import randn
from numpy import array, hstack, ones
from numpy.linalg import pinv, svd
import matplotlib.pyplot as plt
import numpy as np


def ls_func(slope, intercept, x):
    return slope * x + intercept


xi = array([0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, 10]) - 0.5 + randn(20)
yi = array([0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9]) - 0.5 + randn(20) + 5

y = yi.reshape(-1, 1)
A = hstack([xi.reshape(-1, 1), ones(xi.size).reshape(-1, 1)])

pseudo_A = pinv(A)

slope_ls, intercept_ls = tuple(pseudo_A @ y)
print(f"LS : intercept = {intercept_ls}     slope = {slope_ls}")

mean_x = np.mean(xi)
mean_y = np.mean(yi)

A_tls = hstack([xi.reshape(-1, 1) - mean_x, yi.reshape(-1, 1) - mean_y])
_, _, vt = svd(A_tls)
v = vt.T
a, b = tuple(v[:, -1])
slope_tls = - a / b
c = - (a * mean_x + b * mean_y)
intercept_tls = - c / b
print(f"TLS : intercept = {intercept_tls}     slope = {slope_tls}")



plt.figure()
plt.scatter(xi, yi, label='original dots')
plt.plot(xi, [ls_func(slope_ls, intercept_ls, x) for x in xi], label='Least Squares')
plt.plot(xi, [ls_func(slope_tls, intercept_tls, x) for x in xi], label='Total Least Squares')
plt.legend()
plt.savefig('q1plot.png')
