#!/usr/bin/env python3
"""Track B — authored conceptual slot-frame for AP Statistics skill 4.B
("justify a claim based on statistical calculations and results").

CM-D16: conceptual content is generated from an AUTHORED frame + validated slot
pools. Correctness comes from the authored justification taxonomy, NOT from
generation (INV-3). The number slots are context; the tested object is which
justification is statistically valid. This is the pilot's load-bearing risk test
(CM-FACT-19): can slot-frames cover Practice-4 interpretation at quality + volume?

Frame FB-4B-COMPARE-01 (cell 1.9 x 4.B):
  Compare two groups' means + SDs where A's mean exceeds B's but the spreads are
  large enough that the distributions substantially overlap. The claim under test
  is an over-strong "always/every" claim. The VALID justification affirms the
  on-average difference while rejecting the over-strong claim by citing overlap.

Synthetic; not official CB content. release_status pending review.
"""
from __future__ import annotations

import json
import random
from pathlib import Path
from typing import Dict, List

import misconceptions as MISC
import scenarios as SCN

OUT_DIR = Path(__file__).resolve().parent / "out"

# Authored slot pool. NOTE: all scenarios are OBSERVATIONAL comparisons (no random
# assignment), so the "association implies causation" distractor is unambiguously
# invalid. Do not add experimental/randomized-treatment scenarios to this frame
# without also removing that distractor type (validity discipline surfaced by the
# Track-B build, 2026-08-23).
SCENARIOS: List[Dict[str, str]] = [
    {"ctx": "a survey of eating habits", "a": "self-described high-fiber eaters",
     "b": "self-described low-fiber eaters", "quantity": "daily satiety score", "unit": "points",
     "domain": "health"},
    {"ctx": "a commuting survey", "a": "people who bike to work", "b": "people who take the bus",
     "quantity": "commute time", "unit": "minutes", "domain": "social"},
    {"ctx": "an observational garden study", "a": "plants in sunny spots",
     "b": "plants in shaded spots", "quantity": "recorded height", "unit": "cm",
     "domain": "biology"},
    {"ctx": "a survey of study habits", "a": "students who study mostly at night",
     "b": "students who study mostly in the morning", "quantity": "self-reported focus rating",
     "unit": "points", "domain": "education"},
]

# Authored justification taxonomy. Exactly one type is valid for this frame.
CORRECT_TYPE = "affirms_average_rejects_overstrong_via_overlap"
MISCONCEPTION_TYPES = [
    "ignores_variability_claims_every_value",
    "association_implies_causation",
    "restates_claim_without_evidence",
    "over_generalizes_beyond_data",
]


CAT_TABLE_TAGS = {
    "u1_3__count_percent_confusion",
    "u1_3__relative_frequency_denominator_error",
    "u1_3__quantitative_display_for_categories",
}

SAMPLING_METHODS = ["srs", "stratified", "cluster", "systematic", "convenience", "voluntary"]
SAMPLING_DISTRACTOR_TAGS = [
    "u1_11__stratified_cluster_confusion",
    "u1_11__convenience_or_voluntary_called_random",
    "u1_11__systematic_srs_conflation",
    "u1_11__stratified_samples_whole_groups",
]
SAMPLING_DISTRACTOR_TAGS_BY_METHOD = {
    "srs": [
        "u1_11__systematic_srs_conflation",
        "u1_11__stratified_cluster_confusion",
        "u1_11__convenience_or_voluntary_called_random",
    ],
    "stratified": [
        "u1_11__stratified_cluster_confusion",
        "u1_11__stratified_samples_whole_groups",
        "u1_11__systematic_srs_conflation",
    ],
    "cluster": [
        "u1_11__stratified_samples_whole_groups",
        "u1_11__stratified_cluster_confusion",
        "u1_11__convenience_or_voluntary_called_random",
    ],
    "systematic": [
        "u1_11__systematic_srs_conflation",
        "u1_11__convenience_or_voluntary_called_random",
        "u1_11__stratified_cluster_confusion",
    ],
    "convenience": [
        "u1_11__convenience_or_voluntary_called_random",
        "u1_11__stratified_cluster_confusion",
        "u1_11__stratified_samples_whole_groups",
    ],
    "voluntary": [
        "u1_11__convenience_or_voluntary_called_random",
        "u1_11__stratified_cluster_confusion",
        "u1_11__stratified_samples_whole_groups",
    ],
}



VARIABLE_TYPES = {"categorical", "categorical ordinal", "quantitative discrete", "quantitative continuous"}
VARIABLE_TAGS = {
    "u1_2__numeric_codes_called_quantitative",
    "u1_2__counts_or_ordinal_miscategorized",
    "u1_2__quantitative_called_categorical",
}



DISTRIBUTION_SHAPES = ["right-skewed", "left-skewed", "roughly symmetric"]
DISTRIBUTION_TAGS = {
    "u1_6__skew_direction_reversed",
    "u1_6__center_spread_confused",
    "u1_6__outlier_from_range_not_fences",
    "u1_6__ignores_shape_reports_center_only",
}

PVALUE_TAGS = {
    "u3_6__p_value_probability_null_true",
    "u3_6__p_value_probability_sample_due_to_chance",
    "u3_6__p_value_probability_alternative_true",
    "u3_6__p_value_reverses_extreme_direction",
}

DESIGN_TAGS = {
    "u1_13__confounding_vs_lurking_confused",
    "u1_13__control_blinding_randomization_confused",
    "u1_13__observational_treated_as_experiment",
}

BIAS_TAGS = {
    "u1_12__bias_type_confused",
    "u1_12__sampling_vs_nonsampling_error",
    "u1_12__no_bias_called_biased",
}

MUTUALLY_EXCLUSIVE_TAGS = {
    "u2_5__uses_independent_for_disjoint",
    "u2_5__overlap_wording_ignored",
    "u2_5__different_labels_mean_disjoint",
    "u2_5__same_trial_condition_missed",
}

BOXPLOT_TAGS = {
    "u1_8__quartile_median_positions_swapped",
    "u1_8__whisker_to_extreme_ignores_outlier",
    "u1_8__box_spans_range_not_iqr",
}

GRAPH_TAGS = {
    "u1_5__miscounted_bin_frequency",
    "u1_5__stem_leaf_place_value_error",
    "u1_5__wrong_plot_type_for_data",
}


PROP_CI_CLAIM_TAGS = {
    "u3_4__endpoint_inclusion_reversed",
    "u3_4__confidence_level_as_probability_claim",
    "u3_4__sample_statistic_as_population_claim",
    "u3_4__overstated_certainty_from_interval",
}


RANDOM_VARIABLE_TAGS = {
    "u2_8__probabilities_do_not_sum_to_one",
    "u2_8__negative_probability_allowed",
    "u2_8__cumulative_probability_confused_with_point_probability",
}

TWOWAY_INTERPRET_TAGS = {
    "u2_1__raw_counts_as_conditional_comparison",
    "u2_1__used_column_denominator_for_row_condition",
    "u2_1__marginal_percent_treated_as_conditional",
}

CAT_GRAPH_TAGS = {
    "u1_4__count_percent_graph_confusion",
    "u1_4__relative_frequency_graph_denominator_error",
    "u1_4__categorical_graph_as_quantitative_axis",
}

def _justification_text(kind: str, s: Dict[str, str], mA: float, mB: float, sd: float) -> str:
    a, b, q = s["a"], s["b"], s["quantity"]
    if kind == CORRECT_TYPE:
        return (f"On average {a} had a higher {q} (mean {mA} vs {mB}), so the data support a "
                f"typical difference; but because both SDs are about {sd}, the distributions "
                f"overlap substantially, so the data do not support a claim that {a} are always higher.")
    if kind == "ignores_variability_claims_every_value":
        return (f"Since the mean for {a} ({mA}) is greater than for {b} ({mB}), every member of "
                f"{a} must have a higher {q} than every member of {b}.")
    if kind == "association_implies_causation":
        return (f"Because {a} had a higher mean {q}, being in {a} causes a higher {q}.")
    if kind == "restates_claim_without_evidence":
        return f"The claim is correct because {a} clearly did better on {q}."
    if kind == "over_generalizes_beyond_data":
        return (f"These results prove that {a} will always outperform {b} on {q} in any future "
                f"study or population.")
    raise ValueError(kind)


def gen_4b_instance(rng: random.Random, seed: int) -> Dict:
    s = rng.choice(SCENARIOS)
    scenario_prov = SCN.framing("slotframe_4b", s.get("domain"))  # raises if framing missing
    # guardrail: A mean > B mean, but SD large relative to the gap (=> overlap),
    # so the authored correct/incorrect justifications remain valid for this instance.
    diff = rng.choice([3, 4, 5, 6])
    mB = rng.choice([35, 45, 55])       # higher floor -> less sub-zero mass, still overlapping
    mA = mB + diff
    sd = rng.choice([10, 12, 14])       # SD >> diff (gap<=6) -> substantial overlap
    claim = f"{s['a']} always have a higher {s['quantity']} than {s['b']}."

    prompt = (f"In {s['ctx']}, {s['a']} had a mean {s['quantity']} of {mA} {s['unit']} "
              f"(SD about {sd}) and {s['b']} had a mean of {mB} {s['unit']} (SD about {sd}). "
              f"A student claims: \"{claim}\" Which statement best justifies whether the data "
              f"support this claim?")

    options = [{"text": _justification_text(CORRECT_TYPE, s, mA, mB, sd),
                "correct": True, "misconception": None}]
    for mis in rng.sample(MISCONCEPTION_TYPES, 3):
        # MISC.provenance() raises if the justification-misconception type is not
        # in the canonical catalog, keeping distractors grounded + cited.
        options.append({"text": _justification_text(mis, s, mA, mB, sd),
                        "correct": False, "misconception": mis,
                        "misconception_source": MISC.provenance(mis)})
    rng.shuffle(options)

    checks = [
        ("guardrail_A_mean_gt_B", mA > mB),
        ("guardrail_overlap_sd_gt_gap", sd > (mA - mB)),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical",
         all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source",
         all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present",
         bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_observational_rule",
         any("OBSERVATIONAL" in r for r in scenario_prov.get("validity_rules", []))),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-4b-{seed:06d}",
        "content_key": f"apstat-4b-compare-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.9"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-4.B", "practice": 4},
        ],
        "cells": [{"topic": "1.9", "skill": "4.B"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{
            "part_key": "part-a", "prompt": prompt,
            "response_modalities": ["mcq"], "points": 1,
            "criteria": [{
                "criterion_key": "part-a-criterion-1", "points": 1,
                "description": "Selects the justification that affirms the on-average difference "
                               "while rejecting the over-strong 'always' claim due to overlap.",
                "required_evidence": "Correct justification type: " + CORRECT_TYPE,
                "deterministic_checks": [{"kind": "mcq_key", "correct_type": CORRECT_TYPE}],
                "accepted_variants": [],
            }],
        }],
        "provenance": {
            "generator": "course_mode_stats_generator/slot_frames.py",
            "frame_id": "FB-4B-COMPARE-01",
            "template_id": "slotframe_4b_compare",
            "params": {"scenario": s["ctx"], "mA": mA, "mB": mB, "sd": sd},
            "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Authored conceptual frame; correctness from authored justification taxonomy.",
        },
        "_property_checks": checks,
    }



