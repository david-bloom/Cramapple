#!/usr/bin/env python3
"""Canonical misconception catalog for the Course-Mode AP Statistics generators.

WHY THIS FILE EXISTS
--------------------
Plan step A5 (COURSE_MODE_PILOT_BUILD_PLAN.md) and CM-D15 require that every MCQ
distractor encode a *known* misconception so an item doubles as a diagnostic
probe. Before this file, the misconception tags lived inline in `generator.py` /
`slot_frames.py` as bare strings with no provenance -- plausible, but invented in
code and not tied to canonical material.

This module makes the misconception layer CANONICALLY GROUNDED: every tag used by
a generator must resolve to an entry here, and every entry cites its source.

SOURCING & RIGHTS (read before adding entries)
----------------------------------------------
Per DECISION-0031 / DECISION-0033 (see AP_STATISTICS_2027_CED_FACT_PACK.md
"Provenance & rights"), NO official College Board questions, scoring guidelines,
or verbatim exam content may enter authoring. This catalog therefore records only
*documented error patterns* and CED *structure*, each with a citation:

  - fact_pack : AP_STATISTICS_2027_CED_FACT_PACK.md, esp. Section 10 (per-topic
                misconceptions distilled from the 2025 Chief Reader Report and the
                CED). This is the primary, in-repo canonical source.
  - ced       : CED structure / formula sheet / task-verb conventions (Section 10
                "General exam-wide conventions").
  - albert.io / fiveable.me / khanacademy.org : trusted third-party study guides,
                used ONLY to corroborate documented error patterns for the topics
                Section 10 flags as thin (normal-distribution tails; regression
                prediction). Patterns only -- never verbatim CB items.

EVIDENCE tiers (how well-attested a pattern is):
  - documented_cr       : documented in the Chief Reader Report via fact pack S10.
  - ced_structural      : follows directly from a CED formula / EK / convention.
  - external_corroborated: documented as a common error in trusted study guides.

The catalog is data, not content: adding an entry does not release anything. All
generated items remain `unreleased_generated_pending_review` under the CM-D19 gate
(David reviewer of record), and Section 3 / Section 10 remain under the D2 SME gate.
"""
from __future__ import annotations

from typing import Dict, List, Optional


# --- reusable source references -------------------------------------------------
# fact pack section anchors (in-repo, primary)
def _fp(ref: str, note: str) -> Dict[str, str]:
    return {"kind": "fact_pack", "ref": f"AP_STATISTICS_2027_CED_FACT_PACK.md {ref}", "note": note}


def _ced(ref: str, note: str) -> Dict[str, str]:
    return {"kind": "ced", "ref": ref, "note": note}


def _ext(kind: str, url: str, note: str) -> Dict[str, str]:
    return {"kind": kind, "url": url, "note": note}


# frequently reused external anchors (documented error patterns only)
_ALBERT_NORMAL = "https://www.albert.io/blog/ap-statistics-the-normal-distribution-revisited/"
_FIVEABLE_NORMAL = "https://fiveable.me/ap-stats/unit-2/normal-distribution-revisited/study-guide/dx4vMcx3WjSw68f1Ov66"
_KHAN_NORMAL = "https://www.khanacademy.org/math/ap-statistics/density-curves-normal-distribution-ap/normal-distributions-calculations/e/z_scores_2"
_ALBERT_LSRL = "https://www.albert.io/blog/ap-statistics-least-squares-regression/"
_FIVEABLE_LSRL = "https://fiveable.me/ap-stats/unit-2/linear-regression-models/study-guide/PSt5cfDuvB5nu60DHulR"
_KHAN_LSRL = "https://www.khanacademy.org/math/ap-statistics/bivariate-data-ap/least-squares-regression/v/interpreting-slope-of-regression-line"

_VALID_KINDS = {"fact_pack", "ced", "albert.io", "fiveable.me", "khanacademy.org"}
_VALID_EVIDENCE = {"documented_cr", "ced_structural", "external_corroborated"}


class Misconception:
    """One catalog entry. `tag` is the stable key generators reference."""

    def __init__(self, tag: str, label: str, description: str, evidence: str,
                 procedures: List[str], topics: List[str], skills: List[str],
                 sources: List[Dict[str, str]], ek_codes: Optional[List[str]] = None):
        self.tag = tag
        self.label = label
        self.description = description
        self.evidence = evidence
        self.procedures = procedures
        self.topics = topics
        self.skills = skills
        self.sources = sources
        self.ek_codes = ek_codes or []

    def provenance(self) -> Dict[str, object]:
        """Compact, emit-safe provenance attached to each generated distractor."""
        return {
            "tag": self.tag,
            "label": self.label,
            "evidence": self.evidence,
            "ek_codes": list(self.ek_codes),
            "sources": [dict(s) for s in self.sources],
        }


