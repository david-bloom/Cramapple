#!/usr/bin/env python3
"""QA gate for Course Mode AP Statistics cell 1.11 x 2.A.

This script is intentionally narrow: it verifies the Track B sampling-method
slot-frame added for Topic 1.11 / Skill 2.A, including the harness checks and a
small independent re-derivation probe for every new misconception tag.

It does not emit packages, build load SQL, touch a database, or release content.
"""
from __future__ import annotations

import argparse
import json
import random
import sys
from typing import Dict, Iterable, List, Sequence

import misconceptions as MISC
import scenarios as SCN
import slot_frames as SF


EXPECTED_FRAME_ID = "FB-U1-11-2A-SAMPLING-01"
EXPECTED_CELL = "1.11 x 2.A"
EXPECTED_TAGS = set(SF.SAMPLING_DISTRACTOR_TAGS)
REPRESENTATIVE_SEEDS = (11000, 11004)


def _failures_from_checks(inst: Dict) -> List[str]:
    return [name for name, ok in inst["_property_checks"] if not ok]


def _correct_option(inst: Dict) -> Dict:
    correct = [opt for opt in inst["mcq_form"]["options"] if opt["correct"]]
    if len(correct) != 1:
        raise AssertionError(f"{inst['package_id']}: expected exactly one correct option, got {len(correct)}")
    return correct[0]


def _distractor_tags(insts: Iterable[Dict]) -> set[str]:
    return {
        opt["misconception"]
        for inst in insts
        for opt in inst["mcq_form"]["options"]
        if opt.get("misconception")
    }


def _assert_sampling_key(inst: Dict) -> None:
    method = inst["provenance"]["params"]["method"]
    text = _correct_option(inst)["text"]
    expectations = {
        "srs": ("SRS", "whole population"),
        "stratified": ("Stratified random sample", "every group"),
        "cluster": ("Cluster sample", "selected groups"),
        "systematic": ("Systematic random sample", "fixed interval"),
        "convenience": ("Not a random sample", "convenience sample"),
        "voluntary": ("Not a random sample", "voluntary-response sample"),
    }
    for phrase in expectations[method]:
        if phrase not in text:
            raise AssertionError(
                f"{inst['package_id']}: key for method {method!r} missing phrase {phrase!r}: {text!r}"
            )


def _assert_rederived_distractor(inst: Dict, tag: str, text: str) -> None:
    method = inst["provenance"]["params"]["method"]
    if tag == "u1_11__convenience_or_voluntary_called_random":
        if method in ("convenience", "voluntary"):
            if not text.startswith("SRS,"):
                raise AssertionError(f"{inst['package_id']}: expected non-random-as-SRS distractor, got {text!r}")
        elif "Convenience sample" not in text:
            raise AssertionError(f"{inst['package_id']}: expected random-selection-as-convenience distractor, got {text!r}")
        return

    if tag == "u1_11__stratified_cluster_confusion":
        if method == "cluster":
            if not text.startswith("Stratified random sample"):
                raise AssertionError(f"{inst['package_id']}: expected cluster mislabeled as stratified, got {text!r}")
        elif not text.startswith("Cluster sample"):
            raise AssertionError(f"{inst['package_id']}: expected stratified/grouping mislabeled as cluster, got {text!r}")
        return

    if tag == "u1_11__systematic_srs_conflation":
        if method == "systematic":
            if not text.startswith("SRS,"):
                raise AssertionError(f"{inst['package_id']}: expected systematic mislabeled as SRS, got {text!r}")
        elif not text.startswith("Systematic random sample"):
            raise AssertionError(f"{inst['package_id']}: expected non-systematic plan mislabeled as systematic, got {text!r}")
        return

    if tag == "u1_11__stratified_samples_whole_groups":
        if not text.startswith("Stratified random sample") or "whole" not in text and "all" not in text:
            raise AssertionError(f"{inst['package_id']}: expected whole-group stratified misconception, got {text!r}")
        return

    raise AssertionError(f"{inst['package_id']}: unhandled distractor tag {tag!r}")


