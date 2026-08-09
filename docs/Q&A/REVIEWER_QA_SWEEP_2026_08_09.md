# Reviewer QA sweep — 2026-08-09

## Scope

- Production project: `pcntajvbdfqhbeewmdry`
- Sweep time: `2026-08-09 03:14:45+00`
- Review window: `2026-08-08 19:07:07+00` through the sweep
- Window rule: the prior documented full-sweep marker (`2026-08-08 19:07:07+00`, the
  trailing-window addendum in `REVIEWER_QA_SWEEP_2026_08_08.md`)
- Included activity: human `subject_review` decisions at the `tutor_question` stage
  (`app.content_review_decisions`, denormalized read via `public.content_review_decisions`)
- Active reviewers: reviewers with at least one included submission
- Mode: read-only Production queries; no content records or reviewer decisions were
  modified as part of the sweep itself

The window contained 231 `tutor_question`-stage decisions across 2 reviewers, but one of
those two is not a blind review pass and is reported separately below (same pattern as the
08-08 addendum).

## Volume by reviewer

| Reviewer | Decisions | Approve | Approve with edits | Disapprove | Notes | Topic selections | Window |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Muhammad Saood | 40 | 12 | 26 | 2 | 40 | 0 | 08-09 02:23 – 03:14 |
| David (owner remediation) | 191 | 191 | 0 | 0 | 191 | 0 | 08-08 20:39 – 08-09 01:05 |

**Muhammad Saood is the only blind-review reviewer active this window** — a much thinner
window than 08-08's (5 active reviewers). All 40 decisions are on a new item pool,
`-np1-` (content keys like `apphycem-frq-np1-001`, `apphy1-mcq-np1-004`), split evenly:
AP Physics C: E&M (20: 10 FRQ + 10 MCQ) and AP Physics 1 (20: 10 FRQ + 10 MCQ).

**David's 191 decisions are not blind review** — every one carries
`assignment_purpose='owner_remediation_approval'` with a note beginning "Owner-directed AI
QA / CED-conformance review pass, 2026-08-08." Breakdown by note pattern: 105 "no defects
found," 63 "version-bumped to resolve [stem/mcq_choices desync]," 13 "specific content
defect identified and repaired," and 10 "cross-subject single-approve QA sweep" (protocol
§9) remediations. This is the tail end of the 212-item, all-10-subject QA/repair/publish
pass already documented in `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` (v0.4
revision note), not new activity discovered by this sweep — excluded from the
blind-review total and disapproval-rate comparisons below.

Automated integrity checks (all 231 decisions): 0 reviewer/assignment mismatches, 0
review-stage mismatches, 0 unsubmitted assignments with a submitted decision, 0 missing
content versions, 0 missing stems. Structure checks: 0 reviewed MCQ versions with an
invalid choice count (≠4) or correct-answer count (≠1), 0 reviewed FRQ versions with a
zero or non-positive-point criterion. Cross-reviewer double coverage: none — every version
in the window was touched exactly once.

**Disapproved-but-published cross-check (P0-B net, §6 Phase 7a):** 0 items with
`status='published'` and `review_status IN ('excluded','modification_reserved')` —
the publish-gate bug has not recurred.

### Saood's `-np1-` rates vs. his historical rates on the same subjects

| Subject | Pool | n | Approve | Approve with edits | Disapprove |
|---|---|---:|---:|---:|---:|
| AP Physics 1 | Historical (pre-08-09) | 135 | 37.8% | 57.8% | 4.4% |
| AP Physics 1 | `-np1-` batch | 20 | 50.0% | 50.0% | 0.0% |
| AP Physics C: E&M | Historical (pre-08-09) | 117 | 15.4% | 76.9% | 7.7% |
| AP Physics C: E&M | `-np1-` batch | 20 | 10.0% | 80.0% | 10.0% |

Physics 1's `-np1-` batch reads cleaner than Saood's historical rate on that subject
(approve up ~12 points, disapprove down to 0% from 4.4%). E&M's `-np1-` batch sits within
normal variation of his historical rate there — already his roughest subject at
n=117 — rather than a clear shift; n=20 per pool is small enough that a few points either
way isn't meaningful on its own.

## QA signals

