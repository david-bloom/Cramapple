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
        ["plausible slope SIGN for the context", "non-negative predictions for non-negative quantities"],
        [_SEC5, _SEC6, _SEC7]),
    "normal_prob": Framing(
        "normal_prob", "Q4", "Calculate", 3, "exam_aligned_digital",
        ["a quantity modeled as Normal", "probability must lie in [0, 1]"],
        [_SEC5, _SEC6, _SEC7]),
    "summary_stats": Framing(
        "summary_stats", "Q2", "Calculate", 3, "exam_aligned_digital",
        ["a raw quantitative data set (no real-world causal claim implied)"],
        [_SEC5, _SEC6, _SEC7]),
    "slotframe_4b": Framing(
        "slotframe_4b", "Q2", "Justify", 4, "exam_aligned_digital",
        ["OBSERVATIONAL comparison only (no random assignment -> no causal claim)",
         "means differ but spreads overlap so an over-strong claim is refutable"],
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

# regression: (xlab, ylab, who, sign) -- sign encodes a plausible slope direction
REGRESSION_CONTEXTS: List[Dict[str, object]] = [
    {"xlab": "hours studied", "ylab": "exam score", "who": "a tutor", "sign": +1, "domain": "education"},
    {"xlab": "age of a used car (years)", "ylab": "price ($1000s)", "who": "a dealership analyst", "sign": -1, "domain": "business"},
    {"xlab": "outside temperature (F)", "ylab": "daily ice-cream sales ($)", "who": "a shop owner", "sign": +1, "domain": "business"},
    {"xlab": "fertilizer (g/plant)", "ylab": "plant height (cm)", "who": "a gardener", "sign": +1, "domain": "biology"},
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
    for ctx in NORMAL_CONTEXTS:
        if not all(k in ctx for k in ("quantity", "unit", "domain", "mu_choices", "sigma_choices")):
            problems.append(f"normal context missing fields: {ctx}")
        elif not ctx["mu_choices"] or not ctx["sigma_choices"]:
            problems.append(f"normal context has empty mu/sigma choices: {ctx}")
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
        },
        "framing": {p: {"archetype": f.archetype, "task_verb": f.task_verb,
                        "modality": f.modality} for p, f in FRAMING.items()},
        "self_check_problems": probs,
        "ok": not probs,
    }, indent=2))
