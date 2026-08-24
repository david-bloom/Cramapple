#!/usr/bin/env python3
"""Canonical scenario/framing catalog for the Course-Mode AP Statistics generators.

WHY THIS FILE EXISTS
--------------------
Companion to `misconceptions.py`. Where that file grounds the *distractors*, this
file grounds the *scenarios* -- the contexts a generated item is set in and the
framing (question archetype + task verb + response modality) it must conform to.

Before this file, the context banks lived inline in `generator.py` /
`slot_frames.py` as bare tuples with no rationale. Now:
  - each procedure has a FRAMING that ties it to a canonical AP archetype (fact
    pack Section 5), a task verb (Section 6), and the digital modality (Section 7),
    plus the validity rules an instance must satisfy; and
  - each context carries a domain + any validity flag (observational, two-group,
    slope-sign), so a generated item can emit auditable scenario provenance.

SOURCING & RIGHTS (read before adding contexts)
-----------------------------------------------
Contexts here are ORIGINAL synthetic settings. Per the AP Statistics Phase-4
authoring brief (Governing Rule 2) and DECISION-0031/0033, NO official College
Board material -- questions, scoring guidelines, or identifiable official
structures -- may be used as source, exemplar, or input. We therefore ground
scenarios in CED *structure* (archetypes / task verbs / modality), never in CED
*content*:
  - fact_pack : AP_STATISTICS_2027_CED_FACT_PACK.md Sections 5 (FRQ archetypes),
                6 (task verbs), 7 (response modality / digital constraints).
  - ced       : the same conventions as expressed in the CED itself.

Modality tags (Section 7): `exam_aligned_digital` for text/numeric items that fit
the Bluebook digital exam; `supplemental_hand_drawn` for anything relying on a
hand-drawn graph (Cramapple has no Desmos equivalent). Every procedure here is
text/numeric -> `exam_aligned_digital`.

This is data, not content: adding a scenario releases nothing. Items stay
`unreleased_generated_pending_review` under CM-D19; §3/§10 stay under the D2 gate.
"""
from __future__ import annotations

from typing import Dict, List, Optional


# ---- canonical framing sources -------------------------------------------------
def _fp(ref: str, note: str) -> Dict[str, str]:
    return {"kind": "fact_pack", "ref": f"AP_STATISTICS_2027_CED_FACT_PACK.md {ref}", "note": note}


# FRQ archetypes (Section 5) -- the four Section II question types.
ARCHETYPES = {
    "Q1": "Multi-focus on Practices 1 & 2 (formulate questions; collect/represent data)",
    "Q2": "Multi-focus on Practices 3 & 4 (analyze data; interpret results)",
    "Q3": "Inference: a significance test or confidence interval",
    "Q4": "Multi-focus on Practices 2, 3 & 4 (spans multiple content areas)",
}

# Task verbs (Section 6) used by the pilot procedures.
TASK_VERBS = {
    "Calculate": "perform the steps to a final numeric answer",
    "Construct": "build a representation / interval",
    "Justify": "give statistical reasoning to support or qualify a claim",
}

_VALID_MODALITY = {"exam_aligned_digital", "supplemental_hand_drawn"}


class Framing:
    """Canonical framing for a generator procedure."""

    def __init__(self, procedure: str, archetype: str, task_verb: str, practice: int,
                 modality: str, validity_rules: List[str], sources: List[Dict[str, str]]):
        assert archetype in ARCHETYPES, f"unknown archetype {archetype!r}"
        assert task_verb in TASK_VERBS, f"unknown task verb {task_verb!r}"
        assert modality in _VALID_MODALITY, f"unknown modality {modality!r}"
        self.procedure = procedure
        self.archetype = archetype
        self.task_verb = task_verb
        self.practice = practice
        self.modality = modality
        self.validity_rules = validity_rules
        self.sources = sources

    def provenance(self, domain: Optional[str] = None) -> Dict[str, object]:
        prov: Dict[str, object] = {
            "archetype": self.archetype,
            "archetype_label": ARCHETYPES[self.archetype],
            "task_verb": self.task_verb,
            "practice": self.practice,
            "modality": self.modality,
            "validity_rules": list(self.validity_rules),
            "sources": [dict(s) for s in self.sources],
        }
        if domain is not None:
            prov["domain"] = domain
        return prov


