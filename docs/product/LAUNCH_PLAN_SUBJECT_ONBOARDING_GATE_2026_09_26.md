# Launch Plan — Subject Onboarding Gate — 2026-09-26

**Status:** Draft, wraps existing work | **Owner:** David Bloom | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`
**Primary source:** `docs/product/SUBJECT_SERVABILITY_CRITERIA.md` — this is already the reusable,
per-subject checklist. This plan does not replace it; it is the wrapper that makes it a repeatable
gate any agent can run per subject, plus the one pipeline dependency that currently blocks 9 of 10
subjects from passing.

## Product Goal

A subject is only advertised as available to students once it has passed all six criteria in
`SUBJECT_SERVABILITY_CRITERIA.md`, verified against live serving RPCs, not inferred from the content
review tool's published-item count. This plan is run once per subject.

**Day-one launch subjects are AP Biology and AP Statistics** (`DECISION-0069`, 2026-09-26). Remaining
subjects fast-follow post-launch as confidence in site performance improves. AP Statistics' criterion-6
hazard, flagged as urgent in this plan's first draft, **is already resolved** — see the second
correction block below.

## The six criteria (do not re-derive; use the source doc)

1. Reviewed/approved (`content_items.status='published'`).
2. Rubric exists (`frq_criteria` / `mcq_choices`).
3. Serving label (`label_status` adequate for the serving path in use).
4. Canonical answer (`canonical_answer_1` or unambiguous MCQ choice).
5. Difficulty value (`app.content_item_difficulty` row, band + basis populated).
6. Exam pack version (exactly one `published`, non-retired version per subject — **check this first**,
   it's a routing hazard even when 1-5 pass).

## CORRECTION, 2026-09-26 (same day, after a second AI review)

The table below has been updated with more current numbers from
`docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`, which already
verified criterion 6 ("Pack singular?") as **Yes** for all 8 non-Statistics subjects and gives current
validated-label counts — re-deriving this from scratch is redundant with work already done. Statistics
remains the one confirmed criterion-6 hazard. Note this table is jointly maintained with
`LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` (that plan owns criteria 3/5 updates; this plan owns
1/2/4/6) — check the other plan's latest edit before overwriting a row.

## CORRECTION #2, 2026-09-26: AP Statistics' criterion-6 hazard was already resolved 2026-09-25

David confirmed (and the repo history verifies) this was resolved **before** this plan's first draft
was written: `docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md` retired the MCQ-only
pilot exam-pack version and confirmed platform-wide exam-pack-version singularity was restored. The
"urgent hazard" framing in this plan's first draft was wrong — it was sourced from
`SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table, which was never updated after the fix. See
`DECISION-0070`. Table corrected below.

## Current status per subject (updated 2026-09-26)

| Subject | Criterion 4 (canonical) | Criteria 3 & 5 (labels/difficulty) | Criterion 6 (exam pack) | Overall |
| --- | --- | --- | --- | --- |
| AP Biology | Closed | Serves via the label-free FRQ path; unit-gated path uses labels promoted under FF-3 (8→141 servable product-wide, 2026-09-24) — re-verify Biology's own current count live, don't assume 0 | Met | Passing today, on the FRQ path confirmed; unit-gated path status needs a fresh live check |
| AP Statistics | Closed (69/69) | Open (64 validated per the 2026-09-25 audit) | **Met — pilot pack retired 2026-09-25, singularity verified restored** | Open on labels/difficulty only; no longer blocked on a David decision |
| AP Calculus AB | Closed (62/62) | Open (9 validated per the 2026-09-25 audit) | **Confirmed Met** (Pack singular: Yes) | Open on labels/difficulty only |
| AP Chemistry | Closed, strict count 51/51 | Open (45 validated per the 2026-09-25 audit) | **Confirmed Met** | Open on labels/difficulty only |
| AP Precalculus | Closed (32 items) | Open (30 validated per the 2026-09-25 audit) | **Confirmed Met** | Open on labels/difficulty only |
| AP Calculus BC | Closed (29 items, 2 defects found/fixed) | Open (4 validated per the 2026-09-25 audit) | **Confirmed Met** | Open on labels/difficulty only |
| AP Physics 1 | Closed (54/54, 1 defect found/fixed) | Open (9 validated per the 2026-09-25 audit) | **Confirmed Met** | Open on labels/difficulty only |
| AP Physics 2 | Closed, strict count 28/28 | Open (10 validated per the 2026-09-25 audit) | **Confirmed Met** | Open on labels/difficulty only |
| AP Physics C: Mechanics | Closed, strict count 36/36 | Open (4 validated per the 2026-09-25 audit) | **Confirmed Met** | Open on labels/difficulty only |
| AP Physics C: E&M | Closed, strict count 49/49 | Open (6 validated per the 2026-09-25 audit) | **Confirmed Met** | Open on labels/difficulty only |

