#!/usr/bin/env python3
"""Exact (stdlib-only) statistics primitives for the Course-Mode AP Statistics
computational item generator.

Every routine here is computed exactly with the standard library (math /
statistics) so that generated item answers are independently verifiable by
recomputation. No numpy/scipy. Procedures that require the t or chi-square
distributions (special functions) are deliberately NOT implemented here and are
tracked as a scipy-dependency decision (see README / build report).

This is independently authored synthetic tooling, not a source of official
College Board exam claims.
"""
from __future__ import annotations

import math
from statistics import mean, pstdev, stdev
from typing import List, Sequence, Tuple


# ---------------------------------------------------------------------------
# Normal distribution (exact via math.erf; inverse via Acklam, ~1.15e-9 abs err)
# ---------------------------------------------------------------------------

def norm_cdf(z: float) -> float:
    """P(Z <= z) for the standard normal, exact via erf."""
    return 0.5 * (1.0 + math.erf(z / math.sqrt(2.0)))


def norm_sf(z: float) -> float:
    """P(Z > z)."""
    return 1.0 - norm_cdf(z)


def inv_norm(p: float) -> float:
    """Inverse standard-normal CDF (Acklam's rational approximation)."""
    if not (0.0 < p < 1.0):
        raise ValueError("inv_norm domain is (0,1)")
    a = [-3.969683028665376e+01, 2.209460984245205e+02, -2.759285104469687e+02,
         1.383577518672690e+02, -3.066479806614716e+01, 2.506628277459239e+00]
    b = [-5.447609879822406e+01, 1.615858368580409e+02, -1.556989798598866e+02,
         6.680131188771972e+01, -1.328068155288572e+01]
    c = [-7.784894002430293e-03, -3.223964580411365e-01, -2.400758277161838e+00,
         -2.549732539343734e+00, 4.374664141464968e+00, 2.938163982698783e+00]
    d = [7.784695709041462e-03, 3.224671290700398e-01, 2.445134137142996e+00,
         3.754408661907416e+00]
    plow, phigh = 0.02425, 1 - 0.02425
    if p < plow:
        q = math.sqrt(-2 * math.log(p))
        return (((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) / \
               ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1)
    if p <= phigh:
        q = p - 0.5
        r = q * q
        return (((((a[0] * r + a[1]) * r + a[2]) * r + a[3]) * r + a[4]) * r + a[5]) * q / \
               (((((b[0] * r + b[1]) * r + b[2]) * r + b[3]) * r + b[4]) * r + 1)
    q = math.sqrt(-2 * math.log(1 - p))
    return -(((((c[0] * q + c[1]) * q + c[2]) * q + c[3]) * q + c[4]) * q + c[5]) / \
           ((((d[0] * q + d[1]) * q + d[2]) * q + d[3]) * q + 1)


def z_star(confidence: float) -> float:
    """Two-sided critical value z* for a confidence level (e.g. 0.95 -> ~1.95996)."""
    return inv_norm(1 - (1 - confidence) / 2)


# ---------------------------------------------------------------------------
# One-variable summary statistics (AP / TI-84 conventions)
# ---------------------------------------------------------------------------

def sample_mean(data: Sequence[float]) -> float:
    return mean(data)


def sample_sd(data: Sequence[float]) -> float:
    """Sample standard deviation (n-1 divisor) — the AP 's'."""
    return stdev(data)


def population_sd(data: Sequence[float]) -> float:
    return pstdev(data)


def _median_sorted(s: Sequence[float]) -> float:
    n = len(s)
    mid = n // 2
    if n % 2:
        return float(s[mid])
    return (s[mid - 1] + s[mid]) / 2.0


def five_number_summary(data: Sequence[float]) -> Tuple[float, float, float, float, float]:
    """min, Q1, median, Q3, max using the TI-84 method (median excluded from
    halves when n is odd)."""
    s = sorted(float(x) for x in data)
    n = len(s)
    if n == 1:
        v = float(s[0])
        return (v, v, v, v, v)
    med = _median_sorted(s)
    if n % 2:
        lower = s[: n // 2]
        upper = s[n // 2 + 1:]
    else:
        lower = s[: n // 2]
        upper = s[n // 2:]
    q1 = _median_sorted(lower)
    q3 = _median_sorted(upper)
    return (s[0], q1, med, q3, s[-1])


def iqr(data: Sequence[float]) -> float:
    _, q1, _, q3, _ = five_number_summary(data)
    return q3 - q1


def outlier_fences(data: Sequence[float]) -> Tuple[float, float]:
    """1.5*IQR fences: (low, high)."""
    _, q1, _, q3, _ = five_number_summary(data)
    h = 1.5 * (q3 - q1)
    return (q1 - h, q3 + h)


def z_score(x: float, mu: float, sigma: float) -> float:
    return (x - mu) / sigma


# ---------------------------------------------------------------------------
# Least-squares regression (exact algebra)
# ---------------------------------------------------------------------------

def correlation(xs: Sequence[float], ys: Sequence[float]) -> float:
    n = len(xs)
    mx, my = mean(xs), mean(ys)
    sx, sy = stdev(xs), stdev(ys)
    cov = sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / (n - 1)
    return cov / (sx * sy)


def lsrl(xs: Sequence[float], ys: Sequence[float]) -> Tuple[float, float, float]:
    """Least-squares line: returns (slope, intercept, r)."""
    r = correlation(xs, ys)
    sx, sy = stdev(xs), stdev(ys)
    slope = r * (sy / sx)
    intercept = mean(ys) - slope * mean(xs)
    return (slope, intercept, r)


def predict(slope: float, intercept: float, x: float) -> float:
    return intercept + slope * x


def residual(slope: float, intercept: float, x: float, y: float) -> float:
    return y - predict(slope, intercept, x)


# ---------------------------------------------------------------------------
# Inference for proportions (normal-based; exact)
# ---------------------------------------------------------------------------

def one_prop_se_ci(phat: float, n: int) -> float:
    """Standard error used for a one-proportion confidence interval."""
    return math.sqrt(phat * (1 - phat) / n)


def one_prop_ci(x: int, n: int, confidence: float) -> Tuple[float, float, float, float]:
    """Returns (phat, margin_of_error, low, high)."""
    phat = x / n
    se = one_prop_se_ci(phat, n)
    moe = z_star(confidence) * se
    return (phat, moe, phat - moe, phat + moe)


def one_prop_ztest(x: int, n: int, p0: float) -> Tuple[float, float, float]:
    """One-proportion z-test. Returns (phat, z, two_sided_p)."""
    phat = x / n
    se0 = math.sqrt(p0 * (1 - p0) / n)  # null SE
    z = (phat - p0) / se0
    p = 2 * norm_sf(abs(z))
    return (phat, z, p)


def two_prop_ztest(x1: int, n1: int, x2: int, n2: int) -> Tuple[float, float, float, float, float]:
    """Two-proportion z-test (pooled). Returns (p1, p2, pooled, z, two_sided_p)."""
    p1, p2 = x1 / n1, x2 / n2
    pooled = (x1 + x2) / (n1 + n2)
    se = math.sqrt(pooled * (1 - pooled) * (1 / n1 + 1 / n2))
    z = (p1 - p2) / se
    p = 2 * norm_sf(abs(z))
    return (p1, p2, pooled, z, p)


# ---------------------------------------------------------------------------
# Conditions (used by generator guardrails and check-conditions items)
# ---------------------------------------------------------------------------

def large_counts_one_prop(x: int, n: int) -> bool:
    """np>=10 and n(1-p)>=10 using observed counts."""
    return x >= 10 and (n - x) >= 10


def round_sig(v: float, ndigits: int = 4) -> float:
    return round(v, ndigits)
