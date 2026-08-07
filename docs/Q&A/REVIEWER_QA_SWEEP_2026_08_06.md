# Reviewer QA sweep — 2026-08-06

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Sweep time: `2026-08-06 15:02:34+00`
- Review window: `2026-08-05 21:14:52+00` through the sweep
- Window rule: the later of 24 hours before the sweep and the prior documented full-sweep marker (`2026-08-05 21:14:52+00`, from `REVIEWER_QA_SWEEP_2026_08_05.md`)
- Included activity: human `subject_review` decisions at the `tutor_question` stage
- Active reviewers: reviewers with at least one included submission
- Mode: read-only Production queries; no content records or reviewer decisions were modified

The window contained 87 decisions by 7 reviewers across 84 distinct question versions: 38 MCQ decisions and 49 FRQ decisions.

## Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Shazia Fazal | 30 | 29 | 1 | 0 | 1 | 5 |
| Muhammad Saood | 24 | 10 | 12 | 2 | 24 | 0 |
| Adil Abbasi | 15 | 1 | 10 | 4 | 15 | 30 |
| Muhammad Zeeshan | 10 | 8 | 2 | 0 | 2 | 0 |
| Sarah Sohail | 6 | 4 | 2 | 0 | 2 | 12 |
| Gulgeldi Darrynow | 3 | 1 | 2 | 0 | 2 | 0 |
| Abdul Hanan | 1 | 1 | 0 | 0 | 0 | 0 |

## QA signals

1. **Gulgeldi Darrynow is now active on AP Chemistry.** All 3 of his decisions in this
   window (`apchem-mcq-050`, `apchem-sfrq-005`, `apchem-sfrq-024`) land on items Muhammad
   Zeeshan had already reviewed, and all 3 disagree on label severity:
   - `apchem-mcq-050`: Gulgeldi `approve_with_edits` (a `°C` degree-sign typo) vs. Zeeshan
     `approve`.
   - `apchem-sfrq-005`: Gulgeldi `approve` vs. Zeeshan `approve_with_edits` (flags an
     incorrect equivalence-point stoichiometry statement in part (b)).
   - `apchem-sfrq-024`: Gulgeldi `approve_with_edits` (missing sub-question prompt text)
     vs. Zeeshan `approve`.
   None of these are severe splits, but `apchem-sfrq-005` is worth an owner look — Zeeshan
   is flagging a content-correctness issue (stoichiometric ratio), not just a style nit,
   which Gulgeldi's clean approve did not catch.
2. **Adil Abbasi's AP Biology pass is the highest-signal reviewing in the window.** 4 of
   15 decisions are disapprovals for off-CED content (`APBIO-FRQ-L-016/026/030/036`), each
   citing a specific out-of-scope topic (immunology, MacArthur-Wilson theory, contradicted
   stimulus data, mislabeled operon mechanism). Several `approve_with_edits` notes also
   flag concrete factual errors (e.g. `APBIO-FRQ-L-020`: Falconer's formula misapplied;
   `APBIO-FRQ-L-039`: circular reasoning between Parts A and B). Adil is the only reviewer
   in this window supplying topic selections on every decision (30 across 15 decisions).
3. **Muhammad Saood's AP Calc BC / Physics 1 notes are unusually detailed and mostly
   distractor-quality fixes**, not content errors — repeatedly flagging MCQ distractor
   rationales that don't actually generate their displayed numeric values
   (`apcalcbc-mcq-027/028/038/039/043/045`). One disapproval,
   `apcalcbc-mcq-049`, flags a genuine two-valid-answer defect (both B and C are correct
   Lagrange-bound choices). One AP Physics 1 disapproval, `apphy1-frq-047`, flags an
   unjustified assumption (constant acceleration) baked into part (b) of the rubric.
4. **Topic-selection compliance remains reviewer-specific, not universal.** Adil and Sarah
   supply topics on all their submissions; Shazia partially does (5 across 30); Saood,
   Zeeshan, Gulgeldi, and Abdul Hanan supplied zero.
5. No reviewer/assignment mismatches and no unsubmitted assignments with submitted
   decisions were found for the 87 decisions in this window.

## Follow-ups

- Owner-check `apchem-sfrq-005` — Zeeshan's stoichiometry correction should not be waved
  through on Gulgeldi's clean `approve`.
- Owner-adjudicate the 4 Adil Abbasi AP Biology disapprovals
  (`APBIO-FRQ-L-016/026/030/036`) — each cites a specific, checkable CED or factual defect.
- Consider folding Saood's distractor-rationale fixes into a standing AP Calc BC / Physics
  1 remediation batch; the pattern (correct key, unverifiable distractor explanation)
  recurs across at least 6 items this window.
- Continue enforcing topic-selection expectations for Saood, Zeeshan, Gulgeldi, and Abdul
  Hanan.

## Trailing-window addendum — 2026-08-06 22:09:36+00

