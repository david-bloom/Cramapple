#!/usr/bin/env python3
"""Exploratory coaching test on ten existing synthetic grading responses."""
import json
import os
import pathlib
import sys
import time
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parents[3]
HERE = pathlib.Path(__file__).resolve().parent
ENGINE_GRADES = "--engine-grades" in sys.argv
ROUND = 2 if "--round=2" in sys.argv or ENGINE_GRADES else 1
OUT = HERE / ("ten_case_engine_test_2026_11_14" if ENGINE_GRADES else "ten_case_test_2026_11_14_round2" if ROUND == 2 else "ten_case_test_2026_11_14")
OUT.mkdir(exist_ok=True)
MODEL = "gpt-5.4-mini"
MAX_CALLS = 10
MAX_OUTPUT_TOKENS = 350

SOURCES_ROUND1 = [
    ("biology", ROOT / "docs/research/ap_biology_gold_set_candidate_2026_07_08/provisional_labels.json", [
        ("APBIO-FRQ-L-001", "partially_correct"),
        ("APBIO-FRQ-L-009", "borderline"),
        ("APBIO-FRQ-L-017", "subtly_wrong"),
        ("APBIO-FRQ-L-025", "fully_correct"),
        ("APBIO-FRQ-L-033", "partially_correct"),
    ]),
    ("statistics", ROOT / "docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json", [
        ("APSTAT-MOD3-H001-INV", "partially_correct"),
        ("APSTAT-MOD4-H001-INV", "borderline"),
        ("APSTAT-MOD5-H001-INV", "subtly_wrong"),
        ("APSTAT-MOD6-H001", "fully_correct"),
        ("APSTAT-MOD7-H001", "partially_correct"),
    ]),
]
SOURCES_ROUND2 = [
    ("biology", ROOT / "docs/research/ap_biology_gold_set_candidate_2026_07_08/provisional_labels.json", [
        ("APBIO-FRQ-L-001", "subtly_wrong"),
        ("APBIO-FRQ-L-009", "partially_correct"),
        ("APBIO-FRQ-L-017", "borderline"),
        ("APBIO-FRQ-L-025", "partially_correct"),
        ("APBIO-FRQ-L-033", "subtly_wrong"),
    ]),
    ("statistics", ROOT / "docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json", [
        ("APSTAT-MOD3-H001-INV", "subtly_wrong"),
        ("APSTAT-MOD4-H001-INV", "partially_correct"),
        ("APSTAT-MOD5-H001-INV", "borderline"),
        ("APSTAT-MOD6-H001", "borderline"),
        ("APSTAT-MOD7-H001", "subtly_wrong"),
    ]),
]
SOURCES = SOURCES_ROUND2 if ROUND == 2 else SOURCES_ROUND1

def build_cases():
    result = []
    for subject, path, picks in SOURCES:
        data = json.loads(path.read_text())
        items = {x["content_key"]: x for x in data["items"]}
        for key, kind in picks:
            item = items[key]
            response = next(x for x in item["responses"] if x["synthetic_type"] == kind)
            labels = response["criteria"]
            normalized = {}
            for criterion in item["rubric"]:
                ck = criterion["criterion_key"]
                raw = labels.get(ck, {}) if isinstance(labels, dict) else {}
                normalized[ck] = raw.get("provisional_label", "unknown")
            result.append({
                "subject": subject, "content_key": key, "synthetic_type": kind,
                "response_index": response["response_index"],
                "response_text": response["response_text"],
                "question_text": item["question_text"], "stimulus": item.get("stimulus"),
                "rubric": item["rubric"], "labels": normalized,
                "source": str(path.relative_to(ROOT)), "label_authority": data["label_authority"],
            })
    assert len(result) == 10
    return result

SYSTEM = """You write a concise coaching paragraph shown below an FRQ grade in an AP exam practice app. Use only the supplied question, response, rubric, and criterion outcomes. Name what the response actually earns and the most useful missing or incorrect requirement, then give a concrete next step explaining why it earns the point. Never invent a quote, point award, student motive, or subject fact. If an outcome is uncertain, say so and do not present undecided points as lost. For full-credit work, state the specific success without inventing a defect. Write at most 110 words. Output only the coaching text."""

def generate(case):
    fields = ["subject", "question_text", "stimulus", "response_text", "rubric", "grade"] if ENGINE_GRADES else ["subject", "question_text", "stimulus", "response_text", "rubric", "labels"]
    prompt = json.dumps({k: case[k] for k in fields}, ensure_ascii=False)
    body = json.dumps({"model": MODEL, "instructions": SYSTEM, "input": prompt, "max_output_tokens": MAX_OUTPUT_TOKENS}).encode()
    req = urllib.request.Request("https://api.openai.com/v1/responses", data=body,
        headers={"Authorization": "Bearer " + os.environ["OPENAI_API_KEY"], "Content-Type": "application/json"})
    start = time.monotonic()
    with urllib.request.urlopen(req, timeout=120) as resp:
        raw = json.load(resp)
    parts = [part.get("text", "") for msg in raw.get("output", []) for part in msg.get("content", []) if part.get("type") == "output_text"]
    return {"coaching": "\n".join(parts).strip(), "usage": raw.get("usage", {}),
            "response_id": raw.get("id"), "latency_ms": round((time.monotonic() - start) * 1000)}

def main():
    cases = build_cases()
    if ENGINE_GRADES:
        grades = {x["content_key"]: x["grade"] for x in json.loads((OUT / "grades.json").read_text())}
        if len(grades) != 10:
            raise RuntimeError("Expected ten completed engine grades")
        for case in cases:
            case["grade"] = grades[case["content_key"]]
    if "--prepare-only" in sys.argv:
        manifest = [{k: case[k] for k in ["subject", "content_key", "synthetic_type", "response_index", "labels", "source", "label_authority"]} for case in cases]
        (OUT / "case_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
        print("Prepared ten local cases:", OUT / "case_manifest.json")
        return
    path = OUT / "results.json"
    rows = json.loads(path.read_text()) if path.exists() else []
    done = {(r["subject"], r["content_key"]) for r in rows}
    assert len(rows) <= MAX_CALLS
    for case in cases:
        if (case["subject"], case["content_key"]) in done:
            continue
        if len(rows) >= MAX_CALLS:
            raise RuntimeError("Ten-call cap reached")
        row = {**case, **generate(case)}
        rows.append(row)
        path.write_text(json.dumps(rows, indent=2, ensure_ascii=False) + "\n")
        print(f'{len(rows)}/10 {case["subject"]} {case["content_key"]}: {len(row["coaching"].split())} words, {row["latency_ms"]} ms', flush=True)
    print("Saved", path)

if __name__ == "__main__":
    main()
