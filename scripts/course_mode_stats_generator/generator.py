#!/usr/bin/env python3
"""Course-Mode AP Statistics computational item generator (v1.3).

Architecture (COURSE_MODE_LEARNING_MODEL.md CM-D15): procedure library x
scenario layer x question-form layer. Each PROCEDURE is a deterministic function
of seeded params -> (stimulus, question, correct answer, worked solution,
deterministic_checks). Validate the template once (property tests below); trust
every instance by construction. Distractors are misconception transforms, each
tagged, so an MCQ doubles as a diagnostic probe.

v1.1 (post Fable QA 2026-08-23) hardening:
- Emission is GATED: generate_valid() resamples until an instance passes ALL of
  its own property checks; emit asserts them. No invalid item can ship.
- Distractor SEPARATION: every numeric distractor must differ from the key by
  more than 2x the deterministic tolerance (kills cross-modality inconsistency).
- PLAUSIBILITY: probabilities in [0,1]; non-negative predictions for non-negative
  contexts (LSRL slope sign paired to context, reject y-hat<0 / y_i<0).
- Cells tag ONLY the assessed skill (CM-D05): CI->3.3x3.E, two-prop->3.13x3.E,
  LSRL predict->5.3x3.B, normal->2.11x3.C, summary->1.7x3.B.

v1.3 scope: stdlib-exact, 7 procedures. Proportion CI + two-proportion z-test,
LSRL predict, normal probability, summary stats, one-sample t-test statistic
(4.5x3.E), one-sample t confidence interval (4.2x3.E), and chi-square test for
independence/homogeneity (3.15x3.E). t procedures use the standard tabulated t*;
chi-square uses the statistic + expected counts -- all pure arithmetic, so NO
scipy/special-function dependency. Tail p-values (which would need the t/chi-square
CDF) are intentionally not generated. Two-sample t procedures are the next add.

Synthetic tooling; NOT official College Board content. release_status=
'unreleased_generated_pending_review'; requires CM-D19 template-release + review.
"""
from __future__ import annotations

import json
import math
import random
import re
from pathlib import Path
from typing import Callable, Dict, List, Optional, Tuple

import statlib as S
import misconceptions as MISC
import scenarios as SCN
from cells import practice_of, unit_of

OUT_DIR = Path(__file__).resolve().parent / "out"
SCHEME_TAXONOMY = "ap-statistics-2026-27"
SCHEME_SKILLS = "ap-statistics-skills"

# Context banks now live in scenarios.py (canonically framed by FRQ archetype /
# task verb / modality, per fact pack S5-S7). Aliased here for brevity.
CONTEXTS = SCN.PROPORTION_CONTEXTS
TWO_GROUP = SCN.TWO_GROUP_CONTEXTS
REG_CONTEXTS = SCN.REGRESSION_CONTEXTS
NORMAL_CONTEXTS = SCN.NORMAL_CONTEXTS
MEAN_CONTEXTS = SCN.MEAN_CONTEXTS
TWO_MEAN_CONTEXTS = SCN.TWO_MEAN_CONTEXTS
CATEGORICAL_CONTEXTS = SCN.CATEGORICAL_CONTEXTS
U1_9_COMPARE_CONTEXTS = SCN.U1_9_COMPARE_CONTEXTS


def _rid(prefix: str, seed: int) -> str:
    return f"{prefix}-{seed:06d}"


def _fmt_line(intercept: float, slope: float) -> str:
    sign = "+" if slope >= 0 else "-"
    return f"y-hat = {intercept:.3f} {sign} {abs(slope):.3f}x"


# Number extraction MUST match the runtime verifier (_shared/deterministic-verifier.ts):
# integers, decimals, and leading-decimal forms. Used to assert the correct MCQ
# option's DISPLAYED text actually passes the item's own deterministic checks
# (Fable QA #2: a 2dp key display was failing a 0.001-tol check).
_NUM_RE = re.compile(r"-?(?:\d+(?:\.\d+)?|\.\d+)")


def _display_passes_checks(display_text: str, det_checks: List[Dict]) -> bool:
    nums = [float(m) for m in _NUM_RE.findall(display_text)]
    for c in det_checks:
        kind = c.get("kind")
        if kind == "numeric":
            if len(nums) != 1 or abs(nums[0] - c["value"]) > c["tol"]:
                return False
        elif kind == "interval":
            if len(nums) != 2 or abs(nums[0] - c["low"]) > c["tol"] or abs(nums[1] - c["high"]) > c["tol"]:
                return False
        # other kinds (e.g. mcq_key) are not graded by the data-driven verifier
    return True


# ===========================================================================
# Procedures. Each returns a dict via _package(). Distractors are passed as
# (display_text, misconception_tag, numeric_value_or_None).
# ===========================================================================

