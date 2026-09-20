# Student-Facing Canonical Answers

**Status:** Draft — for review (nothing here is approved)
**Date:** 2026-09-20
**Author:** Strategy Advisor (with Product Owner)
**Product Owner:** David Bloom
**Curricular Owner:** Orly Bloom (answer correctness, teaching quality)
**Launch relevance:** Gating — a subject does not launch without a full-point answer for every free-response item.

## Problem

Every free-response question needs one thing before a subject can launch: a
**full-point answer** — a response that, if a student wrote it, would earn every
available point. Students need to see it after they attempt (this is the "here's
what a perfect answer looks like" moment), and the grader needs it as its
calibration anchor. One artifact, two consumers.

The reasonable assumption is that we already have this. We have canonical
answers on nearly every item, authored and in some cases reviewed. So the honest
question is the one the Product Owner asked: *is there any reason we can't just
reuse them?*

There is. It is specific, and it is fixable without building much.

## What already exists (reuse this)

The plumbing is real and we should not reinvent it:

- **Storage.** `app.content_item_versions.canonical_answer_1` / `canonical_answer_2`
  already hold the FRQ canonical answer (labeled "for FRQ grading calibration").
  MCQ keys live in `mcq_choices.is_correct`; FRQ rubrics and accepted answers in
  `frq_criteria` (`required_evidence`, `accepted_variants`).
- **Authoring.** Every `content/item-packages/**/*.json` carries a top-level
  `canonical_answers[]` array plus a full `parts[].criteria[]` rubric and a
  `scoring_contract`.
- **Review lifecycle.** `content_review_assignments` has a `tutor_frq_canonical`
  stage; `content_review_decisions` records `canonical_decision` and a
  `canonical_answer_snapshot`. Bio short FRQs went through a reviewed "canonical
  pair" pass.
- **A grader that can judge answers.** `evaluate-attempt` already scores a
  free-text response criterion-by-criterion against `frq_criteria`.

We keep all of it. The field, the rubric, the review stage, the grader — the
design below adds one gate and one reframing on top of what is here.

## Why today's canonical answers are not student-ready

The root cause is one thing: **today's canonical answer is a restatement of the
rubric, not a response a student would write** — and nothing proves it earns full
marks. Three consequences follow.

### 1. It reads as a grading checklist, not an answer

Here is the complete canonical answer for `apprecalc-frq-017`, a 6-point long
FRQ, verbatim:

> "The average rate is −0.5. | Shows [f(4)−f(1)]/3=(2−3.5)/3=−0.5. | The zeros are
> approximately −1.646, 2.000, and 3.646. | Reports all three roots to three
> decimals. | f(x)>0 on (−1.646,2)∪(3.646,5]. | Uses alternating signs or test
> values and respects the domain."

That is the six criterion descriptions joined by `|` — it is byte-for-byte
identical to the item's `review_notes.expected_reasoning`. Fragments like
"Reports all three roots to three decimals" and "Uses alternating signs or test
values" describe *what earns a point*; they are not sentences a student would
write. Show that to a student as "the full-credit answer" and they learn our
rubric, not what a strong response looks like.

### 2. Nothing proves it is actually full-point

No step ever grades the canonical against its own rubric. This is not
hypothetical: `APSTATS-SFRQ-008` was keyed to a retired canonical value and
**deterministically zeroed every correct student response** until an audit caught
it (`evaluate-attempt` v37+). "A full-point answer for every question" has to be
*verified*, not asserted. The AP Biology FRQ corpus audit found the adjacent
class of defect — `APBIO-FRQ-L-001/002/003/028` carry points-metadata that
disagree with their own rubric sums, and `APBIO-FRQ-S-013` has contradictory
self-correction text in its evidence requirements. A "must score full marks
against its own rubric" gate catches all of these on contact.

### 3. Coverage is uneven and unmeasured

`canonical_answer_1/2` is nullable and capped at two; Bio was seeded straight to
SQL; graph-construction criteria have no written-answer equivalent at all
(DESIGN-007). Nothing today answers "which FRQs are missing a launch-ready
full-point answer" — the exact question a launch gate must answer.

So: reuse the storage and the content as the **seed**, but the existing answers
are calibration artifacts, not student-facing full-point answers, and they are
unverified. That is the gap.

## The model: one gate, one reframing

> **An answer is not canonical until (a) it is written as a response a student
> would write, and (b) the production grader awards it 100% against its own
> rubric.**

This single rule does the whole job:

- **Makes "full-point" true, not claimed.** The answer is graded before it earns
  the label.
- **Doubles as drift detection.** If the model answer does not score full marks,
  either the answer or the rubric is wrong — and we found out before a student
  did, not after. Every defect in §2 surfaces here automatically.
- **Serves both consumers with one text.** Once verified full-credit, the same
  answer is the grader's calibration anchor *and* is safe to show students
  post-attempt.

Nothing in the storage changes. What changes is that `canonical_answer_1`
graduates from "author's evidence checklist" to "verified full-credit response,"
and we track whether every item has one.

## Draft-and-validate: two independent AIs

Per the Product Owner's framing — *one AI drafts, another validates* — the gate
is built as a two-model pipeline, and the separation is the point:

1. **Draft (Model A).** Rewrite the existing canonical checklist into a coherent,
   student-quality full-credit response, seeded from the current
   `canonical_answers[]`, the `frq_criteria`, and any `frq_synthetic_responses`
   marked `fully_correct`. This is a rewrite of existing content, not net-new
   answer generation.
2. **Validate (Model B — the grader).** Submit Model A's draft to
   `evaluate-attempt` as if it were a student response. It passes only if it earns
   **every criterion, full points, no carry-forward**. Model B must not be the
   model that drafted the answer — the independence is what makes the check
   meaningful.
3. **Escalate on fail.** A draft that cannot reach full marks is not silently
   retried into existence. Failure means a human looks: either the rubric is
   wrong, the item is unanswerable as written, or the answer needs work. This is
   how we surface the `APBIO-FRQ-L-*` and `APSTATS-SFRQ-008` class of defect
   instead of papering over it.

This is exactly the shape of work that AI drafts and AI validates, with humans on
the exceptions — not on every item.

## Coverage as the launch gate

"Full-point answer for every open-response question" is a coverage claim, so make
it measurable and make it the gate:

- A per-subject report: for every published FRQ item version, does a
  **verified** full-point canonical answer exist (drafted, graded to 100%,
  reviewed where policy requires)?
- A subject launches only when that report is **100% green** for its
  free-response bank. Partial coverage is a launch blocker, not a footnote.
- Re-verification is triggered on any change to the item stem, the canonical
  answer, or the rubric — a canonical that was full-point yesterday can be stale
  today (that is the `APSTATS-SFRQ-008` failure mode).

## Governance boundaries to hold

- **Authored canonical ≠ certified gold set.** A verified full-point answer is a
  strong development and student-facing asset; it is *not* the human blind-scored
  gold set that certifies the grader (DECISION-0045). Keep the two concepts
  distinct — this gate does not replace gold-set certification.
- **Answer-key secrecy is absolute.** A full-point answer is an answer key. It is
  never exposed to the `authenticated`/student surface **before** a submitted
  attempt. Post-attempt display is a deliberate, gated reveal, consistent with the
  existing MCQ answer-key hardening (RPC-only reviewer reads, `service_role`
  grading). Any student-facing surface goes through the same boundary, not around
  it.

## What this needs from owners

- **Product Owner (David):** confirm this is the launch gate — no subject ships
  without 100% verified full-point coverage of its FRQ bank — and confirm
  post-attempt student display is in scope.
- **Curricular Owner (Orly):** own the correctness bar for the rewritten answers
  and the escalation queue for items that fail the grader (rubric wrong vs. answer
  wrong vs. item unanswerable).

## Scope guardrails

- **Additive, not a rebuild.** One verification gate, one rewrite pass, one
  coverage report. No new tables — reuse `canonical_answer_1/2`,
  `frq_criteria`, `frq_synthetic_responses`, `evaluate-attempt`, and the existing
  review lifecycle.
- **FRQs only** (short and long). MCQ already has a deterministic verified key;
  graph-construction criteria without a written-answer equivalent are out of scope
  here and tracked under DESIGN-007.
- **Verification is non-negotiable.** No canonical earns the label on assertion; a
  draft that cannot score 100% is escalated, never shipped.
- **Legacy `public.questions`** (`answer_choices`/`rubric` jsonb) is a separate
  model — confirm with the owner before touching it; the live system uses the
  `app.*` triple.

## Open questions

1. **Multiple full-credit paths.** Some FRQs admit genuinely different full-point
   responses. Is one verified canonical enough for launch, or do we want the
   `canonical_answer_2` slot (or more) to hold a second accepted path — and does
   the student see one or several?
2. **Grader confidence coupling.** This gate depends on `evaluate-attempt` being
   trustworthy, but grader calibration itself is gated by TASK-0010 / NOW-013. Can
   full-point verification run against the current grader as content QA now, with
   student-facing display held until TASK-0010 clears — or are they one gate?
3. **Long-FRQ reliability.** Do long FRQs (multi-part, carry-forward) need
   dual-pass verification (DESIGN-001's dual-pass question) before a full-point
   claim is trustworthy?
4. **Rewrite fidelity.** When Model A's readable rewrite scores 100% but drops a
   nuance the terse checklist captured, which is authoritative — the graded prose
   or the original evidence list?
