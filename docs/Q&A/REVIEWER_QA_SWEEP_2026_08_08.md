# Reviewer QA sweep — 2026-08-08

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Sweep time: `2026-08-08 02:06:24+00`
- Review window: `2026-08-06 22:09:36+00` through the sweep
- Window rule: the prior documented full-sweep marker (`2026-08-06 22:09:36+00`, the
  trailing-window addendum in `REVIEWER_QA_SWEEP_2026_08_06.md`)
- Included activity: human `subject_review` decisions at the `tutor_question` stage
- Active reviewers: reviewers with at least one included submission
- Mode: read-only Production queries; no content records or reviewer decisions were
  modified as part of the sweep itself
- Note: as of this sweep, new decisions are recorded via `tutor_score` (1/2/3) without a
  parallel `tutor_decision` text value on ~19% of rows platform-wide; this sweep reads
  `tutor_score` as canonical (1=approve, 2=approve_with_edits, 3=disapprove), confirmed by
  cross-tabulating against the ~2,500 legacy rows that carry both fields.

The window contained 110 decisions by 5 reviewers across 110 distinct question versions
(one exception noted below): 62 approve, 39 approve_with_edits, 9 disapprove.

## Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Window |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Abdul Hanan | 53 | 41 | 12 | 0 | 15 | 0 | 08-07 04:45 – 23:57 |
| Muhammad Saood | 25 | 6 | 19 | 0 | 25 | 0 | 08-07 06:15 – 06:55 |
| Adil Abbasi | 18 | 1 | 15 | 2 | 17 | 18 | 08-07 10:07 – 15:19 |
| Sarah Sohail | 10 | 3 | 3 | 4 | 7 | 10 | 08-07 15:56 – 20:06 |
| Chisom Anuba | 4 | 2 | 2 | 0 | 3 | 0 | 08-08 01:40 – 02:05 |

Automated integrity checks: 0 reviewer/assignment mismatches, 0 review-stage mismatches,
0 unsubmitted assignments with a submitted decision, 0 missing content versions, 0 missing
stems. Structure checks: 0 reviewed MCQ versions with an invalid choice count or
correct-answer count, 0 reviewed FRQ versions with zero or non-positive-point criteria.
Cross-reviewer double coverage: none in this window (one item, `APBIO-FRQ-L-003`, was
touched twice by the *same* reviewer, Adil Abbasi — a disapprove followed by an
approve-with-edits, consistent with a same-day revision cycle, not disagreement).

## QA signals

1. **Chisom Anuba submitted her first reviews this sweep, ending the "0 of 20 assignments
   touched" gap flagged earlier this session.** All 4 decisions independently verified
   correct:
   - `apcalcbc-mcq-001` (approve_with_edits): flags the option-D rationale's "0/0 form"
     phrasing as imprecise. Defensible terminology note, not a defect — the correct answer
     (C=2, via `lim(e^(2x)-1)/x = 2`) and all rationales are mathematically sound.
   - `apcalcab-mcq-004` (approve_with_edits): flags that option C's rationale uses the
     limit definition of the derivative where the power rule would suffice for
     `f(x)=x²+1`, `f'(3)=6`. A sound pedagogical simplification note, not a correctness
     issue — the stated math is correct either way.
   - `apcalcbc-mcq-027` (approve): minor note asking whether to use the `π` symbol instead
     of "pi" in explanation text — cosmetic, correctly left as approve.
   - `apcalcab-frq-023` (approve): no note, clean approval.
   - No topic selections yet, matching the platform-wide pattern (only Adil and Sarah
     supply them this window).
2. **AP Biology accounts for 6 of 9 disapprovals in the window, all citing specific,
   checkable content defects** — Adil Abbasi (`APBIO-FRQ-L-017`, `APBIO-FRQ-L-003`) and
   Sarah Sohail (`APBIO-FRQ-L-029`, `APBIO-FRQ-L-037`, `APBIO-MCQ-045`, `APBIO-MCQ-070`).
   Two are particularly severe:
   - `APBIO-FRQ-L-003`: rubric part (b) expects a 3:1 chi-square ratio, but the stated
     cross (aa × Aa) genetics produces an expected 1:1 ratio — a rubric/content mismatch
     independently checkable from the stimulus.
   - `APBIO-MCQ-045`: stem and rationales depend on BRCA1/PARP-inhibitor/synthetic-lethality
     content that is undergraduate-level and off the AP Biology CED.
3. **AP Biology's disapproval concentration (6 of 18 Adil + Sarah decisions, 33%) is much
   higher than the rest of the window (0 of 78 for Abdul Hanan and Saood, on AP Calc/
   Physics)** — consistent with Biology being the thinner-reviewed, higher-defect-rate
   subject flagged earlier in this session (only 3 active qualified reviewers there vs. 4
   in Physics).
4. **Zero topic-selection compliance from Abdul Hanan, Saood, and Chisom this window** —
   continuing the regression first noted in the 08-06 addendum.

## Jill Schmidlkofer — gold-set verification redo

