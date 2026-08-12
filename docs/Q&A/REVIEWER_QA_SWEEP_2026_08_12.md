# Reviewer QA sweep — 2026-08-12

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Sweep time: `2026-08-12 11:00:13.643416+00`
- Review window: `2026-08-10 02:23:09.980149+00` through the sweep (the prior sweep's
  marker, `REVIEWER_QA_SWEEP_2026_08_10.md`)
- Included activity: human `subject_review` decisions at the `tutor_question` stage
  (`app.content_review_decisions`)
- Active reviewers: reviewers with at least one included submission
- Mode: read-only Production queries; no content records or reviewer decisions were
  modified as part of the sweep itself

The window contained 101 `tutor_question`-stage decisions across 5 reviewers. One of
those five (David) is owner-remediation, not blind review, and is reported separately
below, matching the pattern of every prior sweep.

## Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Window |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Ahmed Ali | 50 | 8 | 41 | 1 | 50 | 0 | 08-10 11:37 – 08-11 13:38 |
| David (owner remediation) | 29 | 29 | 0 | 0 | 29 | 0 | 08-10 02:34 – 08-11 13:38 |
| Sarah Sohail | 15 | 2 | 12 | 1 | 13 | 0 | 08-10 13:57 – 08-11 22:31 |
| Chisom Anuba | 4 | 2 | 2 | 0 | 4 | 0 | 08-10 23:12 – 23:40 |
| Muhammad Saood | 3 | 1 | 1 | 1 | 3 | 0 | 08-10 02:23 – 02:25 |

**Sarah Sohail is new to the blind-review roster this window** — first appearance in any
sweep to date, 15 decisions, all AP Biology MCQ. **Four blind-review reviewers active this
window** (72 decisions) — down from six in 08-10, but the drop is concentrated in Abdul
Hanan and Shazia Fazal going fully quiet (0 decisions each, both fully compliant on topic
selections last window) rather than a broad falloff. David's 29 decisions all carry
`assignment_purpose='owner_remediation_approval'` and are excluded from the blind-review
total and rates below, same treatment as every prior sweep.

Automated integrity checks (all 101 decisions): 0 reviewer/assignment mismatches, 0
review-stage mismatches, 0 unsubmitted assignments with a submitted decision, 0 missing
content versions, 0 missing stems. Structure checks: 0 reviewed MCQ versions (55 checked)
with an invalid choice count (≠4) or correct-answer count (≠1), 0 reviewed FRQ versions
(43 checked) with a zero or non-positive-point criterion. Cross-reviewer double coverage:
3 versions touched by two different reviewers each (`apphycem-frq-056`, `apphycm-frq-049`,
`apphycm-frq-047`) — not zero this window, but small and not concentrated in one
reviewer pair; worth a spot-check next sweep if the pattern repeats.

## QA signal: P0-B net check jumps to 17 — concentrated in two reviewers' first passes

**Disapproved-but-published cross-check (§6 Phase 7a):** 17 items with
`status='published'` and `review_status IN ('excluded','modification_reserved')` — up
from 9 in the 08-10 sweep and 0 in the two sweeps before that. All 17 are from decisions
inside this window (none carried over), and all 17 are `approve_with_edits` or
`disapprove` findings against previously-published content, same mechanism as 08-10:
the 08-09 gate fix lets re-review findings on published items get written down instead
of erroring out.

| content_key | Subject | Reviewer | Finding (summarized) |
|---|---|---|---|
| `APBIO-MCQ-043` | AP Biology | Sarah Sohail | Overstates "genetically identical"/"always maintains" claims for mitosis |
| `APBIO-MCQ-054` | AP Biology | Sarah Sohail | "Blending of expression levels" phrasing risks reading as blending inheritance |
| `APBIO-MCQ-056` | AP Biology | Sarah Sohail | Stem assumes specific parental genotypes without stating them |
| `APBIO-MCQ-084` | AP Biology | Sarah Sohail | Minor precision issues in a distractor rationale (sympatric speciation) |
| `APBIO-MCQ-086` | AP Biology | Sarah Sohail | **Disapproved** — stimulus factually wrong: lampreys are vertebrates, not exceptions |
| `APBIO-MCQ-088` | AP Biology | Sarah Sohail | Implies relatedness guarantees the altruistic allele is carried |
| `APBIO-MCQ-093` | AP Biology | Sarah Sohail | Rationale overstates evidence ("entire community structure collapses") |
| `APBIO-MCQ-097` | AP Biology | Sarah Sohail | r/K selection presented too rigidly vs. modern life-history-continuum framing |
| `APBIO-MCQ-099` | AP Biology | Sarah Sohail | Rationale claims causal certainty ("confounders were controlled") the stimulus doesn't support |
| `apphy1-mcq-021` | AP Physics 1 | Ahmed Ali | All three distractors fail dimensional analysis (own rationales admit it) |
| `apphy2-mcq-010` | AP Physics 2 | Ahmed Ali | Two distractors dimensionally invalid (qv/B, qB/v) |
| `apphy2-mcq-013` | AP Physics 2 | Ahmed Ali | Stem/answer mismatch on what varies at the air–glass boundary |
| `apphycem-mcq-012` | AP Physics C: E&M | Ahmed Ali | Flagged best-aligned item in its cluster, minor edit only |
| `apphycem-mcq-016` | AP Physics C: E&M | Ahmed Ali | Stem promises integral form but shows differential-form (∇·B) options |
| `apphycm-mcq-006` | AP Physics C: Mechanics | Ahmed Ali | Two distractors dimensionally impossible; near-duplicate of `apphycm-mcq-012` |
| `apphycm-mcq-014` | AP Physics C: Mechanics | Ahmed Ali | All three distractors dimensionally incoherent — tests recall, not reasoning |
| `apphycm-mcq-020` | AP Physics C: Mechanics | Ahmed Ali | Stem doesn't define variables used in the answer (d, I) |

