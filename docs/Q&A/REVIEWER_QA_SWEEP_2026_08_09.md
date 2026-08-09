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
3. **A recurring, low-severity pattern across ~19 of the 40 `-np1-` items: unstated sign/
   reference conventions** — magnitude expressions that should specify `ρ>0`/`λ>0`/`|·|`,
   potential calculations that don't state the `V(∞)=0` reference, and one FRQ
   (`apphy1-frq-np1-002`) where an instant-of-slope-discontinuity (`t=4`) is included in
   both adjacent open intervals. None change the correct answer; all are the same class of
   fix (add a stated convention/assumption), suggesting the `-np1-` authoring pass should
   get a pinned "state your sign/reference conventions explicitly" instruction before its
   next batch, the same way §4's prompt rule got pinned after DeepSeek's over-flagging.
4. **Zero topic-selection compliance from Saood this window** — continuing the regression
   flagged in the 08-06 and 08-08 sweeps (now observed across every window Saood has
   appeared in).
5. **Both open follow-ups from the 08-08 sweep are closed:**
   - `apphy1-mcq-027` (option-value rendering blocker, 36 m vs. 6 m): now version 3,
     `status='published'`, `review_status='question_review_approved'` — fixed and
     published 2026-08-08 21:26:36+00.
   - `APBIO-MCQ-045` (off-CED BRCA1/PARP-inhibitor content, flagged twice across two prior
     windows): version 1 is now `status='retired'`, `review_status='excluded'` —
     owner-adjudicated out rather than repaired in place.

## Gold-set verification — status check

No change since the 08-08 sweep (re-checked rather than re-audited, since nothing new
happened on this track): Jill Schmidlkofer 30 pending / 36 submitted; Muhammad Saood 70
submitted; Chisom Anuba 7 pending. No new submissions this window.

## Follow-ups

- Pin an explicit sign/reference-convention instruction for the `-np1-` Physics authoring
  pool (per QA signal 3) before its next batch — the same fix class recurred ~19 times in
  one 40-item sample and is cheap to prevent at the source.
- Owner-adjudicate the two `-np1-` disapprovals (`apphycem-frq-np1-008`,
  `apphycem-mcq-np1-007`) — both are independently checkable and block-worthy as written.
- Review coverage this window was thin (1 blind reviewer vs. 5 on 08-08) — confirm whether
  that's a scheduling gap or the other reviewers are between assignments before treating it
  as a trend.
- Watch for Jill's and Chisom's gold-set-verification queues (30 and 7 pending,
  respectively) — unchanged for two consecutive sweeps now.
