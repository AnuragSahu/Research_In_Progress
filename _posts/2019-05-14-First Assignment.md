---
title: "Assignment 1 Solutions"
---

Q1. 
Solution:

Every Inner product needs to satisfy the following properties:

1. Positivity
2. Definiteness
3. Additivity
4. Homogeneity
5. Symmetry


Part 3 Q3

{% highlight ruby %}
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mplb

fig = plt.figure()
ax = fig.add_subplot(111)
u = np.linspace(-3,3,50)
x ,y = np.meshgrid(u,u)
z = x**2 - y**2
ax.contour(x,y,z)
Ex,Ey = np.gradient(z)
Ex = - Ex
Ey = - Ey
 
ax.quiver(x,y,z,Ex,Ey)
plt.show()
{% endhighlight %}