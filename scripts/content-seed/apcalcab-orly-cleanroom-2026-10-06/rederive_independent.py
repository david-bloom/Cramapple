"""AQP §9 independent re-derivation by the orchestrating context, from the stems alone."""
from sympy import sin, cos, sqrt, pi, Rational as Q, nsimplify, simplify
aroc = lambda f, a, b: simplify((f(b) - f(a)) / (b - a))
print('c1-v1', aroc(lambda x: sin(2*x), 0, pi/4))                       # 4/pi
print('c1-v2', aroc(lambda x: 3*cos(2*x) + 1, pi/6, 5*pi/6))            # 0
print('c1-v3', aroc(lambda t: 12 + 5*sin(2*t), pi/6, pi/2))             # -15*sqrt(3)/(2*pi)
tab = {0: 1, 2: 10, 3: 16, 5: 28, 7: 24, 9: 26}
print('c2-v1', {iv: Q(tab[iv[1]] - tab[iv[0]], iv[1] - iv[0]) for iv in [(2, 3), (5, 7), (7, 9), (0, 2)]})  # max at (2,3)
f = lambda x: x**3 - 6*x
print('c2-v2', {iv: aroc(f, *iv) for iv in [(0, 5), (2, 5), (1, 5), (3, 4)]})                              # max at (2,5)
V = lambda t: 40*sqrt(t + 1) - 4*t
print('c2-v3', {iv: aroc(V, *iv) for iv in [(0, 15), (3, 8), (8, 15), (3, 35)]})                          # min at (3,35)