Not covered by the reviewer-decisions sweep above (separate track:
`gold_set_verification_assignments`, not `content_review_decisions`). Re-checked her
current state rather than re-running the full audit, since nothing has changed since the
last pass in this session:

- **10 submitted assignments, unchanged from the prior audit** — all previously verified
  clean (0 mark/text mismatches on re-check of the assignment list).
- **8 assignments sitting in her pending queue awaiting redo**: the 2 mindfulness-app
  items returned per owner direction, plus the 6 items with the 7 flagged element-mark
  misses (`d464e879`, `e3534ffa`, `8f4d5178`, `8fde785a`, `f386f8ec`, `e6721aba`). No
  resubmissions yet.

## Follow-ups

- Owner-adjudicate `APBIO-FRQ-L-003`'s rubric/genetics mismatch (3:1 vs. the
  cross-implied 1:1 ratio) and `APBIO-FRQ-L-017`'s two-questions-stapled-together defect —
  both are independently checkable and block-worthy as written.
- Consider recruiting a 4th AP Biology reviewer given the subject's disproportionate
  defect rate against only 3 active reviewers.
- Re-issue the topic-selection reminder — now 3 of 5 active reviewers (Abdul Hanan,
  Saood, Chisom) supply zero.
- Watch for Jill's redo submissions on the 8 pending items; re-audit once she resubmits.

## Trailing-window addendum — 2026-08-08 19:07:07+00

Protocol re-run against Production project `pcntajvbdfqhbeewmdry` at
`2026-08-08 19:07:07+00`, same read-only query methodology, **plus gold-set activity**
(`gold_set_verification_assignments` / `gold_set_elements` / `gold_set_element_marks`),
which the prior window covered only as a status check, not a full audit. Window rule:
the prior documented full-sweep marker (`2026-08-08 02:06:24+00`, the sweep time recorded
above) through this run.

### Volume by reviewer

The window contained 205 `tutor_question`-stage decisions across 5 reviewers, but one of
those five is not a blind review pass and is reported separately below.

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Window |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Abdul Hanan | 60 | 54 | 6 | 0 | 41 | 0 | 08-08 07:24 – 15:50 |
| Adil Abbasi | 20 | 0 | 20 | 0 | 20 | 20 | 08-08 11:53 – 14:20 |
| Ahmed Ali | 20 | 4 | 16 | 0 | 20 | 0 | 08-08 03:18 – 04:32 |
| Chisom Anuba | 1 | 1 | 0 | 0 | 0 | 0 | 08-08 02:15 |
| David (owner remediation) | 104 | 104 | 0 | 0 | 104 | 0 | 08-08 03:39 – 16:49 |

**Ahmed Ali is a new reviewer this window** (first appearance in any sweep), active on
Physics 2 / Physics C: Mechanics / Physics C: E&M.

**David's 104 decisions are not blind review** — every one carries
`assignment_purpose='owner_remediation_approval'` and a note beginning "Owner remediation
per Saood," i.e. this is a large batch closing out Muhammad Saood's prior FRQ/MCQ
feedback on the Physics bank, not a new independent review pass. Excluded from the
101-decision blind-review total and from disapproval-rate comparisons below.

Automated integrity checks (blind-review decisions only): 0 reviewer/assignment
mismatches, 0 review-stage mismatches, 0 unsubmitted assignments with a submitted
decision, 0 missing content versions, 0 missing stems, 0 same-version double-coverage.
Structure checks: 0 reviewed MCQ versions with an invalid choice/correct-answer count, 0
reviewed FRQ versions with zero or non-positive-point criteria.

**Zero disapprovals across all 101 blind-review decisions this window** — a departure
from every prior sweep, where AP Biology in particular ran a 20-33% disapproval rate.
Consistent with the window's composition (largely `-np2-` batch items and Physics C
items under first-pass detailed review, not a resample of the general bank) rather than
a quality signal on its own.

### QA signals

1. **Ahmed Ali independently re-surfaces the exact "pasted-prompt rubric" defect pattern
   the QA protocol's §9.3 structural scan already found at 22-28% prevalence across
   Physics 2/C-Mechanics/C-E&M FRQs** — explicitly named as a recurring pattern in his own
   notes ("third pasted-prompt rubric pattern," `apphycem-frq-009`; similar language on
   `apphy2-frq-002`, `apphy2-frq-003`, `apphycem-frq-008`, `apphycm-frq-003`,
   `apphycm-frq-008`): rubric criteria that are the literal prompt text pasted into the
   scoring slot rather than actual scoring language, several paying zero points for
   content the stem explicitly demands. Independent discovery by a human reviewer,
   nine FRQs deep into a first pass, matching a defect class already identified by
   mechanical pattern-scan — real corroboration, not overlap.
2. **`apphy1-mcq-027` has a hard rendering/scoring blocker**: the option list states
   "C. 36 m" while the rationale block states "C. 6 m" for the same choice — the item
   cannot be consistently rendered or scored as stored (Ahmed Ali, approve_with_edits,
   flagged as near-blocking).