**All 17 are currently live to students with an open modification (or exclusion)
finding against them.** 9 of 17 are Sarah Sohail's first-ever pass through AP Biology
MCQs (8 `approve_with_edits`, 1 `disapprove`); 8 of 17 are Ahmed Ali's first pass through
his non-Physics-1-FRQ queue this window — all Physics MCQ, all flagging dimensional-
analysis defects in distractors, a sharply consistent failure mode across four different
Physics subjects. This reads as two reviewers doing exactly what re-review is for, not
noise — but the volume (nearly double 08-10's) and the concentration of one specific
defect type (non-functional distractors failing dimensional analysis) across an entire
Physics MCQ pass is worth a targeted remediation batch rather than one-off fixes.

## Disapprovals — 3, all independently checkable

- `apphycm-frq-044` (Muhammad Saood): energy/velocity calculation is internally
  consistent through v_max = 2.00 m/s, but the note flags the doubled-compression
  follow-up (quadrupled spring energy) as not correctly carried through the rubric.
- `apphycem-mcq-011` (Ahmed Ali): pure symbol recall with no reasoning step; third
  time-constant item in the bank alongside `apphycem-mcq-010` and `mcq-017` — a
  duplication/depth concern, not just a wording nit.
- `APBIO-MCQ-086` (Sarah Sohail): stimulus asserts lampreys lack a vertebral column;
  lampreys are vertebrates (Agnatha) — factually incorrect stimulus, independently
  checkable against the AP Biology CED (Unit 7, Topic 7.9).

## New reviewer: Sarah Sohail

First sweep appearance. 15 decisions, all AP Biology MCQ, 80% edit rate (12/15), 1
disapprove, 9 of her 15 decisions are the published-content re-review findings in the
table above. Notes are substantive and specific (blending-inheritance terminology,
CED-topic misalignment, evidentiary overreach in rationales) — reads as a real first
pass, not boilerplate. No baseline to compare against yet; next sweep is the first
opportunity for a trend read.

## Ahmed Ali — sustained 100%+ edit-heavy pattern, now with a Physics MCQ pass

Continuing the pattern flagged in 08-10 (100% edit rate that window vs. 80% historical,
all Physics FRQ): this window Ahmed's 50 decisions are 82% `approve_with_edits` (41/50),
16% approve (8/50), 2% disapprove (1/50) — and unlike 08-10, this window includes his
first MCQ pass (the 8 dimensional-analysis findings above), not just FRQ. The edit rate
easing off 100% back toward the historical 80% range is consistent with the FRQ-only
subset continuing as before; the MCQ pass is new territory this window, not yet enough
data to characterize on its own.

## Topic-selection compliance

0 topic selections across all 101 decisions this window (all five reviewers, including
David). This extends the 0%-across-active-reviewers pattern from 08-10 (where 4 of 6
reviewers were at 0%) to all reviewers active this window — Shazia Fazal and Abdul Hanan,
the two 100%-compliant reviewers in 08-10, recorded no decisions at all this window, so
there is no compliant reviewer left in the sample to contrast against. Still reads as a
workflow/UI gap rather than reviewer behavior, per the 08-10 finding, but worth confirming
directly with Shazia or Abdul next time either is active, since they're the only two
data points that ever showed 100%.

## Follow-ups from the 08-10 sweep — status

- **Not closed:** remediate the 9 published-but-`modification_reserved` items from 08-10
  — no evidence in this window's data that they were addressed; the count only grew
  (see the 17-item table above, which is a new, non-overlapping set from this window).
- **Not closed:** owner-adjudicate the 08-10 sweep's 4 disapprovals (`APBIO-MCQ-094`,
  `apphy2-frq-041/043/045`) — not independently re-checked this sweep.
- **Not checked this sweep:** the `-np1-` sign/reference-convention and normal-force-at-
  N=0 items carried forward since 08-09/08-10 — no new `-np1-` activity this window either.
- **Partially addressed:** topic-selection-compliance gap — see above; the compliant
  reviewers went quiet rather than the gap closing.
- **Confirmed, not resolved:** Ahmed Ali's edit-rate pattern is now a third data point
  (80% historical → 100% on 08-10 → 82% with a new MCQ pass this window) — reads as
  stable edit-heavy reviewing with normal window-to-window noise, not a runaway trend.
  Treat as his baseline going forward rather than something to keep watching.

