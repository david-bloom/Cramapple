# AP Biology Launch Readiness — 2026-09-24

Measured against the six conditions in `AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md`, all figures
queried from Production after today's M0–M4 and the M2.1/M2.2 repairs.

## The number that matters

**Biology can serve 41 of its 118 published items.** 22 FRQ and 19 MCQ, spread across all eight
units (u1:2 u2:9 u3:2 u4:5 u5:5 u6:9 u7:6 u8:3).

That is the launch-relevant figure, and it is not one of the six conditions — which is itself worth
noting. The plan's definition of done measures *content completeness*; it never asks whether a
student can be given the content. Those turned out to be very different questions.

| Why an item is not servable | Items |
| --- | ---: |
| No current serving label at all (last written 2026-08-08) | 43 |
| Serving label whose taxonomy hash predates today and does not match | 24 |
| Serving label `held` with empty `required_units` | 6 |
| Hand-drawn, excluded from text serving by design | 4 |

The serving selector requires `label.validated_against_taxo_hash = taxonomy_relevant_hash(version)`
and **fails silently** — a mismatch returns fewer rows, never an error.

---

## The six conditions

| # | Condition | Status |
| --- | --- | --- |
| 1 | Every published FRQ has a canonical answer and stored segmentation | **Not met** — 4 short |
| 2 | Every item carries a ratified topic label better than `provisional_model` | **Not met by design** |
| 3 | Every item carries a ratified difficulty value | **Not met** — 0 of 118 |
| 4 | No open high-severity QA finding | **Not met** |
| 5 | Grader gate run against the **applied** canonicals | **Not met, and now unreachable** |
| 6 | The 4 hand-drawn items have an explicit disposition | **Met** |

### 1 — Canonical answers and segmentation

70 of 75 FRQ carry a canonical; 67 carry segmentation (548 spans). Outstanding:

- `APBIO-FRQ-S-101` — no canonical. Held: clears the grader gate on 1 of 3 runs. The cause is a
  rubric defect (criterion `a-iv` spans two stem sub-parts), which needs a Product Owner call.
- `APBIO-FRQ-S-021`, `-023`, `-058` — canonical present but no spans. Held: work order F drafted
  over their published text rather than assembling it, which would have deleted 104, 100 and 138
  characters of live content.

### 2 — Topic labels

112 `provisional_model` + 6 `held`. The condition asks for *better than* `provisional_model`, so it
fails by construction. DECISION-0062 deliberately chose this: promotion to `validated` is gated on
the unresolved T9/T6.b vs DECISION-0055 question, and the schema makes `validated` unreachable
without a named validator. **This is a deferred decision, not an unfinished task.**

### 3 — Difficulty

`app.content_item_difficulty` exists and is empty. 0 of 118 items carry a difficulty value anywhere.
Blocked on Codex work order J.0 (regenerate Biology difficulty emitting `attainment_ratio`).

### 4 — Open high-severity findings

- `A-QA-001` — `APBIO-FRQ-S-073`, criterion `a`: the only item A's QA did not accept.
- `TL-061` / `TL-062` — `APBIO-FRQ-L-008`, `APBIO-FRQ-S-071` mislabelled `1.1`; should be `2.7`.
  Now `held`, so they carry no topic at all. One-line fix on Product Owner word.
- `QA2-070/072/074/076` — the 4 hand-drawn items cannot have a text canonical. Dispositioned under
  condition 6, so arguably closed rather than open.
- `M1-B-001` — `S-101`, above.
- **New, from this assessment:** 24 serving labels with a pre-existing hash mismatch, and 43 items
  with no serving label. Neither was previously recorded.

### 5 — Grader gate against applied canonicals

**M1 closed this window.** The gate refuses any item with a canonical present
(`canonical_answer_already_present`, verified by probe after M1). So:

- `S-102` and `S-103` — the M5 baseline graded the exact text M1 later applied: 4/4 and 5/5. That is
  genuine evidence, and it exists only because the baseline was captured first.
- `S-101` — still reachable, and still failing 2 runs in 3.
- **The other 65 can never be measured through this path.** They already had canonicals before this
  program began (recorded as F-QA-002), and now so do the rest.

Meeting this condition requires widening the gate's guard — a change to `evaluate-attempt`.

**What this does and does not risk.** `evaluate-attempt` selects `stem, stimulus, prompt_json,
rubric_type, evaluator_strategy, explanation, help_text, content_hash` — **not** the canonical
answer. Verified by reading the function. So an unverified canonical cannot mis-grade a student. It
can mislead wherever the canonical *is* read: `review-decision`, and any future Open Hand surface
that strikes text using the spans. That is a smaller blast radius than it first appears, and it
should be stated rather than assumed.

### 6 — Hand-drawn disposition

Met. One correction to the plan's record: Production shows all four at `review_status =
question_review_approved` and `evaluator_strategy = human_shadow` — **not** the split the plan
described (`human_graded_pilot_approved` for `-002`, `ai_provisional_unapproved` for the others).
`human_shadow` is dev/calibration-only and never a live grading fallback, so all four score nothing
in production today.

---

## What launch actually needs, in order

1. **Serving coverage.** 41 of 118 is the binding constraint and no condition tracks it. The 43
   items with no serving label are the largest single block, and the label run is seven weeks old.
2. **Difficulty (J.0)** — Codex, already queued.
3. **The 4 held FRQ** — S-101 needs a rubric decision; S-021/023/058 need a call on whether drafting
   over published text is acceptable.
4. **Topic-label promotion** — only if coverage reporting is wanted before launch. It gates T8, not
   serving.
5. **The 2 osmosis corrections** — one line, on your word.

## Method note

Everything above was queried from Production rather than read from the plan. Two of the findings —
the serving-label hash mismatch and the coverage-label staling — were *caused by today's own
migrations* and were invisible until counted. Both are repaired; the pre-existing 24 and the missing
43 are not, and are not mine to assume.