_SEC5 = _fp("S5 (Free-response archetypes)", "Section II question archetypes Q1-Q4")
_SEC6 = _fp("S6 (Task verbs)", "the item stem's verb must match the scored demand")
_SEC7 = _fp("S7 (Response modality)", "digital Bluebook; text/numeric entry -> exam_aligned_digital")


FRAMING: Dict[str, Framing] = {
    "one_prop_ci": Framing(
        "one_prop_ci", "Q3", "Construct", 3, "exam_aligned_digital",
        ["proportion context: a count x out of n", "large-counts condition must hold"],
        [_SEC5, _SEC6, _SEC7]),
    "two_prop_ztest": Framing(
        "two_prop_ztest", "Q3", "Calculate", 3, "exam_aligned_digital",
        ["two DISTINCT groups", "pooled large-counts condition must hold",
         "an appreciable between-group difference so z is meaningful"],
        [_SEC5, _SEC6, _SEC7]),
    "lsrl_predict": Framing(
        "lsrl_predict", "Q2", "Calculate", 3, "exam_aligned_digital",
        ["plausible slope SIGN for the context",
         "the requested x is in the context's realistic range (no absurd extrapolation)",
         "the prediction AND every distractor land inside the response's credible envelope "
         "(y_lo..y_hi) -- e.g. exam score <= 100, a >10-year-old car is cheap, temperature in Celsius"],
        [_SEC5, _SEC6, _SEC7]),
    "normal_prob": Framing(
        "normal_prob", "Q4", "Calculate", 3, "exam_aligned_digital",
        ["a quantity modeled as Normal", "probability must lie in [0, 1]"],
        [_SEC5, _SEC6, _SEC7]),
    "summary_stats": Framing(
        "summary_stats", "Q2", "Calculate", 3, "exam_aligned_digital",
        ["a raw quantitative data set (no real-world causal claim implied)"],
        [_SEC5, _SEC6, _SEC7]),
    "compare_stats": Framing(
        "compare_stats", "Q2", "Calculate", 3, "exam_aligned_digital",
        ["two one-variable quantitative data sets for distinct groups",
         "the requested statistic is stated explicitly as Group A minus Group B",
         "answer is a single numeric comparison: mean difference, median difference, or IQR difference"],
        [_SEC5, _SEC6, _SEC7]),
    "slotframe_4b": Framing(
        "slotframe_4b", "Q2", "Justify", 4, "exam_aligned_digital",
        ["OBSERVATIONAL comparison only (no random assignment -> no causal claim)",
         "means differ but spreads overlap so an over-strong claim is refutable"],
        [_SEC5, _SEC6, _SEC7]),
    "t_test_mean": Framing(
        "t_test_mean", "Q4", "Calculate", 3, "exam_aligned_digital",
        ["a random sample of a quantitative variable (population roughly Normal or n large)",
         "a hypothesized mean mu0 and a positive sample SD",
         "the t-statistic magnitude stays in a realistic range"],
        [_SEC5, _SEC6, _SEC7]),
    "t_interval_mean": Framing(
        "t_interval_mean", "Q4", "Construct", 3, "exam_aligned_digital",
        ["df = n-1 within the standard t-table (n <= 31)",
         "confidence in {90%, 95%, 99%}",
         "t (for a mean), never z -- CED convention; interval bounds realistic for the quantity"],
        [_SEC5, _SEC6, _SEC7]),
    "chi_square_test": Framing(
        "chi_square_test", "Q4", "Calculate", 3, "exam_aligned_digital",
        ["a two-way table of counts for two categorical variables",
         "every EXPECTED count >= 5 (the large-counts condition)",
         "chi-square for independence/homogeneity only; statistic stays in a realistic range"],
        [_SEC5, _SEC6, _SEC7]),
    "two_sample_t_test": Framing(
        "two_sample_t_test", "Q4", "Calculate", 3, "exam_aligned_digital",
        ["two DISTINCT independent samples of a quantitative variable",
         "populations roughly Normal or both samples large",
         "df = min(n1-1, n2-1) within the standard t-table (n <= 31)",
         "the t-statistic magnitude stays in a realistic range"],
        [_SEC5, _SEC6, _SEC7]),
    "two_sample_t_interval": Framing(
        "two_sample_t_interval", "Q4", "Construct", 3, "exam_aligned_digital",
        ["two DISTINCT independent samples of a quantitative variable",
         "populations roughly Normal or both samples large",
         "df = min(n1-1, n2-1) within the standard t-table (n <= 31)",
         "confidence in {90%, 95%, 99%}",
         "t (for means), never z -- CED convention; interval bounds realistic for the quantity"],
        [_SEC5, _SEC6, _SEC7]),
}