def _pct_text(count: int, total: int) -> str:
    return f"{100 * count / total:.0f}%"


def _cat_rel_table_text(categories: List[tuple], total: int) -> str:
    return "; ".join(f"{label}: {_pct_text(count, total)}" for label, count in categories)


def _cat_count_table_text(categories: List[tuple]) -> str:
    return "; ".join(f"{label}: {count}" for label, count in categories)


def gen_u1_3_cat_table_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U1_3_CAT_TABLE_CONTEXTS)
    categories = list(c["categories"])
    shift = rng.choice([0, 2, 4, 6])
    categories = [(label, count + shift) for label, count in categories]
    total = sum(count for _label, count in categories)
    largest = max(count for _label, count in categories)
    correct_text = "Relative-frequency table: " + _cat_rel_table_text(categories, total)
    wrong_denom_text = "Relative-frequency table: " + _cat_rel_table_text(categories, largest)
    prompt = (f"A sample of {total} {c['unit']}s was classified by {c['quantity']}. "
              f"The category counts are {_cat_count_table_text(categories)}. "
              "Which representation correctly shows the relative-frequency table for this one categorical variable?")
    distractors = [
        ("Frequency table: " + _cat_count_table_text(categories), "u1_3__count_percent_confusion"),
        (wrong_denom_text, "u1_3__relative_frequency_denominator_error"),
        (f"Dotplot on a number line after coding the categories as 1, 2, 3, and 4", "u1_3__quantitative_display_for_categories"),
    ]
    options = [{"text": correct_text, "correct": True, "misconception": None}]
    for text, tag in distractors:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u1_3_cat_tables", c.get("domain"))
    checks = [
        ("total_positive", total > 0),
        ("relative_freq_sum_near_100", abs(sum(100 * count / total for _label, count in categories) - 100) < 1e-9),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("cat_table_tags_used", {o.get("misconception") for o in options if o.get("misconception")} == CAT_TABLE_TAGS),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u1_3-3a-{seed:06d}",
        "content_key": f"apstat-u1-3-3a-cat_table-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Easy-Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.3"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-3.A", "practice": 3},
        ],
        "cells": [{"topic": "1.3", "skill": "3.A"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                   "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                  "description": "Selects the relative-frequency table that preserves category labels and divides by the full sample total.",
                                  "required_evidence": correct_text,
                                  "deterministic_checks": [{"kind": "mcq_key", "correct_representation": "categorical_relative_frequency_table"}],
                                  "accepted_variants": []}]}],
        "provenance": {"generator": "course_mode_stats_generator/slot_frames.py",
                       "frame_id": "FB-U1-3-3A-CAT-TABLE-01", "template_id": "slotframe_u1_3_cat_tables",
                       "params": {"scenario_id": c["id"], "categories": categories, "total": total},
                       "seed": seed, "release_status": "unreleased_generated_pending_review",
                       "note": "Authored conceptual frame; correctness from one-categorical-variable table representation rules."},
        "_property_checks": checks,
    }


def generate_u1_3_cat_tables(count: int, base_seed: int = 13000) -> List[Dict]:
    return [gen_u1_3_cat_table_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]

def _sampling_plan_text(method: str, s: Dict[str, object], rng: random.Random) -> str:
    n = rng.choice([30, 40, 50, 60])
    groups = rng.choice([3, 4, 5])
    start = rng.choice([4, 7, 11])
    every = rng.choice([8, 10, 12])
    units = str(s["units"])
    if method == "srs":
        return (f"The researcher uses {s['frame']} and a random number generator to select "
                f"{n} {units} from the entire population.")
    if method == "stratified":
        return (f"The researcher separates the population by {s['strata']}, then uses a random "
                f"number generator to select some {units} from every {s['strata']} group.")
    if method == "cluster":
        return (f"The researcher divides the population into {s['clusters']}, randomly selects "
                f"{groups} {s['clusters']}, and records data from every {s['units'][:-1] if units.endswith('s') else s['units']} "
                f"in the selected {s['clusters']}.")
    if method == "systematic":
        return (f"The researcher chooses a random starting position, {start}, in {s['frame']} "
                f"and then selects that entry and every {every}th entry after it.")
    if method == "convenience":
        return f"The researcher records responses from {units} at {s['location']}."
    if method == "voluntary":
        return f"The researcher uses responses from {units} who choose to answer after seeing {s['voluntary_channel']}."
    raise ValueError(method)


def _sampling_correct_text(method: str, s: Dict[str, object]) -> str:
    if method == "srs":
        return "SRS, because individuals are randomly selected from a list of the whole population."
    if method == "stratified":
        return (f"Stratified random sample, because the population is grouped by {s['strata']} "
                f"and some {s['units']} are randomly selected from every group.")
    if method == "cluster":
        return (f"Cluster sample, because whole {s['clusters']} are randomly selected and every "
                f"{s['units'][:-1] if str(s['units']).endswith('s') else s['units']} in those selected groups is included.")
    if method == "systematic":
        return "Systematic random sample, because a random start is followed by a fixed interval."
    if method == "convenience":
        return "Not a random sample; it is a convenience sample because the units are easy to reach."
    if method == "voluntary":
        return "Not a random sample; it is a voluntary-response sample because units choose whether to respond."
    raise ValueError(method)


def _sampling_distractor_text(tag: str, method: str, s: Dict[str, object]) -> str:
    if tag == "u1_11__stratified_cluster_confusion":
        if method == "cluster":
            return (f"Stratified random sample, because the population is divided into {s['clusters']} "
                    "before the sample is chosen.")
        return (f"Cluster sample, because the population is divided into groups such as {s['strata']} "
                "before the sample is chosen.")
    if tag == "u1_11__convenience_or_voluntary_called_random":
        if method in ("convenience", "voluntary"):
            return "SRS, because any member of the population could have ended up in the response group."
        return "Convenience sample, because the randomly selected units are the ones the researcher contacts."
    if tag == "u1_11__systematic_srs_conflation":
        if method == "systematic":
            return "SRS, because the researcher uses a random starting point from a list."
        return "Systematic random sample, because the researcher uses random selection after organizing the population."
    if tag == "u1_11__stratified_samples_whole_groups":
        if method == "cluster":
            return (f"Stratified random sample, because all {s['units']} in the selected "
                    f"{s['clusters']} are included.")
        return (f"Stratified random sample, because the researcher should randomly choose whole "
                f"{s['strata']} groups and include everyone in them.")
    raise ValueError(tag)