def _M(*args, **kwargs) -> Misconception:
    return Misconception(*args, **kwargs)


# ==============================================================================
# CATALOG
# ==============================================================================
CATALOG: Dict[str, Misconception] = {m.tag: m for m in [

    # --- one_prop_ci (3.3 x 3.E) : one-sample z-interval for a proportion -------
    _M("forgot_z_star_used_se_only",
       "Omitted the critical value (used SE as the margin of error)",
       "Built the interval as p-hat +/- SE instead of p-hat +/- z*.SE, dropping the "
       "critical value from the CI template statistic +/- (critical value)(SE).",
       "ced_structural", ["one_prop_ci"], ["3.3"], ["3.E"],
       [_ced("CED formula sheet / fact pack S10 'General exam-wide conventions'",
             "CI template = statistic +/- (critical value)(standard error); omitting z* is a structural error"),
        _fp("S10 Unit 3 (3.3-3.4)", "margin of error = z*.SE for the one-proportion z-interval")]),

    _M("forgot_sqrt_in_se",
       "Dropped the square root in the standard error",
       "Computed SE as p-hat(1-p-hat)/n instead of sqrt(p-hat(1-p-hat)/n), so the "
       "margin of error is far too small.",
       "ced_structural", ["one_prop_ci"], ["3.3"], ["3.E"],
       [_fp("S10 Unit 3 (3.3-3.4)", "SE_phat = sqrt(phat(1-phat)/n) -- the radical is part of the formula")]),

    _M("one_sided_only_added_me",
       "Reported a one-sided interval (added the margin but not subtracted)",
       "Gave (p-hat, p-hat + ME) instead of a two-sided interval. Related to the "
       "documented error of using a confidence interval to conduct a one-sided test.",
       "documented_cr", ["one_prop_ci"], ["3.3"], ["3.E"],
       [_fp("S10 Unit 3 (3.5-3.8), item (6)",
            "2025 CR Report flags using a CI to conduct what should be a one-sided significance test")]),

    _M("used_wrong_z_90pct",
       "Used the wrong critical value for the stated confidence level",
       "Substituted a z* for a different confidence level (e.g. 90% z*=1.645 in "
       "place of the stated level), a critical-value selection error.",
       "ced_structural", ["one_prop_ci"], ["3.3"], ["3.E"],
       [_ced("CED formula sheet / fact pack S10 'General exam-wide conventions'",
             "critical value must match the stated confidence level in the CI template")]),

    # --- two_prop_ztest (3.13 x 3.E) : pooled two-proportion z-test ------------
    _M("used_unpooled_se",
       "Used the unpooled (CI) standard error in the significance test",
       "The two-proportion z-TEST uses the pooled proportion p_c (under H0: p1=p2) "
       "in the SE; using each sample's own p-hat is the CONFIDENCE-INTERVAL SE. "
       "Mixing them is a documented, precise CI-vs-test confusion.",
       "documented_cr", ["two_prop_ztest"], ["3.13"], ["3.E"],
       [_fp("S10 Unit 3 (3.12-3.13)",
            "pooled proportion used only for the test (H0: p1=p2), NOT the CI which uses each phat_i "
            "separately -- a sharp, testable CI-vs-test distinction")]),

    _M("reversed_group_order_sign",
       "Reversed the order of subtraction (sign of z flipped)",
       "Computed p2 - p1 instead of p1 - p2, flipping the sign of the test statistic.",
       "ced_structural", ["two_prop_ztest"], ["3.13"], ["3.E"],
       [_fp("S10 Unit 3 (3.12-3.13)", "test statistic numerator is (phat1 - phat2) - 0")]),

    _M("forgot_1_minus_p_in_se",
       "Dropped the (1 - p_c) factor in the pooled standard error",
       "Used p_c(1/n1+1/n2) instead of p_c(1-p_c)(1/n1+1/n2) under the radical.",
       "ced_structural", ["two_prop_ztest"], ["3.13"], ["3.E"],
       [_fp("S10 Unit 3 (3.12-3.13)", "pooled SE = sqrt(p_c(1-p_c)) * sqrt(1/n1 + 1/n2)")]),

    _M("wrong_se_combined_n",
       "Combined the two sample sizes incorrectly in the standard error",
       "Used a single combined n (e.g. n1+n2) in the SE instead of the 1/n1 + 1/n2 "
       "structure, mis-scaling the standard error.",
       "ced_structural", ["two_prop_ztest"], ["3.13"], ["3.E"],
       [_fp("S10 Unit 3 (3.12-3.13)", "pooled SE uses (1/n1 + 1/n2), not a single combined denominator")]),

    # --- lsrl_predict (5.3 x 3.B) : prediction from a least-squares line -------
    # Section 10 flags Unit 5 misconception coverage as the THINNEST of the five
    # units; these are corroborated against trusted study guides (patterns only).
    _M("swapped_slope_intercept",
       "Swapped slope and intercept when substituting into y-hat = a + bx",
       "Substituted the x-value into the wrong coefficient (used a as the slope / b "
       "as the intercept), a documented plug-in error for regression prediction.",
       "external_corroborated", ["lsrl_predict"], ["5.3"], ["3.B"],
       [_fp("S10 Unit 5 (5.3)", "prediction model is y-hat = a + bx (a = intercept, b = slope)"),
        _ext("albert.io", _ALBERT_LSRL, "predict by substituting x into y-hat = a + bx; slope/intercept roles are fixed"),
        _ext("fiveable.me", _FIVEABLE_LSRL, "linear regression model y-hat = a + bx; correct substitution of x")]),

    _M("dropped_intercept",
       "Omitted the intercept when predicting (used b*x only)",
       "Reported b*x instead of a + b*x, dropping the y-intercept from the prediction.",
       "external_corroborated", ["lsrl_predict"], ["5.3"], ["3.B"],
       [_fp("S10 Unit 5 (5.3)", "y-hat = a + bx -- the intercept a is part of every prediction"),
        _ext("khanacademy.org", _KHAN_LSRL, "prediction uses the full line a + bx, not the slope term alone")]),

    _M("sign_error_on_slope",
       "Sign error on the slope term when predicting",
       "Subtracted the slope contribution (a - b*x) instead of adding it, mishandling "
       "the slope's sign in the prediction.",
       "external_corroborated", ["lsrl_predict"], ["5.3"], ["3.B"],
       [_fp("S10 Unit 5 (5.4)", "sign discipline: a positive/negative slope direction is easily flipped"),
        _ext("albert.io", _ALBERT_LSRL, "slope sign carries direction; mishandling it is a common prediction error")]),

    _M("plugged_in_1_not_x",
       "Substituted x = 1 instead of the requested x-value",
       "Evaluated a + b (i.e. x = 1) rather than a + b*x_new, a slip in substituting "
       "the requested explanatory value into the line.",
       "external_corroborated", ["lsrl_predict"], ["5.3"], ["3.B"],
       [_fp("S10 Unit 5 (5.3)", "the requested x-value must be substituted into y-hat = a + bx"),
        _ext("fiveable.me", _FIVEABLE_LSRL, "substitute the given x-value, not a placeholder, into the model")]),

    _M("predicted_intercept_ignored_x",
       "Predicted the intercept, ignoring the explanatory variable",
       "Reported the y-intercept a as the prediction (y-hat = a), dropping the b*x term "
       "and treating the response as if it did not depend on x.",
       "ced_structural", ["lsrl_predict"], ["5.3"], ["3.B"],
       [_fp("S10 Unit 5 (5.3)", "the model y-hat = a + bx depends on x; using a alone drops the explanatory variable")]),

    _M("used_x_minus_one",
       "Substituted x - 1 instead of the requested x-value",
       "Evaluated the line at x - 1 rather than the requested x -- an off-by-one slip in "
       "substituting the explanatory value into y-hat = a + bx.",
       "ced_structural", ["lsrl_predict"], ["5.3"], ["3.B"],
       [_fp("S10 Unit 5 (5.3)", "the requested x-value must be substituted exactly into y-hat = a + bx")]),

    # --- normal_prob (2.11 x 3.C) : normal-distribution probability ------------
    # Section 10 flags 2.11 misconception coverage as thin; corroborated via
    # trusted study guides (documented tail/area error patterns).
    _M("used_upper_tail",
       "Reported the upper-tail area instead of the requested lower-tail area",
       "For a 'less than' (left-tail) probability, reported P(Z > z) = 1 - Phi(z) "
       "instead of Phi(z). Choosing the wrong tail for the question's wording is a "
       "documented, high-frequency error.",
       "external_corroborated", ["normal_prob"], ["2.11"], ["3.C"],
       [_fp("S10 Unit 2 (2.11)", "standard normal + interval-probability notation (lower/upper bounds) define which tail is requested"),
        _ext("albert.io", _ALBERT_NORMAL,
             "'at least'/'more than' point to the right tail; 'at most'/'less than' to the left -- "
             "picking the wrong direction is a common student error"),
        _ext("fiveable.me", _FIVEABLE_NORMAL, "match the tail (left vs right) to the inequality in the prompt"),
        _ext("khanacademy.org", _KHAN_NORMAL, "area above vs below a point: choose the correct region")]),

    _M("reported_area_mean_to_z",
       "Reported the area between the mean and z (table misread)",
       "Gave |Phi(z) - 0.5| (the mean-to-z body area) instead of the cumulative "
       "area, a classic normal-table misreading.",
       "external_corroborated", ["normal_prob"], ["2.11"], ["3.C"],
       [_fp("S10 Unit 2 (2.11)", "cumulative area under the standard normal vs the mean-to-z body area are distinct regions"),
        _ext("albert.io", _ALBERT_NORMAL,
             "area under the curve over an interval, read from the correct region -- mean-to-z body area is not the cumulative probability"),
        _ext("khanacademy.org", _KHAN_NORMAL, "distinguish cumulative area from the area between the mean and z")]),

    _M("reported_two_sided_area",
       "Reported a two-sided (symmetric) area instead of a one-sided probability",
       "Doubled the tail into a two-sided area for a one-sided question, related to "
       "the documented 'split the area in half' confusion on extreme-value problems.",
       "external_corroborated", ["normal_prob"], ["2.11"], ["3.C"],
       [_fp("S10 Unit 2 (2.11)", "a one-sided probability is a single tail/region, distinct from a symmetric two-sided area"),
        _ext("albert.io", _ALBERT_NORMAL,
             "for the most extreme p% of values the area is split in half -- conflating one- and two-sided areas is a documented error"),
        _ext("fiveable.me", _FIVEABLE_NORMAL, "one-sided vs two-sided area must match the question")]),

    # --- summary_stats (1.7 x 3.B) : sample mean of a small data set -----------
    _M("reported_median_not_mean",
       "Reported the median instead of the mean",
       "Returned the middle value rather than the arithmetic mean -- a mean/median "
       "confusion, the mixup underlying much of the mean-vs-median-position content.",
       "documented_cr", ["summary_stats"], ["1.7"], ["3.B"],
       [_fp("S10 Unit 1 (1.7)", "mean = (1/n) sum x_i vs median = middle ordered value; both defined distinctly"),
        _fp("S10 Unit 1 (1.6)", "2025 CR Report Q1 documents mean-vs-median reasoning errors")]),

    _M("reported_pop_sd",
       "Reported a standard deviation instead of the mean",
       "Returned a spread measure (population SD) when a center (mean) was asked for "
       "-- a center-vs-spread / wrong-statistic error.",
       "ced_structural", ["summary_stats"], ["1.7"], ["3.B"],
       [_fp("S10 Unit 1 (1.7)", "mean is a measure of center; SD is a measure of spread -- distinct statistics")]),

    _M("divided_by_n_minus_1",
       "Divided by n - 1 instead of n when computing the mean",
       "Applied the sample-variance denominator (n - 1) to the mean, which always "
       "divides the sum by n -- a cross-formula confusion.",
       "ced_structural", ["summary_stats"], ["1.7"], ["3.B"],
       [_fp("S10 Unit 1 (1.7)", "mean divides by n; only the sample SD/variance uses 1/(n-1)")]),

    _M("reported_midrange",
       "Reported the midrange (min+max)/2 instead of the mean",
       "Averaged only the extreme values, ignoring the interior data -- a plausible "
       "but incorrect measure-of-center substitute.",
       "ced_structural", ["summary_stats"], ["1.7"], ["3.B"],
       [_fp("S10 Unit 1 (1.7)", "range = max - min is a spread; the midrange is not the mean")]),

    _M("forgot_to_divide",
       "Reported the sum without dividing by n",
       "Returned sum(x_i) instead of sum(x_i)/n, omitting the division step of the mean.",
       "ced_structural", ["summary_stats"], ["1.7"], ["3.B"],
       [_fp("S10 Unit 1 (1.7)", "mean = (1/n) sum x_i -- the division by n is required")]),

    # --- slot-frame FB-4B-COMPARE-01 (1.9 x 4.B) : justify a claim -------------
    _M("ignores_variability_claims_every_value",
       "Treated a difference in means as a claim about every individual value",
       "Concluded that a higher group mean implies every member of that group exceeds "
       "every member of the other, ignoring variability/overlap between distributions.",
       "documented_cr", ["slotframe_4b"], ["1.9"], ["4.B"],
       [_fp("S10 Unit 1 (1.9) / 'General exam-wide conventions'",
            "on-average differences must not be over-read as claims about all individual values; overlap matters")]),

    _M("association_implies_causation",
       "Interpreted an observational association as causation",
       "Claimed group membership CAUSES the outcome from an observational comparison "
       "with no random assignment -- correlation/association does not imply causation.",
       "documented_cr", ["slotframe_4b"], ["1.9"], ["4.B"],
       [_fp("S10 Unit 5 (5.2)", "EK 5.2.A.4: correlation does not imply causation (stated explicitly)"),
        _fp("S10 Unit 1 (1.10-1.13)", "observational studies (no random assignment) do not support causal claims")],
       ek_codes=["5.2.A.4"]),

    _M("restates_claim_without_evidence",
       "Restated the claim without citing statistical evidence",
       "Asserted the claim is correct without referencing the calculations/results, "
       "failing the 4.B demand to justify from evidence.",
       "documented_cr", ["slotframe_4b"], ["1.9"], ["4.B"],
       [_fp("S4/S6 (skill 4.B; task verbs) + S10 'General exam-wide conventions'",
            "a justification must reference the statistical evidence, not merely restate the claim")]),

    _M("over_generalizes_beyond_data",
       "Over-generalized beyond the data using definitive language",
       "Extended the finding to 'always'/'any future population' and used definitive "
       "language ('proves'), violating the non-definitive-conclusion convention.",
       "documented_cr", ["slotframe_4b"], ["1.9"], ["4.B"],
       [_fp("S10 'General exam-wide conventions'",
            "2025 CR Report: conclusions must use non-definitive language ('convincing evidence'), never 'proves'/'always'; "
            "and must not generalize beyond the studied population")]),

    # --- t procedures (means): 4.2 x 3.E interval, 4.5 x 3.E test statistic ----
    _M("se_divided_by_n_not_sqrt_n",
       "Used SE = s/n instead of s/sqrt(n)",
       "Divided the sample SD by n rather than sqrt(n) when forming the standard "
       "error of the mean.",
       "ced_structural", ["t_test_mean", "t_interval_mean"], ["4.5", "4.2"], ["3.E"],
       [_fp("S3/S4 (t procedures)", "SE of a sample mean is s/sqrt(n), not s/n")]),
    _M("used_s_not_se",
       "Used the sample SD s as the standard error (forgot /sqrt(n))",
       "Treated s itself as the standard error, omitting the /sqrt(n) that turns a "
       "spread into the SD of the sample mean.",
       "ced_structural", ["t_test_mean", "t_interval_mean"], ["4.5", "4.2"], ["3.E"],
       [_fp("S3/S4 (t procedures)", "the SD of x-bar is s/sqrt(n); s alone overstates the SE")]),
    _M("flipped_t_numerator",
       "Flipped the sign of the t-statistic numerator",
       "Computed (mu0 - x-bar) instead of (x-bar - mu0), reversing the sign of t.",
       "ced_structural", ["t_test_mean"], ["4.5"], ["3.E"],
       [_fp("S3/S4 (t procedures)", "t = (x-bar - mu0)/(s/sqrt(n)); numerator is observed minus hypothesized")]),
    _M("used_z_star_not_t_star",
       "Used a z* critical value instead of t* for a mean",
       "Used a Normal critical value (e.g. 1.96 at 95%) instead of the larger t* with "
       "df = n-1 -- a documented z-vs-t confusion for means.",
       "ced_structural", ["t_interval_mean"], ["4.2"], ["3.E"],
       [_fp("S8/S3 (CED convention)", "means use t (df = n-1); z is for proportions, so a t interval must use t*")]),

    # --- chi-square (independence/homogeneity): 3.15 x 3.E test statistic ------
    _M("chi_forgot_square",
       "Summed (O - E)/E without squaring",
       "Computed sum of (O - E)/E instead of (O - E)^2/E, omitting the square.",
       "ced_structural", ["chi_square_test"], ["3.15"], ["3.E"],
       [_fp("S3 (chi-square)", "chi-square = sum (O - E)^2 / E; the deviation is squared")]),
    _M("chi_no_divide_by_E",
       "Summed (O - E)^2 without dividing by E",
       "Computed sum of (O - E)^2 and never divided each squared deviation by E.",
       "ced_structural", ["chi_square_test"], ["3.15"], ["3.E"],
       [_fp("S3 (chi-square)", "each squared deviation is standardized by dividing by its expected count")]),
    _M("chi_divided_by_O_not_E",
       "Divided the squared deviation by O instead of E",
       "Computed sum of (O - E)^2/O, dividing by the observed rather than expected count.",
       "ced_structural", ["chi_square_test"], ["3.15"], ["3.E"],
       [_fp("S3 (chi-square)", "the denominator in chi-square is the EXPECTED count E, not the observed O")]),
    _M("chi_uniform_expected",
       "Used equal expected counts (grand total / number of cells)",
       "Computed each expected count as grand_total / (#cells) -- an equal split across all "
       "cells -- instead of E = row_total * col_total / grand_total, then summed (O - E)^2/E.",
       "ced_structural", ["chi_square_test"], ["3.15"], ["3.E"],
       [_fp("S3 (chi-square)", "expected counts come from the MARGINAL totals (row*col/grand), not an equal split")]),
    _M("chi_expected_row_only",
       "Built expected counts from the row total only (ignored column marginals)",
       "Computed each expected count as row_total / (#columns) -- splitting each row equally "
       "across columns and ignoring the column marginals -- then summed (O - E)^2/E.",
       "ced_structural", ["chi_square_test"], ["3.15"], ["3.E"],
       [_fp("S3 (chi-square)", "expected counts use BOTH marginals (row*col/grand); a row-only split ignores the column distribution")]),
]}