def gen_one_prop_ci(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(CONTEXTS)
    src, trait, noun = c["src"], c["trait"], c["noun"]
    conf = rng.choice([0.90, 0.95, 0.99])
    while True:
        n = rng.choice([80, 100, 120, 150, 200, 250])
        x = rng.randint(int(0.15 * n), int(0.85 * n))
        if S.large_counts_one_prop(x, n):
            break
    phat, moe, lo, hi = S.one_prop_ci(x, n, conf)
    zc, se = S.z_star(conf), S.one_prop_se_ci(x / n, n)
    prompt = (f"{src.capitalize()} takes a random sample of {n} {noun} and finds that {x} of them "
              f"{trait}. Construct a {int(conf*100)}% confidence interval for the true proportion "
              f"of {noun} that {trait}.")
    worked = (f"p-hat = {x}/{n} = {phat:.4f}. Conditions: {x} >= 10 and {n-x} >= 10. "
              f"SE = sqrt(p-hat(1-p-hat)/n) = {se:.4f}. z* = {zc:.3f}. ME = z*·SE = {moe:.4f}. "
              f"Interval = {phat:.4f} +/- {moe:.4f} = ({lo:.4f}, {hi:.4f}).")
    se_only = se
    se_novsqrt = zc * (phat * (1 - phat) / n)
    moe90 = S.z_star(0.90) * se
    distractors = [
        (f"({phat-se_only:.3f}, {phat+se_only:.3f})", "forgot_z_star_used_se_only", None),
        (f"({phat-se_novsqrt:.3f}, {phat+se_novsqrt:.3f})", "forgot_sqrt_in_se", None),
        (f"({phat:.3f}, {phat+moe:.3f})", "one_sided_only_added_me", None),
        (f"({phat-moe90:.3f}, {phat+moe90:.3f})", "used_wrong_z_90pct", None),
    ]
    checks = [
        ("phat_equals_x_over_n", abs(phat - x / n) < 1e-12),
        ("interval_centered_at_phat", abs((lo + hi) / 2 - phat) < 1e-9),
        ("bounds_in_0_1", -0.0001 <= lo and hi <= 1.0001),
        ("large_counts_condition_holds", S.large_counts_one_prop(x, n)),
    ]
    return _package("one_prop_ci", seed, "3.3", ["3.E"], "Medium", prompt,
                    f"({lo:.4f}, {hi:.4f})", worked,
                    [{"kind": "interval", "low": round(lo, 4), "high": round(hi, 4), "tol": 0.001}],
                    f"({lo:.3f}, {hi:.3f})", None, 0.001, distractors,
                    {"n": n, "x": x, "conf": conf}, checks, scenario_domain=c["domain"])


def gen_two_prop_ztest(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(TWO_GROUP)
    noun, verb, gA, gB = c["noun"], c["verb"], c["gA"], c["gB"]
    while True:
        n1 = rng.choice([80, 100, 120, 150])
        n2 = rng.choice([80, 100, 120, 150])
        x1 = rng.randint(int(0.2 * n1), int(0.8 * n1))
        x2 = rng.randint(int(0.2 * n2), int(0.8 * n2))
        pooled = (x1 + x2) / (n1 + n2)
        diff = abs(x1 / n1 - x2 / n2)
        if (pooled * n1 >= 10 and (1 - pooled) * n1 >= 10 and
                pooled * n2 >= 10 and (1 - pooled) * n2 >= 10 and 0.06 <= diff <= 0.20):
            break
    p1, p2, pooled, z, p = S.two_prop_ztest(x1, n1, x2, n2)
    tol = 0.01
    prompt = (f"In {gA}, {x1} of {n1} {noun} {verb}. In {gB}, {x2} of {n2} {noun} {verb}. "
              f"Calculate the pooled two-proportion z test statistic for H0: p1 = p2.")
    worked = (f"p1 = {p1:.4f}, p2 = {p2:.4f}, pooled p = ({x1}+{x2})/({n1}+{n2}) = {pooled:.4f}. "
              f"SE = sqrt(p(1-p)(1/n1+1/n2)) = {(pooled*(1-pooled)*(1/n1+1/n2))**0.5:.4f}. "
              f"z = (p1-p2)/SE = {z:.4f}.")
    z_unpooled = (p1 - p2) / (p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2) ** 0.5
    z_no1mp = (p1 - p2) / (pooled * (1 / n1 + 1 / n2)) ** 0.5
    z_badn = (p1 - p2) / (pooled * (1 - pooled) / (n1 + n2)) ** 0.5
    distractors = [
        (f"z = {z_unpooled:.2f}", "used_unpooled_se", z_unpooled),
        (f"z = {-z:.2f}", "reversed_group_order_sign", -z),
        (f"z = {z_no1mp:.2f}", "forgot_1_minus_p_in_se", z_no1mp),
        (f"z = {z_badn:.2f}", "wrong_se_combined_n", z_badn),
    ]
    checks = [
        ("pooled_correct", abs(pooled - (x1 + x2) / (n1 + n2)) < 1e-12),
        ("z_sign_matches_diff", (z > 0) == (p1 > p2)),
        ("z_magnitude_reasonable", abs(z) <= 4.0),
    ]
    return _package("two_prop_ztest", seed, "3.13", ["3.E"], "Hard", prompt,
                    f"z = {z:.4f}", worked,
                    [{"kind": "numeric", "value": round(z, 4), "tol": tol}],
                    f"z = {z:.2f}", z, tol, distractors,
                    {"x1": x1, "n1": n1, "x2": x2, "n2": n2}, checks, scenario_domain=c["domain"])


def gen_lsrl_predict(rng: random.Random, seed: int) -> Dict:
    """Predict a response from a least-squares line (cell 5.3 x 3.B). The item shows
    the LINE (not raw data), so the generator picks a, b directly (with small jitter
    for a realistic non-round coefficient). Every value -- the KEY and each distractor
    -- must land inside the context's CREDIBILITY ENVELOPE (y_lo..y_hi) with the
    requested x in a realistic range, so no instance produces an absurd scenario (an
    exam score > 100, a $36k 15-year-old car, or freezing ice-cream weather)."""
    c = rng.choice(REG_CONTEXTS)
    xlab, ylab, who, sign = c["xlab"], c["ylab"], c["who"], c["sign"]
    y_lo, y_hi = float(c["y_lo"]), float(c["y_hi"])
    tol = 0.05
    plausible: List[Tuple[str, str, float]] = []
    a = b = 0.0
    x_new = 0
    yhat = 0.0
    for _ in range(600):
        a = round(rng.choice(c["a_choices"]) + rng.uniform(-0.9, 0.9), 2)      # intercept (baseline)
        b = round(sign * (rng.choice(c["b_mag"]) + rng.uniform(-0.3, 0.3)), 2)  # realistic non-round slope
        x_new = rng.randint(c["x_lo"], c["x_hi"])                              # realistic prediction point
        yhat = a + b * x_new
        # Candidate distractors -- each a DISTINCT, documented misconception. A candidate
        # is kept only if its value is a CREDIBLE value for this quantity (inside the
        # y_lo..y_hi envelope) and clear of / distinct from the key. The envelope is what
        # keeps every option believable (an exam-score distractor stays <=100 and >=65; a
        # used-car distractor stays a real price), and it naturally drops the transforms
        # that would overshoot (e.g. sign-flip on a steep negative slope).
        cand = [
            (b * x_new,           "dropped_intercept"),            # omitted the intercept
            (a - b * x_new,       "sign_error_on_slope"),          # flipped the slope's sign
            (a + b,               "plugged_in_1_not_x"),           # substituted x = 1
            (a,                   "predicted_intercept_ignored_x"),  # used y-hat = a, ignored x
            (a + b * (x_new - 1), "used_x_minus_one"),             # off-by-one on x
        ]
        plausible = []
        chosen_vals: List[float] = []
        for val, tag in cand:
            if not (y_lo <= val <= y_hi):                 # credible value for THIS quantity
                continue
            if abs(val - yhat) <= 3 * tol:                # clear of the key's grading band
                continue
            if any(abs(val - v) <= 3 * tol for v in chosen_vals):
                continue                                  # distinct from the other distractors
            plausible.append((f"{val:.2f}", tag, val))
            chosen_vals.append(val)
        # The KEY must be a credible, non-boundary value (not hugging y_lo/y_hi, so it is
        # not the obvious odd-one-out and never exceeds a hard cap like a 100-point exam).
        key_ok = (y_lo + 0.05 * (y_hi - y_lo)) <= yhat <= (y_hi - 0.02 * (y_hi - y_lo))
        if key_ok and len(plausible) >= 3:
            break
    prompt = (f"{who.capitalize()} fits a least-squares line predicting {ylab} from {xlab}. "
              f"The line is {_fmt_line(a, b)}. Predict {ylab} when {xlab} = {x_new}.")
    worked = f"{_fmt_line(a, b).replace('x', f'({x_new})')} = {yhat:.3f}."
    distractors = plausible[:3]
    checks = [
        ("predict_formula", abs(yhat - (a + b * x_new)) < 1e-9),
        ("key_in_envelope", y_lo <= yhat <= y_hi),
        ("key_not_at_boundary", (y_lo + 0.05 * (y_hi - y_lo)) <= yhat <= (y_hi - 0.02 * (y_hi - y_lo))),
        ("x_new_in_realistic_range", c["x_lo"] <= x_new <= c["x_hi"]),
        ("slope_sign_matches_context", (b > 0) == (sign > 0)),
        ("three_plausible_distractors", len(distractors) == 3),
        ("distractors_in_envelope", all(y_lo <= v <= y_hi for _, _, v in distractors)),
        ("distractors_clear_of_key", all(abs(v - yhat) > 2 * tol for _, _, v in distractors)),
        ("distractors_distinct", len({d for d, _, _ in distractors}) == 3),
    ]
    return _package("lsrl_predict", seed, "5.3", ["3.B"], "Easy", prompt,
                    f"y-hat = {yhat:.3f}", worked,
                    [{"kind": "numeric", "value": round(yhat, 3), "tol": tol}],
                    f"{yhat:.2f}", yhat, tol, distractors,
                    {"slope": b, "intercept": a, "x_new": x_new}, checks, scenario_domain=c["domain"])


def gen_normal_prob(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(NORMAL_CONTEXTS)
    mu = rng.choice(c["mu_choices"])       # per-context ranges keep the numbers realistic
    sigma = rng.choice(c["sigma_choices"])
    mult = rng.choice([-2, -1.5, -1, 1, 1.5, 2])
    x = round(mu + mult * sigma, 1)
    tol = 0.005
    z = S.z_score(x, mu, sigma)
    below = S.norm_cdf(z)
    prompt = (f"In a large population, {c['quantity']} ({c['unit']}) is modeled by a Normal "
              f"distribution with mean {mu} and standard deviation {sigma}. Find the probability "
              f"that a randomly chosen value is less than {x} {c['unit']}.")
    worked = f"z = ({x} - {mu})/{sigma} = {z:.4f}. P(Z < {z:.4f}) = {below:.4f}."
    upper = 1 - below
    body = abs(below - 0.5)          # area between mean and z (table misread)
    two_tail = 2 * min(below, upper)  # reported a two-sided area
    distractors = [
        (f"{upper:.4f}", "used_upper_tail", upper),
        (f"{body:.4f}", "reported_area_mean_to_z", body),
        (f"{two_tail:.4f}", "reported_two_sided_area", two_tail),
    ]
    checks = [
        ("prob_in_0_1", 0.0 <= below <= 1.0),
        ("z_correct", abs(z - (x - mu) / sigma) < 1e-12),
        ("cdf_sf_sum_to_1", abs(below + S.norm_sf(z) - 1.0) < 1e-12),
        ("all_options_valid_prob", all(0.0 <= v <= 1.0 for v in (upper, body, two_tail))),
    ]
    return _package("normal_prob", seed, "2.11", ["3.C"], "Easy", prompt,
                    f"P = {below:.4f}", worked,
                    [{"kind": "numeric", "value": round(below, 4), "tol": tol}],
                    f"{below:.4f}", below, tol, distractors,
                    {"mu": mu, "sigma": sigma, "x": x}, checks, scenario_domain=c["domain"])


def gen_summary_stats(rng: random.Random, seed: int) -> Dict:
    n = rng.choice([7, 9, 11])
    data = sorted(rng.randint(10, 90) for _ in range(n))
    m = S.sample_mean(data)
    tol = 0.01  # accommodates the 2dp key display (Fable QA #2: 0.001 rejected "51.14")
    prompt = (f"Consider the data set: {', '.join(str(d) for d in data)}. Calculate the sample mean.")
    worked = f"mean = sum/n = {sum(data)}/{n} = {m:.4f}."
    mn, q1, med, q3, mx = S.five_number_summary(data)
    distractors = [
        (f"{med:.2f}", "reported_median_not_mean", med),
        (f"{S.population_sd(data):.2f}", "reported_pop_sd", S.population_sd(data)),
        (f"{sum(data)/(n-1):.2f}", "divided_by_n_minus_1", sum(data) / (n - 1)),
        (f"{(min(data)+max(data))/2:.2f}", "reported_midrange", (min(data) + max(data)) / 2),
        (f"{sum(data):.2f}", "forgot_to_divide", float(sum(data))),
    ]
    checks = [
        ("mean_correct", abs(m - sum(data) / n) < 1e-9),
        ("five_num_ordered", mn <= q1 <= med <= q3 <= mx),
    ]
    return _package("summary_stats", seed, "1.7", ["3.B"], "Easy", prompt,
                    f"mean = {m:.4f}", worked,
                    [{"kind": "numeric", "value": round(m, 4), "tol": tol}],
                    f"{m:.2f}", m, tol, distractors,
                    {"data": data}, checks, scenario_domain=None)


def _compare_stat(data: List[int], stat: str) -> float:
    if stat == "mean":
        return float(S.sample_mean(data))
    if stat == "median":
        return float(S.five_number_summary(data)[2])
    if stat == "iqr":
        return float(S.iqr(data))
    if stat == "range":
        return float(max(data) - min(data))
    raise ValueError(stat)


def _fmt_data(data: List[int], unit: str) -> str:
    return ", ".join(f"{x:g}" for x in data) + f" {unit}"


def gen_compare_stats(rng: random.Random, seed: int) -> Dict:
    """Compare two one-variable quantitative distributions (cell 1.9 x 3.B).
    The requested statistic is explicit and the answer is always Group A minus
    Group B, so a numeric-entry verifier can grade a single parseable number."""
    c = rng.choice(U1_9_COMPARE_CONTEXTS)
    tol = 0.01
    stat = rng.choice(["mean", "median", "iqr"])
    stat_label = {"mean": "mean", "median": "median", "iqr": "IQR"}[stat]
    data_a: List[int] = []
    data_b: List[int] = []
    key = 0.0
    distractors: List[Tuple[str, str, float]] = []
    for _ in range(600):
        n = rng.choice([7, 9])
        lo, hi = int(c["low"]), int(c["high"])
        center_a = rng.randint(lo + 18, hi - 12)
        offset = rng.choice([-14, -10, -7, 7, 10, 14])
        center_b = max(lo + 14, min(hi - 14, center_a - offset))
        spread_a = rng.choice([3, 4, 5, 6, 8])
        spread_b = rng.choice([3, 4, 5, 6, 8])
        data_a = sorted(max(lo, min(hi, round(rng.gauss(center_a, spread_a)))) for _ in range(n))
        data_b = sorted(max(lo, min(hi, round(rng.gauss(center_b, spread_b)))) for _ in range(n))
        mean_a, mean_b = _compare_stat(data_a, "mean"), _compare_stat(data_b, "mean")
        med_a, med_b = _compare_stat(data_a, "median"), _compare_stat(data_b, "median")
        iqr_a, iqr_b = _compare_stat(data_a, "iqr"), _compare_stat(data_b, "iqr")
        range_a, range_b = _compare_stat(data_a, "range"), _compare_stat(data_b, "range")
        stat_a, stat_b = _compare_stat(data_a, stat), _compare_stat(data_b, stat)
        key = stat_a - stat_b
        if abs(key) < 2.0:
            continue
        candidates: List[Tuple[float, str]] = []
        if stat == "mean":
            candidates.append((med_a - med_b, "u1_9__used_mean_not_median"))  # wrong formula: median(A)-median(B) instead of mean(A)-mean(B)
        elif stat == "median":
            candidates.append((mean_a - mean_b, "u1_9__used_mean_not_median"))  # wrong formula: mean(A)-mean(B) instead of median(A)-median(B)
        else:
            candidates.append((range_a - range_b, "u1_9__used_range_not_iqr"))  # wrong formula: range(A)-range(B) instead of IQR(A)-IQR(B)
            candidates.append((mean_a - mean_b, "u1_9__used_mean_not_median"))  # wrong formula: mean(A)-mean(B) instead of IQR(A)-IQR(B)
        candidates.extend([
            (-key, "u1_9__sign_reversed_difference"),                         # wrong formula: statistic(B)-statistic(A)
            (stat_a, "u1_9__reported_single_group_stat"),                      # wrong formula: statistic(A) only, no subtraction
            (stat_b, "u1_9__reported_single_group_stat"),                      # wrong formula: statistic(B) only, no subtraction
        ])
        distractors = []
        chosen: List[float] = []
        chosen_tags = set()
        for val, tag in candidates:
            if tag in chosen_tags:
                continue
            if abs(val - key) <= 3 * tol:
                continue
            if any(abs(val - prior) <= 3 * tol for prior in chosen):
                continue
            distractors.append((f"{val:.2f}", tag, val))
            chosen.append(val)
            chosen_tags.add(tag)
            if len(distractors) == 3:
                break
        if len(distractors) == 3:
            break
    prompt = (f"A researcher records {c['quantity']} for two groups. {c['group_a']} (Group A): "
              f"{_fmt_data(data_a, c['unit'])}. {c['group_b']} (Group B): {_fmt_data(data_b, c['unit'])}. "
              f"Calculate Group A's {stat_label} minus Group B's {stat_label}.")
    worked = (f"Group A {stat_label} = {stat_a:.4f}; Group B {stat_label} = {stat_b:.4f}; "
              f"A - B = {stat_a:.4f} - {stat_b:.4f} = {key:.4f}.")
    checks = [
        ("key_formula", abs(key - (_compare_stat(data_a, stat) - _compare_stat(data_b, stat))) < 1e-9),
        ("data_sets_same_odd_length", len(data_a) == len(data_b) and len(data_a) in (7, 9)),
        ("key_not_trivial", abs(key) >= 2.0),
        ("three_plausible_distractors", len(distractors) == 3),
        ("distractors_clear_of_key", all(abs(v - key) > 2 * tol for _, _, v in distractors)),
        ("distractors_distinct", len({d for d, _, _ in distractors}) == 3),
        ("distractor_tags_distinct", len({tag for _, tag, _ in distractors}) == 3),
    ]
    return _package("compare_stats", seed, "1.9", ["3.B"], "Medium", prompt,
                    f"{stat_label} difference = {key:.4f}", worked,
                    [{"kind": "numeric", "value": round(key, 4), "tol": tol}],
                    f"{key:.2f}", key, tol, distractors,
                    {"scenario_id": c["id"], "stat": stat, "data_a": data_a, "data_b": data_b},
                    checks, scenario_domain=c["domain"])


def gen_t_test_mean(rng: random.Random, seed: int) -> Dict:
    """One-sample t test statistic for a mean (cell 4.5 x 3.E). t (for means),
    never z (CED convention). Distractors are all genuine t-values from documented
    SE / sign errors, kept in a realistic |t| range."""
    c = rng.choice(MEAN_CONTEXTS)
    tol = 0.01
    plausible: List[Tuple[str, str, float]] = []
    for _ in range(400):
        mu0 = float(rng.choice(c["mu0_choices"]))
        s = float(rng.choice(c["s_choices"]))
        n = int(rng.choice(c["n_choices"]))
        se = s / math.sqrt(n)
        target_t = rng.choice([-2.5, -2.0, -1.5, -1.2, 1.2, 1.5, 2.0, 2.5])
        xbar = round(mu0 + target_t * se, 2)
        t = S.t_statistic(xbar, mu0, s, n)
        # Distractor candidates: each a documented, on-scale t-value error.
        cand = [
            (-t,                    "flipped_t_numerator"),          # (mu0 - xbar)
            ((xbar - mu0) / s,      "used_s_not_se"),                # forgot /sqrt(n)  (smaller |t|)
            ((xbar - mu0) / (s / n), "se_divided_by_n_not_sqrt_n"),  # SE = s/n         (larger |t|)
        ]
        plausible = []
        chosen: List[float] = []
        for val, tag in cand:
            if abs(val) > 9:               # realistic: keep every option in a sane t-range
                continue
            if abs(val - t) <= 3 * tol:    # clear of the key's grading band
                continue
            if any(abs(val - v) <= 3 * tol for v in chosen):
                continue                   # distinct from the other distractors
            plausible.append((f"{val:.2f}", tag, val))
            chosen.append(val)
        if 1.0 <= abs(t) <= 5.0 and len(plausible) >= 3:
            break
    prompt = (f"{c['who'].capitalize()} claims the mean {c['quantity']} is {mu0:g} {c['unit']}. "
              f"A random sample of n = {n} has sample mean {xbar:g} {c['unit']} and sample standard "
              f"deviation s = {s:g} {c['unit']}. Calculate the one-sample t test statistic for H0: mu = {mu0:g}.")
    worked = f"t = ({xbar:g} - {mu0:g}) / ({s:g} / sqrt({n})) = {t:.3f}."
    distractors = plausible[:3]
    checks = [
        ("t_formula", abs(t - (xbar - mu0) / (s / math.sqrt(n))) < 1e-9),
        ("t_realistic", 1.0 <= abs(t) <= 5.0),
        ("three_plausible_distractors", len(distractors) == 3),
        ("distractors_in_t_range", all(abs(v) <= 9 for _, _, v in distractors)),
        ("distractors_clear_of_key", all(abs(v - t) > 2 * tol for _, _, v in distractors)),
        ("distractors_distinct", len({d for d, _, _ in distractors}) == 3),
    ]
    return _package("t_test_mean", seed, "4.5", ["3.E"], "Medium", prompt,
                    f"t = {t:.3f}", worked,
                    [{"kind": "numeric", "value": round(t, 3), "tol": tol}],
                    f"{t:.2f}", t, tol, distractors,
                    {"mu0": mu0, "xbar": xbar, "s": s, "n": n}, checks, scenario_domain=c["domain"])


def gen_t_interval_mean(rng: random.Random, seed: int) -> Dict:
    """One-sample t confidence interval for a mean (cell 4.2 x 3.E). t*, never z*
    (CED convention). Distractor intervals are all centered at x-bar and differ
    only in width (from documented SE / z-vs-t errors), so each is a realistic,
    positive-bounded interval -- no off-scale option."""
    c = rng.choice(MEAN_CONTEXTS)
    tol = 0.02
    plausible: List[Tuple[str, str, None]] = []
    for _ in range(400):
        s = float(rng.choice(c["s_choices"]))
        n = int(rng.choice(c["n_choices"]))          # n <= 30 keeps df = n-1 in the table
        conf = rng.choice([0.90, 0.95, 0.99])
        xbar = float(rng.choice(c["mu0_choices"]))
        df = n - 1
        moe, lo, hi = S.one_mean_t_interval(xbar, s, n, conf)
        se = s / math.sqrt(n)
        cand = [
            (S.z_star(conf) * se,          "used_z_star_not_t_star"),      # z* not t* (narrower)
            (S.t_star(df, conf) * (s / n), "se_divided_by_n_not_sqrt_n"),  # SE = s/n (much narrower)
            (S.t_star(df, conf) * s,       "used_s_not_se"),               # forgot /sqrt(n) (much wider)
        ]
        plausible = []
        chosen: List[float] = []
        for m, tag in cand:
            if m <= 0 or (xbar - m) <= 0:      # realistic: positive margin AND positive lower bound
                continue
            if abs(m - moe) <= tol:            # a visibly different interval from the key
                continue
            if any(abs(m - mm) <= tol for mm in chosen):
                continue                       # distinct from the other distractor intervals
            plausible.append((f"({xbar - m:.2f}, {xbar + m:.2f})", tag, None))
            chosen.append(m)
        if lo > 0 and len(plausible) >= 3:
            break
    tstar = S.t_star(df, conf)
    prompt = (f"{c['who'].capitalize()} takes a random sample of n = {n} and measures {c['quantity']}, "
              f"obtaining sample mean {xbar:g} {c['unit']} and sample standard deviation s = {s:g} {c['unit']}. "
              f"Construct a {int(conf * 100)}% confidence interval for the population mean {c['quantity']}.")
    worked = (f"df = {n} - 1 = {df}. t* = {tstar:.3f}. SE = s/sqrt(n) = {se:.4f}. "
              f"ME = t*·SE = {moe:.4f}. Interval = {xbar:g} +/- {moe:.4f} = ({lo:.3f}, {hi:.3f}).")
    distractors = plausible[:3]
    checks = [
        ("interval_uses_t_star", abs(moe - tstar * (s / math.sqrt(n))) < 1e-9),
        ("interval_centered", abs((lo + hi) / 2 - xbar) < 1e-9),
        ("lower_bound_positive", lo > 0),
        ("df_in_table", df in S.T_STAR),
        ("three_plausible_distractors", len(distractors) == 3),
        ("distractor_intervals_distinct", len({d for d, _, _ in distractors}) == 3),
        ("distractor_lower_bounds_positive",
         all(float(d.strip("()").split(",")[0]) > 0 for d, _, _ in distractors)),
    ]
    return _package("t_interval_mean", seed, "4.2", ["3.E"], "Medium", prompt,
                    f"({lo:.3f}, {hi:.3f})", worked,
                    [{"kind": "interval", "low": round(lo, 3), "high": round(hi, 3), "tol": 0.01}],
                    f"({lo:.2f}, {hi:.2f})", None, 0.01, distractors,
                    {"xbar": xbar, "s": s, "n": n, "conf": conf}, checks, scenario_domain=c["domain"])


def _fmt_table(rows: List[str], cols: List[str], obs: List[List[int]]) -> str:
    """Readable inline rendering of a two-way count table (no monospace needed)."""
    parts = []
    for rlab, orow in zip(rows, obs):
        parts.append(f"{rlab}: " + ", ".join(f"{clab} {v}" for clab, v in zip(cols, orow)))
    return "; ".join(parts)


def gen_chi_square_test(rng: random.Random, seed: int) -> Dict:
    """Chi-square test statistic for a two-way table (cell 3.15 x 3.E), for
    independence/homogeneity only. Distractors are POSITIVE, on-scale chi-square
    values from documented WRONG-EXPECTED-COUNTS / wrong-denominator errors -- not
    the naive 'forgot to square' / 'no divide by E' transforms, which produce
    off-scale or negative values a student rules out on sight."""
    c = rng.choice(CATEGORICAL_CONTEXTS)
    rows, cols = c["rows"], c["cols"]
    nrows, ncols, ncells = len(rows), len(cols), len(rows) * len(cols)
    tol = 0.01
    plausible: List[Tuple[str, str, float]] = []
    for _ in range(800):
        obs = [[rng.randint(10, 45) for _ in range(ncols)] for _ in range(nrows)]
        exp = S.chi_square_expected(obs)
        if any(e < 5 for erow in exp for e in erow):     # large-counts condition (all E >= 5)
            continue
        x2 = S.chi_square_stat(obs)
        grand = sum(sum(r) for r in obs)
        row_tot = [sum(r) for r in obs]
        eu = grand / ncells                              # uniform (equal-split) expected
        d_uniform = sum((o - eu) ** 2 / eu for orow in obs for o in orow)
        d_rowonly = sum((o - (row_tot[i] / ncols)) ** 2 / (row_tot[i] / ncols)
                        for i, orow in enumerate(obs) for o in orow)
        d_byO = sum((o - e) ** 2 / o for orow, erow in zip(obs, exp) for o, e in zip(orow, erow))
        cand = [
            (d_byO,     "chi_divided_by_O_not_E"),   # correct E, divided by O
            (d_uniform, "chi_uniform_expected"),     # E = grand/#cells
            (d_rowonly, "chi_expected_row_only"),    # E = row_total/#cols
        ]
        p_max = 4.0 * max(x2, 3.0)                        # on-scale: no wild outlier option
        plausible = []
        chosen: List[float] = []
        for val, tag in cand:
            if not (0.0 < val <= p_max):
                continue
            if abs(val - x2) <= 3 * tol:
                continue
            if any(abs(val - v) <= 3 * tol for v in chosen):
                continue
            plausible.append((f"{val:.2f}", tag, val))
            chosen.append(val)
        if 2.0 <= x2 <= 25.0 and len(plausible) >= 3:
            break
    df = (nrows - 1) * (ncols - 1)
    prompt = (f"A researcher records {c['desc']}, obtaining these observed counts -- "
              f"{_fmt_table(rows, cols, obs)}. Calculate the chi-square test statistic for the "
              f"test of {'homogeneity' if nrows > 1 else 'independence'} (df = {df}).")
    ex0 = exp[0][0]
    worked = (f"Expected count E = (row total x column total)/grand total; e.g. E[{rows[0]},{cols[0]}] = "
              f"({row_tot[0]} x {sum(obs[i][0] for i in range(nrows))})/{grand} = {ex0:.3f}. "
              f"chi-square = sum (O - E)^2/E = {x2:.3f}.")
    distractors = plausible[:3]
    checks = [
        ("chi_square_formula", abs(x2 - S.chi_square_stat(obs)) < 1e-9),
        ("chi_square_nonneg", x2 >= 0),
        ("chi_square_realistic", 2.0 <= x2 <= 25.0),
        ("all_expected_at_least_5", all(e >= 5 for erow in exp for e in erow)),
        ("three_plausible_distractors", len(distractors) == 3),
        ("distractors_positive", all(v > 0 for _, _, v in distractors)),
        ("distractors_on_scale", all(v <= 4.0 * max(x2, 3.0) for _, _, v in distractors)),
        ("distractors_clear_of_key", all(abs(v - x2) > 2 * tol for _, _, v in distractors)),
    ]
    return _package("chi_square_test", seed, "3.15", ["3.E"], "Hard", prompt,
                    f"chi-square = {x2:.2f}", worked,
                    [{"kind": "numeric", "value": round(x2, 3), "tol": tol}],
                    f"{x2:.2f}", x2, tol, distractors,
                    {"observed": obs}, checks, scenario_domain=c["domain"])


def gen_two_sample_t_test(rng: random.Random, seed: int) -> Dict:
    """Two-sample (independent) t test statistic for a difference of means
    (cell 4.7 x 3.E). Uses unpooled (Welch) SE and conservative df = min(n1-1, n2-1).
    Distractors are all genuine t-values from documented SE / sign errors,
    kept in a realistic |t| range."""
    c = rng.choice(TWO_MEAN_CONTEXTS)
    tol = 0.01
    plausible: List[Tuple[str, str, float]] = []
    for _ in range(400):
        s1 = float(rng.choice(c["s_choices"]))
        n1 = int(rng.choice(c["n_choices"]))
        s2 = float(rng.choice(c["s_choices"]))
        n2 = int(rng.choice(c["n_choices"]))
        mu1 = float(rng.choice(c["mu_choices"]))
        mu2 = float(rng.choice(c["mu_choices"]))
        se = math.sqrt((s1 ** 2 / n1) + (s2 ** 2 / n2))
        target_t = rng.choice([-2.5, -2.0, -1.5, -1.2, 1.2, 1.5, 2.0, 2.5])
        xbar1 = round(mu1 + target_t * se, 2)
        xbar2 = round(mu2, 2)
        t = S.two_sample_t_statistic(xbar1, s1, n1, xbar2, s2, n2)
        # Distractor candidates: each a documented, on-scale t-value error.
        df = min(n1 - 1, n2 - 1)
        se_pooled = math.sqrt(((n1 - 1) * s1 ** 2 + (n2 - 1) * s2 ** 2) / (n1 + n2 - 2)) * math.sqrt(1 / n1 + 1 / n2)
        cand = [
            (-t,                        "reversed_group_order_means"),     # (xbar2 - xbar1): sign flip
            ((xbar1 - xbar2) / math.sqrt(s1 ** 2 + s2 ** 2), "used_s_not_se"),  # SE = sqrt(s1^2+s2^2): SDs used as SE, no /n
            ((xbar1 - xbar2) / se_pooled, "used_pooled_se_for_means"),     # pooled SE instead of unpooled
            ((xbar1 - xbar2) / math.sqrt(s1 ** 2 / n1 ** 2 + s2 ** 2 / n2 ** 2), "se_divided_by_n_not_sqrt_n"),  # divided variance by n^2 (s/n not s/sqrt(n))
        ]
        plausible = []
        chosen: List[float] = []
        for val, tag in cand:
            if abs(val) > 9:               # realistic: keep every option in a sane t-range
                continue
            if abs(val - t) <= 3 * tol:    # clear of the key's grading band
                continue
            if any(abs(val - v) <= 3 * tol for v in chosen):
                continue                   # distinct from the other distractors
            plausible.append((f"{val:.2f}", tag, val))
            chosen.append(val)
        if 1.0 <= abs(t) <= 5.0 and len(plausible) >= 3:
            break
    prompt = (f"{c['gA'].capitalize()} has sample mean {xbar1:g} {c['unit']} (s = {s1:g}, n = {n1}) "
              f"and {c['gB'].capitalize()} has sample mean {xbar2:g} {c['unit']} (s = {s2:g}, n = {n2}). "
              f"Calculate the two-sample t test statistic for H0: mu1 = mu2.")
    worked = f"t = ({xbar1:g} - {xbar2:g}) / sqrt({s1:g}^2/{n1} + {s2:g}^2/{n2}) = {t:.3f}."
    distractors = plausible[:3]
    checks = [
        ("t_formula", abs(t - (xbar1 - xbar2) / math.sqrt((s1 ** 2 / n1) + (s2 ** 2 / n2))) < 1e-9),
        ("t_realistic", 1.0 <= abs(t) <= 5.0),
        ("df_in_table", df in S.T_STAR),
        ("three_plausible_distractors", len(distractors) == 3),
        ("distractors_in_t_range", all(abs(v) <= 9 for _, _, v in distractors)),
        ("distractors_clear_of_key", all(abs(v - t) > 2 * tol for _, _, v in distractors)),
        ("distractors_distinct", len({d for d, _, _ in distractors}) == 3),
    ]
    return _package("two_sample_t_test", seed, "4.7", ["3.E"], "Hard", prompt,
                    f"t = {t:.3f}", worked,
                    [{"kind": "numeric", "value": round(t, 3), "tol": tol}],
                    f"{t:.2f}", t, tol, distractors,
                    {"mu1": mu1, "xbar1": xbar1, "s1": s1, "n1": n1, "mu2": mu2, "xbar2": xbar2, "s2": s2, "n2": n2},
                    checks, scenario_domain=c["domain"])


def gen_two_sample_t_interval(rng: random.Random, seed: int) -> Dict:
    """Two-sample t confidence interval for a difference of means (cell 4.10 x 3.E).
    Uses unpooled (Welch) SE and conservative df = min(n1-1, n2-1).
    t*, never z* (CED convention). Distractor intervals are all centered at
    (xbar1 - xbar2) and differ only in width (from documented SE / z-vs-t errors),
    so each is a realistic interval -- no off-scale option."""
    c = rng.choice(TWO_MEAN_CONTEXTS)
    tol = 0.02
    plausible: List[Tuple[str, str, None]] = []
    for _ in range(400):
        s1 = float(rng.choice(c["s_choices"]))
        n1 = int(rng.choice(c["n_choices"]))
        s2 = float(rng.choice(c["s_choices"]))
        n2 = int(rng.choice(c["n_choices"]))
        conf = rng.choice([0.90, 0.95, 0.99])
        xbar1 = float(rng.choice(c["mu_choices"]))
        xbar2 = float(rng.choice(c["mu_choices"]))
        df = min(n1 - 1, n2 - 1)
        moe, lo, hi = S.two_sample_t_interval(xbar1, s1, n1, xbar2, s2, n2, conf)
        se = math.sqrt((s1 ** 2 / n1) + (s2 ** 2 / n2))
        se_pooled = math.sqrt(((n1 - 1) * s1 ** 2 + (n2 - 1) * s2 ** 2) / (n1 + n2 - 2)) * math.sqrt(1 / n1 + 1 / n2)
        cand = [
            (S.z_star(conf) * se,           "used_z_star_not_t_star"),       # z* not t*
            (S.t_star(df, conf) * se_pooled, "used_pooled_se_for_means"),    # pooled SE not unpooled
            (S.t_star(df, conf) * math.sqrt(s1 ** 2 / n1 ** 2 + s2 ** 2 / n2 ** 2), "se_divided_by_n_not_sqrt_n"),  # divided variance by n^2 (s/n not s/sqrt(n))
        ]
        plausible = []
        chosen: List[float] = []
        for m, tag in cand:
            if m <= 0:                      # realistic: positive margin
                continue
            if abs(m - moe) <= tol:         # a visibly different interval from the key
                continue
            if any(abs(m - mm) <= tol for mm in chosen):
                continue                    # distinct from the other distractor intervals
            diff = xbar1 - xbar2
            lo_d = diff - m
            if lo_d <= 0:                   # realistic: positive lower bound for this context
                continue
            plausible.append((f"({lo_d:.2f}, {diff + m:.2f})", tag, None))
            chosen.append(m)
        if lo > 0 and len(plausible) >= 3:
            break
    tstar = S.t_star(df, conf)
    diff = xbar1 - xbar2
    prompt = (f"{c['gA'].capitalize()} has sample mean {xbar1:g} {c['unit']} (s = {s1:g}, n = {n1}) "
              f"and {c['gB'].capitalize()} has sample mean {xbar2:g} {c['unit']} (s = {s2:g}, n = {n2}). "
              f"Construct a {int(conf * 100)}% confidence interval for the difference in population means (mu1 - mu2).")
    worked = (f"df = min({n1} - 1, {n2} - 1) = {df}. t* = {tstar:.3f}. "
              f"SE = sqrt({s1:g}^2/{n1} + {s2:g}^2/{n2}) = {se:.4f}. "
              f"ME = t*·SE = {moe:.4f}. Interval = {diff:g} +/- {moe:.4f} = ({lo:.3f}, {hi:.3f}).")
    distractors = plausible[:3]
    checks = [
        ("interval_uses_t_star", abs(moe - tstar * se) < 1e-9),
        ("interval_centered", abs((lo + hi) / 2 - diff) < 1e-9),
        ("lower_bound_positive", lo > 0),
        ("df_in_table", df in S.T_STAR),
        ("three_plausible_distractors", len(distractors) == 3),
        ("distractor_intervals_distinct", len({d for d, _, _ in distractors}) == 3),
        ("distractor_lower_bounds_positive",
         all(float(d.strip("()").split(",")[0]) > 0 for d, _, _ in distractors)),
    ]
    return _package("two_sample_t_interval", seed, "4.10", ["3.E"], "Hard", prompt,
                    f"({lo:.3f}, {hi:.3f})", worked,
                    [{"kind": "interval", "low": round(lo, 3), "high": round(hi, 3), "tol": 0.01}],
                    f"({lo:.2f}, {hi:.2f})", None, 0.01, distractors,
                    {"xbar1": xbar1, "s1": s1, "n1": n1, "xbar2": xbar2, "s2": s2, "n2": n2, "conf": conf},
                    checks, scenario_domain=c["domain"])


PROCEDURES: Dict[str, Callable[[random.Random, int], Dict]] = {
    "one_prop_ci": gen_one_prop_ci,
    "two_prop_ztest": gen_two_prop_ztest,
    "lsrl_predict": gen_lsrl_predict,
    "normal_prob": gen_normal_prob,
    "summary_stats": gen_summary_stats,
    "compare_stats": gen_compare_stats,
    "t_test_mean": gen_t_test_mean,
    "t_interval_mean": gen_t_interval_mean,
    "chi_square_test": gen_chi_square_test,
    "two_sample_t_test": gen_two_sample_t_test,
    "two_sample_t_interval": gen_two_sample_t_interval,
}


# ===========================================================================
# Item-package assembly with distinctness + separation enforcement
# ===========================================================================

def _package(proc, seed, topic, skills, difficulty, prompt, answer_desc, worked,
             det_checks, mcq_correct, mcq_key_value: Optional[float], tol: float,
             mcq_distractors: List[Tuple[str, str, Optional[float]]], params, checks,
             scenario_domain: Optional[str] = None) -> Dict:
    unit = unit_of(topic)
    scenario_prov = SCN.framing(proc, scenario_domain)  # raises if proc lacks canonical framing
    options = [{"text": mcq_correct, "correct": True, "misconception": None}]
    seen = {mcq_correct}
    for disp, tag, val in mcq_distractors:
        if disp in seen:
            continue
        if val is not None and mcq_key_value is not None and abs(val - mcq_key_value) <= 3 * tol:
            continue  # separation guard: keep distractors clear of the key's grading tolerance
                      # (3x margin so rounded display never lands within 2x tol either)
        seen.add(disp)
        # MISC.provenance() raises if the tag is not in the canonical catalog,
        # so every emitted distractor is guaranteed to cite a canonical source.
        options.append({"text": disp, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
        if len(options) == 4:
            break
    # Shuffle so the correct option is not always first (Fable QA #3). Seed with
    # proc+seed (not seed alone) so the correct-answer letter is not identical
    # across all procedures for a shared seed (re-QA finding); still deterministic.
    random.Random(f"{proc}-{seed}").shuffle(options)
    checks = list(checks) + [
        ("correct_option_passes_own_checks", _display_passes_checks(mcq_correct, det_checks)),
        ("mcq_option_texts_unique", len({o["text"] for o in options}) == len(options)),
        ("mcq_exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("mcq_has_3_distractors", len(options) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical",
         all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source",
         all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present",
         bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_modality_exam_aligned", scenario_prov.get("modality") == "exam_aligned_digital"),
    ]
    taxonomy_refs = [
        {"scheme_key": SCHEME_TAXONOMY, "node_key": f"unit-{unit}"},
        {"scheme_key": SCHEME_TAXONOMY, "node_key": f"topic-{topic}"},
    ] + [{"scheme_key": SCHEME_SKILLS, "node_key": f"skill-{sk}", "practice": practice_of(sk)} for sk in skills]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": _rid(proc, seed),
        "content_key": _rid(f"apstat-{proc}", seed),
        "item_type": "mcq",
        "difficulty": difficulty,
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": taxonomy_refs,
        "cells": [{"topic": topic, "skill": sk} for sk in skills],
        "prompt": prompt,
        "numeric_form": {"answer_desc": answer_desc, "deterministic_checks": det_checks},
        "mcq_form": {"options": options},
        "worked_solution": worked,
        "parts": [{
            "part_key": "part-a", "prompt": prompt,
            "response_modalities": ["mcq", "numeric"], "points": 1,
            "criteria": [{
                "criterion_key": "part-a-criterion-1", "points": 1,
                "description": answer_desc, "required_evidence": worked,
                "deterministic_checks": det_checks, "accepted_variants": [],
            }],
        }],
        "scenario_provenance": scenario_prov,
        "provenance": {
            "generator": "course_mode_stats_generator/generator.py",
            "template_id": proc, "params": params, "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Synthetic; not official CB content. Requires CM-D19 template-release + review.",
        },
        "_property_checks": checks,
    }


# ===========================================================================
# Generation, gating, property harness
# ===========================================================================

def _valid(inst: Dict) -> bool:
    return all(ok for _n, ok in inst["_property_checks"])


def _correct_positions_vary(per_proc: int = 40) -> bool:
    """After shuffling (Fable QA #3), the correct option must not sit at a fixed
    index across a batch. Returns True if >= 2 distinct correct-answer positions
    appear across the computational procedures."""
    positions = set()
    for proc in PROCEDURES:
        for inst in generate(proc, per_proc):
            opts = inst["mcq_form"]["options"]
            positions.add(next(i for i, o in enumerate(opts) if o["correct"]))
    return len(positions) >= 2


def generate(proc: str, count: int, base_seed: int = 1000) -> List[Dict]:
    """Raw generation (may include instances that fail their own checks — used to
    measure the true reject rate)."""
    return [PROCEDURES[proc](random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate_valid(proc: str, count: int, base_seed: int = 1000) -> List[Dict]:
    """Gated generation: resample (seed walk) until each slot yields a valid item."""
    out, seed, made = [], base_seed, 0
    while made < count:
        inst = PROCEDURES[proc](random.Random(seed), seed)
        seed += 1
        if _valid(inst):
            out.append(inst)
            made += 1
        if seed - base_seed > count * 50 + 500:
            raise RuntimeError(f"{proc}: could not produce {count} valid instances")
    return out


def property_report(per_proc: int = 80) -> Dict:
    report = {"per_procedure": {}, "total_instances": 0, "total_checks": 0,
              "failures": [], "reject_rate": {}}
    for proc in PROCEDURES:
        insts = generate(proc, per_proc)
        nchecks = rejects = 0
        for inst in insts:
            bad = [n for n, ok in inst["_property_checks"] if not ok]
            nchecks += len(inst["_property_checks"])
            if bad:
                rejects += 1
                report["failures"] += [f"{proc}/{inst['provenance']['seed']}/{n}" for n in bad]
        report["per_procedure"][proc] = {"instances": len(insts), "checks": nchecks}
        report["reject_rate"][proc] = f"{rejects}/{per_proc}"
        report["total_instances"] += len(insts)
        report["total_checks"] += nchecks
    meta = [
        ("ci_higher_conf_wider", S.one_prop_ci(64, 100, 0.99)[1] > S.one_prop_ci(64, 100, 0.95)[1]),
        ("ci_larger_n_narrower", S.one_prop_ci(128, 200, 0.95)[1] < S.one_prop_ci(64, 100, 0.95)[1]),
        ("normal_cdf_monotone", S.norm_cdf(0.0) < S.norm_cdf(1.0) < S.norm_cdf(2.0)),
        ("two_prop_equal_groups_z0", abs(S.two_prop_ztest(50, 100, 50, 100)[3]) < 1e-9),
        ("lsrl_perfect_line_r1", abs(S.lsrl([1, 2, 3, 4], [3, 5, 7, 9])[2] - 1.0) < 1e-9),
        ("misconception_catalog_selfcheck", not MISC.validate_catalog()),
        ("scenario_catalog_selfcheck", not SCN.validate_scenarios()),
        ("correct_answer_position_varies", _correct_positions_vary()),
    ]
    report["meta_failures"] = [n for n, ok in meta if not ok]
    report["ok"] = not report["failures"] and not report["meta_failures"]
    return report


def emit_samples(per_proc: int = 3, base_seed: int = 5000) -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    n = 0
    for proc in PROCEDURES:
        for inst in generate_valid(proc, per_proc, base_seed):
            assert _valid(inst), f"invalid instance reached emit: {inst['package_id']}"
            pkg = {k: v for k, v in inst.items() if k != "_property_checks"}
            (OUT_DIR / f"{inst['package_id']}.json").write_text(json.dumps(pkg, indent=2))
            n += 1
    return n


if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "emit":
        print(f"emitted {emit_samples()} sample item-packages to {OUT_DIR}")
    else:
        rep = property_report()
        print(json.dumps({k: v for k, v in rep.items() if k != "failures"}, indent=2))
        if rep["failures"]:
            print("FAILURES:", rep["failures"][:20])
        print("OVERALL:", "PASS" if rep["ok"] else "FAIL")