def gen_u1_11_sampling_instance(rng: random.Random, seed: int) -> Dict:
    s = rng.choice(SCN.U1_11_SAMPLING_CONTEXTS)
    method = rng.choice(SAMPLING_METHODS)
    scenario_prov = SCN.framing("slotframe_u1_11_sampling", s.get("domain"))
    plan = _sampling_plan_text(method, s, rng)
    prompt = (f"A researcher wants to study {s['measure']} among {s['population']}. "
              f"Sampling plan: {plan} Which choice best describes the sampling method?")

    options = [{"text": _sampling_correct_text(method, s), "correct": True, "misconception": None}]
    for tag in rng.sample(SAMPLING_DISTRACTOR_TAGS_BY_METHOD[method], 3):
        options.append({"text": _sampling_distractor_text(tag, method, s),
                        "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)

    correct_text = next(o["text"] for o in options if o["correct"])
    checks = [
        ("method_known", method in SAMPLING_METHODS),
        ("four_options", len(options) == 4),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical",
         all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source",
         all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present",
         bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_is_unit_1_11_sampling",
         any("Unit 1 random-sampling methods" in r for r in scenario_prov.get("validity_rules", []))),
        ("nonrandom_methods_marked_nonrandom",
         method not in ("convenience", "voluntary") or correct_text.startswith("Not a random sample")),
        ("stratified_rule_correct",
         method != "stratified" or "every group" in correct_text),
        ("cluster_rule_correct",
         method != "cluster" or "every" in correct_text and "selected groups" in correct_text),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u1_11-2a-{seed:06d}",
        "content_key": f"apstat-u1-11-2a-sampling-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.11"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-2.A", "practice": 2},
        ],
        "cells": [{"topic": "1.11", "skill": "2.A"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{
            "part_key": "part-a", "prompt": prompt,
            "response_modalities": ["mcq"], "points": 1,
            "criteria": [{
                "criterion_key": "part-a-criterion-1", "points": 1,
                "description": "Selects the sampling-method classification that matches the described plan.",
                "required_evidence": f"Correct sampling method: {method}",
                "deterministic_checks": [{"kind": "mcq_key", "correct_method": method}],
                "accepted_variants": [],
            }],
        }],
        "provenance": {
            "generator": "course_mode_stats_generator/slot_frames.py",
            "frame_id": "FB-U1-11-2A-SAMPLING-01",
            "template_id": "slotframe_u1_11_sampling",
            "params": {"scenario_id": s["id"], "method": method},
            "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Authored conceptual frame; correctness from sampling-method taxonomy.",
        },
        "_property_checks": checks,
    }



def gen_u1_2_variables_instance(rng: random.Random, seed: int) -> Dict:
    s = rng.choice(SCN.U1_2_VARIABLE_CONTEXTS)
    scenario_prov = SCN.framing("slotframe_u1_2_variables", s.get("domain"))
    correct = str(s["correct"])
    prompt = (f"In {s['ctx']}, the variable recorded for each {s['unit']} is {s['variable']}. "
              "Which choice best classifies this variable?")
    options = [{"text": f"{correct}, because {s['why']}.", "correct": True, "misconception": None}]
    for text, tag in s["distractors"]:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    checks = [
        ("known_correct_type", correct in VARIABLE_TYPES),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_is_variable_classification", any("variable classification" in r for r in scenario_prov.get("validity_rules", []))),
        ("distractor_tags_subset", all(o.get("misconception") in VARIABLE_TAGS for o in options if not o["correct"])),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u1_2-2a-{seed:06d}",
        "content_key": f"apstat-u1-2-2a-variables-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Easy-Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.2"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-2.A", "practice": 2},
        ],
        "cells": [{"topic": "1.2", "skill": "2.A"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{
            "part_key": "part-a", "prompt": prompt,
            "response_modalities": ["mcq"], "points": 1,
            "criteria": [{
                "criterion_key": "part-a-criterion-1", "points": 1,
                "description": "Selects the variable classification that matches what the recorded values mean.",
                "required_evidence": f"Correct variable type: {correct}",
                "deterministic_checks": [{"kind": "mcq_key", "correct_type": correct}],
                "accepted_variants": [],
            }],
        }],
        "provenance": {
            "generator": "course_mode_stats_generator/slot_frames.py",
            "frame_id": "FB-U1-2-2A-VARIABLES-01",
            "template_id": "slotframe_u1_2_variables",
            "params": {"scenario_id": s["id"], "correct": correct},
            "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Authored conceptual frame; correctness from variable-type taxonomy.",
        },
        "_property_checks": checks,
    }



def _distribution_summary(shape: str, shift: int) -> Dict[str, float]:
    if shape == "right-skewed":
        vals = {"min": 10, "q1": 20, "median": 24, "q3": 34, "max": 52, "mean": 29}
    elif shape == "left-skewed":
        vals = {"min": 22, "q1": 40, "median": 50, "q3": 54, "max": 64, "mean": 45}
    else:
        vals = {"min": 25, "q1": 40, "median": 50, "q3": 60, "max": 75, "mean": 50}
    return {k: float(v + shift) for k, v in vals.items()}


def _reverse_shape(shape: str) -> str:
    if shape == "right-skewed":
        return "left-skewed"
    if shape == "left-skewed":
        return "right-skewed"
    return "right-skewed"


def _distribution_option(shape: str, median: float, iqr: float, outlier_phrase: str) -> str:
    return (f"The distribution is {shape}, centered near the median {median:g}, "
            f"with IQR {iqr:g}, and {outlier_phrase}.")


def gen_u1_6_distribution_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U1_6_DISTRIBUTION_CONTEXTS)
    shape = rng.choice(DISTRIBUTION_SHAPES)
    shift = rng.choice([0, 5, 10, 15])
    vals = _distribution_summary(shape, shift)
    iqr = vals["q3"] - vals["q1"]
    low_fence = vals["q1"] - 1.5 * iqr
    high_fence = vals["q3"] + 1.5 * iqr
    has_outliers = vals["min"] < low_fence or vals["max"] > high_fence
    outlier_phrase = "there are no outliers by the 1.5 x IQR rule"
    prompt = (f"A summary of {c['quantity']} ({c['unit']}) is: min {vals['min']:g}, Q1 {vals['q1']:g}, "
              f"median {vals['median']:g}, Q3 {vals['q3']:g}, max {vals['max']:g}, and mean about {vals['mean']:g}. "
              "Which description is best supported by the summary?")
    correct_text = _distribution_option(shape, vals["median"], iqr, outlier_phrase)
    distractors = [
        (_distribution_option(_reverse_shape(shape), vals["median"], iqr, outlier_phrase),
         "u1_6__skew_direction_reversed"),
        (f"The distribution is {shape}, centered near the IQR {iqr:g}, with spread about the median {vals['median']:g}, and {outlier_phrase}.",
         "u1_6__center_spread_confused"),
        (f"The distribution is {shape}, centered near the median {vals['median']:g}, with IQR {iqr:g}, and the maximum is an outlier because it is far from the minimum.",
         "u1_6__outlier_from_range_not_fences"),
        (f"The median is about {vals['median']:g} {c['unit']} and the IQR is about {iqr:g} {c['unit']}.",
         "u1_6__ignores_shape_reports_center_only"),
    ]
    chosen = rng.sample(distractors, 3)
    options = [{"text": correct_text, "correct": True, "misconception": None}]
    for text, tag in chosen:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u1_6_distribution", c.get("domain"))
    checks = [
        ("known_shape", shape in DISTRIBUTION_SHAPES),
        ("iqr_positive", iqr > 0),
        ("fences_correct", low_fence == vals["q1"] - 1.5 * iqr and high_fence == vals["q3"] + 1.5 * iqr),
        ("no_outliers_by_fences", not has_outliers),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_uses_iqr_fences", any("1.5 x IQR" in r for r in scenario_prov.get("validity_rules", []))),
        ("distractor_tags_subset", all(o.get("misconception") in DISTRIBUTION_TAGS for o in options if not o["correct"])),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u1_6-4a-{seed:06d}",
        "content_key": f"apstat-u1-6-4a-distribution-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.6"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-4.A", "practice": 4},
        ],
        "cells": [{"topic": "1.6", "skill": "4.A"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{
            "part_key": "part-a", "prompt": prompt,
            "response_modalities": ["mcq"], "points": 1,
            "criteria": [{
                "criterion_key": "part-a-criterion-1", "points": 1,
                "description": "Selects the distribution description matching shape, center, spread, and outlier evidence.",
                "required_evidence": f"Correct shape: {shape}; median {vals['median']:g}; IQR {iqr:g}; no outliers by fences",
                "deterministic_checks": [{"kind": "mcq_key", "correct_shape": shape}],
                "accepted_variants": [],
            }],
        }],
        "provenance": {
            "generator": "course_mode_stats_generator/slot_frames.py",
            "frame_id": "FB-U1-6-4A-DISTRIBUTION-01",
            "template_id": "slotframe_u1_6_distribution",
            "params": {"scenario_id": c["id"], "shape": shape, "summary": vals},
            "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Authored conceptual frame; correctness from distribution-summary taxonomy.",
        },
        "_property_checks": checks,
    }



def _hist_counts(values: List[int], width: int) -> List[tuple]:
    start = (min(values) // width) * width
    stop = ((max(values) // width) + 1) * width
    bins = []
    lo = start
    while lo <= stop:
        hi = lo + width - 1
        bins.append((lo, hi, sum(1 for v in values if lo <= v <= hi)))
        lo += width
    return bins


def _pct(count: int, denom: int) -> int:
    return round(count / denom * 100)


def _twoway_table_text(rows: tuple, cols: tuple, counts: tuple) -> str:
    return (f"{rows[0]}: {cols[0]} {counts[0][0]}, {cols[1]} {counts[0][1]}; "
            f"{rows[1]}: {cols[0]} {counts[1][0]}, {cols[1]} {counts[1][1]}")


def gen_u2_1_twoway_interpret_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U2_1_TWOWAY_CONTEXTS)
    rows, cols = c["rows"], c["cols"]
    shift = rng.choice([0, 2, 4, 6])
    counts = tuple(tuple(v + shift for v in row) for row in c["counts"])
    focus_idx = cols.index(c["focus_col"])
    row_totals = [sum(row) for row in counts]
    col_total = counts[0][focus_idx] + counts[1][focus_idx]
    grand_total = sum(row_totals)
    row_pcts = [_pct(counts[i][focus_idx], row_totals[i]) for i in range(2)]
    col_pcts = [_pct(counts[i][focus_idx], col_total) for i in range(2)]
    marginal_pct = _pct(col_total, grand_total)
    higher = rows[0] if row_pcts[0] > row_pcts[1] else rows[1]
    lower = rows[1] if higher == rows[0] else rows[0]
    higher_pct = max(row_pcts)
    lower_pct = min(row_pcts)
    raw_higher = rows[0] if counts[0][focus_idx] > counts[1][focus_idx] else rows[1]
    raw_lower = rows[1] if raw_higher == rows[0] else rows[0]
    correct_text = (f"About {higher_pct}% of {higher} are in the '{c['focus_col']}' category, "
                    f"compared with about {lower_pct}% of {lower}, so {higher} have the larger conditional percentage.")
    prompt = (f"The two-way table summarizes {c['row_variable']} and whether each case is classified as {c['col_variable']}. "
              f"Counts are {_twoway_table_text(rows, cols, counts)}. "
              f"Which statement correctly interprets the conditional distribution of '{c['focus_col']}' by {c['row_variable']}?")
    distractors = [
        (f"Because the count {counts[0][focus_idx] if raw_higher == rows[0] else counts[1][focus_idx]} is larger than "
         f"{counts[1][focus_idx] if raw_higher == rows[0] else counts[0][focus_idx]}, {raw_higher} have the larger conditional percentage than {raw_lower}.",
         "u2_1__raw_counts_as_conditional_comparison"),
        (f"Among cases in the '{c['focus_col']}' category, about {col_pcts[0]}% are {rows[0]} and {col_pcts[1]}% are {rows[1]}, "
         f"so those are the conditional percentages within the two {c['row_variable']} groups.",
         "u2_1__used_column_denominator_for_row_condition"),
        (f"Overall, about {marginal_pct}% of all cases are in the '{c['focus_col']}' category, so each {c['row_variable']} group has about {marginal_pct}% in that category.",
         "u2_1__marginal_percent_treated_as_conditional"),
    ]
    options = [{"text": correct_text, "correct": True, "misconception": None}]
    for text, tag in distractors:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u2_1_twoway_interpret", c.get("domain"))
    checks = [
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("twoway_tags_used", {o.get("misconception") for o in options if o.get("misconception")} == TWOWAY_INTERPRET_TAGS),
        ("raw_count_misleads", raw_higher != higher),
        ("conditional_percentages_distinct", row_pcts[0] != row_pcts[1]),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u2_1-4a-{seed:06d}",
        "content_key": f"apstat-u2-1-4a-twoway_interpret-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-2"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-2.1"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-4.A", "practice": 4},
        ],
        "cells": [{"topic": "2.1", "skill": "4.A"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                   "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                  "description": "Selects the row-conditional interpretation that uses each row total as the denominator.",
                                  "required_evidence": correct_text,
                                  "deterministic_checks": [{"kind": "mcq_key", "correct_representation": "row_conditional_comparison"}],
                                  "accepted_variants": []}]}],
        "provenance": {"generator": "course_mode_stats_generator/slot_frames.py",
                       "frame_id": "FB-U2-1-4A-TWOWAY-01", "template_id": "slotframe_u2_1_twoway_interpret",
                       "params": {"scenario_id": c["id"], "rows": rows, "cols": cols, "counts": counts,
                                  "focus_col": c["focus_col"], "row_totals": row_totals,
                                  "row_percentages": row_pcts, "column_percentages": col_pcts,
                                  "marginal_percentage": marginal_pct},
                       "seed": seed, "release_status": "unreleased_generated_pending_review",
                       "note": "Authored conceptual frame; correctness from two-way table conditional-distribution interpretation."},
        "_property_checks": checks,
    }


