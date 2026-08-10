# Reviewer QA sweep — 2026-08-10

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Sweep time: `2026-08-10 02:23:09.980149+00`
- Review window: `2026-08-09 03:14:45+00` through the sweep (the prior sweep's marker,
  `REVIEWER_QA_SWEEP_2026_08_09.md`)
- Included activity: human `subject_review` decisions at the `tutor_question` stage
  (`app.content_review_decisions`)
- Active reviewers: reviewers with at least one included submission
- Mode: read-only Production queries; no content records or reviewer decisions were
  modified as part of the sweep itself

The window contained 227 `tutor_question`-stage decisions across 7 reviewers. One of
those seven (David) is owner-remediation, not blind review, and is reported separately
below, matching the 08-08/08-09 pattern.

## Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Window |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Ahmed Ali | 30 | 0 | 30 | 0 | 30 | 0 | 08-09 04:03 – 07:18 |
| Muhammad Saood | 28 | 3 | 22 | 3 | 28 | 0 | 08-09 03:14 – 08-10 02:22 |
| Abdul Hanan | 23 | 14 | 9 | 0 | 16 | 0 | 08-09 13:37 – 14:21 |
| Shazia Fazal | 19 | 17 | 2 | 0 | 3 | 19 | 08-09 17:07 – 19:55 |
| Adil Abbasi | 19 | 2 | 16 | 1 | 19 | 19 | 08-09 13:28 – 15:07 |
| Chisom Anuba | 4 | 0 | 4 | 0 | 4 | 0 | 08-09 19:04 – 19:40 |
| David (owner remediation) | 104 | 104 | 0 | 0 | 104 | 0 | 08-09 03:26 – 20:16 |

**Six blind-review reviewers active this window** (123 decisions) — the thin, 1-reviewer
window from 08-09 has recovered; back to 08-08-scale coverage. David's 104 decisions all
carry `assignment_purpose='owner_remediation_approval'` and are excluded from the
blind-review total and rates below, same treatment as the last two sweeps.

Note: `tutor_decision` label is null on 75 of the 227 rows (all pre-existing decisions
written before the 08-09 `review-decision` label-persistence fix landed at 14:47 that day);
counts above use `tutor_score` (1/2/3 → approve/edits/disapprove) as a fallback wherever
the label is null, since `tutor_score` was always written correctly.

Automated integrity checks (all 227 decisions): 0 reviewer/assignment mismatches, 0
review-stage mismatches, 0 unsubmitted assignments with a submitted decision, 0 missing
content versions, 0 missing stems. Structure checks: 0 reviewed MCQ versions (93 checked)
with an invalid choice count (≠4) or correct-answer count (≠1), 0 reviewed FRQ versions
(134 checked) with a zero or non-positive-point criterion. Cross-reviewer double coverage:
none — every version in the window was touched exactly once.

## QA signal: P0-B net check is no longer 0 — and that's the fix working, not a regression

**Disapproved-but-published cross-check (§6 Phase 7a):** 9 items with `status='published'`
and `review_status IN ('excluded','modification_reserved')` — the first non-zero reading
across the three most recent sweeps (08-08 and 08-09 both reported 0).

This is not a recurrence of the P0-B publish-gate bug. It's the direct, intended
consequence of the 08-09 gate fix (`c4ce88a`, deployed 14:47): before that fix, the gate
blocked *any* update that touched `review_status` on already-published content, including
legitimate re-review findings — so a reviewer flagging a published item as needing
modification would error out and never get recorded. The fix narrowed the gate to only
fire on the transition *into* `published`, which unblocked those re-review decisions —
and this window's data is the first sweep to see them land. All 9 have
`review_status='modification_reserved'` (none `excluded`) and are genuine
`approve_with_edits` findings from this window's reviewers against previously-published
content:

| content_key | Subject | Reviewer | Finding (summarized) |
|---|---|---|---|
| `apcalcab-frq-012` | AP Calculus AB | Chisom Anuba | u-substitution technique/limits-of-integration clarifications for parts a–c |
| `APSTAT-MOD4-M001` | AP Statistics | Shazia Fazal | 1-pt criterion bundles 4 requirements with no minimum fix — scoring ambiguity |
| `APBIO-FRQ-L-025` | AP Biology | Adil Abbasi | Format mismatch — reads as Long FRQ but has no investigation/data-plot content AP requires |
| `APBIO-MCQ-074` | AP Biology | Adil Abbasi | Stem tests recall, not SP1/SP6; only 1 of 3 distractors functional |
| `APBIO-MCQ-069` | AP Biology | Adil Abbasi | Stem/distractor mismatch; missing exon diagram image |
| `APBIO-MCQ-046` | AP Biology | Adil Abbasi | Non-functional distractor; stimulus wording nearly gives away the answer |
| `APBIO-MCQ-025` | AP Biology | Adil Abbasi | Rubric chain too long; off-CED aldosterone/ENaC reference in a distractor rationale |
| `APBIO-MCQ-033` | AP Biology | Adil Abbasi | Nomenclature density too high; one non-functional distractor |
| `APBIO-MCQ-030` | AP Biology | Adil Abbasi | Two non-functional distractors, effectively a 2-option item |

**All 9 are currently live to students with an open modification finding against them** —
this is the real actionable list this sweep surfaces, not a bug report. 8 of 9 are Adil
Abbasi's AP Biology pass; this reads as Adil doing exactly what re-review is for
(independently re-checking already-published content and catching what first review
missed), now that the gate lets those findings actually get written down.

## Disapprovals — 4, all independently checkable

