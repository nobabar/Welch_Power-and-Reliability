import matplotlib.pyplot as plt
import numpy as np
from scipy import stats


@np.vectorize
def pvalue_grid(size,delta):            
    a = np.random.randn(size)
    b = np.random.randn(size) + delta
    t, pvalue = stats.ttest_ind(a, b)
    return pvalue


n, d = np.meshgrid(range(2, 30, 1), np.linspace(0.2, 2, 51))
n = n.T
d = d.T


Z = pvalue_grid(n, d)
O = np.ones((28, 51), dtype=float, order='C')*.05


fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
surf = ax.plot_surface(n, d, Z, cmap=plt.cm.coolwarm,
                       linewidth=0, antialiased=True)
threshold = ax.plot_surface(n, d, O, color = 'grey', alpha = 0.7)
ax.set(xlabel="n", ylabel="delta", zlabel="p-value")
# fig.colorbar(surf, shrink=0.5, aspect=5)
ax.view_init(20, 120)


