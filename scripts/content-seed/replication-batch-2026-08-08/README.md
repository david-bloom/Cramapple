# Replication batch — 2026-08-08 (np2)

Owner-directed replication of the BC np1 zero-defect result: a second
new-protocol batch, same authoring + hand-verification process, spanning two
subjects this time, to test whether the result holds.

- **AP Calculus AB**: 10 FRQ (`apcalcab-frq-np2-001..010`) + 10 MCQ
  (`apcalcab-mcq-np2-001..010`), spanning Units 4-8 (the units researched in
  the same-day CED deepening — distinct from the BC np1 batch's Units 1-3
  focus). SQL: `20260808_apcalcab_newprotocol_frq_batch.sql` (items 1-4),
  `20260808_apcalcab_newprotocol_frq_batch_part2.sql` (items 5-10),
  `20260808_apcalcab_newprotocol_mcq_batch.sql` (all 10 MCQ).
- **AP Precalculus**: 10 FRQ (`apprecalc-frq-np2-001..010`) + 10 MCQ
  (`apprecalc-mcq-np2-001..010`), spanning Units 1-3 (the full assessed
  scope). Every FRQ follows the CED's fixed structure exactly: 3 parts, 2
  points each, 6 points total, distributed across the 4 required task models
  (3 Function Concepts, 2 Modeling Non-Periodic, 2 Modeling Periodic, 3
  Symbolic Manipulations). Executed directly against Production via the
  Supabase MCP tool following the identical INSERT pattern as the AB files
  in this directory — no separate .sql file was written for the Precalc half
  of this batch; the exact statements are recorded in the session transcript
  and in `docs/activity_log/ACTIVITY_LOG.md`'s entry for this date.

All 40 items inserted as `status='draft'`, every criterion/answer-key
independently hand-verified by direct computation before insertion (same
standard as np1), then assigned to Abdul Hanan (qualified for AB, BC, and
Precalculus) via `content_review_assignments`
(`review_stage='tutor_question'`, `assignment_purpose='subject_review'`).

Grounding: every FRQ criterion and MCQ distractor traces to a specific
documented misconception, scoring-architecture rule, or exclusion boundary
from the same-day CED deepening work in `docs/product/
AP_CALCULUS_AB_BC_CED_FACT_PACK.md` and `docs/product/
AP_PRECALCULUS_CED_FACT_PACK.md` — e.g. the Candidates-Test-vs-local-test
split (AB Unit 5), average-value-vs-average-rate-of-change confusion (AB
Unit 8), the "r-squared is not valid justification" trap and the
hidden-quadratic-in-e^x rejection requirement (Precalc Unit 2), and the
frequency-to-sinusoidal-parameter-b conversion (Precalc Unit 3).