def generate_u2_1_twoway_interpret(count: int, base_seed: int = 21000) -> List[Dict]:
    return [gen_u2_1_twoway_interpret_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def _percentages(categories: List[tuple]) -> List[tuple]:
    total = sum(count for _, count in categories)
    return [(name, round(count / total * 100)) for name, count in categories]


def _bar_pct_text(pcts: List[tuple]) -> str:
    return "; ".join(f"{name}: {pct}%" for name, pct in pcts)


def gen_u1_4_cat_graph_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U1_4_CAT_GRAPH_CONTEXTS)
    shift = rng.choice([0, 2, 4, 6])
    categories = [(name, count + shift) for name, count in c["categories"]]
    total = sum(count for _, count in categories)
    pcts = _percentages(categories)
    largest = max(count for _, count in categories)
    wrong_denominator = [(name, round(count / largest * 100)) for name, count in categories]
    coded_points = ", ".join(f"{i + 1}={name}" for i, (name, _) in enumerate(categories))
    count_as_pct = [(name, count) for name, count in categories]
    correct_text = "Relative-frequency bar graph with separate category bars: " + _bar_pct_text(pcts)
    prompt = (f"A group of {total} {c['population']} was classified by {c['variable']}. "
              f"The category counts are " + "; ".join(f"{name}: {count}" for name, count in categories) +
              ". Which description correctly represents the relative-frequency bar graph for this categorical variable?")
    distractors = [
        ("Relative-frequency bar graph with bar heights copied from the counts: " + _bar_pct_text(count_as_pct),
         "u1_4__count_percent_graph_confusion"),
        ("Relative-frequency bar graph using the largest category as the denominator: " + _bar_pct_text(wrong_denominator),
         "u1_4__relative_frequency_graph_denominator_error"),
        (f"Line graph on a number line after coding the categories as {coded_points}, with points connected in code order",
         "u1_4__categorical_graph_as_quantitative_axis"),
    ]
    options = [{"text": correct_text, "correct": True, "misconception": None}]
    for text, tag in distractors:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u1_4_cat_graphs", c.get("domain"))
    checks = [
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("cat_graph_tags_used", {o.get("misconception") for o in options if o.get("misconception")} == CAT_GRAPH_TAGS),
        ("correct_percentages_sum_near_100", 98 <= sum(pct for _, pct in pcts) <= 102),
        ("denominator_is_total", total > largest),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u1_4-3a-{seed:06d}",
        "content_key": f"apstat-u1-4-3a-cat_graph-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Easy-Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.4"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-3.A", "practice": 3},
        ],
        "cells": [{"topic": "1.4", "skill": "3.A"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                   "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                  "description": "Selects the relative-frequency bar graph description that divides each category count by the total.",
                                  "required_evidence": correct_text,
                                  "deterministic_checks": [{"kind": "mcq_key", "correct_representation": "relative_frequency_bar_graph"}],
                                  "accepted_variants": []}]}],
        "provenance": {"generator": "course_mode_stats_generator/slot_frames.py",
                       "frame_id": "FB-U1-4-3A-CAT-GRAPH-01", "template_id": "slotframe_u1_4_cat_graphs",
                       "params": {"scenario_id": c["id"], "categories": categories, "total": total, "percentages": pcts},
                       "seed": seed, "release_status": "unreleased_generated_pending_review",
                       "note": "Authored conceptual frame; correctness from categorical graph representation taxonomy."},
        "_property_checks": checks,
    }


def generate_u1_4_cat_graphs(count: int, base_seed: int = 14000) -> List[Dict]:
    return [gen_u1_4_cat_graph_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def _hist_text(bins: List[tuple], unit: str) -> str:
    return "; ".join(f"{lo}-{hi} {unit}: {count}" for lo, hi, count in bins)


def _stemplot_text(values: List[int]) -> str:
    stems = {}
    for value in values:
        stems.setdefault(value // 10, []).append(value % 10)
    return "; ".join(f"{stem} | {' '.join(str(leaf) for leaf in leaves)}" for stem, leaves in sorted(stems.items()))


def gen_u1_5_graph_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U1_5_GRAPH_CONTEXTS)
    values = [v + rng.choice([0, 1, 2, 3]) for v in c["values"]]
    width = rng.choice([5, 10])
    bins = _hist_counts(values, width)
    correct_text = "Histogram with counts " + _hist_text(bins, c["unit"])
    wrong_bins = list(bins)
    idx = rng.randrange(len(wrong_bins) - 1)
    lo, hi, count = wrong_bins[idx]
    lo2, hi2, count2 = wrong_bins[idx + 1]
    if count > 0:
        wrong_bins[idx] = (lo, hi, count - 1)
        wrong_bins[idx + 1] = (lo2, hi2, count2 + 1)
    else:
        wrong_bins[idx] = (lo, hi, count + 1)
        wrong_bins[idx + 1] = (lo2, hi2, max(0, count2 - 1))
    prompt = (f"The {c['quantity']} ({c['unit']}) are {', '.join(str(v) for v in values)}. "
              "Which representation correctly displays these quantitative data?")
    distractors = [
        ("Histogram with counts " + _hist_text(wrong_bins, c["unit"]), "u1_5__miscounted_bin_frequency"),
        ("Stemplot " + _stemplot_text([v * 10 for v in values]), "u1_5__stem_leaf_place_value_error"),
        (f"Bar chart with one bar for each named category of {c['quantity']}, rather than a numeric axis", "u1_5__wrong_plot_type_for_data"),
    ]
    options = [{"text": correct_text, "correct": True, "misconception": None}]
    for text, tag in distractors:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u1_5_graphs", c.get("domain"))
    checks = [
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("graph_tags_used", {o.get("misconception") for o in options if o.get("misconception")} == GRAPH_TAGS),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u1_5-3a-{seed:06d}",
        "content_key": f"apstat-u1-5-3a-graphs-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.5"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-3.A", "practice": 3},
        ],
        "cells": [{"topic": "1.5", "skill": "3.A"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                   "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                  "description": "Selects the graph description that preserves the quantitative values and frequencies.",
                                  "required_evidence": correct_text,
                                  "deterministic_checks": [{"kind": "mcq_key", "correct_representation": "histogram_counts"}],
                                  "accepted_variants": []}]}],
        "provenance": {"generator": "course_mode_stats_generator/slot_frames.py",
                       "frame_id": "FB-U1-5-3A-GRAPH-01", "template_id": "slotframe_u1_5_graphs",
                       "params": {"scenario_id": c["id"], "values": values, "bin_width": width, "bins": bins},
                       "seed": seed, "release_status": "unreleased_generated_pending_review",
                       "note": "Authored conceptual frame; correctness from quantitative graph representation taxonomy."},
        "_property_checks": checks,
    }