# ==============================================================================
# CONTEXT BANKS (original synthetic settings; each tagged with a domain)
# ==============================================================================
# one-proportion: (source, trait phrase, unit noun)
PROPORTION_CONTEXTS: List[Dict[str, str]] = [
    {"src": "a school newspaper", "trait": "bike to school", "noun": "students", "domain": "education"},
    {"src": "a city parks survey", "trait": "visited a park last month", "noun": "residents", "domain": "civic"},
    {"src": "a quality-control team", "trait": "pass inspection", "noun": "microchips", "domain": "manufacturing"},
    {"src": "a biologist", "trait": "germinated", "noun": "seeds", "domain": "biology"},
    {"src": "a marketing team", "trait": "opened the email", "noun": "customers", "domain": "business"},
]

# two-group: (noun, verb phrase, groupA, groupB) -- two DISTINCT groups
TWO_GROUP_CONTEXTS: List[Dict[str, str]] = [
    {"noun": "voters", "verb": "support the measure", "gA": "County A", "gB": "County B", "domain": "civic"},
    {"noun": "households", "verb": "own a pet", "gA": "the suburb", "gB": "the city", "domain": "social"},
    {"noun": "passengers", "verb": "checked a bag", "gA": "Airline X", "gB": "Airline Y", "domain": "business"},
    {"noun": "online orders", "verb": "shipped on time", "gA": "warehouse 1", "gB": "warehouse 2", "domain": "operations"},
]

# regression (predict from an LSRL). Each context carries a CREDIBILITY ENVELOPE so
# every generated instance is real-world plausible (SME review 2026-08-24):
#   x_lo/x_hi  -- realistic range for the prediction point (the requested x)
#   y_lo/y_hi  -- credible range for the response; the KEY *and every DISTRACTOR*
#                 must land inside it (e.g. an exam score can't exceed 100; a used
#                 car isn't worth $36k; ice-cream temperature is in Celsius, not a
#                 freezing Fahrenheit value)
#   a_choices  -- intercept pool (the response's baseline at x=0)
#   b_mag      -- |slope| pool; actual slope = sign * b_mag (+ small jitter for a
#                 realistic non-round least-squares coefficient)
REGRESSION_CONTEXTS: List[Dict[str, object]] = [
    {"xlab": "the day's high temperature (°C)", "ylab": "ice-cream sales (dollars)",
     "who": "a shop owner", "sign": +1, "domain": "business",
     "x_lo": 17, "x_hi": 34, "y_lo": 0, "y_hi": 700, "a_choices": [40, 60, 80], "b_mag": [8, 10, 12, 15]},
    {"xlab": "weeks since planting", "ylab": "seedling height (centimeters)",
     "who": "a botanist", "sign": +1, "domain": "biology",
     "x_lo": 6, "x_hi": 16, "y_lo": 0, "y_hi": 180, "a_choices": [6, 10, 14], "b_mag": [4, 5, 6]},
    {"xlab": "monthly ad spend (thousands of dollars)", "ylab": "monthly revenue (thousands of dollars)",
     "who": "a business analyst", "sign": +1, "domain": "business",
     "x_lo": 4, "x_hi": 20, "y_lo": 0, "y_hi": 500, "a_choices": [30, 50, 70], "b_mag": [8, 10, 12]},
    {"xlab": "hours studied", "ylab": "exam score (points, out of 100)",
     "who": "a tutor", "sign": +1, "domain": "education",
     "x_lo": 4, "x_hi": 12, "y_lo": 65, "y_hi": 100, "a_choices": [62, 66, 70], "b_mag": [2, 2.5, 3]},
    {"xlab": "age (years)", "ylab": "price of a used car (thousands of dollars)",
     "who": "a dealership analyst", "sign": -1, "domain": "business",
     "x_lo": 3, "x_hi": 11, "y_lo": 1, "y_hi": 32, "a_choices": [28, 30, 34], "b_mag": [2, 2.5, 3]},
]

