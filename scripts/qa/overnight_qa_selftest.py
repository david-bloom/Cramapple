#!/usr/bin/env python3
"""
Self-test for overnight_qa_harness.py.

A QA harness that has never been shown to FAIL is not trustworthy. This builds synthetic
fixtures with deliberately planted defects, runs the harness against them, and asserts that
each defect is detected. It also runs a clean fixture and asserts a pass.

  python3 scripts/qa/overnight_qa_selftest.py

Exit 0 = the harness detects everything it should. Exit 1 = the harness has regressed.
"""
from __future__ import annotations
import json, os, subprocess, sys, tempfile, csv

HERE = os.path.dirname(os.path.abspath(__file__))
HARNESS = os.path.join(HERE, "overnight_qa_harness.py")


def jl(path, rows):
    with open(path, "w") as f:
        for r in rows:
            f.write(json.dumps(r) + "\n")


def crit(*keys):
    return [{"criterion_key": k, "points_possible": 1, "learner_facing_text": k} for k in keys]


def item(key, sub, ca1="", ca2="", keys=(), vid="v", cid="c", topic=None, typ="frq"):
    return {"content_item_id": cid, "version_id": vid, "version_num": 2, "content_key": key,
            "subject_key": sub, "item_type": typ, "canonical_answer_1": ca1,
            "canonical_answer_2": ca2, "stem": "s", "stimulus": "", "prompt_topic": topic,
            "stated_total_points": None, "has_split_from": False, "split_from": None,
            "criteria": crit(*keys)}


