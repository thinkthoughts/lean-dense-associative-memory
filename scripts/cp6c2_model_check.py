"""Exact brute-force check for CP6c.2.

For F = x^n (polyF), every target pattern t, target memory mu = 0 and neuron
i = 0, the average of the one-flip gap  E(flip(xi^mu), i) - E(xi^mu)  over the
fiber {omega | omega[mu] = t} equals N^n - (N-2)^n exactly.
Run: python3 -I scripts/cp6c2_model_check.py
"""
import itertools
from fractions import Fraction

def energy(xi, s, n):
    return -sum(sum(a * b for a, b in zip(p, s)) ** n for p in xi)

def check(N, K, n, mu=0, i=0):
    pm = lambda b: 1 if b else -1
    fibers = {}
    for bits in itertools.product([False, True], repeat=K * N):
        xi = [[pm(bits[k * N + j]) for j in range(N)] for k in range(K)]
        s = xi[mu]; f = s.copy(); f[i] = -f[i]
        gap = energy(xi, f, n) - energy(xi, s, n)
        key = tuple(bits[mu * N:(mu + 1) * N])
        tot, cnt = fibers.get(key, (0, 0)); fibers[key] = (tot + gap, cnt + 1)
    signal = N ** n - (N - 2) ** n
    means = {Fraction(tot, cnt) for tot, cnt in fibers.values()}
    ok = means == {signal}
    print(f"N={N} K={K} n={n}: fiber means={sorted(means)} signal={signal} {'OK' if ok else 'FAIL'}")
    return ok

ok = all(check(N, K, n) for N, K in [(1, 2), (2, 2), (3, 2), (3, 3), (4, 3)] for n in [0, 1, 2, 3, 4])
print("ALL PASS" if ok else "FAILURE")
raise SystemExit(0 if ok else 1)