# normal: a light, realistic quantity for the Normal model. Each context carries
# its OWN plausible mean/SD pools so the generated numbers fit the setting (a
# per-context parameter guardrail -- avoids nonsense like "heart rate, mean 200").
NORMAL_CONTEXTS: List[Dict[str, object]] = [
    {"quantity": "battery life", "unit": "hours", "domain": "manufacturing",
     "mu_choices": [10, 12, 24, 40], "sigma_choices": [1, 2, 3]},
    {"quantity": "adult resting heart rate", "unit": "bpm", "domain": "health",
     "mu_choices": [68, 72, 76, 80], "sigma_choices": [6, 8, 10]},
    {"quantity": "daily commute time", "unit": "minutes", "domain": "social",
     "mu_choices": [20, 30, 45, 60], "sigma_choices": [5, 8, 10]},
    {"quantity": "bag fill weight", "unit": "grams", "domain": "manufacturing",
     "mu_choices": [200, 500, 1000], "sigma_choices": [5, 10, 15]},
]

# means (t procedures): a quantitative variable with a hypothesized/claimed mean.
# Each context carries its OWN plausible mu0 / sample-SD / sample-size pools so the
# generated summary statistics fit the setting (per-context guardrail). n<=30 keeps
# df=n-1 inside the standard t-table.
MEAN_CONTEXTS: List[Dict[str, object]] = [
    {"quantity": "cups of coffee sold per hour", "unit": "cups", "who": "a cafe manager", "domain": "business",
     "mu0_choices": [18, 22, 25, 30], "s_choices": [3, 4, 5, 6], "n_choices": [10, 12, 15, 20, 25]},
    {"quantity": "battery life", "unit": "hours", "who": "a quality engineer", "domain": "manufacturing",
     "mu0_choices": [10, 12, 20, 24], "s_choices": [1, 2, 3], "n_choices": [8, 10, 12, 16, 20]},
    {"quantity": "one-way commute time", "unit": "minutes", "who": "a transit analyst", "domain": "social",
     "mu0_choices": [25, 30, 40, 45], "s_choices": [4, 6, 8], "n_choices": [10, 15, 20, 25, 30]},
    {"quantity": "seedling height after three weeks", "unit": "cm", "who": "a botanist", "domain": "biology",
     "mu0_choices": [8, 10, 12, 15], "s_choices": [1, 2, 3], "n_choices": [9, 12, 16, 20]},
]

# two-sample means (two-sample t procedures): two independent samples of a
# quantitative variable. Each context carries plausible per-group mu / SD / n
# pools for a two-group comparison. n <= 30 keeps df = min(n1-1, n2-1) inside
# the standard t-table. Two DISTINCT groups gA, gB.
TWO_MEAN_CONTEXTS: List[Dict[str, object]] = [
    {"quantity": "daily steps", "unit": "steps", "gA": "office workers", "gB": "construction workers",
     "domain": "health", "mu_choices": [8000, 10000, 12000, 14000], "s_choices": [2000, 3000, 4000],
     "n_choices": [12, 15, 18, 20, 25]},
    {"quantity": "time to resolve a customer issue", "unit": "minutes", "gA": "experienced staff", "gB": "new hires",
     "domain": "business", "mu_choices": [15, 20, 25, 30], "s_choices": [4, 5, 6], "n_choices": [10, 12, 15, 20]},
    {"quantity": "battery life under heavy use", "unit": "hours", "gA": "brand A", "gB": "brand B",
     "domain": "manufacturing", "mu_choices": [8, 10, 12, 14], "s_choices": [1.5, 2, 2.5], "n_choices": [10, 14, 18, 22]},
    {"quantity": "test score", "unit": "points", "gA": "morning class", "gB": "afternoon class",
     "domain": "education", "mu_choices": [72, 76, 80, 84], "s_choices": [6, 8, 10], "n_choices": [12, 15, 18, 20, 25]},
    {"quantity": "plant height after six weeks", "unit": "cm", "gA": "with fertilizer", "gB": "control group",
     "domain": "biology", "mu_choices": [20, 25, 30, 35], "s_choices": [3, 4, 5], "n_choices": [10, 12, 16, 20]},
]

