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
review tool's published-item count. Since Cramapple is launching with multiple subjects, this plan is
run once per subject, and its output feeds directly into which subjects go into the day-one launch set
(an open question for David — see the go-live index).

## The six criteria (do not re-derive; use the source doc)

1. Reviewed/approved (`content_items.status='published'`).
2. Rubric exists (`frq_criteria` / `mcq_choices`).
3. Serving label (`label_status` adequate for the serving path in use).
4. Canonical answer (`canonical_answer_1` or unambiguous MCQ choice).
5. Difficulty value (`app.content_item_difficulty` row, band + basis populated).
6. Exam pack version (exactly one `published`, non-retired version per subject — **check this first**,
   it's a routing hazard even when 1-5 pass).

## Current status per subject (as of `SUBJECT_SERVABILITY_CRITERIA.md`, 2026-09-25)

| Subject | Criterion 4 (canonical) | Criteria 3 & 5 (labels/difficulty) | Criterion 6 (exam pack) | Overall |
| --- | --- | --- | --- | --- |
| AP Biology | Closed | Not met (0 validated labels; serves via the label-free FRQ path instead) | Met | Passing today, on the FRQ path only — unit-gated path serves 0 |
| AP Statistics | Closed (69/69) | Open | **Live hazard: two published exam-pack versions simultaneously** | Blocked on a David decision (retire pilot pack / migrate-then-retire / verified stopgap) |
| AP Calculus AB | Closed (62/62) | Open | Unconfirmed in this plan — verify live before assuming Met | Open |
| AP Chemistry | Closed, strict count 51/51 | Open (78/123 non-validated) | Unconfirmed — verify live | Open |
| AP Precalculus | Closed (32 items) | Open (30/120 validated) | Unconfirmed — verify live | Open |
| AP Calculus BC | Closed (29 items, 2 defects found/fixed) | Open (4/129 validated) | Unconfirmed — verify live | Open |
| AP Physics 1 | Closed (54/54, 1 defect found/fixed) | Open (115/124 non-validated) | Unconfirmed — verify live | Open |
| AP Physics 2 | Closed, strict count 28/28 | Open (69/79 non-validated) | Unconfirmed — verify live | Open |
| AP Physics C: Mechanics | Closed, strict count 36/36 | Criterion 3 covered by a pending relabel order; 5 open | Unconfirmed — verify live | Open |
| AP Physics C: E&M | Closed, strict count 49/49 | Open (97/103 non-validated) | Unconfirmed — verify live | Open |

Treat this table as a starting point, not current truth — re-verify against live systems before
reporting any subject's status, per the method note below and the doc's own repeated finding that
counts go stale fast.

## Acceptance Criteria (per subject; repeat this block for each subject you're assigned)

- [ ] Criterion 6 checked first, live: exactly one `published`, non-retired `exam_pack_versions` row
      for the subject.
- [ ] Criteria 1, 2, 4 verified live for the version actually being served (not just the subject as a
      whole — if criterion 6 fails, criteria 1-5 must be measured per-version).
- [ ] Criteria 3 and 5 verified live; if not met, confirm whether `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`'s
      pipeline has run for this subject yet — if not, this subject is blocked on that plan, not on you.
- [ ] The actual serving RPC(s) for this subject are called directly against Production and the
      returned item count is recorded, with a diagnosed reason for any zero-or-low result (which
      criterion failed), not just a raw count.
- [ ] Any model-call-based verification (grader-gate reachability, label agreement) is run 3+ times
      before being trusted.
- [ ] This subject's entry in `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table is updated
      with the current, cited result — dated, with a link to the migration/report that produced it. If
      an earlier count in that table was wrong, correct it visibly (as AP Biology's own doc did) rather
      than silently overwriting it.
- [ ] Subject status is reported back to `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` as Pass / Blocked
      (name the blocking criterion) / Not started.

## Special cases already known

- **AP Statistics**: do not touch the dual-published-exam-pack-version hazard without a David decision
  first — this is a Hard Gate (a wrong choice here could break the 51+ live student sessions already
  served against the current working pack).
- **AP Biology**: passes today only through the label-free FRQ practice path; the unit-gated path
  serves zero. If unit-gated practice is part of the launch experience, Biology is not actually fully
  passing — flag this distinction rather than reporting a blanket "Biology: Done."

## Out of Scope

Deciding which subjects are in the day-one launch set (that's David's call, tracked in the go-live
index) and building the content-pipeline itself (that's `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`).

## Method Note

Call the real serving RPCs against Production. Do not model what they should return from reading SQL —
this exact mistake produced a same-day self-correction in AP Biology's own readiness doc (a "41
servable items" figure that was wrong because it didn't match what the live selector actually checks).