## Gold-set verification — status check

Reviewer roster changed again this window: **Ghazanfar Ali is new to the gold-set-
verification roster** (54 pending, 0 submitted — no first submission yet). Muhammad
Saood 34 pending / 90 submitted (up from 70 submitted, unchanged-pending baseline —
he's both clearing his queue and being assigned more). Chisom Anuba jumped from 7
pending (unchanged for three consecutive sweeps per 08-10's follow-up) to **45 pending**
— a large new assignment batch landed, not the stale queue itself moving. Jill
Schmidlkofer 0 pending / 70 submitted (up from 66 — she kept working past her "closed
out" state from 08-10). Abdul Hanan cleared to 0 pending / 46 submitted (was 3 pending
/ unreported submitted in 08-10 — now fully caught up and then some). Ahmed Ali, new to
this roster in 08-10 with 4 pending, no longer appears at all — worth confirming whether
his assignments were reassigned or completed off-sweep.

**New this sweep:** the gold-set corpus itself now has a subject-by-criterion-structure
breakdown, added to the protocol document rather than repeated here each time — see
`docs/research/GOLD_SET_GENERATION_PROTOCOL.md` §8 for the full table (answers created /
assigned / reviewed per subject, split by single- vs. multi-point criterion structure).
Two findings from that table worth surfacing here: **AP Precalculus has 44 answers
created but only 1 assignment** (43 answers with no reviewer assigned at all — the
largest unassigned backlog in the corpus), and **AP Physics C: Mechanics has 0 of 28
assignments reviewed** (fully generated, essentially unstarted on the reader side).

## Follow-ups

- Remediate the 17 published-but-flagged items surfaced by this sweep's P0-B net check
  (table above) — 9 AP Biology MCQs from Sarah Sohail (1 outright factual error), 8
  Physics MCQs from Ahmed Ali (all dimensional-analysis distractor defects) — all
  currently live to students.
- The dimensional-analysis distractor pattern across Ahmed Ali's 8 Physics MCQ findings
  spans four subjects (Physics 1, Physics 2, C: E&M, C: Mechanics) — worth a scripted
  scan for the same defect class across the rest of the Physics MCQ bank rather than
  waiting for reviewers to find each instance individually.
- Owner-adjudicate this window's 3 disapprovals (`apphycm-frq-044`, `apphycem-mcq-011`,
  `APBIO-MCQ-086`) — all independently checkable.
- Carry forward the still-unremediated 08-10 P0-B items (9) and 08-10 disapprovals (4) —
  neither shows evidence of being addressed this window.
- Assign reviewers against the 43 unassigned AP Precalculus gold-set answers
  (`GOLD_SET_GENERATION_PROTOCOL.md` §8) — the largest unassigned backlog in the corpus.
- Start a reviewer pass on AP Physics C: Mechanics gold-set answers (28 assigned, 0
  reviewed) — generation there is complete but verification hasn't started.
- Confirm whether Ahmed Ali's gold-set-verification assignments (4 pending as of 08-10)
  were completed or reassigned — he no longer appears on the roster this window.
- Watch Chisom Anuba's gold-set-verification queue — jumped from a stale 7 pending to 45
  pending; confirm this is a fresh assignment batch and not a backlog re-count.
- Confirm with Shazia Fazal or Abdul Hanan directly whether topic selections are being
  made and dropped somewhere, since they're the only two reviewers who have ever shown
  100% compliance and both were inactive this window.

## Remediation (2026-08-12, post-sweep)

The 17 published-but-flagged items and this window's 3 disapprovals are closed.
`scripts/content-seed/reviewer-qa-remediation/20260812_p0b_flagged_batch_repair.sql`
repaired and republished 17 items (9 AP Biology MCQs — Sarah Sohail's requested wording
softenings, plus a full rewrite of `APBIO-MCQ-086` fixing the lamprey/vertebrate factual
error and removing out-of-scope cladistics jargon; 8 Physics MCQs — Ahmed Ali's own
specified dimensionally-consistent distractor replacements, transcribed verbatim rather
than re-derived) and closed a 19th item (`apphycem-mcq-012`) with a no-content-change
re-approval (Ahmed flagged it with no stated defect). `apphycm-mcq-011`'s disapproval had
landed on an already-superseded version (created 07-20, superseded 08-08 before his
08-11 review) — the live content carried the identical bare-symbol-recall defect, rebuilt
as an applied RC-discharge computation per his spec. `apphycm-frq-044` was already
independently repaired 2026-08-11 (confirmed, no action needed). Post-repair: the P0-B
net check (`status='published'` AND `review_status IN ('excluded','modification_reserved')`)
is 0 rows across the entire corpus, not just this window's items.

**Not done, carried forward:** the 08-10 sweep's 9 P0-B items and 4 disapprovals remain
unaddressed — out of scope for this remediation pass, which targeted only the 08-12
sweep's findings. The Physics MCQ dimensional-analysis defect-pattern scan (follow-up
above) was not run against the rest of the bank; this pass fixed only the 8 items Ahmed
already found by hand.
