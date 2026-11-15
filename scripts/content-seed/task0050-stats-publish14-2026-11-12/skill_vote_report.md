# AP Statistics Phase B — Skill-Code Labelling Run

**Run:** `skill-codes-ap_statistics-20261113030247` · **Started:** 2026-11-13T03:02:47.794Z
**Governing records:** `DECISION-0085`, `APPROVAL-0060`, `TASK-0050`
**Models:** proposers `openai/gpt-5.5`, `google/gemini-2.5-pro`; blind adjudicator `anthropic/claude-opus-5`.
All three ran on every item, so unanimity and majority stay distinguishable.

## Outcome

| | Items |
| --- | --- |
| Deterministic (topic has one registered skill — no model call) | 3 |
| Model-decided, `validated` (>= 2 of 3) | 11 |
| — of those, unanimous 3/3 | 9 |
| — of those, majority-earned 2/3 | 2 |
| — of those, adjudicator broke a proposer split | 2 |
| Held (no majority) — NOT written | 0 |
| **Total** | **14** |

**Proposer agreement rate:** 9/11 = 81.8%.
For context, `TAXONOMY_LABELING_PLAN_V3` measured 44% two-model agreement at topic
granularity with a ~55-way choice; this run's choice set averages 2.33 candidates, so a
materially higher rate is expected and is not by itself evidence of quality.

**Gateway spend:** $0.2444 across 33 calls.

## What is NOT in this run

- Nothing was applied. The SQL file is written, never executed.
- Labels land as `provisional_model`, pending a Production decision record and write approval.
  The current `content_item_cells_validation_check` accepts `model_run_id` as provenance,
  but also requires `validated_at` and `validation_decision_id`. The consensus tier is
  recorded in `model_run_id`, so promotion needs no model re-run.
- These items exist **only in Production**. Development holds different AP Statistics content
  (pack `4e54bb4f`, 203 MCQ, already skill-labelled), so this cannot be rehearsed in Dev.
  Applying it is therefore a Production Hard Gate, outside `APPROVAL-0060`.