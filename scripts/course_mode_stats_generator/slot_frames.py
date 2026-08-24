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

DISTRIBUTION_SHAPES = ["right-skewed", "left-skewed", "roughly symmetric"]
DISTRIBUTION_TAGS = {
    "u1_6__skew_direction_reversed",
    "u1_6__center_spread_confused",
    "u1_6__outlier_from_range_not_fences",
    "u1_6__ignores_shape_reports_center_only",
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
            "params": {"scenario": s["ctx"], "mA": mA, "mB": mB, "sd": sd},
            "seed": seed,
            "release_status": "unreleased_generated_pending_review",
            "note": "Authored conceptual frame; correctness from authored justification taxonomy.",
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


def generate_4b(count: int, base_seed: int = 7000) -> List[Dict]:
    return [gen_4b_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate_u1_6_distribution(count: int, base_seed: int = 16000) -> List[Dict]:
    return [gen_u1_6_distribution_instance(random.Random(base_seed + i), base_seed + i) for i in range(count)]


def generate(count: int, base_seed: int = 7000) -> List[Dict]:
    return generate_4b(count, base_seed)


def _report_frame(frame_id: str, cell: str, insts: List[Dict], note: str) -> Dict:
    failures = []
    nchecks = 0
    for inst in insts:
        for name, ok in inst["_property_checks"]:
            nchecks += 1
            if not ok:
                failures.append(f"{inst['provenance']['seed']}/{name}")
    correct_positions = [
        next(idx for idx, opt in enumerate(inst["mcq_form"]["options"]) if opt["correct"])
        for inst in insts
    ]
    return {
        "frame_id": frame_id, "cell": cell,
        "instances": len(insts), "checks": nchecks,
        "distinct_prompts": len({i["prompt"] for i in insts}),
        "correct_answer_positions": sorted(set(correct_positions)),
        "correct_answer_position_varies": len(set(correct_positions)) >= 2,
        "failures": failures, "ok": len(failures) == 0,
        "authoring_cost_note": note,
    }


def property_report(count: int = 120) -> Dict:
    dist_insts = generate_u1_6_distribution(count, 16000)
    dist_tags_used = {
        opt["misconception"]
        for inst in dist_insts
        for opt in inst["mcq_form"]["options"]
        if opt.get("misconception")
    }
    frames = [
        _report_frame("FB-4B-COMPARE-01", "1.9 x 4.B", generate_4b(count, 7000),
                      "Existing authored 4.B comparison frame."),
        _report_frame("FB-U1-6-4A-DISTRIBUTION-01", "1.6 x 4.A", dist_insts,
                      "1 authored frame + 5 contexts x 3 shape surfaces, with varied summary values."),
    ]
    meta_tests = [
        ("all_frames_ok", all(f["ok"] for f in frames)),
        ("correct_answer_position_varies", all(f["correct_answer_position_varies"] for f in frames)),
        ("misconception_catalog_self_check", not MISC.validate_catalog()),
        ("scenario_catalog_self_check", not SCN.validate_scenarios()),
        ("u1_6_all_new_misconception_tags_used", DISTRIBUTION_TAGS.issubset(dist_tags_used)),
    ]
    return {
        "frames": frames,
        "instances": sum(f["instances"] for f in frames),
        "checks": sum(f["checks"] for f in frames),
        "meta_tests": [{"name": name, "ok": ok} for name, ok in meta_tests],
        "ok": all(f["ok"] for f in frames) and all(ok for _name, ok in meta_tests),
    }


def emit_samples(count: int = 4, base_seed: int = 9000) -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    sample_sets = [generate_4b(count, base_seed), generate_u1_6_distribution(count, 16100)]
    emitted = 0
    for inst in [item for sample in sample_sets for item in sample]:
        assert all(ok for _n, ok in inst["_property_checks"]), \
            f"invalid slot-frame instance reached emit: {inst['package_id']}"
        pkg = {k: v for k, v in inst.items() if k != "_property_checks"}
        (OUT_DIR / f"{inst['package_id']}.json").write_text(json.dumps(pkg, indent=2))
        emitted += 1
    return emitted


if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "emit":
        print("emitted", emit_samples(), "slot-frame samples")
    else:
        print(json.dumps(property_report(), indent=2))
