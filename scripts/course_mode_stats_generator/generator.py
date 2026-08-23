#!/usr/bin/env python3
"""Course-Mode AP Statistics computational item generator (v1.1).

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

v1 scope: stdlib-exact, normal-based procedures only (no t / chi-square — those
need special functions and a scipy dependency decision).

Synthetic tooling; NOT official College Board content. release_status=
'unreleased_generated_pending_review'; requires CM-D19 template-release + review.
"""
from __future__ import annotations

import json
import random
from pathlib import Path
from typing import Callable, Dict, List, Optional, Tuple

import statlib as S
from cells import practice_of, unit_of

OUT_DIR = Path(__file__).resolve().parent / "out"
SCHEME_TAXONOMY = "ap-statistics-2026-27"
SCHEME_SKILLS = "ap-statistics-skills"

CONTEXTS = [  # (source, trait phrase, unit noun)
    ("a school newspaper", "bike to school", "students"),
    ("a city parks survey", "visited a park last month", "residents"),
    ("a quality-control team", "pass inspection", "microchips"),
    ("a biologist", "germinated", "seeds"),
    ("a marketing team", "opened the email", "customers"),
]

# two-group contexts get their own phrasing pool (avoids "residents are residents...")
TWO_GROUP = [  # (noun, verb phrase, groupA, groupB)
    ("voters", "support the measure", "County A", "County B"),
    ("households", "own a pet", "the suburb", "the city"),
    ("passengers", "checked a bag", "Airline X", "Airline Y"),
    ("online orders", "shipped on time", "warehouse 1", "warehouse 2"),
]

# regression contexts carry an expected slope SIGN so keyed predictions are sensible
REG_CONTEXTS = [  # (xlab, ylab, who, sign)
    ("hours studied", "exam score", "a tutor", +1),
    ("age of a used car (years)", "price ($1000s)", "a dealership analyst", -1),
    ("outside temperature (F)", "daily ice-cream sales ($)", "a shop owner", +1),
    ("fertilizer (g/plant)", "plant height (cm)", "a gardener", +1),
]


def _rid(prefix: str, seed: int) -> str:
    return f"{prefix}-{seed:06d}"


def _fmt_line(intercept: float, slope: float) -> str:
    sign = "+" if slope >= 0 else "-"
    return f"y-hat = {intercept:.3f} {sign} {abs(slope):.3f}x"


# ===========================================================================
# Procedures. Each returns a dict via _package(). Distractors are passed as
# (display_text, misconception_tag, numeric_value_or_None).
# ===========================================================================

def gen_one_prop_ci(rng: random.Random, seed: int) -> Dict:
    src, trait, noun = rng.choice(CONTEXTS)
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
                    {"n": n, "x": x, "conf": conf}, checks)


def gen_two_prop_ztest(rng: random.Random, seed: int) -> Dict:
    noun, verb, gA, gB = rng.choice(TWO_GROUP)
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
                    {"x1": x1, "n1": n1, "x2": x2, "n2": n2}, checks)


def gen_lsrl_predict(rng: random.Random, seed: int) -> Dict:
    xlab, ylab, who, sign = rng.choice(REG_CONTEXTS)
    tol = 0.05
    for _ in range(200):  # reject non-plausible (negative y-hat / y_i)
        slope = sign * rng.choice([0.8, 1.2, 1.5, 2.0, 3.0])
        n = rng.choice([6, 7, 8])
        xs = sorted(rng.sample(range(1, 16), n))
        intercept = rng.choice([20, 30, 40, 60, 80])  # large enough to keep y>=0
        ys = [round(intercept + slope * x + rng.uniform(-2, 2), 1) for x in xs]
        b, a, r = S.lsrl(xs, ys)  # b = slope, a = intercept
        x_new = rng.choice(list(range(max(xs) + 1, max(xs) + 5)))
        yhat = S.predict(b, a, x_new)  # predict(slope, intercept, x)
        if yhat >= 0 and all(y >= 0 for y in ys):
            break
    prompt = (f"{who.capitalize()} fits a least-squares line predicting {ylab} from {xlab}. "
              f"The line is {_fmt_line(a, b)}. Predict {ylab} when {xlab} = {x_new}.")
    worked = f"{_fmt_line(a, b).replace('x', f'({x_new})')} = {yhat:.3f}."
    distractors = [
        (f"{a + b:.2f}", "plugged_in_1_not_x", a + b),
        (f"{b + a * x_new:.2f}", "swapped_slope_intercept", b + a * x_new),
        (f"{b * x_new:.2f}", "dropped_intercept", b * x_new),
        (f"{a - b * x_new:.2f}", "sign_error_on_slope", a - b * x_new),
    ]
    checks = [
        ("predict_formula", abs(yhat - (a + b * x_new)) < 1e-9),
        ("yhat_nonneg", yhat >= 0),
        ("all_y_nonneg", all(y >= 0 for y in ys)),
        ("r_in_range", -1.0 <= r <= 1.0),
        ("slope_sign_matches_context", (b > 0) == (sign > 0)),
    ]
    return _package("lsrl_predict", seed, "5.3", ["3.B"], "Easy", prompt,
                    f"y-hat = {yhat:.3f}", worked,
                    [{"kind": "numeric", "value": round(yhat, 3), "tol": tol}],
                    f"{yhat:.2f}", yhat, tol, distractors,
                    {"slope": b, "intercept": a, "x_new": x_new}, checks)