# categorical (chi-square independence/homogeneity): two categorical variables ->
# a two-way table. rows = groups/categories of one variable, cols = the other.
CATEGORICAL_CONTEXTS: List[Dict[str, object]] = [
    {"desc": "adults in three cities and their preferred hot drink",
     "rows": ["City A", "City B", "City C"], "cols": ["Tea", "Coffee", "Neither"],
     "row_noun": "adults", "domain": "social"},
    {"desc": "students in two grade levels and how they get to school",
     "rows": ["9th grade", "12th grade"], "cols": ["Bus", "Car", "Bike/Walk"],
     "row_noun": "students", "domain": "education"},
    {"desc": "devices from two production lines and their inspection outcome",
     "rows": ["Line 1", "Line 2"], "cols": ["Pass", "Rework", "Fail"],
     "row_noun": "devices", "domain": "manufacturing"},
]

# Unit 1.9 two-distribution comparison contexts. Each id is cell-namespaced so
# parallel agents can append without collisions. Contexts are original synthetic
# settings, not College Board prompts.
U1_9_COMPARE_CONTEXTS: List[Dict[str, object]] = [
    {"id": "u1_9__garden_seedlings", "quantity": "seedling heights after four weeks", "unit": "cm",
     "group_a": "sunlit bed", "group_b": "shaded bed", "domain": "biology", "low": 12, "high": 48},
    {"id": "u1_9__delivery_times", "quantity": "delivery times", "unit": "minutes",
     "group_a": "Route A", "group_b": "Route B", "domain": "operations", "low": 18, "high": 85},
    {"id": "u1_9__study_sessions", "quantity": "study-session lengths", "unit": "minutes",
     "group_a": "weekday sessions", "group_b": "weekend sessions", "domain": "education", "low": 20, "high": 120},
    {"id": "u1_9__store_receipts", "quantity": "customer receipt totals", "unit": "dollars",
     "group_a": "morning customers", "group_b": "evening customers", "domain": "business", "low": 8, "high": 95},
    {"id": "u1_9__trail_counts", "quantity": "daily trail-user counts", "unit": "people",
     "group_a": "north trail", "group_b": "south trail", "domain": "civic", "low": 15, "high": 140},
]


# ==============================================================================
# Access + validation helpers
# ==============================================================================
def framing(procedure: str, domain: Optional[str] = None) -> Dict[str, object]:
    try:
        return FRAMING[procedure].provenance(domain)
    except KeyError:
        raise KeyError(
            f"procedure {procedure!r} has no canonical framing in scenarios.py; "
            f"add a Framing entry tying it to an FRQ archetype (S5), task verb (S6), "
            f"and modality (S7) before generating items for it."
        )


def all_procedures() -> List[str]:
    return sorted(FRAMING)