def generate_u1_5_graphs(count: int, base_seed: int = 15000) -> List[Dict]:
    return [gen_u1_5_graph_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def _shift_summary(summary: Dict[str, int], shift: int) -> Dict[str, int]:
    return {k: v + shift for k, v in summary.items()}


def _boxplot_text(summ: Dict[str, int], unit: str, box_lo: int, line_at: int, box_hi: int,
                  low_whisker: int, high_whisker: int, outlier_text: str) -> str:
    return (f"Box from {box_lo:g} to {box_hi:g} {unit}, median line at {line_at:g}, "
            f"whiskers to {low_whisker:g} and {high_whisker:g}, {outlier_text}.")


def gen_u1_8_boxplot_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U1_8_BOXPLOT_CONTEXTS)
    shift = rng.choice([0, 2, 4, 6])
    summ = _shift_summary(c["summary"], shift)
    iqr = summ["q3"] - summ["q1"]
    low_fence = summ["q1"] - 1.5 * iqr
    high_fence = summ["q3"] + 1.5 * iqr
    outliers = []
    if summ["min"] < low_fence:
        outliers.append(summ["min"])
    if summ["max"] > high_fence:
        outliers.append(summ["max"])
    outlier_text = "with no plotted outliers" if not outliers else "with plotted outlier(s) at " + ", ".join(f"{v:g}" for v in outliers)
    correct_text = _boxplot_text(summ, c["unit"], summ["q1"], summ["median"], summ["q3"],
                                 summ["low_whisker"], summ["high_whisker"], outlier_text)
    prompt = (f"For {c['quantity']} ({c['unit']}), a summary is min {summ['min']:g}, Q1 {summ['q1']:g}, "
              f"median {summ['median']:g}, Q3 {summ['q3']:g}, max {summ['max']:g}. "
              f"Using the 1.5 x IQR rule, the non-outlier whisker endpoints are {summ['low_whisker']:g} and {summ['high_whisker']:g}. "
              "Which modified boxplot description matches this summary?")
    distractors = [
        (_boxplot_text(summ, c["unit"], summ["median"], summ["q1"], summ["q3"], summ["low_whisker"], summ["high_whisker"], outlier_text), "u1_8__quartile_median_positions_swapped"),
        (_boxplot_text(summ, c["unit"], summ["q1"], summ["median"], summ["q3"], summ["min"], summ["max"], "with no plotted outliers"), "u1_8__whisker_to_extreme_ignores_outlier"),
        (_boxplot_text(summ, c["unit"], summ["min"], summ["median"], summ["max"], summ["min"], summ["max"], outlier_text), "u1_8__box_spans_range_not_iqr"),
    ]
    options = [{"text": correct_text, "correct": True, "misconception": None}]
    for text, tag in distractors:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u1_8_boxplots", c.get("domain"))
    checks = [("iqr_positive", iqr > 0),
              ("whiskers_inside_fences", summ["low_whisker"] >= low_fence and summ["high_whisker"] <= high_fence),
              ("endpoint_outlier_present", bool(outliers)),
              ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
              ("four_options", len(options) == 4),
              ("option_texts_unique", len({o["text"] for o in options}) == 4),
              ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
              ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
              ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
              ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
              ("boxplot_tags_used", {o.get("misconception") for o in options if o.get("misconception")} == BOXPLOT_TAGS)]
    return {"schema_version": "course-mode-generated-0.1", "package_id": f"slotframe-u1_8-3a-{seed:06d}",
            "content_key": f"apstat-u1-8-3a-boxplots-{seed:06d}", "item_type": "mcq", "difficulty": "Medium",
            "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
            "taxonomy_refs": [{"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
                              {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.8"},
                              {"scheme_key": "ap-statistics-skills", "node_key": "skill-3.A", "practice": 3}],
            "cells": [{"topic": "1.8", "skill": "3.A"}], "scenario_provenance": scenario_prov,
            "prompt": prompt, "mcq_form": {"options": options},
            "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                       "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                      "description": "Selects the modified boxplot description matching quartiles, whiskers, and outliers.",
                                      "required_evidence": correct_text,
                                      "deterministic_checks": [{"kind": "mcq_key", "correct_representation": "modified_boxplot"}],
                                      "accepted_variants": []}]}],
            "provenance": {"generator": "course_mode_stats_generator/slot_frames.py", "frame_id": "FB-U1-8-3A-BOXPLOT-01",
                           "template_id": "slotframe_u1_8_boxplots", "params": {"scenario_id": c["id"], "summary": summ, "iqr": iqr, "fences": [low_fence, high_fence]},
                           "seed": seed, "release_status": "unreleased_generated_pending_review",
                           "note": "Authored conceptual frame; correctness from modified-boxplot summary rules."},
            "_property_checks": checks}


def generate_u1_8_boxplots(count: int, base_seed: int = 18000) -> List[Dict]:
    return [gen_u1_8_boxplot_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def _u2_5_correct_text(c: Dict[str, object]) -> str:
    if c["relationship"] == "mutually_exclusive":
        return f"The events are mutually exclusive, because {c['correct_reason']}."
    return (f"The events are not mutually exclusive, because {c['shared_outcome']} is an outcome "
            "that satisfies both event definitions.")


def _u2_5_distractor_text(tag: str, c: Dict[str, object]) -> str:
    event_a = str(c["event_a"])
    event_b = str(c["event_b"])
    if tag == "u2_5__uses_independent_for_disjoint":
        if c["relationship"] == "mutually_exclusive":
            return "The events are independent, because if Event A occurs, then Event B cannot also occur."
        return ("The events are independent, because the two event definitions describe different "
                "features of the selected outcome.")
    if tag == "u2_5__overlap_wording_ignored":
        if c["relationship"] == "overlap":
            return ("The events are mutually exclusive, because the two event names are stated separately "
                    "in the problem.")
        return ("The events are not mutually exclusive, because both are possible somewhere in the sample space.")
    if tag == "u2_5__different_labels_mean_disjoint":
        return ("The events are mutually exclusive, because the two descriptions use different labels "
                "for the selected outcome.")
    if tag == "u2_5__same_trial_condition_missed":
        return ("The events are not mutually exclusive, because over many repetitions of the chance process "
                "one event could occur on one trial and the other could occur on another trial.")
    raise ValueError(tag)


def gen_u2_5_mutually_exclusive_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U2_5_MUTUALLY_EXCLUSIVE_CONTEXTS)
    scenario_prov = SCN.framing("slotframe_u2_5_mutually_exclusive", c.get("domain"))
    relationship = str(c["relationship"])
    prompt = (f"For {c['trial']}, let Event A be that {c['event_a']} and Event B be that "
              f"{c['event_b']}. Which statement best justifies whether Events A and B are "
              "mutually exclusive?")

    if relationship == "mutually_exclusive":
        tag_pool = [
            "u2_5__uses_independent_for_disjoint",
            "u2_5__different_labels_mean_disjoint",
            "u2_5__same_trial_condition_missed",
        ]
    elif relationship == "overlap":
        tag_pool = [
            "u2_5__overlap_wording_ignored",
            "u2_5__different_labels_mean_disjoint",
            "u2_5__same_trial_condition_missed",
        ]
    else:
        raise ValueError(f"unknown Unit 2.5 relationship {relationship!r}")

    options = [{"text": _u2_5_correct_text(c), "correct": True, "misconception": None}]
    for tag in rng.sample(tag_pool, 3):
        options.append({"text": _u2_5_distractor_text(tag, c), "correct": False,
                        "misconception": tag, "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)

    correct_text = next(o["text"] for o in options if o["correct"])
    checks = [
        ("known_relationship", relationship in {"mutually_exclusive", "overlap"}),
        ("same_trial_in_prompt", str(c["trial"]).startswith("one ")),
        ("overlap_has_shared_outcome", relationship != "overlap" or bool(c.get("shared_outcome"))),
        ("disjoint_has_no_shared_outcome", relationship != "mutually_exclusive" or c.get("shared_outcome") is None),
        ("correct_text_matches_relationship",
         (relationship == "mutually_exclusive" and correct_text.startswith("The events are mutually exclusive"))
         or (relationship == "overlap" and correct_text.startswith("The events are not mutually exclusive"))),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_is_unit_2_5_mutual_exclusivity",
         any("mutually exclusive" in r for r in scenario_prov.get("validity_rules", []))),
        ("distractor_tags_subset", all(o.get("misconception") in MUTUALLY_EXCLUSIVE_TAGS for o in options if not o["correct"])),
        ("context_id_namespaced", str(c.get("id", "")).startswith("u2_5__")),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u2_5-4b-{seed:06d}",
        "content_key": f"apstat-u2-5-4b-mutually-exclusive-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-2"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-2.5"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-4.B", "practice": 4},
        ],
        "cells": [{"topic": "2.5", "skill": "4.B"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{
            "part_key": "part-a", "prompt": prompt,
            "response_modalities": ["mcq"], "points": 1,
            "criteria": [{
                "criterion_key": "part-a-criterion-1", "points": 1,
                "description": "Selects the justification that correctly identifies whether the two events can occur on the same trial.",
                "required_evidence": _u2_5_correct_text(c),
                "deterministic_checks": [{"kind": "mcq_key", "correct_relationship": relationship}],
                "accepted_variants": [],
            }],
        }],
        "provenance": {
            "generator": "course_mode_stats_generator/slot_frames.py",
            "frame_id": "FB-U2-5-4B-MUTUALLY-EXCLUSIVE-01",
            "template_id": "slotframe_u2_5_mutually_exclusive",
            "params": {"scenario_id": c["id"], "relationship": relationship},
            "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Authored conceptual frame; correctness from same-trial mutually-exclusive-event taxonomy.",
        },
        "_property_checks": checks,
    }


def gen_u1_12_bias_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U1_12_BIAS_CONTEXTS)
    prompt = f"{c['stem']} Which statement best identifies the bias, if any?"
    options = [{"text": c["correct"], "correct": True, "misconception": None}]
    for text, tag in c["distractors"]:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u1_12_bias", c.get("domain"))
    checks = [("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
              ("four_options", len(options) == 4),
              ("option_texts_unique", len({o["text"] for o in options}) == 4),
              ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
              ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
              ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
              ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
              ("bias_tags_subset", all(o.get("misconception") in BIAS_TAGS for o in options if not o["correct"]))]
    return {"schema_version": "course-mode-generated-0.1", "package_id": f"slotframe-u1_12-2a-{seed:06d}",
            "content_key": f"apstat-u1-12-2a-bias-{seed:06d}", "item_type": "mcq", "difficulty": "Medium",
            "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
            "taxonomy_refs": [{"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
                              {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.12"},
                              {"scheme_key": "ap-statistics-skills", "node_key": "skill-2.A", "practice": 2}],
            "cells": [{"topic": "1.12", "skill": "2.A"}], "scenario_provenance": scenario_prov,
            "prompt": prompt, "mcq_form": {"options": options},
            "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                       "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                      "description": "Selects the bias classification supported by the data-collection scenario.",
                                      "required_evidence": c["correct"],
                                      "deterministic_checks": [{"kind": "mcq_key", "correct_bias_statement": c["correct"]}],
                                      "accepted_variants": []}]}],
            "provenance": {"generator": "course_mode_stats_generator/slot_frames.py", "frame_id": "FB-U1-12-2A-BIAS-01",
                           "template_id": "slotframe_u1_12_bias", "params": {"scenario_id": c["id"]},
                           "seed": seed, "release_status": "unreleased_generated_pending_review",
                           "note": "Authored conceptual frame; correctness from sampling-bias taxonomy."},
            "_property_checks": checks}