Protocol re-run against Production project `pcntajvbdfqhbeewmdry` at
`2026-08-06 22:09:36+00`, using the same read-only query methodology. Window rule: the
later of 24 hours before the sweep and the prior documented full-sweep marker
(`2026-08-06 15:02:34+00`, the sweep time recorded above) — so this window picks up
exactly where the prior sweep left off: `2026-08-06 15:02:34+00` through the run time
(the last decision in-window landed at `19:02:11+00`; nothing was submitted in the final
~3 hours before the sweep).

The window contained 83 decisions by 4 reviewers across 83 distinct question versions
(no same-version double-coverage): 30 MCQ decisions and 53 FRQ decisions.

Automated integrity checks: 0 reviewer/assignment mismatches, 0 decision/version
mismatches, 0 review-stage mismatches, 0 unsubmitted assignments with a submitted
decision, 0 missing content versions, 0 missing stems. Structure checks: 0 reviewed MCQ
versions with an invalid choice count or correct-answer count, 0 reviewed FRQ versions
with zero or incomplete criteria.

### Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Median gap |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Abdul Hanan | 50 | 23 | 25 | 2 | 32 | 0 | 106.25s |
| Muhammad Saood | 20 | 7 | 13 | 0 | 20 | 0 | 72.27s |
| Sarah Sohail | 7 | 3 | 4 | 0 | 4 | 0 | 533.41s |
| Adil Abbasi | 6 | 0 | 4 | 2 | 6 | 0 | 314.22s |

Zero topic selections across all four reviewers this window — a regression from the prior
sweep, where Adil and Sarah supplied them on every submission.

### QA signals

1. **`apcalcab-frq-005` remains broken after being flagged two days ago.** Muhammad Saood
   caught the underlying defect on 2026-08-04 (approve_with_edits): the rubric's anchor
   point `(2,2)` does not lie on the stated curve `x²+xy+2y²=14` — substituting gives 16,
   not 14. Shazia Fazal reviewed a later version on 2026-08-06 09:06 and caught only a
   secondary point-value mismatch, missing the algebra error. Abdul Hanan's
   `disapprove` at 15:14 in this window re-catches the identical `16≠14` defect Saood
   found 2 days prior, using near-identical reasoning. The item has been re-submitted at
   least once without the core fix landing.
2. **`apcalcab-frq-012` may be a duplicate bank entry.** Abdul Hanan flags, in his own
   `approve_with_edits` note at 15:04:42, that this looks like the same question he
   reviewed the day before (2026-08-05) but with every criterion's point value changed
   from 3pt to 1pt (9pt total → 3pt total), and asks for owner confirmation before it goes
   into the bank as a second entry rather than a revision.
3. **`apcalcab-frq-014` flipped from `approve_with_edits` to `disapprove` by the same
   reviewer within 33 minutes.** Abdul Hanan approved with edits at 15:22:27 (minor
   near-miss gap, low priority), then disapproved at 15:55:10 citing rubric criteria that
   state only method with no expected values, plus a point-total conflict (subparts
   listed as 1pt vs. criteria scored at 3pt). Consistent with a same-day revision cycle
   (author resubmitted a worse version between the two reviews) rather than reviewer
   inconsistency, but worth an owner spot-check since the two notes read as describing
   different content.
4. **Abdul Hanan's disapproval rate ticked up this window (2 of 50, both AP Calc AB) but
   both are well-supported.** `apcalcab-frq-005` (above) and `apcalcab-frq-014` (above)
   both cite specific, checkable rubric or arithmetic defects, not style preference.
5. **Abdul Hanan accounted for 50 of 83 decisions (60%) in this ~4-hour window**, at a
   106s median gap between submissions (min 17s). Comparable to his 08-05 volume (50
   decisions, 96s median) — high but not newly anomalous for this reviewer; no sign of a
   quality drop given the notes-on-approve rate stayed at 32/50 (64%) and both
   disapprovals above are substantive.
6. **Revision-cycle pattern across the AP Calc AB item set**: `apcalcab-frq-008/009/010/011`
   each show Abdul Hanan first flagging a rubric-depth gap (approve_with_edits, 08-05),
   then re-reviewing a corrected version today with a clean `approve` and no note — the
   flag → fix → clear loop working as intended, in contrast to signal 1 above.

### Follow-ups

- Owner-check `apcalcab-frq-005` — the curve/point arithmetic defect has now been flagged
  twice (Saood 08-04, Abdul 08-06) without a fix landing; escalate past a third
  approve_with_edits cycle.
- Owner-confirm whether `apcalcab-frq-012`'s 08-06 15:04 version is an intentional point
  re-weight or a duplicate bank entry, per Abdul Hanan's note.
- Spot-check `apcalcab-frq-014`'s two 08-06 versions (15:22 and 15:55) to confirm the
  disapprove reflects genuinely different content and not a reviewer read error.
- Topic-selection compliance dropped to zero across all active reviewers this window;
  re-issue the reminder before the next sweep.
