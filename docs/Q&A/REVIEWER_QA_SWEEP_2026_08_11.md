# Reviewer QA sweep — 2026-08-11

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Sweep time: `2026-08-11 12:58:21.011384+00`
- Review window: `2026-08-10 02:23:09.980149+00` through the sweep (the prior main sweep's
  marker, `REVIEWER_QA_SWEEP_2026_08_10.md`; the 08-10 gold-set-only addendum used a
  separate, narrower trailing window and is not the marker used here)
- Included activity: human `subject_review` decisions at the `tutor_question` stage
  (`app.content_review_decisions`)
- Active reviewers: reviewers with at least one included submission
- Mode: read-only Production queries; no content records or reviewer decisions were
  modified as part of the sweep itself

The window contained 51 `tutor_question`-stage decisions across 5 reviewers. One of those
five (David) is owner-remediation, not blind review, and is reported separately below,
matching the standing pattern.

## Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Window |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Ahmed Ali | 34 | 5 | 29 | 0 | 34 | 0 | 08-10 11:37 – 08-11 12:57 |
| David (owner remediation) | 5 | 5 | 0 | 0 | 5 | 0 | 08-10 02:34 |
| Sarah Sohail | 5 | 1 | 4 | 0 | 4 | 5 | 08-10 13:57 – 14:58 |
| Chisom Anuba | 4 | 2 | 2 | 0 | 4 | 0 | 08-10 23:12 – 23:40 |
| Muhammad Saood | 3 | 1 | 1 | 1 | 3 | 0 | 08-10 02:23 – 02:25 |

**Four blind-review reviewers active this window** (46 decisions). Shazia Fazal and Adil
Abbasi, both active and fully topic-selection-compliant last window, recorded no activity
this window; Sarah Sohail is back after being absent from the last two sweeps. David's 5
decisions all carry `assignment_purpose='owner_remediation_approval'` and are excluded
from the blind-review total and rates below, same treatment as prior sweeps.

Automated integrity checks (all 51 decisions): 0 reviewer/assignment mismatches, 0
review-stage mismatches, 0 unsubmitted assignments with a submitted decision, 0 missing
content versions, 0 missing/blank stems. Structure checks: 0 reviewed MCQ versions (16
checked) with an invalid choice count (≠4) or correct-answer count (≠1), 0 reviewed FRQ
versions (35 checked) with a zero or non-positive-point criterion. Cross-reviewer double
coverage: none — every version in the window (excluding owner-remediation) was touched by
exactly one reviewer.

## QA signal: P0-B net check — now 16 published/modification_reserved items, up from 9

**Disapproved-but-published cross-check (§6 Phase 7a):** 16 items with `status='published'`
and `review_status IN ('excluded','modification_reserved')` — up from 9 in the 08-10
sweep. All 16 have `review_status='modification_reserved'` (none `excluded`), confirming
this is still the intended re-review-finding path opened by the 08-09 gate fix, not a
recurrence of the P0-B bug. The original 9 are unchanged (no remediation landed on them
this window); 7 are new this window:

| content_key | Subject | Reviewer | Finding (summarized) |
|---|---|---|---|
| `APBIO-MCQ-063` | AP Biology | Sarah Sohail | Names CBC, eIF4E, 43S pre-initiation complex, 5′→3′ exonuclease mechanics — exceeds CED detail level |
| `APBIO-MCQ-067` | AP Biology | Sarah Sohail | Option B rationale overclaims beyond what the stimulus experiments demonstrate |
| `APBIO-MCQ-079` | AP Biology | Sarah Sohail | Option B treats disruptive selection as sufficient for sympatric speciation without reproductive-barrier evidence in the stimulus |
| `apphy1-frq-048` | AP Physics 1 | Ahmed Ali | b-explanation/b-new test the same insight twice (2 points dressed as 3); needs an added graph part |
| `apphy2-mcq-003` | AP Physics 2 | Ahmed Ali | Stem is a sentence fragment; distractor D is a non-plausible throwaway |
| `apphy2-mcq-006` | AP Physics 2 | Chisom Anuba | Option A's correct-answer explanation needs to state field magnitudes are equal/directions opposite, not just "cancel" |
| `apphycm-mcq-012` | AP Physics C: Mechanics | Ahmed Ali | Distractors C/D (Uθ, ∫U dθ) are dimensionally implausible; scope note needed since the CED only states the linear form `F = −dU/dx` |

**All 16 are currently live to students with an open modification finding against them.**
This is the actionable list this sweep surfaces. Unlike the 08-10 batch (8 of 9 from one
reviewer's single pass), this window's 7 new findings come from three different
reviewers across three subjects — reads as ordinary re-review throughput, not a
concentrated pass.

## Disapprovals — 1, independently checkable

- `apphycm-frq-044` (Muhammad Saood): the numeric energy calculation is verified correct
  (`v_max = 2.00 m/s` at 0.100 m compression, `4.00 m/s` at 0.200 m compression, consistent
  with `U_s ∝ x²` and `v_max ∝ x`); the defect is a physical-setup ambiguity — the stimulus
  says the mass is "on a spring" (implying an attached oscillator, which never "leaves the
  spring") but part (a) asks for speed "after leaving the spring" (implying an unattached
  block). Saood's fix — state explicitly which setup is intended — is the correct minimal
  repair. Genuine defect, not a wording nit.

## Ahmed Ali — edit rate 85.3% this window, third data point

Ahmed's 34 decisions this window are 29 `approve_with_edits` / 5 `approve` (85.3% edit
rate) — between his 80% historical baseline (first 20 decisions) and the 100% spike
reported in the 08-10 sweep (30/30). Three consecutive windows now: 80% → 100% → 85.3%.
Reads as an edit-heavy reviewing style with some week-to-week variance around a rate
meaningfully above 80%, not a one-window anomaly — no further action needed, continue
observing.

