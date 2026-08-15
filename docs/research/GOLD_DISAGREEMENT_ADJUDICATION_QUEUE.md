# Gold Disagreement Adjudication Queue

**Status:** Adopted — owner-directed 2026-08-13  
**Scope:** Gold-set reader disagreements only. This is a small operational addendum to `GOLD_SET_GENERATION_PROTOCOL.md`; it does not change the initial cold-review rules or the certification metric.

## Purpose

Two independent reader marks are useful evidence, but they are not an authoritative gold label when the readers disagree. This queue turns those disagreements into durable adjudicated outcomes without contaminating the original independent reads.

The original readers do **not** negotiate or adjudicate their own disagreement. Their submitted marks remain immutable evidence.

## Entry rule

Create one queue row for each gold-set element where two qualified cold readers submitted different `present` values after both assignments are locked.

Operational key: `(gold_set_answer_id, gold_set_element_id)`. The table below uses `content_key + answer_type + criterion_key` for readability.

Queue states:

- `OPEN` — disagreement detected; no adjudicator assigned.
- `ASSIGNED` — third qualified subject reviewer assigned.
- `ADJUDICATED` — third cold mark and disposition recorded.
- `ESCALATED` — third reviewer identifies rubric/content ambiguity or cannot resolve the case.
- `CLOSED` — final gold disposition has been incorporated into the frozen gold set or the defective answer/criterion has been excluded and repaired.

## Adjudication procedure

1. **Lock the first two reads.** Jill/Saood (or the applicable first two readers) never see each other's marks before both are submitted.
2. **Third cold read.** Assign a third qualified subject reviewer who was not one of the original two. Show only the question, answer, rubric/element, and ordinary source context. Do **not** show the writer script, machine verifier outputs, grader output, or the first two readers' marks.
3. **Record the third mark first.** The adjudicator records `present` / `absent` plus a short evidence quote or rationale before seeing the disagreement history.
4. **Reveal and classify.** After the third mark is locked, reveal the first two reader marks and classify the case as one of:
   - `FINAL_PRESENT`
   - `FINAL_ABSENT`
   - `RUBRIC_AMBIGUOUS`
   - `GOLD_ANSWER_DEFECT`
   - `RUBRIC_OR_CONTENT_DEFECT`
5. **Escalation rule.** If the third reviewer selects either ambiguity/defect disposition, the row moves to `ESCALATED`. A curriculum/domain owner resolves the rubric/content issue before that element can enter a frozen gold set.
6. **Freeze rule.** Only `FINAL_PRESENT` or `FINAL_ABSENT` may become authoritative gold labels. Ambiguous or defective rows are excluded from grader-accuracy denominators until repaired and re-adjudicated.

### Important measurement rule

Adjudication does **not** rewrite history. Reader-vs-reader disagreement remains reported exactly as observed for pipeline certification. The adjudicated label is used for the frozen regression set and later grader scoring; it must not retroactively make the original reader disagreement disappear from the certification statistics.

## Required row fields

Each durable row should carry:

- `gold_set_answer_id`
- `gold_set_element_id`
- `content_key`
- `answer_type`
- `criterion_key` / element label
- original Reader A id, mark, evidence
- original Reader B id, mark, evidence
- adjudicator id
- adjudicator cold mark + evidence
- disposition
- adjudication rationale
- `status`
- `created_at`, `adjudicated_at`, `closed_at`
- repair/replacement reference when disposition is a defect

No new Production table is required to start. This Markdown queue is the immediate durable operating queue. A database/UI queue should only be added if the volume makes the manual record burdensome.

## Current queue — AP Statistics Set B

Read-only Production snapshot taken 2026-08-13. Jill Schmidlkofer and Muhammad Saood are the two original cold readers. There are **17 disputed element marks across 13 answers** in the current Set B Statistics corpus.

Priority is `P0` for provisional-accept answers because those disagreements affect the candidate certification/frozen-gold path; `P1` covers answers that were already routed to `reader_queue` upstream.

| Priority | Status | Item | Answer | Route | Criterion | Element | Jill | Saood |
|---|---|---|---|---|---|---|---|---|
| P0 | OPEN | APSTATS-SFRQ-001 | A2 | provisional_accept | c1 | Mean ≈23.7 and greater than median | absent | present |
| P1 | OPEN | APSTATS-SFRQ-001 | A3 | reader_queue | c1 | Mean ≈23.7 and greater than median | absent | present |
| P0 | OPEN | APSTATS-SFRQ-001 | A5 | provisional_accept | c1 | Mean ≈23.7 and greater than median | absent | present |
| P0 | OPEN | APSTATS-SFRQ-001 | A6 | provisional_accept | d1 | Removing 41 lowers mean and SD | absent | present |
| P0 | OPEN | APSTATS-SFRQ-002 | A5 | provisional_accept | b1 | Quiz B z-score = 2.5 | present | absent |
| P1 | OPEN | APSTATS-SFRQ-002 | A6 | reader_queue | c1 | Better relative performance on Quiz B | absent | present |
| P0 | OPEN | APSTATS-SFRQ-003 | A1 | provisional_accept | c1 | Prediction = 76.6 | absent | present |
| P1 | OPEN | APSTATS-SFRQ-003 | A4 | reader_queue | c1 | Prediction = 76.6 | present | absent |
| P1 | OPEN | APSTATS-SFRQ-003 | A5 | reader_queue | a1 | +4.1 points per study hour | present | absent |
| P0 | OPEN | APSTATS-SFRQ-004 | A2 | provisional_accept | a1 | +1 screen hour associated with -0.65 sleep hours | present | absent |
| P1 | OPEN | APSTATS-SFRQ-004 | A4 | reader_queue | a1 | +1 screen hour associated with -0.65 sleep hours | present | absent |
| P1 | OPEN | APSTATS-SFRQ-004 | A4 | reader_queue | c1 | Residual -0.25 and slept less than predicted | present | absent |
| P0 | OPEN | APSTATS-SFRQ-004 | A8 | provisional_accept | d1 | 12 hours is outside observed x-range 1–8 | present | absent |
| P1 | OPEN | APSTATS-SFRQ-005 | A4 | reader_queue | d1 | Sample may not represent whole student body | absent | present |
| P0 | OPEN | APSTATS-SFRQ-005 | A5 | provisional_accept | b1 | Undercoverage/self-selection bias | absent | present |
| P0 | OPEN | APSTATS-SFRQ-005 | A8 | provisional_accept | a1 | Convenience or voluntary-response sample | absent | present |
| P1 | OPEN | APSTATS-SFRQ-006 | A4 | reader_queue | c1 | Block on similar baseline anxiety before random assignment | present | absent |

## Immediate use

1. Assign the **P0 rows first** to a third qualified AP Statistics reviewer.
2. The third reviewer completes the cold mark without access to Jill/Saood's marks.
3. Record the disposition and rationale in this file (or its future database-backed successor).
4. Do not freeze the affected answer/element as authoritative gold until its row reaches `CLOSED`.

## Exit condition

The queue is healthy when:

- every detected two-reader disagreement is represented exactly once;
- no `OPEN`/`ASSIGNED` disagreement is silently treated as authoritative gold;
- all `FINAL_PRESENT`/`FINAL_ABSENT` outcomes have a third cold mark and rationale;
- ambiguity/defect dispositions have a repair or explicit exclusion path; and
- certification reports preserve the original disagreement rate separately from adjudicated gold labels.