def generate_u1_12_bias(count: int, base_seed: int = 11200) -> List[Dict]:
    return [gen_u1_12_bias_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def gen_u1_13_design_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U1_13_DESIGN_CONTEXTS)
    prompt = f"{c['stem']} Which statement best identifies the design element or flaw?"
    options = [{"text": c["correct"], "correct": True, "misconception": None}]
    for text, tag in c["distractors"]:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    scenario_prov = SCN.framing("slotframe_u1_13_design", c.get("domain"))
    checks = [("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
              ("four_options", len(options) == 4),
              ("option_texts_unique", len({o["text"] for o in options}) == 4),
              ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
              ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
              ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
              ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
              ("design_tags_subset", all(o.get("misconception") in DESIGN_TAGS for o in options if not o["correct"]))]
    return {"schema_version": "course-mode-generated-0.1", "package_id": f"slotframe-u1_13-2a-{seed:06d}",
            "content_key": f"apstat-u1-13-2a-design-{seed:06d}", "item_type": "mcq", "difficulty": "Medium",
            "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
            "taxonomy_refs": [{"scheme_key": "ap-statistics-2026-27", "node_key": "unit-1"},
                              {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-1.13"},
                              {"scheme_key": "ap-statistics-skills", "node_key": "skill-2.A", "practice": 2}],
            "cells": [{"topic": "1.13", "skill": "2.A"}], "scenario_provenance": scenario_prov,
            "prompt": prompt, "mcq_form": {"options": options},
            "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                       "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                      "description": "Selects the study-design statement supported by the scenario.",
                                      "required_evidence": c["correct"],
                                      "deterministic_checks": [{"kind": "mcq_key", "correct_design_statement": c["correct"]}],
                                      "accepted_variants": []}]}],
            "provenance": {"generator": "course_mode_stats_generator/slot_frames.py", "frame_id": "FB-U1-13-2A-DESIGN-01",
                           "template_id": "slotframe_u1_13_design", "params": {"scenario_id": c["id"]},
                           "seed": seed, "release_status": "unreleased_generated_pending_review",
                           "note": "Authored conceptual frame; correctness from study-design taxonomy."},
            "_property_checks": checks}


def generate_u1_13_design(count: int, base_seed: int = 11300) -> List[Dict]:
    return [gen_u1_13_design_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def _pvalue_tail_phrase(ctx: Dict[str, object]) -> str:
    if ctx["alternative"] == "greater":
        return f"at least as large as the one in the sample ({ctx['stat_phrase']})"
    return f"at least as small as the one in the sample ({ctx['stat_phrase']})"


def _pvalue_correct_text(ctx: Dict[str, object], p_value: float) -> str:
    return (f"If {ctx['parameter']} really is {ctx['null_value']:.2f}, then there is about a "
            f"{p_value:.1%} chance of getting a sample result {_pvalue_tail_phrase(ctx)} by random sampling alone.")


def _pvalue_wrong_direction_text(ctx: Dict[str, object], p_value: float) -> str:
    opposite = "this small or smaller" if ctx["alternative"] == "greater" else "this large or larger"
    return (f"If {ctx['parameter']} really is {ctx['null_value']:.2f}, then there is about a "
            f"{p_value:.1%} chance of getting a sample proportion {opposite} by random sampling alone.")


def _pvalue_distractor_text(tag: str, ctx: Dict[str, object], p_value: float) -> str:
    if tag == "u3_6__p_value_probability_null_true":
        return f"There is about a {p_value:.1%} chance that the null hypothesis is true."
    if tag == "u3_6__p_value_probability_sample_due_to_chance":
        return f"There is about a {p_value:.1%} chance that the sample result happened by chance."
    if tag == "u3_6__p_value_probability_alternative_true":
        return f"There is about a {p_value:.1%} chance that the alternative hypothesis is true."
    if tag == "u3_6__p_value_reverses_extreme_direction":
        return _pvalue_wrong_direction_text(ctx, p_value)
    raise ValueError(tag)


def gen_u3_6_pvalue_instance(rng: random.Random, seed: int) -> Dict:
    ctx = rng.choice(SCN.U3_6_PVALUE_CONTEXTS)
    p_value = rng.choice([0.008, 0.014, 0.027, 0.041, 0.063, 0.118, 0.184])
    scenario_prov = SCN.framing("slotframe_u3_6_pvalue_interpret", ctx.get("domain"))
    alt_symbol = ">" if ctx["alternative"] == "greater" else "<"
    prompt = (f"A significance test is performed using {ctx['source']} to test H0: p = {ctx['null_value']:.2f} "
              f"against Ha: p {alt_symbol} {ctx['null_value']:.2f}, where p is {ctx['parameter']}. "
              f"The sample result was {ctx['observed']}, and the p-value is {p_value:.3f}. "
              "Which statement correctly interprets the p-value in context?")
    options = [{"text": _pvalue_correct_text(ctx, p_value), "correct": True, "misconception": None}]
    for tag in rng.sample(sorted(PVALUE_TAGS), 3):
        options.append({"text": _pvalue_distractor_text(tag, ctx, p_value),
                        "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    correct_text = next(o["text"] for o in options if o["correct"])
    checks = [
        ("p_value_in_unit_interval", 0 < p_value < 1),
        ("alternative_known", ctx["alternative"] in ("greater", "less")),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_is_pvalue_interpretation", any("conditional on H0" in r for r in scenario_prov.get("validity_rules", []))),
        ("correct_mentions_null_condition", "really is" in correct_text and f"{ctx['null_value']:.2f}" in correct_text),
        ("correct_mentions_tail_event", "at least as" in correct_text),
        ("pvalue_tags_subset", all(o.get("misconception") in PVALUE_TAGS for o in options if not o["correct"])),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u3_6-4f-{seed:06d}",
        "content_key": f"apstat-u3-6-4f-pvalue-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-3"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-3.6"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-4.F", "practice": 4},
        ],
        "cells": [{"topic": "3.6", "skill": "4.F"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{
            "part_key": "part-a", "prompt": prompt,
            "response_modalities": ["mcq"], "points": 1,
            "criteria": [{
                "criterion_key": "part-a-criterion-1", "points": 1,
                "description": "Selects the interpretation of a p-value as a conditional tail probability under H0 in context.",
                "required_evidence": "Correctly conditions on H0 and refers to a result as extreme as or more extreme than the observed result.",
                "deterministic_checks": [{"kind": "mcq_key", "correct_type": "p_value_conditional_tail_probability"}],
                "accepted_variants": [],
            }],
        }],
        "provenance": {
            "generator": "course_mode_stats_generator/slot_frames.py",
            "frame_id": "FB-U3-6-4F-PVALUE-01",
            "template_id": "slotframe_u3_6_pvalue_interpret",
            "params": {"scenario_id": ctx["id"], "p_value": p_value, "alternative": ctx["alternative"]},
            "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Authored conceptual frame; correctness from p-value interpretation taxonomy.",
        },
        "_property_checks": checks,
    }



def _pct_fmt(value: float) -> str:
    return f"{value * 100:.0f}%"


def _prop_ci_claim_case(rng: random.Random) -> Dict[str, object]:
    claim_type = rng.choice(["greater", "less", "different"])
    support = rng.choice([True, False])
    threshold = rng.choice([0.25, 0.30, 0.40, 0.50, 0.60, 0.70])
    width = rng.choice([0.08, 0.10, 0.12])
    gap = rng.choice([0.03, 0.05, 0.07])
    if claim_type == "greater":
        if support:
            low = threshold + gap
            high = low + width
        else:
            low = threshold - width / 2
            high = threshold + width / 2
        claim = f"more than {_pct_fmt(threshold)}"
        reason_support = f"the entire interval is above {_pct_fmt(threshold)}"
        reason_no_support = f"the interval includes values at or below {_pct_fmt(threshold)}"
    elif claim_type == "less":
        if support:
            high = threshold - gap
            low = high - width
        else:
            low = threshold - width / 2
            high = threshold + width / 2
        claim = f"less than {_pct_fmt(threshold)}"
        reason_support = f"the entire interval is below {_pct_fmt(threshold)}"
        reason_no_support = f"the interval includes values at or above {_pct_fmt(threshold)}"
    else:
        if support:
            direction = rng.choice(["above", "below"])
            if direction == "above":
                low = threshold + gap
                high = low + width
            else:
                high = threshold - gap
                low = high - width
        else:
            low = threshold - width / 2
            high = threshold + width / 2
        claim = f"different from {_pct_fmt(threshold)}"
        reason_support = f"{_pct_fmt(threshold)} is not in the interval of plausible values"
        reason_no_support = f"{_pct_fmt(threshold)} is in the interval of plausible values"
    low = round(max(0.03, low), 2)
    high = round(min(0.97, high), 2)
    center = round((low + high) / 2, 2)
    return {"claim_type": claim_type, "support": support, "threshold": threshold,
            "low": low, "high": high, "center": center, "claim": claim,
            "reason_support": reason_support, "reason_no_support": reason_no_support}


def _prop_ci_correct_text(case: Dict[str, object], c: Dict[str, str]) -> str:
    if case["support"]:
        return (f"The interval supports the claim that {c['parameter']} is {case['claim']}, because "
                f"{case['reason_support']}. The conclusion should still be stated as inference from the sample, not as proof.")
    return (f"The interval does not support the claim that {c['parameter']} is {case['claim']}, because "
            f"{case['reason_no_support']}. Values consistent with the interval make the claim too strong for these results.")


def _prop_ci_distractor_text(tag: str, case: Dict[str, object], c: Dict[str, str], confidence: int) -> str:
    if tag == "u3_4__endpoint_inclusion_reversed":
        if case["support"]:
            return (f"The interval does not support the claim, because the claimed cutoff {_pct_fmt(case['threshold'])} "
                    "is not one of the endpoints of the interval.")
        return (f"The interval supports the claim, because the cutoff {_pct_fmt(case['threshold'])} lies inside the interval "
                "and is therefore a plausible value.")
    if tag == "u3_4__confidence_level_as_probability_claim":
        return (f"There is a {confidence}% probability that {c['parameter']} is between {_pct_fmt(case['low'])} and "
                f"{_pct_fmt(case['high'])}, so the claim is automatically supported.")
    if tag == "u3_4__sample_statistic_as_population_claim":
        return (f"The sample proportion is about {_pct_fmt(case['center'])}, so {c['parameter']} equals about "
                f"{_pct_fmt(case['center'])}; the claim should be judged from that sample value alone.")
    if tag == "u3_4__overstated_certainty_from_interval":
        if case["support"]:
            return (f"The interval proves that {c['parameter']} is {case['claim']}, so the claim is guaranteed true.")
        return (f"The interval proves that {c['parameter']} is not {case['claim']}, so the claim is impossible.")
    raise ValueError(tag)


def gen_u3_4_prop_ci_claim_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U3_4_PROP_CI_CLAIM_CONTEXTS)
    scenario_prov = SCN.framing("slotframe_u3_4_prop_ci_claim", c.get("domain"))
    confidence = rng.choice([90, 95, 99])
    case = _prop_ci_claim_case(rng)
    prompt = (f"In {c['source']}, a random sample was used to estimate {c['parameter']}. "
              f"The resulting {confidence}% confidence interval is ({_pct_fmt(case['low'])}, {_pct_fmt(case['high'])}). "
              f"A student claims that {c['parameter']} is {case['claim']}. Which interpretation is best supported by the interval?")
    options = [{"text": _prop_ci_correct_text(case, c), "correct": True, "misconception": None}]
    for tag in rng.sample(sorted(PROP_CI_CLAIM_TAGS), 3):
        options.append({"text": _prop_ci_distractor_text(tag, case, c, confidence),
                        "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)
    checks = [
        ("interval_ordered", 0 < case["low"] < case["high"] < 1),
        ("threshold_in_unit_interval", 0 < case["threshold"] < 1),
        ("support_rule_consistent",
         (case["claim_type"] == "greater" and case["support"] == (case["low"] > case["threshold"])) or
         (case["claim_type"] == "less" and case["support"] == (case["high"] < case["threshold"])) or
         (case["claim_type"] == "different" and case["support"] == (not (case["low"] <= case["threshold"] <= case["high"])))),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("scenario_is_prop_ci_claim", any("one-population proportion confidence interval" in r for r in scenario_prov.get("validity_rules", []))),
        ("prop_ci_claim_tags_subset", all(o.get("misconception") in PROP_CI_CLAIM_TAGS for o in options if not o["correct"])),
    ]
    return {
        "schema_version": "course-mode-generated-0.1",
        "package_id": f"slotframe-u3_4-4f-{seed:06d}",
        "content_key": f"apstat-u3-4-4f-prop-ci-claim-{seed:06d}",
        "item_type": "mcq",
        "difficulty": "Medium",
        "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
        "taxonomy_refs": [
            {"scheme_key": "ap-statistics-2026-27", "node_key": "unit-3"},
            {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-3.4"},
            {"scheme_key": "ap-statistics-skills", "node_key": "skill-4.F", "practice": 4},
        ],
        "cells": [{"topic": "3.4", "skill": "4.F"}],
        "scenario_provenance": scenario_prov,
        "prompt": prompt,
        "mcq_form": {"options": options},
        "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                   "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                  "description": "Selects the CI interpretation that correctly judges claim support for a population proportion.",
                                  "required_evidence": _prop_ci_correct_text(case, c),
                                  "deterministic_checks": [{"kind": "mcq_key", "correct_claim_support": case["support"],
                                                            "claim_type": case["claim_type"]}],
                                  "accepted_variants": []}]}],
        "provenance": {"generator": "course_mode_stats_generator/slot_frames.py",
                       "frame_id": "FB-U3-4-4F-PROP-CI-CLAIM-01",
                       "template_id": "slotframe_u3_4_prop_ci_claim",
                       "params": {"scenario_id": c["id"], "confidence": confidence, **case},
                       "seed": seed, "release_status": "unreleased_generated_pending_review",
                       "note": "Authored conceptual frame; correctness from confidence-interval claim-support rules."},
        "_property_checks": checks,
    }


