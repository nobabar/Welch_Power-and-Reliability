from statsmodels.stats.power import TTestIndPower
import matplotlib.pyplot as plt
import numpy as np


@np.vectorize
def power_grid(x,y):
    power = TTestIndPower().solve_power(effect_size = x, 
                                        nobs1 = y, 
                                        alpha = 0.05)
    return power

X,Y = np.meshgrid(np.linspace(0.2, 2, 51), 
                  np.linspace(2, 30, 100))
X = X.T
Y = Y.T

Z = power_grid(X, Y)
O = np.ones((51, 100), dtype=float, order='C')*.8


fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
surf = ax.plot_surface(X, Y, Z, cmap=plt.cm.coolwarm,
                       linewidth=0, antialiased=True)
threshold = ax.plot_surface(X, Y, O, color = 'grey', alpha = 0.5)
ax.set(xlabel="distance", ylabel="n", zlabel="puissance")
# fig.colorbar(surf, shrink=0.5, aspect=5)
ax.view_init(20, 300)