## Topic-selection compliance

Sarah Sohail is fully compliant this window (5/5). Ahmed Ali (0/34), Chisom Anuba (0/4),
and Muhammad Saood (0/3) recorded zero topic selections — consistent with the standing
gap flagged in every sweep since 08-06. Shazia Fazal and Adil Abbasi, both 100% compliant
last window, had no activity this window so contribute no new data point either way. The
pattern remains binary (0% or 100%) per reviewer, still consistent with a per-reviewer
UI/workflow gap rather than inconsistent individual behavior.

## Follow-ups from the 08-10 sweep — status

- **Partially closed:** of the 4 disapprovals flagged 08-10 for owner adjudication,
  3 (`apphy2-frq-041/043/045`) are now `status='reviewed_disapproved'`,
  `review_status='excluded'` — closed. **`APBIO-MCQ-094` is still open**: unchanged since
  07-28, `status='assigned'`, `review_status=null`, only one version ever created. It was
  never published (so no student-facing exposure), but the disapproval itself has not been
  acted on in two full sweep windows.
- **Not remediated this window:** the 9 published-but-`modification_reserved` items
  surfaced 08-10 (8 AP Biology MCQs/1 FRQ from Adil, 1 Calc AB FRQ from Chisom, 1
  Statistics FRQ from Shazia) — unchanged, still live with open findings; now folded into
  the 16-item list above.
- **Unresolved, now worse:** the topic-selection-compliance gap — same reviewers affected,
  no fix landed.
- Ahmed Ali's edit-rate watch — addressed above (third data point in hand).
- Chisom Anuba's/Abdul Hanan's/Ahmed Ali's gold-set queues — see below; this turned into
  the sweep's most significant finding.

## Gold-set verification — status check, reconciled against a concurrent owner decision

Roster comparison against the 08-10 sweep (main + addendum): Jill Schmidlkofer (66
submitted) and Muhammad Saood (70 submitted) are unchanged. Abdul Hanan is unchanged at 3
submitted (cleared to 0 pending in the 08-10 addendum, still 0 pending / 3 submitted now).

**Ahmed Ali (4 pending as of 08-10) and Chisom Anuba (7 pending as of 08-10) no longer
appear in `app.gold_set_verification_assignments` at all** — a direct query for their
`reviewer_id`s returns zero rows, not zero *pending*. Table total (139) reconciles exactly
to Abdul Hanan (3) + Jill Schmidlkofer (66) + Muhammad Saood (70) with no remainder. This
DB query alone, with `app.audit_events` showing no row for either reviewer under any
`gold_set`-related `object_type`/`metadata`, would read as an unexplained hard-delete —
the same shape as the previously-fixed "Ghazanfar withdrawal orphan" bug (2026-08-08 log
entry), except rows gone entirely rather than stuck.

**It isn't a bug.** This branch (`claude/gold-set-answer-assignments-o3ibgi`) had a
concurrent commit land mid-window (`c60f22c`, 2026-08-11 00:30 UTC, ~12.5 hours before
this sweep's query): an owner decision to pause all gold-set-answer-as-grading-exemplar
work after the exemplar-grading pilot closed inconclusive, which explicitly removed 15
*pending* `app.gold_set_verification_assignments` rows across AP Calculus AB/BC,
Precalculus, and all four AP Physics courses — including Ahmed Ali's and Chisom Anuba's.
See `docs/activity_log/ACTIVITY_LOG.md`, "Cross-Subject Gold-Set Verification Assignments
Paused," for the full rationale. `audit_events` still has nothing for it, since the
removal was a direct, documented DB action outside the normal assignment-lifecycle
application path rather than a reviewer-triggered event — worth remembering as a
non-bug explanation the next time a sweep hits this exact "rows gone, no audit trail"
shape.

## Follow-ups

- Remediate the growing published-but-`modification_reserved` list — now 16 items across
  AP Biology, AP Calculus AB, AP Statistics, AP Physics 1, AP Physics 2, and AP Physics C:
  Mechanics, all live to students with unaddressed findings.
- Close out `APBIO-MCQ-094` — the one 08-10 disapproval that never got owner-adjudicated
  (its three physics siblings from the same window did); low urgency since it was never
  published, but it's been sitting for two sweep windows.
- Owner-adjudicate this window's 1 disapproval (`apphycm-frq-044`) — independently
  checkable and block-worthy as written.
- Continue watching the topic-selection-compliance gap — unresolved for six consecutive
  sweeps now (08-06 through 08-11).
- Watch for Shazia Fazal's and Adil Abbasi's return to activity next window; both were
  100% topic-selection-compliant in their last active window and had zero activity this
  one.