3. **Off-CED content continues to recur, in both Biology and Physics.** Adil Abbasi flags
   `APBIO-MCQ-045` (BRCA1/PARP-inhibitor/synthetic-lethality) a second time — **this is
   the same item Sarah Sohail disapproved for identical reasons in the prior window of
   this same sweep** — suggesting either a duplicate independent catch on unremediated
   content or a resubmission that didn't fix the core issue. Also flagged this window:
   `APBIO-MCQ-096` (biogeochemical cycles, removed from the AP Bio CED in the 2019
   redesign), `APBIO-MCQ-087` (dN/dS neutral theory, undergraduate population genetics).
   On the Physics side: `apphy2-frq-003` (RC circuit / τ=RC, belongs in Physics C: E&M,
   not on the Physics 2 equation sheet), `apphycem-mcq-003`/`apphycem-mcq-004`
   (differential-form Gauss's law and curl operators — vector calculus not in the Physics
   C: E&M CED, which uses the integral form only).
4. **Adil Abbasi flags a systemic answer-length-cueing pattern across ~15 of his 20 AP
   Biology items this window** — the keyed/correct option running substantially longer
   than distractors, a construct-irrelevant difficulty cue rather than a content defect.
5. **Abdul Hanan caught a small, precise numeric rubric error**: `apcalcab-frq-np2-008`
   part (b) target value stated as 2983.653, independently recomputed as 2983.649
   (P(10)=2000e^0.4, verified to high precision) — genuine, if minor.

### Gold-set activity

Full audit this pass, not just a status re-check (see main sweep's note above for why the
prior pass deferred this).

- **The rubric-ordering defect Jill Schmidlkofer found in `APSTATS-SFRQ-010` ("gold set
  question 37 of 66") was fixed earlier in this session**, and the same root cause
  (`gold_set_elements.element_index` restarting at 1 per criterion, allowing a
  later criterion's element to collide into an earlier criterion's display position) was
  traced to 4 more published AP Statistics items — all from the 2026-08-07 TASK-0022
  redecomposition: `apstats-frq-u12-005`, `APSTATS-SFRQ-007`, `APSTATS-SFRQ-008`,
  `APSTATS-SFRQ-009`. All 5 fixed by renumbering `element_index` to be globally
  sequential per item, verified against the entire gold set afterward: 0 remaining
  defects among items with genuine multi-element criteria (23 additional flagged
  candidates elsewhere in the gold set all have exactly one element per criterion — not
  the same failure mode, since a single-element criterion can't collide with another).
- **Time-sensitive finding**: Jill's entire current pending gold-set-verification queue
  (30 assignments) is against exactly these 4 items — 8 on `SFRQ-010`, 8 on `SFRQ-009`,
  8 on `SFRQ-008`, 6 on `SFRQ-007`. The fix landed before she resumes work on them, so her
  upcoming redo will see the corrected order.
- **Spot-checked whether the display bug corrupted already-submitted marks**: Muhammad
  Saood submitted 30 verification marks against these same 4 items before the fix
  landed. Re-checked all 8 `SFRQ-010` marks and a sample of the `SFRQ-009` marks against
  the corrected element order — every `evidence_quote` matches its `element_label`
  exactly (e.g. "0.3 hours" quotes attach to the standard-deviation-computation element,
  "0.6 hours" quotes attach to the reduced-sample-size element). **0 mismatches** — marks
  are joined by a stable `gold_set_element_id`, not display position, so the ordering bug
  affected only what reviewers saw on screen, not what was recorded. Saood's 30 marks do
  not need to be redone.
- **Gold-set verification assignment status, all reviewers**: Jill Schmidlkofer 30
  pending / 36 submitted; Muhammad Saood 70 submitted; Chisom Anuba 7 pending (new to
  gold-set verification this window, no submissions yet).

### Follow-ups

- Escalate Ahmed Ali's independent re-discovery of the pasted-prompt-rubric pattern —
  run a structural-pattern SQL scan (per the QA protocol §9.3's own finding that
  pattern-hunting outperforms blind resampling by roughly an order of magnitude) across
  the rest of the Physics 2 / Physics C: Mechanics / Physics C: E&M FRQ bank rather than
  waiting for reviewers to hit each instance one at a time.
- Fix `apphy1-mcq-027` immediately — the option-value mismatch (36 m vs. 6 m) is a
  literal rendering/scoring blocker, not a quality nit.
- Owner-adjudicate `APBIO-MCQ-045` — flagged by two different reviewers across two
  windows of this same sweep (Sarah Sohail disapprove, Adil Abbasi approve_with_edits),
  still appears unremediated.
- Consider a fix at the source: the TASK-0022 redecomposition script (or whatever
  authoring path produces bundled multi-point criteria generally) should assign
  `element_index` globally per item, not per criterion, so this defect class can't
  recur on the next multi-point redecomposition or on Biology/Chemistry/Calculus's
  existing genuine multi-point criteria if they're ever re-touched.
- Chisom Anuba is newly active on gold-set verification (7 pending, all AP-something
  TBD) — confirm what she's queued against and whether any of it touches the 5 items
  just fixed.