def generate_u3_4_prop_ci_claim(count: int, base_seed: int = 30400) -> List[Dict]:
    return [gen_u3_4_prop_ci_claim_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]

def _prob_table_text(rv: str, values: List[int], probs: List[float], label: str = "P") -> str:
    entries = "; ".join(f"{rv}={v}: {p:.2f}" for v, p in zip(values, probs))
    return f"{label} table: {entries}"


def _adjusted_sum_probs(probs: List[float]) -> List[float]:
    adjusted = list(probs)
    adjusted[-1] = round(max(0.01, adjusted[-1] + 0.08), 2)
    return adjusted


def _negative_probs(probs: List[float]) -> List[float]:
    adjusted = list(probs)
    adjusted[0] = round(adjusted[0] + adjusted[-1] + 0.04, 2)
    adjusted[-1] = -0.04
    return adjusted


def _cumulative_probs(probs: List[float]) -> List[float]:
    running = 0.0
    cumulative = []
    for p in probs:
        running += p
        cumulative.append(round(running, 2))
    return cumulative


def gen_u2_8_random_variable_distribution_instance(rng: random.Random, seed: int) -> Dict:
    c = rng.choice(SCN.U2_8_RANDOM_VARIABLE_CONTEXTS)
    values = list(c["values"])
    probs = [float(p) for p in c["probs"]]
    rv = str(c["rv"])
    scenario_prov = SCN.framing("slotframe_u2_8_random_variable_distributions", c.get("domain"))

    prompt = (f"A random variable {rv} is defined as {c['quantity']}. "
              "Which table is a valid probability distribution for this random variable?")
    correct_text = _prob_table_text(rv, values, probs, "Probability")
    distractors = [
        (_prob_table_text(rv, values, _adjusted_sum_probs(probs), "Probability"),
         "u2_8__probabilities_do_not_sum_to_one"),
        (_prob_table_text(rv, values, _negative_probs(probs), "Probability"),
         "u2_8__negative_probability_allowed"),
        (_prob_table_text(rv, values, _cumulative_probs(probs), "Cumulative probability"),
         "u2_8__cumulative_probability_confused_with_point_probability"),
    ]
    options = [{"text": correct_text, "correct": True, "misconception": None}]
    for text, tag in distractors:
        options.append({"text": text, "correct": False, "misconception": tag,
                        "misconception_source": MISC.provenance(tag)})
    rng.shuffle(options)

    used_tags = {o.get("misconception") for o in options if o.get("misconception")}
    checks = [
        ("source_probs_nonnegative", all(0 <= p <= 1 for p in probs)),
        ("source_probs_sum_to_one", abs(sum(probs) - 1.0) < 1e-9),
        ("bad_sum_not_one", abs(sum(_adjusted_sum_probs(probs)) - 1.0) > 0.02),
        ("negative_distractor_has_negative_probability", any(p < 0 for p in _negative_probs(probs))),
        ("cumulative_distractor_not_point_distribution", sum(_cumulative_probs(probs)) > 1.0),
        ("exactly_one_correct", sum(1 for o in options if o["correct"]) == 1),
        ("four_options", len(options) == 4),
        ("option_texts_unique", len({o["text"] for o in options}) == 4),
        ("all_distractors_tagged", all(o["misconception"] for o in options if not o["correct"])),
        ("all_distractor_tags_canonical", all(o["misconception"] in MISC.CATALOG for o in options if not o["correct"])),
        ("all_distractors_cite_source", all(o.get("misconception_source", {}).get("sources") for o in options if not o["correct"])),
        ("scenario_framing_present", bool(scenario_prov.get("archetype")) and bool(scenario_prov.get("sources"))),
        ("random_variable_tags_used", used_tags == RANDOM_VARIABLE_TAGS),
    ]
    return {"schema_version": "course-mode-generated-0.1", "package_id": f"slotframe-u2_8-3a-{seed:06d}",
            "content_key": f"apstat-u2-8-3a-random-variable-distribution-{seed:06d}", "item_type": "mcq", "difficulty": "Medium",
            "exam_pack_ref": {"exam_code": "ap_statistics", "cycle": "2026-27"},
            "taxonomy_refs": [{"scheme_key": "ap-statistics-2026-27", "node_key": "unit-2"},
                              {"scheme_key": "ap-statistics-2026-27", "node_key": "topic-2.8"},
                              {"scheme_key": "ap-statistics-skills", "node_key": "skill-3.A", "practice": 3}],
            "cells": [{"topic": "2.8", "skill": "3.A"}], "scenario_provenance": scenario_prov,
            "prompt": prompt, "mcq_form": {"options": options},
            "parts": [{"part_key": "part-a", "prompt": prompt, "response_modalities": ["mcq"], "points": 1,
                       "criteria": [{"criterion_key": "part-a-criterion-1", "points": 1,
                                      "description": "Selects the table that gives valid point probabilities for a discrete random variable.",
                                      "required_evidence": correct_text,
                                      "deterministic_checks": [{"kind": "mcq_key", "correct_representation": "valid_probability_distribution"}],
                                      "accepted_variants": []}]}],
            "provenance": {"generator": "course_mode_stats_generator/slot_frames.py", "frame_id": "FB-U2-8-3A-RANDOM-VARIABLE-DIST-01",
                           "template_id": "slotframe_u2_8_random_variable_distributions",
                           "params": {"scenario_id": c["id"], "values": values, "probabilities": probs},
                           "seed": seed, "release_status": "unreleased_generated_pending_review",
                           "note": "Authored conceptual frame; correctness from probability-distribution validity rules."},
            "_property_checks": checks}


