# AP Statistics Phase B — Skill-Code Labelling Run

**Run:** `skill-codes-ap_statistics-20260929040715` · **Started:** 2026-09-29T04:07:15.240Z
**Governing records:** `DECISION-0085`, `APPROVAL-0060`, `TASK-0050`
**Models:** proposers `openai/gpt-5.5`, `google/gemini-2.5-pro`; blind adjudicator `anthropic/claude-opus-5`.
All three ran on every item, so unanimity and majority stay distinguishable.

## Outcome

| | Items |
| --- | --- |
| Deterministic (topic has one registered skill — no model call) | 42 |
| Model-decided, `validated` (>= 2 of 3) | 139 |
| — of those, unanimous 3/3 | 103 |
| — of those, majority-earned 2/3 | 36 |
| — of those, adjudicator broke a proposer split | 20 |
| Held (no majority) — NOT written | 0 |
| **Total** | **181** |

**Proposer agreement rate:** 119/139 = 85.6%.
For context, `TAXONOMY_LABELING_PLAN_V3` measured 44% two-model agreement at topic
granularity with a ~55-way choice; this run's choice set averages 2.33 candidates, so a
materially higher rate is expected and is not by itself evidence of quality.

**Gateway spend:** $0.0000 across 417 calls.

## What is NOT in this run

- Nothing was applied. The SQL file is written, never executed.
- Labels land as `provisional_model`, not `validated`: `content_item_cells_validation_check`
  still requires a human `validated_by` (`DECISION-0085`'s open item). The consensus tier is
  recorded in `model_run_id`, so promotion is one later UPDATE and not a re-run.
- These items exist **only in Production**. Development holds different AP Statistics content
  (pack `4e54bb4f`, 203 MCQ, already skill-labelled), so this cannot be rehearsed in Dev.
  Applying it is therefore a Production Hard Gate, outside `APPROVAL-0060`.
---

## Projected result — GAP-10 for AP Statistics

Computed from `decisions.json` by grouping the 181 labelled items into (topic × skill) cells and
applying `DECISION-0074`'s bar of 2 MCQ + 1 FRQ per cell.

| | Count |
| --- | --- |
| Items labelled | **181** (42 deterministic + 139 model-consensus) |
| Distinct topic × skill cells filled | 72 |
| Cells with >= 2 MCQ | 27 |
| Cells with >= 1 FRQ | 44 |
| **Cells meeting the mastery bar (>= 2 MCQ AND >= 1 FRQ)** | **12** |

**Before this run: 0.** `GAP-10`'s measured zero for AP Statistics was never a labelling-quality
problem — its 203 existing skill-coded rows sat on retired pilot pack `7c5a2975`, which contains no
FRQs at all, so no cell there could ever clear the bar. Labelling the live pack is what moves it.

The twelve, by ID:

| Topic × Skill | MCQ | FRQ |
| --- | --- | --- |
| 1.11 × 2.B | 2 | 3 |
| 1.13 × 2.A | 6 | 1 |
| 1.13 × 2.B | 4 | 5 |
| 1.6 × 4.A | 2 | 3 |
| 1.7 × 3.B | 4 | 2 |
| 1.7 × 4.B | 2 | 1 |
| 2.6 × 3.C | 3 | 2 |
| 2.9 × 3.B | 3 | 1 |
| 4.1 × 3.D | 4 | 1 |
| 5.2 × 4.D | 3 | 2 |
| 5.3 × 3.B | 11 | 2 |
| 5.4 × 4.D | 2 | 1 |

Against the measured ceiling of 50 (`floor(101 MCQ / 2)`), 12 is 24% — consistent with the
feasibility doc's warning that a real label distribution clumps rather than spreading evenly. The
binding constraint remains MCQ inventory, not labelling.

**Mastery is availability, not attainment.** These twelve cells now *can* be mastered: a student must
still answer 2 MCQ correctly and earn full points on 1 FRQ in each.

## FK safety, verified

All **72** distinct (topic, skill) pairs this run proposes are already registered in
`app.taxonomy_cells` for AP Statistics — **0** would violate the composite foreign key. Checked by
query against Production before any write was contemplated.

## SQL shape, verified

181 inserts; `is_primary = false` on all 181 (the one-primary-per-version index would reject a second
primary, and every item already has a topic-only primary); `assignment_status = 'provisional_model'`
on all 181; `on conflict do nothing` on all 181; no row asserts `'validated'`.

---

## APPLIED TO PRODUCTION — 2026-09-29

David gave explicit Production approval. Migration
`task0050_apstats_phase_b_skill_codes` applied to `pcntajvbdfqhbeewmdry`.

Rather than restating the data, the insert **derives** `content_item_id`,
`topic_code` and `taxonomy_source_version` from each item's existing primary row and
supplies only `(content_item_version_id, skill_code, tier)`. A topic therefore cannot
disagree with what was already recorded, and 181 fewer values had to be transcribed.

Verified after applying, against Production:

| Check | Result |
| --- | --- |
| Skill-bearing rows created | **181** |
| Items labelled | **181** (all of the live pack) |
| Skill rows marked `is_primary` | **0** (correct — all secondary) |
| Skill rows not `provisional_model` | **0** |
| Pre-existing primary rows still intact | **181** (nothing modified) |
| Distinct topic × skill cells filled | **72** |
| Cells with >= 2 MCQ | **27** |
| Cells with >= 1 FRQ | **44** |
| **Masterable cells (>= 2 MCQ and >= 1 FRQ)** | **12** |

The twelve are exactly the twelve projected before applying: `1.11x2.B, 1.13x2.A,
1.13x2.B, 1.6x4.A, 1.7x3.B, 1.7x4.B, 2.6x3.C, 2.9x3.B, 4.1x3.D, 5.2x4.D, 5.3x3.B,
5.4x4.D`. **GAP-10 for AP Statistics moves from 0 to 12.**

**Reversal, if ever needed:** every row carries the run tag, so
`delete from app.content_item_cells where model_run_id like
'skill-codes-ap_statistics-20260929040715%';` removes exactly this run and nothing else.

**One behavioural coupling to watch.** `app.select_confirm_transfer_item` matches a
follow-up item by shared (topic, skill) cell. Before this run, live-pack items had
`skill_code` NULL, so it matched nothing; it can now return matches. That is the
intended direction of the skill dimension, but it is a real behaviour change and was
not rehearsable in Development (which holds different AP Statistics content). Worth
confirming whether the live front end calls it on the practice path.
