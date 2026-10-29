"""Brute-force model check for CP6c.1 (exact arithmetic, small N and K).

Mirrors the Lean definitions: samples omega : Memory -> Neuron -> Bool,
patterns toPM(omega), target mu = 0, neuron i = 0. For each separation
function F it checks
  1. toggling coordinate (nu, i), nu != mu, reverses the nu-th cross-talk summand;
  2. the cross-talk sums to exactly 0 over every target fiber;
and reports the range of cross-talk values to show the result is non-vacuous.
Run: python3 -I scripts/cp6c1_model_check.py
"""
import itertools
from fractions import Fraction

def check(N, K, n, F, name, mu=0, i=0):
    pm = lambda b: 1 if b else -1
    def summand(xi, nu):
        tg = xi[mu]; fl = tg.copy(); fl[i] = -fl[i]
        return (F(sum(a * b for a, b in zip(xi[nu], tg)))
                - F(sum(a * b for a, b in zip(xi[nu], fl))))
    worst, fibers, values = 0, {}, set()
    for bits in itertools.product([False, True], repeat=K * N):
        w = [list(bits[k * N:(k + 1) * N]) for k in range(K)]
        xi = [[pm(b) for b in row] for row in w]
        noise = sum(summand(xi, nu) for nu in range(K) if nu != mu)
        values.add(noise)
        fibers[tuple(w[mu])] = fibers.get(tuple(w[mu]), 0) + noise
        for nu in range(K):
            if nu == mu:
                continue
            w2 = [r.copy() for r in w]; w2[nu][i] = not w2[nu][i]
            xi2 = [[pm(b) for b in row] for row in w2]
            worst = max(worst, abs(summand(xi2, nu) + summand(xi, nu)))
    fib = max(abs(v) for v in fibers.values())
    print(f"{name:10s} N={N} K={K} n={n}: max|g(toggle)+g|={worst} "
          f"max|fiber sum|={fib} noise range=[{min(values)}, {max(values)}]")
    return worst == 0 and fib == 0

ok = True
for N, K in [(3, 2), (3, 3), (4, 3)]:
    for n in [1, 2, 3, 4]:
        ok &= check(N, K, n, lambda x: x ** n, "polyF")
        ok &= check(N, K, n, lambda x: x ** n if x >= 0 else 0, "rectified")
        ok &= check(N, K, n, lambda x: Fraction(1, 1 + x * x) + x ** 3, "arbitrary")
print("ALL PASS" if ok else "FAILURE")
raise SystemExit(0 if ok else 1)