# ==============================================================================
# Access + validation helpers (used by generator.py / slot_frames.py harnesses)
# ==============================================================================
def get(tag: str) -> Misconception:
    """Return the catalog entry for `tag`, or raise if it is not canonical."""
    try:
        return CATALOG[tag]
    except KeyError:
        raise KeyError(
            f"misconception tag {tag!r} is not in the canonical catalog "
            f"(scripts/course_mode_stats_generator/misconceptions.py). Every generator "
            f"distractor must reference a catalog entry with a cited source."
        )


def provenance(tag: str) -> Dict[str, object]:
    """Emit-safe provenance dict for a distractor tag."""
    return get(tag).provenance()


def all_tags() -> List[str]:
    return sorted(CATALOG)


def validate_catalog(strict_external: bool = True) -> List[str]:
    """Self-check the catalog's own integrity. Returns a list of problems (empty = OK)."""
    problems: List[str] = []
    for tag, m in CATALOG.items():
        if m.evidence not in _VALID_EVIDENCE:
            problems.append(f"{tag}: bad evidence tier {m.evidence!r}")
        if not m.sources:
            problems.append(f"{tag}: no sources")
        for s in m.sources:
            if s.get("kind") not in _VALID_KINDS:
                problems.append(f"{tag}: bad source kind {s.get('kind')!r}")
            if s["kind"] in ("albert.io", "fiveable.me", "khanacademy.org") and "url" not in s:
                problems.append(f"{tag}: external source missing url")
            if s["kind"] in ("fact_pack", "ced") and "ref" not in s:
                problems.append(f"{tag}: {s['kind']} source missing ref")
        # every external_corroborated entry should still carry an in-repo anchor
        if strict_external and m.evidence == "external_corroborated":
            if not any(s["kind"] in ("fact_pack", "ced") for s in m.sources):
                problems.append(f"{tag}: external_corroborated but no fact_pack/ced anchor")
        if not m.procedures:
            problems.append(f"{tag}: not attached to any procedure")
    return problems


if __name__ == "__main__":
    import json

    probs = validate_catalog()
    summary = {
        "entries": len(CATALOG),
        "by_evidence": {
            tier: sum(1 for m in CATALOG.values() if m.evidence == tier)
            for tier in sorted(_VALID_EVIDENCE)
        },
        "by_procedure": {
            proc: sorted(t for t, m in CATALOG.items() if proc in m.procedures)
            for proc in sorted({p for m in CATALOG.values() for p in m.procedures})
        },
        "self_check_problems": probs,
        "ok": not probs,
    }
    print(json.dumps(summary, indent=2))