def generate_u2_8_random_variable_distributions(count: int, base_seed: int = 22800) -> List[Dict]:
    return [gen_u2_8_random_variable_distribution_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate_u2_5_mutually_exclusive(count: int, base_seed: int = 22500) -> List[Dict]:
    return [gen_u2_5_mutually_exclusive_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


# ==============================================================================
# Frame registry + harness. Each Track B cell appends ONE entry to FRAMES below
# (append-only) — no harness rewrite needed. (Integration lesson from batch 2.)
# ==============================================================================
def generate_4b(count: int, base_seed: int = 7000) -> List[Dict]:
    return [gen_4b_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate_u1_11_sampling(count: int, base_seed: int = 11000) -> List[Dict]:
    return [gen_u1_11_sampling_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate_u1_2_variables(count: int, base_seed: int = 12000) -> List[Dict]:
    return [gen_u1_2_variables_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate_u1_6_distribution(count: int, base_seed: int = 16000) -> List[Dict]:
    return [gen_u1_6_distribution_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate_u3_6_pvalue(count: int, base_seed: int = 36000) -> List[Dict]:
    return [gen_u3_6_pvalue_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate(count: int, base_seed: int = 7000) -> List[Dict]:
    return generate_4b(count, base_seed)


FRAMES = [
    {"frame_id": "FB-4B-COMPARE-01", "cell": "1.9 x 4.B", "gen": generate_4b,
     "base_seed": 7000, "expected_tags": set(),
     "note": "1 authored frame + scenario/justification slots. Coverage: Practice-4 skill 4.B."},
    {"frame_id": "FB-U1-3-3A-CAT-TABLE-01", "cell": "1.3 x 3.A", "gen": generate_u1_3_cat_tables,
     "base_seed": 13000, "expected_tags": set(CAT_TABLE_TAGS),
     "note": "Categorical table/relative-frequency representation. Coverage: Unit 1 topic 1.3."},
    {"frame_id": "FB-U1-11-2A-SAMPLING-01", "cell": "1.11 x 2.A", "gen": generate_u1_11_sampling,
     "base_seed": 11000, "expected_tags": set(SAMPLING_DISTRACTOR_TAGS),
     "note": "Sampling-method identification. Coverage: Unit 1 random-sampling methods."},
    {"frame_id": "FB-U1-2-2A-VARIABLES-01", "cell": "1.2 x 2.A", "gen": generate_u1_2_variables,
     "base_seed": 12000, "expected_tags": set(VARIABLE_TAGS),
     "note": "Variable classification (categorical vs quantitative). Coverage: Unit 1 topic 1.2."},
    {"frame_id": "FB-U1-6-4A-DISTRIBUTION-01", "cell": "1.6 x 4.A", "gen": generate_u1_6_distribution,
     "base_seed": 16000, "expected_tags": set(DISTRIBUTION_TAGS),
     "note": "Distribution description (shape/center/spread/outliers). Coverage: Unit 1 topic 1.6."},
    {"frame_id": "FB-U1-4-3A-CAT-GRAPH-01", "cell": "1.4 x 3.A", "gen": generate_u1_4_cat_graphs,
     "base_seed": 14000, "expected_tags": set(CAT_GRAPH_TAGS),
     "note": "Categorical graph representation (relative-frequency bar graph). Coverage: Unit 1 topic 1.4."},
    {"frame_id": "FB-U1-5-3A-GRAPH-01", "cell": "1.5 x 3.A", "gen": generate_u1_5_graphs,
     "base_seed": 15000, "expected_tags": set(GRAPH_TAGS),
     "note": "Quantitative graph representation (histogram/dotplot/stemplot). Coverage: Unit 1 topic 1.5."},
    {"frame_id": "FB-U1-8-3A-BOXPLOT-01", "cell": "1.8 x 3.A", "gen": generate_u1_8_boxplots,
     "base_seed": 18000, "expected_tags": set(BOXPLOT_TAGS),
     "note": "Boxplot from five-number summary. Coverage: Unit 1 topic 1.8."},
    {"frame_id": "FB-U1-12-2A-BIAS-01", "cell": "1.12 x 2.A", "gen": generate_u1_12_bias,
     "base_seed": 11200, "expected_tags": set(BIAS_TAGS),
     "note": "Sampling bias classification. Coverage: Unit 1 topic 1.12."},
    {"frame_id": "FB-U1-13-2A-DESIGN-01", "cell": "1.13 x 2.A", "gen": generate_u1_13_design,
     "base_seed": 11300, "expected_tags": set(DESIGN_TAGS),
     "note": "Experimental design classification. Coverage: Unit 1 topic 1.13."},
    {"frame_id": "FB-U3-6-4F-PVALUE-01", "cell": "3.6 x 4.F", "gen": generate_u3_6_pvalue,
     "base_seed": 36000, "expected_tags": set(PVALUE_TAGS),
     "note": "p-value interpretation in context. Coverage: Unit 3 topic 3.6 skill 4.F."},

    {"frame_id": "FB-U3-4-4F-PROP-CI-CLAIM-01", "cell": "3.4 x 4.F", "gen": generate_u3_4_prop_ci_claim,
     "base_seed": 30400, "expected_tags": set(PROP_CI_CLAIM_TAGS),
     "note": "Confidence-interval claim interpretation for one population proportion. Coverage: Unit 3 topic 3.4."},
    {"frame_id": "FB-U2-8-3A-RANDOM-VARIABLE-DIST-01", "cell": "2.8 x 3.A", "gen": generate_u2_8_random_variable_distributions,
     "base_seed": 22800, "expected_tags": set(RANDOM_VARIABLE_TAGS),
     "note": "Random-variable probability distribution representation. Coverage: Unit 2 topic 2.8."},
    {"frame_id": "FB-U2-5-4B-MUTUALLY-EXCLUSIVE-01", "cell": "2.5 x 4.B", "gen": generate_u2_5_mutually_exclusive,
     "base_seed": 22500, "expected_tags": set(MUTUALLY_EXCLUSIVE_TAGS),
     "note": "Mutually exclusive event relationship justification. Coverage: Unit 2 topic 2.5."},
    {"frame_id": "FB-U2-1-4A-TWOWAY-01", "cell": "2.1 x 4.A", "gen": generate_u2_1_twoway_interpret,
     "base_seed": 21000, "expected_tags": set(TWOWAY_INTERPRET_TAGS),
     "note": "Two-way table conditional-distribution interpretation. Coverage: Unit 2 topic 2.1."},
]


def _report_frame(frame_id: str, cell: str, insts: List[Dict], note: str) -> Dict:
    failures = []
    nchecks = 0
    for inst in insts:
        for name, ok in inst["_property_checks"]:
            nchecks += 1
            if not ok:
                failures.append(f"{inst['provenance']['seed']}/{name}")
    positions = [
        next(idx for idx, opt in enumerate(inst["mcq_form"]["options"]) if opt["correct"])
        for inst in insts
    ]
    return {
        "frame_id": frame_id, "cell": cell,
        "instances": len(insts), "checks": nchecks,
        "distinct_prompts": len({i["prompt"] for i in insts}),
        "correct_answer_positions": sorted(set(positions)),
        "correct_answer_position_varies": len(set(positions)) >= 2,
        "failures": failures, "ok": len(failures) == 0,
        "authoring_cost_note": note,
    }


def property_report(count: int = 120) -> Dict:
    frames = []
    tags_ok = True
    for spec in FRAMES:
        insts = spec["gen"](count, spec["base_seed"])
        frames.append(_report_frame(spec["frame_id"], spec["cell"], insts, spec["note"]))
        used = {opt.get("misconception") for inst in insts
                for opt in inst["mcq_form"]["options"] if opt.get("misconception")}
        if not spec["expected_tags"].issubset(used):
            tags_ok = False
    meta = [
        ("all_frames_ok", all(f["ok"] for f in frames)),
        ("correct_answer_position_varies", all(f["correct_answer_position_varies"] for f in frames)),
        ("misconception_catalog_self_check", not MISC.validate_catalog()),
        ("scenario_catalog_self_check", not SCN.validate_scenarios()),
        ("all_frame_expected_tags_used", tags_ok),
    ]
    return {
        "frames": frames,
        "instances": sum(f["instances"] for f in frames),
        "checks": sum(f["checks"] for f in frames),
        "meta_tests": [{"name": n, "ok": ok} for n, ok in meta],
        "ok": all(f["ok"] for f in frames) and all(ok for _n, ok in meta),
    }


def emit_samples(count: int = 4, base_seed: int = 9000) -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    emitted = 0
    for i, spec in enumerate(FRAMES):
        for inst in spec["gen"](count, base_seed + 100 * i):
            assert all(ok for _n, ok in inst["_property_checks"]), \
                f"invalid slot-frame instance reached emit: {inst['package_id']}"
            pkg = {k: v for k, v in inst.items() if k != "_property_checks"}
            (OUT_DIR / f"{inst['package_id']}.json").write_text(json.dumps(pkg, indent=2))
            emitted += 1
    return emitted


if __name__ == "__main__":
    print(json.dumps(property_report(), indent=2))