def gen_normal_prob(rng: random.Random, seed: int) -> Dict:
    mu = rng.choice([50, 100, 200, 500])
    sigma = rng.choice([5, 10, 15, 25])
    mult = rng.choice([-2, -1.5, -1, 1, 1.5, 2])
    x = round(mu + mult * sigma, 1)
    tol = 0.005
    z = S.z_score(x, mu, sigma)
    below = S.norm_cdf(z)
    prompt = (f"A quantity is Normally distributed with mean {mu} and standard deviation {sigma}. "
              f"Find the probability that a randomly chosen value is less than {x}.")
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
                    {"mu": mu, "sigma": sigma, "x": x}, checks)


def gen_summary_stats(rng: random.Random, seed: int) -> Dict:
    n = rng.choice([7, 9, 11])
    data = sorted(rng.randint(10, 90) for _ in range(n))
    m = S.sample_mean(data)
    tol = 0.001
    prompt = (f"Consider the data set: {', '.join(str(d) for d in data)}. Calculate the sample mean.")
    worked = f"mean = sum/n = {sum(data)}/{n} = {m:.4f}."
    _, _, med, _, _ = S.five_number_summary(data)
    distractors = [
        (f"{med:.2f}", "reported_median_not_mean", med),
        (f"{S.population_sd(data):.2f}", "reported_pop_sd", S.population_sd(data)),
        (f"{sum(data)/(n-1):.2f}", "divided_by_n_minus_1", sum(data) / (n - 1)),
        (f"{(min(data)+max(data))/2:.2f}", "reported_midrange", (min(data) + max(data)) / 2),
        (f"{sum(data):.2f}", "forgot_to_divide", float(sum(data))),
    ]
    checks = [
        ("mean_correct", abs(m - sum(data) / n) < 1e-9),
        ("five_num_ordered", True),
    ]
    return _package("summary_stats", seed, "1.7", ["3.B"], "Easy", prompt,
                    f"mean = {m:.4f}", worked,
                    [{"kind": "numeric", "value": round(m, 4), "tol": tol}],
                    f"{m:.2f}", m, tol, distractors,
                    {"data": data}, checks)


PROCEDURES: Dict[str, Callable[[random.Random, int], Dict]] = {
    "one_prop_ci": gen_one_prop_ci,
    "two_prop_ztest": gen_two_prop_ztest,
    "lsrl_predict": gen_lsrl_predict,
    "normal_prob": gen_normal_prob,
    "summary_stats": gen_summary_stats,
}


# ===========================================================================
# Item-package assembly with distinctness + separation enforcement
# ===========================================================================

def _package(proc, seed, topic, skills, difficulty, prompt, answer_desc, worked,
             det_checks, mcq_correct, mcq_key_value: Optional[float], tol: float,
             mcq_distractors: List[Tuple[str, str, Optional[float]]], params, checks) -> Dict:
    unit = unit_of(topic)
    options = [{"text": mcq_correct, "correct": True, "misconception": None}]
    seen = {mcq_correct}
    for disp, tag, val in mcq_distractors:
        if disp in seen:
            continue
        if val is not None and mcq_key_value is not None and abs(val - mcq_key_value) <= 3 * tol:
            continue  # separation guard: keep distractors clear of the key's grading tolerance
                      # (3x margin so rounded display never lands within 2x tol either)
        seen.add(disp)
        options.append({"text": disp, "correct": False, "misconception": tag})
        if len(options) == 4:
            break
    checks = list(checks) + [
        ("mcq_option_texts_unique", len({o["text"] for o in options}) == len(options)),
        ("mcq_exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("mcq_has_3_distractors", len(options) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
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
