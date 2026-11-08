"""Map a grading_run.json (real evaluate-attempt output) to FrqDemo RepairPayload objects.

Mapping (grader field -> demo field):
  feedback_preview                      -> point_summary
  criterion_results[i] + frq_criteria   -> criteria[{label: learner_facing_text, status, evidence}]
      status: earned -> earned; partial/partially_earned -> partial; anything else -> missing
      evidence: decision_explanation (grader's words), with evidence_quote appended when present
  first not-earned criterion's learner_facing_text -> missing_concept (null when full credit)
  criterion minimum_fix for highest_value_gap.criterion_key (else repair_hint) -> next_fix
  teaching_note: null (the grader returns none; Repair renders it only when present)
Usage: python3 -I map_grading_to_payloads.py grading_run.json out.json
"""
import json, sys

def next_fix(g):
    """The grader's own fix text for the highest-value gap. Prefer the criterion-level
    minimum_fix (a full sentence the grader wrote) over repair_hint, which the function
    templates from keyword fragments ("Provide the missing mathematical evidence: no, not uniqueness, additional")."""
    hvg = g.get("highest_value_gap") or {}
    key = hvg.get("criterion_key")
    for c in g.get("criterion_results") or []:
        if c.get("criterion_key") == key and c.get("minimum_fix"):
            return c["minimum_fix"]
    for c in g.get("criterion_results") or []:
        if c.get("status") != "earned" and c.get("minimum_fix"):
            return c["minimum_fix"]
    return g.get("repair_hint") or hvg.get("minimum_fix")

run = json.load(open(sys.argv[1]))
out = []
for r in run["results"]:
    g = r.get("grading_result") or {}
    if g.get("status") != "graded":
        out.append({"content_key": r["content_key"], "skipped": g.get("status"), "reason": g.get("uncertainty_reason")})
        continue
    crit_text = {c["criterion_key"]: c for c in r.get("criteria", [])}
    criteria = []
    missing = None
    for c in g.get("criterion_results") or []:
        st = c.get("status")
        status = "earned" if st == "earned" else "partial" if st in ("partial", "partially_earned") else "missing"
        meta = crit_text.get(c.get("criterion_key"), {})
        label = meta.get("learner_facing_text") or c.get("criterion_key")
        ev = (c.get("decision_explanation") or "").strip()
        q = (c.get("evidence_quote") or "").strip().strip('"').strip("“”").strip()
        if q and q not in ev:
            ev = f"{ev} Quoted: “{q}”" if ev else f"Quoted: “{q}”"
        criteria.append({"label": label, "status": status, "evidence": ev})
        if status != "earned" and missing is None:
            missing = label
    payload = {
        "points_earned": g.get("points_earned"),
        "points_possible": g.get("points_available"),
        "point_summary": g.get("feedback_preview"),
        "criteria": criteria,
        "missing_concept": missing,
        "next_fix": next_fix(g),
        "teaching_note": None,
    }
    out.append({
        "content_key": r["content_key"], "subject_key": r["subject_key"],
        "grader": {"model_id": g.get("model_id"), "prompt_version": g.get("prompt_version"), "confidence": g.get("confidence"), "graded_at": g.get("created_at"), "grading_result_id": g.get("id"), "attempt_id": r.get("attempt_id")},
        "repair": payload,
    })
json.dump(out, open(sys.argv[2], "w"), indent=2, ensure_ascii=False)
print(json.dumps([(o["content_key"], o.get("skipped") or f"{o['repair']['points_earned']}/{o['repair']['points_possible']}") for o in out]))