- `APBIO-MCQ-094` (Adil Abbasi): succession/climax-community content is not CED-aligned
  for Unit 8; also has a 100-vs-25-word length-cue defect (matches the biology
  length-parity pattern flagged in the 08-09 sweep).
- `apphy2-frq-041` (Saood): rubric doesn't assess the actual calorimetry procedure/energy-
  conservation equation needed; independent-variable framing is unnecessarily restrictive.
- `apphy2-frq-043` (Saood): net work/efficiency has no unique signed answer without a
  stated cycle direction (clockwise/counterclockwise) — rubric needs the direction pinned.
- `apphy2-frq-045` (Saood): rubric never actually assesses `E = ma/|q|`; "tools to observe
  motion" is too vague to yield a measurable field.

All four read as genuine, specific defects (missing governing equation/procedure or a
real ambiguity), not wording nits — same character as the two disapprovals in the 08-09
sweep, both of which were owner-adjudicated this window (see Follow-ups closed, below).

## Ahmed Ali — 100% edit rate this window vs. 80% historical

Ahmed's 30 decisions this window (13 Physics 1 FRQ, 4 Physics 2 FRQ, 6 C:E&M FRQ, 7
C:Mechanics FRQ) are **100% `approve_with_edits`, 0% straight approve** — up from an 80%
edit / 20% approve split across his 20 prior decisions. Every note is substantive (spot-
checked several: precision/units clarifications, missing-assumption call-outs), not
boilerplate, so this reads as a continuation of an already edit-heavy reviewing style
intensifying, not a new anomaly — but worth watching for a third data point before treating
100% as his new normal.

## Topic-selection compliance

Shazia Fazal (19/19) and Adil Abbasi (19/19) are fully compliant this window. Ahmed Ali
(0/30), Muhammad Saood (0/28), Abdul Hanan (0/23), and Chisom Anuba (0/4) recorded zero
topic selections — the Saood regression flagged in the 08-06/08-08/08-09 sweeps now
extends to three more reviewers. This looks like a per-reviewer UI/workflow gap rather
than random noise: it's binary (0% or 100%) across every reviewer, not partial compliance.

## Follow-ups from the 08-09 sweep — status

- **Closed:** both `-np1-` disapprovals owner-adjudicated —
  `apphycem-frq-np1-008` and `apphycem-mcq-np1-007` are now `status='reviewed_disapproved'`,
  `review_status='excluded'`.
- **Closed:** Jill Schmidlkofer's gold-set-verification queue, unchanged for two sweeps at
  30 pending / 36 submitted, is now **0 pending / 66 submitted** — she cleared it this
  window.
- **Still open:** the 5 still-published pasted-prompt-rubric FRQs
  (`apphy2-frq-002/003/005`, `apphycem-frq-008/009`) are unchanged —
  `status='published'`, `review_status='question_review_approved'`, `updated_at`
  timestamps from 08-08, no remediation landed this window. Same defect class as the 63
  already fixed; still missed.
- **Not independently checked this sweep:** the sign/reference-convention instruction for
  the E&M `-np1-` pool, the normal-force-at-N=0 template scan, and the
  `apphycem-frq-np1-004` 124.680-vs-124.666 recomputation — no new `-np1-` activity
  occurred this window to check against, and no scan was run; carrying forward.
- **Not checked this sweep:** AP Biology MCQ length-parity draft routing status (still
  drafts per `docs/research/AP_BIOLOGY_MCQ_LENGTH_PARITY_REMEDIATION_2026_08_09.md`, not
  independently re-verified this window).

## Gold-set verification — status check

Reviewer roster expanded this window (Abdul Hanan and Ahmed Ali added,
`docs/activity_log` / `scripts/content-seed/reviewer-management/20260809_gold_set_flags_and_pairing.sql`):
Jill Schmidlkofer 0 pending / 66 submitted (closed out — was 30/36), Muhammad Saood 70
submitted (unchanged), Chisom Anuba 7 pending (unchanged), Abdul Hanan 3 pending (new),
Ahmed Ali 4 pending (new).

## Follow-ups

- Remediate the 9 published-but-`modification_reserved` items surfaced by this sweep's
  P0-B net check (table above) — 8 AP Biology MCQs/1 FRQ from Adil, 1 Calc AB FRQ from
  Chisom, 1 Statistics FRQ from Shazia — all currently live to students with an
  unaddressed modification finding.
- Remediate the still-open 5 pasted-prompt-rubric FRQs
  (`apphy2-frq-002/003/005`, `apphycem-frq-008/009`) — carried over from 08-09, still
  untouched.
- Owner-adjudicate this window's 4 disapprovals (`APBIO-MCQ-094`, `apphy2-frq-041/043/045`)
  — all independently checkable and block-worthy as written.
- Investigate the topic-selection-compliance gap now affecting 4 of 6 active reviewers
  (Ahmed Ali, Saood, Abdul Hanan, Chisom Anuba at 0%; Shazia Fazal, Adil Abbasi at 100%) —
  the binary pattern suggests a workflow/UI gap specific to whichever review path the
  0%-group uses, not inconsistent individual behavior.
- Watch Ahmed Ali's edit rate (100% this window vs. 80% historical) for a third data point
  before concluding it's a durable shift.
- Chisom Anuba's gold-set-verification queue (7 pending) is now unchanged for three
  consecutive sweeps — confirm whether this is a scheduling gap.
- Abdul Hanan (3 pending) and Ahmed Ali (4 pending) are new to the gold-set-verification
  roster this window — watch for first submissions next sweep.