1. **Saood's `-np1-` pass reads as independent re-derivation (protocol §9), not a
   read-and-check pass** — nearly every `approve_with_edits` note re-derives the physics
   from scratch (Gauss's law integrals, energy/kinematics chains, potential calculations)
   and flags gaps the stored rubric/rationale didn't address, rather than just confirming
   the stored answer "looks right." This is the discipline §9.1 asks for, applied by a
   human reviewer rather than an agent.
2. **Two disapprovals, both independently checkable:**
   - `apphycem-frq-np1-008`: the rubric asserts the y-axis is an equipotential line for
     two equal point charges. Independently re-derived and confirmed wrong — along the
     y-axis, `V(0,y) = 2kQ/sqrt(d²+y²)`, which varies with `y`, so the axis is not an
     equipotential; the true equipotential through the origin is a figure-eight-like
     separatrix. A genuine physics defect, not a wording nit.
   - `apphycem-mcq-np1-007`: flagged for conflating "out of scope for this course" with
     "missing numerical information" in a distractor rationale — a scope/rationale
     mismatch rather than a wrong answer key.
3. **A recurring, low-severity pattern, concentrated in E&M, not spread evenly across the
   batch: unstated sign/reference conventions.** Keyword-verified re-scan of all 28
   non-clean `-np1-` notes: 9 of 16 non-clean E&M items (56%) cite a missing convention
   (state `ρ>0`/`λ>0`/`|·|`, the `V(∞)=0` reference, the Coulomb's-constant value used, or
   a "long cylinder / negligible end effects" assumption) vs. **0 of 10** non-clean Physics
   1 items. This answers the "is this a source-fixable bug, not independent findings"
   question directly: over half of E&M's edits trace to one missing authoring instruction,
   not to diverse independently-discovered defects — pin a "state your sign/reference
   conventions explicitly" instruction for the E&M `-np1-` pool specifically (Physics 1
   doesn't need it; its edits are a different mix, see next point).
4. **One specific bug recurs twice in the same 40-item batch, independent of the convention
   pattern above:** the normal-force-direction-at-minimum-speed ambiguity (a ball/car on a
   vertical circular track at the exact minimum speed has `N=0`, so "state the normal
   force's direction" has no defined answer at that speed) appears in both
   `apphy1-frq-np1-006` and `apphy1-mcq-np1-004` — the same circular-motion template reused
   without adjusting for its own edge case. Worth a targeted mechanical scan (per protocol
   §9.3's pattern-hunting) across the rest of the Physics 1 vertical-circular-motion item
   pool rather than waiting for a reviewer to hit each instance.
5. **One possible genuine numeric answer-key defect, distinct from the convention gaps:**
   `apphycem-frq-np1-004`'s rubric states `V(0.300)=124.680 V`; Saood's independent
   recomputation (`k=8.99e9`, `R=0.200 m`, `Q=5.00e-9 C`) gives `124.666 V`. Small but
   real if confirmed — worth a second independent recomputation before dismissing as
   rounding, since it's the one `-np1-` finding that isn't explained by the convention or
   circular-motion patterns above.
6. **Zero topic-selection compliance from Saood this window** — continuing the regression
   flagged in the 08-06 and 08-08 sweeps (now observed across every window Saood has
   appeared in).
7. **Both open follow-ups from the 08-08 sweep are closed:**
   - `apphy1-mcq-027` (option-value rendering blocker, 36 m vs. 6 m): now version 3,
     `status='published'`, `review_status='question_review_approved'` — fixed and
     published 2026-08-08 21:26:36+00.
   - `APBIO-MCQ-045` (off-CED BRCA1/PARP-inhibitor content, flagged twice across two prior
     windows): version 1 is now `status='retired'`, `review_status='excluded'` —
     owner-adjudicated out rather than repaired in place.

## Physics FRQ pasted-prompt-rubric scan (protocol §9.3 follow-up)

Mechanical SQL scan (a criterion's `learner_facing_text` appearing verbatim, length > 25
chars, as a literal substring of the item's own `stem`) across the full Physics 2 /
Physics C: Mechanics / Physics C: E&M FRQ bank, not just previously-reviewed items — the
scan the 08-08 sweep's follow-ups asked for.

**Against every version ever written** (confirms the historical measurement): Physics 2
15/58 (25.9%), E&M 15/68 (22.1%), Mechanics 14/58 (24.1%) — matches the 08-08 sweep's
22-28% figure almost exactly, confirming the pattern was real and this detection signature
reproduces it.

**Against each item's current latest version** (what's live/pending today): Physics 2
4/58 (6.9%), E&M 4/68 (5.9%), Mechanics 2/58 (3.4%) — **the pattern has already been
largely repaired**, consistent with the 63-item stem/`mcq_choices` desync-fix batch in
David's owner-remediation pass (see Volume by reviewer above). All 10 remaining hits are
the item's `part-b` criterion verbatim-echoing a "state the governing principle... and
explain why" instruction from the stem, rather than actual scoring language:

| content_key | Subject | Version | Status |
|---|---|---:|---|
| `apphy2-frq-002` | AP Physics 2 | 1 | **published** |
| `apphy2-frq-003` | AP Physics 2 | 1 | **published** |
| `apphy2-frq-005` | AP Physics 2 | 2 | **published** |
| `apphycem-frq-008` | AP Physics C: E&M | 1 | **published** |
| `apphycem-frq-009` | AP Physics C: E&M | 1 | **published** |
| `apphy2-frq-016` | AP Physics 2 | 2 | retired |
| `apphycem-frq-003` | AP Physics C: E&M | 2 | retired |
| `apphycem-frq-007` | AP Physics C: E&M | 2 | retired |
| `apphycm-frq-002` | AP Physics C: Mechanics | 2 | retired |
| `apphycm-frq-006` | AP Physics C: Mechanics | 2 | retired |

**5 of the 10 are `status='published'` and live to students right now** — these still
need the same remediation already applied to the other ~40 items in this defect class.

## Biology MCQ answer-length-cueing — retroactive remediation

The mechanical detector (`checkAnswerLengthParity` in
`supabase/functions/_shared/mcq-quality.ts`, ratio ≥ 1.4) is already wired into
`admin-content/index.ts`'s MCQ ingestion path and is subject-agnostic — it already flags
new/edited Biology MCQs same as any other subject. **No code fix was needed there.**

The gap is retroactive: `docs/research/MCQ_ANSWER_LENGTH_PARITY_QA_2026_07_21.md` drafted
illustrative rewrites back on 2026-07-21 but explicitly never wrote any of them to a
content row. Re-querying Production today confirms none of that ever landed, for any
subject — and **AP Biology is now the worst subject in Production by this measure**: 27 of
42 published MCQs (64%) carry a correct/distractor length ratio ≥ 1.4, the highest rate of
any subject (next-worst: AP Chemistry at 19/68 = 28%). Full 27-item list and per-item
balanced-distractor drafts are complete in
`docs/research/AP_BIOLOGY_MCQ_LENGTH_PARITY_REMEDIATION_2026_08_09.md` — all 27 simulate to
a ratio below 1.4 after the rewrite (range 0.61x-1.25x), correct answers left completely
unchanged, each rewritten distractor keeping its original misconception but expanded to
comparable length/specificity. Drafting also surfaced (incidentally, not from a targeted
audit) that none of the 27 items has a wrong-keyed answer or an internally contradictory
stem. **Still drafts only**, per the same insertion discipline as §9.4: no content row has
been touched, and none should be without qualified AP Biology subject-matter review and the
new-version → review → approval → publish flow.

## TASK-0022 source fix

The gold-set rubric-ordering defect (`element_index` restarting at 1 per criterion,
scrambling display order — fixed in Production data 2026-08-08, see
`docs/activity_log/ACTIVITY_LOG.md`) was only ever patched in the *data*. The two authoring
scripts that produced it
(`scripts/content-seed/gold-set/20260807_apstats_multipoint_redecomposition.sql` and
`..._full_corpus_redecomposition.sql`) still hard-coded per-criterion-restarting index
values, so copying either as a template for a future redecomposition would reintroduce the
exact defect. Fixed at the source this sweep: both scripts now compute `element_index` via
`row_number() over (partition by content_item_version_id order by criterion_key,
local_index)` instead of hand-typed integers, so the defect class can't recur structurally,
not just by author discipline.

## Gold-set verification — status check

No change since the 08-08 sweep (re-checked rather than re-audited, since nothing new
happened on this track): Jill Schmidlkofer 30 pending / 36 submitted; Muhammad Saood 70
submitted; Chisom Anuba 7 pending. No new submissions this window.

## Follow-ups

- Pin an explicit sign/reference-convention instruction for the `-np1-` **E&M** authoring
  pool specifically (per QA signal 3 — Physics 1 doesn't show this pattern) before its next
  batch.
- Run a mechanical scan for the normal-force-direction-at-N=0 template bug (QA signal 4)
  across the rest of the Physics 1 vertical-circular-motion pool.
- Independently re-verify `apphycem-frq-np1-004`'s `124.680 V` vs. recomputed `124.666 V`
  (QA signal 5) before dismissing as rounding.
- Owner-adjudicate the two `-np1-` disapprovals (`apphycem-frq-np1-008`,
  `apphycem-mcq-np1-007`) — both are independently checkable and block-worthy as written.
- Remediate the 5 still-published pasted-prompt-rubric FRQs (`apphy2-frq-002/003/005`,
  `apphycem-frq-008/009`) — same defect class as the 63 already fixed, just missed by that
  pass.
- Route the completed AP Biology length-parity drafts
  (`docs/research/AP_BIOLOGY_MCQ_LENGTH_PARITY_REMEDIATION_2026_08_09.md`, all 27 items)
  through qualified subject-matter review and the new-version → approval → publish flow —
  drafted, not yet reviewed or published.
- Review coverage this window was thin (1 blind reviewer vs. 5 on 08-08) — confirm whether
  that's a scheduling gap or the other reviewers are between assignments before treating it
  as a trend.
- Watch for Jill's and Chisom's gold-set-verification queues (30 and 7 pending,
  respectively) — unchanged for two consecutive sweeps now.