def build(root):
    t = os.path.join(root, "truth"); os.makedirs(t, exist_ok=True)
    items = [
        item("S-HAS-1", "ap-statistics", "Alpha beta.", "Gamma delta.", ("a", "b"), "v1", "c1"),
        item("S-HAS-2", "ap-statistics", "Epsilon zeta.", "", ("a",), "v2", "c2"),
        item("S-BLANK-1", "ap-statistics", "", "", ("a", "b"), "v3", "c3"),
        item("S-BLANK-2", "ap-statistics", "", "", ("a",), "v4", "c4"),
        item("CHEM-1", "ap-chemistry", None, None, (), "v5", "c5", topic="1.5", typ="mcq"),
        item("CHEM-2", "ap-chemistry", None, None, (), "v6", "c6", typ="mcq"),
        item("APBIO-FRQ-S-001", "biology", "One. Two.", "", ("a", "b"), "bv1", "b1"),
        item("APBIO-HDG-2026-GRAPH-002", "biology", "", "", ("a",), "bv2", "b2"),
    ]
    json.dump(items, open(os.path.join(t, "items.json"), "w"))
    json.dump([{"content_item_id": "c1", "version_id": "v1prior", "version_num": 1,
                "status": "retired", "content_key": "S-HAS-1",
                "canonical_answer_1": "Alpha beta.", "canonical_answer_2": "Gamma delta.",
                "criteria_count": 1}], open(os.path.join(t, "prior_versions.json"), "w"))
    json.dump([{"subject_key": "ap-chemistry", "taxonomy_source_version": "x",
                "school_year": "2026-2027", "taxonomy_confidence": "verified",
                "topic_code": "1.5", "unit_number": 1, "topic_title": "T"}],
              open(os.path.join(t, "closed_list.json"), "w"))

    def pk(sub, typ="frq"):
        return [{"content_key": i["content_key"], "version_id": i["version_id"],
                 "version_num": i["version_num"], "canonical_answer_1": i["canonical_answer_1"],
                 "canonical_answer_2": i["canonical_answer_2"], "criteria": i["criteria"],
                 "prompt_topic": i.get("prompt_topic")}
                for i in items if i["subject_key"] == sub and i["item_type"] == typ]

    runs = {}

    # C clean
    d = os.path.join(root, "C_clean"); os.makedirs(d, exist_ok=True)
    jl(os.path.join(d, "packet.jsonl"), pk("ap-statistics"))
    jl(os.path.join(d, "segmentation_proposal.jsonl"), [
        {"content_key": "S-HAS-1", "full_text": "Alpha beta.Gamma delta.", "spans": [
            {"text": "Alpha beta.", "criterion_keys": ["a"], "provenance": "recovered_ca1",
             "source_field": "canonical_answer_1"},
            {"text": "Gamma delta.", "criterion_keys": ["b"], "provenance": "recovered_ca2",
             "source_field": "canonical_answer_2"}]},
        {"content_key": "S-HAS-2", "full_text": "Epsilon zeta.", "spans": [
            {"text": "Epsilon zeta.", "criterion_keys": ["a"], "provenance": "recovered_ca1",
             "source_field": "canonical_answer_1"}]}])
    runs["C_clean"] = ("C", d, set())

    # C broken
    d = os.path.join(root, "C_broken"); os.makedirs(d, exist_ok=True)
    jl(os.path.join(d, "packet.jsonl"), [
        {"content_key": "S-HAS-1", "version_id": "WRONG", "version_num": 2,
         "canonical_answer_1": "Alpha beta.", "canonical_answer_2": "Gamma delta.",
         "criteria": [{"criterion_key": "a"}]}])
    jl(os.path.join(d, "segmentation_proposal.jsonl"), [
        {"content_key": "S-HAS-1", "full_text": "Alpha beta. INVENTED.", "spans": [
            {"text": "Alpha beta.", "criterion_keys": ["a"], "provenance": "recovered_ca1",
             "source_field": "canonical_answer_1"},
            {"text": " INVENTED.", "criterion_keys": ["zzz"], "provenance": "drafted",
             "source_field": None}]},
        {"content_key": "S-BLANK-1", "full_text": "x", "spans": [
            {"text": "x", "criterion_keys": ["a"], "provenance": "drafted", "source_field": None}]}])
    runs["C_broken"] = ("C", d, {"packet_missing_item", "packet_drift", "scope_collision",
                                 "invented_criterion", "criterion_uncovered", "ca2_dropped"})

    # B broken: underived number + rubric restatement
    d = os.path.join(root, "B_broken"); os.makedirs(d, exist_ok=True)
    jl(os.path.join(d, "packet.jsonl"), pk("ap-statistics"))
    jl(os.path.join(d, "canonical_proposal.jsonl"), [
        {"content_key": "S-BLANK-1", "full_text": "The mean is 42.5 and the interval is 3.1 wide.",
         "spans": [{"text": "The mean is 42.5 and the interval is 3.1 wide.",
                    "criterion_keys": ["a", "b"]}],
         "derivations": [{"value": "42.5", "criterion": "a", "inputs": "stimulus"}]},
        {"content_key": "S-BLANK-2",
         "full_text": "To earn this point, make sure your response identifies skew.",
         "spans": [{"text": "To earn this point, make sure your response identifies skew.",
                    "criterion_keys": ["a"]}], "derivations": []}])
    runs["B_broken"] = ("B", d, {"underived_number", "rubric_restatement_reused"})

    # D broken: invalid code + unit mismatch
    d = os.path.join(root, "D_broken"); os.makedirs(d, exist_ok=True)
    jl(os.path.join(d, "packet.jsonl"), pk("ap-chemistry", "mcq"))
    with open(os.path.join(d, "topic_labels_proposal.csv"), "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["content_key", "subject_key", "proposed_unit",
                                          "proposed_topic_code", "basis"])
        w.writeheader()
        w.writerow({"content_key": "CHEM-1", "subject_key": "ap-chemistry", "proposed_unit": "2",
                    "proposed_topic_code": "1.5", "basis": "recovered_author_code"})
        w.writerow({"content_key": "CHEM-2", "subject_key": "ap-chemistry", "proposed_unit": "9",
                    "proposed_topic_code": "9.9", "basis": "derived"})
    runs["D_broken"] = ("D", d, {"topic_code_not_in_closed_list", "unit_topic_mismatch"})

    # A broken: span cites a version id that is not a version of the item
    d = os.path.join(root, "A_broken"); os.makedirs(d, exist_ok=True)
    jl(os.path.join(d, "packet.jsonl"), pk("biology"))
    jl(os.path.join(d, "recovery_proposal.jsonl"), [
        {"content_key": "APBIO-FRQ-S-001", "full_text": "One. Two.", "spans": [
            {"text": "One. ", "criterion_keys": ["a"], "provenance": "recovered_ca1",
             "source_field": "canonical_answer_1", "source_version_id": "bv1"},
            {"text": "Two.", "criterion_keys": ["b"], "provenance": "recovered_ca1",
             "source_field": "canonical_answer_1", "source_version_id": "NOT-A-VERSION"}]},
        {"content_key": "APBIO-HDG-2026-GRAPH-002", "out_of_scope": True, "spans": [],
         "full_text": ""}])
    runs["A_broken"] = ("A", d, {"foreign_source_version"})

    return t, runs


def main():
    root = tempfile.mkdtemp(prefix="qa_selftest_")
    truth, runs = build(root)
    failures = []
    for name, (order, rundir, expect) in sorted(runs.items()):
        r = subprocess.run([sys.executable, HARNESS, "--order", order, "--truth", truth,
                            "--run", rundir], capture_output=True, text=True)
        if r.returncode == 2:
            failures.append(f"{name}: harness errored\n{r.stderr}")
            continue
        got = set()
        fp = os.path.join(rundir, "qa_findings.csv")
        if os.path.exists(fp):
            got = {row["issue_type"] for row in csv.DictReader(open(fp))}
        missed = expect - got
        if missed:
            failures.append(f"{name}: harness MISSED {sorted(missed)}")
        if not expect and r.returncode != 0:
            failures.append(f"{name}: clean fixture should pass, exit={r.returncode}")
        if expect and r.returncode == 0:
            failures.append(f"{name}: broken fixture should fail, exit=0")
        print(f"  {name:<10} order {order}  exit={r.returncode}  "
              f"detected={sorted(got - {'work_order_count_drift'})}")
    print()
    if failures:
        for f in failures:
            print("FAIL:", f)
        return 1
    print("SELF-TEST PASSED — the harness detects every planted defect and passes the clean run.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