Re-verify before reporting any subject Done — the 2026-09-25 audit is the most current source found,
but content and label state move fast in this repo; don't treat even this table as current truth
without a fresh check on the subject you're actually closing out.

## Acceptance Criteria (per subject; repeat this block for each subject you're assigned)

- [ ] Criterion 6 checked first, live: exactly one `published`, non-retired `exam_pack_versions` row
      for the subject.
- [ ] Criteria 1, 2, 4 verified live for the version actually being served (not just the subject as a
      whole — if criterion 6 fails, criteria 1-5 must be measured per-version).
- [ ] Criteria 3 and 5 verified live; if not met, confirm whether `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`'s
      pipeline has run for this subject yet — if not, this subject is blocked on that plan, not on you.
- [ ] The actual serving RPC(s) for this subject are called directly against Production and the
      returned item count is recorded, with a diagnosed reason for any zero-or-low result (which
      criterion failed), not just a raw count. Note: `select_practice_frqs` hard-caps at 50 rows per
      the 2026-09-25 audit — don't misread a 50-item result as a shortfall when the true count is
      higher.
- [ ] Any model-call-based verification (grader-gate reachability, label agreement) is run 3+ times
      before being trusted.
- [ ] This subject's entry in `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table is updated
      with the current, cited result — dated, with a link to the migration/report that produced it. If
      an earlier count in that table was wrong, correct it visibly (as AP Biology's own doc did) rather
      than silently overwriting it.
- [ ] Subject status is reported back to `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` as Pass / Blocked
      (name the blocking criterion) / Not started.

## Special cases already known

- **AP Statistics:** criterion-6 hazard resolved (see correction #2 above) — no longer a special case,
  do not re-litigate the retire/migrate/stopgap question, it's decided (retired). Also launches on its
  flat/practice serving path per `DECISION-0072` (2026-09-26) — same policy as Biology, not the
  unit-gated path, despite Statistics having the strongest unit-gated coverage of any subject (64
  validated labels, 27 items live across all 5 units). Remaining criteria 3/5 work is not launch-
  blocking for October 2; it matters for whenever unit-gated practice is turned on.
- **AP Biology**: passes today via the label-free FRQ practice path, per `DECISION-0063` (2026-09-24,
  approved) — this is not an open question, it's a recorded launch decision. The unit-gated path
  serves zero and is explicitly deferred (tracked as FF-3), not required for launch.
- **Resolved:** `DECISION-0072` extends `DECISION-0063` to AP Statistics — both Day-1 subjects launch
  flat-path, unit-gating deferred for both. No longer an open question.

## Out of Scope

Deciding which subjects are in the day-one launch set (that's David's call, tracked in the go-live
index) and building the content-pipeline itself (that's `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`).

## Method Note

Call the real serving RPCs against Production. Do not model what they should return from reading SQL —
this exact mistake produced a same-day self-correction in AP Biology's own readiness doc (a "41
servable items" figure that was wrong because it didn't match what the live selector actually checks).