def validate_scenarios() -> List[str]:
    """Self-check: returns a list of problems (empty = OK)."""
    problems: List[str] = []
    for proc, f in FRAMING.items():
        if not f.sources:
            problems.append(f"{proc}: framing has no sources")
        if not f.validity_rules:
            problems.append(f"{proc}: framing has no validity rules")
    # context-bank integrity
    for ctx in PROPORTION_CONTEXTS:
        if not all(k in ctx for k in ("src", "trait", "noun", "domain")):
            problems.append(f"proportion context missing fields: {ctx}")
    for ctx in TWO_GROUP_CONTEXTS:
        if ctx.get("gA") == ctx.get("gB"):
            problems.append(f"two-group context is not two distinct groups: {ctx}")
    for ctx in REGRESSION_CONTEXTS:
        if ctx.get("sign") not in (+1, -1):
            problems.append(f"regression context missing plausible slope sign: {ctx}")
        elif not all(k in ctx for k in ("x_lo", "x_hi", "y_lo", "y_hi", "a_choices", "b_mag")):
            problems.append(f"regression context missing credibility-envelope fields: {ctx}")
        elif ctx["x_lo"] >= ctx["x_hi"] or ctx["y_lo"] >= ctx["y_hi"]:
            problems.append(f"regression context has an inverted x/y range: {ctx}")
    for ctx in NORMAL_CONTEXTS:
        if not all(k in ctx for k in ("quantity", "unit", "domain", "mu_choices", "sigma_choices")):
            problems.append(f"normal context missing fields: {ctx}")
        elif not ctx["mu_choices"] or not ctx["sigma_choices"]:
            problems.append(f"normal context has empty mu/sigma choices: {ctx}")
    for ctx in MEAN_CONTEXTS:
        if not all(k in ctx for k in ("quantity", "unit", "who", "domain", "mu0_choices", "s_choices", "n_choices")):
            problems.append(f"mean context missing fields: {ctx}")
        elif any(n > 31 for n in ctx["n_choices"]):
            problems.append(f"mean context n exceeds t-table (df=n-1 must be <=30): {ctx}")
    for ctx in TWO_MEAN_CONTEXTS:
        if not all(k in ctx for k in ("quantity", "unit", "gA", "gB", "domain", "mu_choices", "s_choices", "n_choices")):
            problems.append(f"two-mean context missing fields: {ctx}")
        elif ctx.get("gA") == ctx.get("gB"):
            problems.append(f"two-mean context is not two distinct groups: {ctx}")
        elif any(n > 31 for n in ctx["n_choices"]):
            problems.append(f"two-mean context n exceeds t-table (df=min(n1-1,n2-1) must be <=30): {ctx}")
    for ctx in CATEGORICAL_CONTEXTS:
        if not all(k in ctx for k in ("desc", "rows", "cols", "row_noun", "domain")):
            problems.append(f"categorical context missing fields: {ctx}")
        elif len(ctx["rows"]) < 2 or len(ctx["cols"]) < 2:
            problems.append(f"categorical context needs >=2 rows and cols: {ctx}")
    seen_compare_ids = set()
    for ctx in U1_9_COMPARE_CONTEXTS:
        required = ("id", "quantity", "unit", "group_a", "group_b", "domain", "low", "high")
        if not all(k in ctx for k in required):
            problems.append(f"u1_9 compare context missing fields: {ctx}")
        if ctx.get("id") in seen_compare_ids:
            problems.append(f"duplicate u1_9 compare context id: {ctx.get('id')}")
        seen_compare_ids.add(ctx.get("id"))
        if not str(ctx.get("id", "")).startswith("u1_9__"):
            problems.append(f"u1_9 compare context id is not namespaced: {ctx.get('id')}")
        if ctx.get("group_a") == ctx.get("group_b"):
            problems.append(f"u1_9 compare context groups are not distinct: {ctx}")
        if ctx.get("low", 0) >= ctx.get("high", 0):
            problems.append(f"u1_9 compare context has inverted range: {ctx}")
    return problems


if __name__ == "__main__":
    import json

    probs = validate_scenarios()
    print(json.dumps({
        "procedures": all_procedures(),
        "context_banks": {
            "proportion": len(PROPORTION_CONTEXTS),
            "two_group": len(TWO_GROUP_CONTEXTS),
            "regression": len(REGRESSION_CONTEXTS),
            "normal": len(NORMAL_CONTEXTS),
            "mean": len(MEAN_CONTEXTS),
            "two_mean": len(TWO_MEAN_CONTEXTS),
            "u1_9_compare": len(U1_9_COMPARE_CONTEXTS),
        },
        "framing": {p: {"archetype": f.archetype, "task_verb": f.task_verb,
                        "modality": f.modality} for p, f in FRAMING.items()},
        "self_check_problems": probs,
        "ok": not probs,
    }, indent=2))