def _assert_representative_rederivation() -> Dict[str, object]:
    insts = [
        SF.gen_u1_11_sampling_instance(random.Random(seed), seed)
        for seed in REPRESENTATIVE_SEEDS
    ]
    seen_tags = set()
    for inst in insts:
        _assert_sampling_key(inst)
        for opt in inst["mcq_form"]["options"]:
            tag = opt.get("misconception")
            if tag:
                _assert_rederived_distractor(inst, tag, opt["text"])
                seen_tags.add(tag)

    missing = EXPECTED_TAGS - seen_tags
    if missing:
        raise AssertionError(f"representative seeds did not cover all new tags; missing {sorted(missing)}")

    return {
        "seeds": list(REPRESENTATIVE_SEEDS),
        "covered_tags": sorted(seen_tags),
    }


def run_qa(count: int) -> Dict[str, object]:
    insts = SF.generate_u1_11_sampling(count, 11000)
    failures = []
    for inst in insts:
        for check in _failures_from_checks(inst):
            failures.append(f"{inst['package_id']}/{check}")
        _assert_sampling_key(inst)

    report = SF.property_report(count)
    frame_reports = [f for f in report["frames"] if f["frame_id"] == EXPECTED_FRAME_ID]
    if len(frame_reports) != 1:
        raise AssertionError(f"expected one {EXPECTED_FRAME_ID} report, got {len(frame_reports)}")
    frame = frame_reports[0]

    if frame["cell"] != EXPECTED_CELL:
        raise AssertionError(f"wrong cell in report: {frame['cell']!r}")
    if frame["instances"] < count:
        raise AssertionError(f"too few instances: {frame['instances']} < {count}")
    if frame["failures"]:
        raise AssertionError(f"frame report failures: {frame['failures']}")
    if set(frame["correct_answer_positions"]) != {0, 1, 2, 3}:
        raise AssertionError(f"correct answer positions did not cover A-D: {frame['correct_answer_positions']}")

    tags_used = _distractor_tags(insts)
    missing_tags = EXPECTED_TAGS - tags_used
    if missing_tags:
        raise AssertionError(f"generated instances did not use all new tags: {sorted(missing_tags)}")
    extra_u1_11_tags = {tag for tag in tags_used if tag.startswith("u1_11__")} - EXPECTED_TAGS
    if extra_u1_11_tags:
        raise AssertionError(f"unexpected u1_11 tags: {sorted(extra_u1_11_tags)}")

    catalog_problems = MISC.validate_catalog()
    scenario_problems = SCN.validate_scenarios()
    if catalog_problems:
        raise AssertionError(f"misconception catalog problems: {catalog_problems}")
    if scenario_problems:
        raise AssertionError(f"scenario catalog problems: {scenario_problems}")

    representative = _assert_representative_rederivation()
    if failures:
        raise AssertionError(f"per-instance failures: {failures}")

    return {
        "ok": True,
        "frame_id": EXPECTED_FRAME_ID,
        "cell": EXPECTED_CELL,
        "instances": frame["instances"],
        "checks": frame["checks"],
        "distinct_prompts": frame["distinct_prompts"],
        "correct_answer_positions": frame["correct_answer_positions"],
        "new_tags_used": sorted(tags_used),
        "representative_rederivation": representative,
        "no_db_or_loader": True,
    }


def main(argv: Sequence[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--count", type=int, default=120, help="number of generated instances to check")
    parser.add_argument("--json", action="store_true", help="print machine-readable JSON only")
    args = parser.parse_args(argv)

    try:
        summary = run_qa(args.count)
    except Exception as exc:  # noqa: BLE001 - CLI should show the precise failing assertion.
        if args.json:
            print(json.dumps({"ok": False, "error": str(exc)}, indent=2))
        else:
            print(f"QA FAILED: {exc}", file=sys.stderr)
        return 1

    if args.json:
        print(json.dumps(summary, indent=2))
    else:
        print(
            f"QA PASS: {summary['frame_id']} ({summary['cell']}) | "
            f"{summary['instances']} instances | {summary['checks']} checks | "
            f"tags={', '.join(summary['new_tags_used'])}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
