# TASK-0053 — Replace All Placeholder MCQ Feedback With Distractor-Specific Feedback

**Status:** Code complete and on PR, awaiting review + deploy. **LAUNCH GATING.**
**Tier:** Hard-Gate (changes what every student reads after every wrong MCQ, in Production)
**Owner:** Claude
**Product Owner:** David Bloom
**Date opened:** 2026-09-29
**Area:** Grading / student-facing feedback / `evaluate-attempt`
**Pull request:** `david-bloom/Cramapple#264` (branch `claude/mcq-distractor-feedback`)
**Related:** `DECISION-0085` (skill dimension), `tasks/TASK-0050-SKILL-DIMENSION-ROLLOUT.md`

---

## Why this gates launch

Every wrong MCQ answer produced one fixed string, on every item, in every subject:

> Select the answer choice that matches the published correct answer.

It restates the definition of "wrong". It is the *only* thing a student gets back from an MCQ, and
MCQs are the bulk of the product. Shipping it to the first real cohort means shipping a grading
engine whose student-visible output teaches nothing.

Measured on Production, 2026-09-29: **34 of the 63** recorded `highest_value_gap` rows were that
placeholder, across **19 distinct items** — and those 19 items carry **76 authored distractor
rationales** that the code never read.

## The decisive finding: this is not blocked on content

The obvious fear is that fixing the code exposes a content gap — that the rationales do not exist.
They do. Every published MCQ distractor in every subject already has an authored rationale:

| Subject | MCQ items | Distractors | Missing rationale |
|---|---:|---:|---:|
| ap-statistics | 304 | 912 | **0** |
| ap-chemistry | 68 | 204 | **0** |
| ap-calculus-bc | 66 | 198 | **0** |
| ap-physics-1 | 63 | 189 | **0** |
| ap-calculus-ab | 57 | 171 | **0** |
| ap-precalculus | 53 | 159 | **0** |
| ap-physics-c-em | 48 | 144 | **0** |
| biology | 43 | 129 | **0** |
| ap-physics-c-mechanics | 41 | 123 | **0** |
| ap-physics-2 | 40 | 120 | **0** |
| **Total** | **783** | **2,349** | **0** |

So the distractor-specific half of this task covers **783 of 783 published MCQ items (100%)** the
moment the code deploys. No authoring, no backfill, no model spend.

## What is NOT covered, stated plainly

The feedback also names the **skill** the question tests and the **unit** it sits in. Those come from
`content_item_cells` → `taxonomy_skills` / `taxonomy_topics`, which only half the corpus has:

| Subject | Published MCQ | Has skill cell |
|---|---:|---:|
| ap-statistics | 304 | 304 |
| ap-calculus-ab | 57 | 56 |
| biology | 43 | 43 |
| ap-calculus-bc | 66 | 3 |
| ap-chemistry | 68 | 0 |
| ap-precalculus | 53 | 0 |
| ap-physics-1 / 2 / c-mech / c-em | 192 | 0 |
| **Total** | **783** | **406 (51.9%)** |

**This does not block the gate.** The orienting sentence degrades independently: an unlabelled item
drops it and still gets the distractor-specific pointer and the closing question. Completing the
other 377 is `TASK-0050`, and it *improves* this feedback rather than being a precondition for it.

## What shipped in the code (PR #264)

Feedback is composed from what the item already knows, in three moves — orient (skill/unit), point
(the **chosen** distractor's authored rationale), redirect (hand back a question). `"Not quite."`
carries the verdict and none of the substance.

The shape rotates across four variants, selected by an FNV-1a hash of the item version and the
chosen distractor, so a twenty-question session does not read as one template twenty times while the
same result re-read is word-for-word stable. Per David, 2026-09-29: feedback should mix "tell" and
"ask" and have guidelines "loose enough that it doesn't feel overly formulaic."

Before and after, on real Production data:

> **Before:** Select the answer choice that matches the published correct answer.
>
> **After:** Not quite. This is Unit 2 material. Look again at the choice you picked: Reported the
> median instead of the mean. Keeping how to calculate summary statistics, relative positions,
> predicted responses in mind, how would you answer it now?

**Deliberately excluded**, not silently approximated:
- The **correct** choice's rationale is never read — it names the answer, and the item may be served
  to the same student again.
- **Naming what the student got right first**: a 1-point MCQ has no partial credit to praise.
- **Handing over a similar bite-sized problem immediately**: a serving / next-best-action decision,
  not a feedback string. See "Open questions".

## Acceptance criteria

- [x] No wrong-answer path can emit the string `"published correct answer"` — asserted across all
      144 combinations of variant × skill shape × rationale presence × unit presence.
- [x] The **chosen** distractor's authored rationale appears in the feedback when one exists.
- [x] The correct choice's rationale never appears.
- [x] Every shape, on every degradation path, ends on a question.
- [x] A skill or unit lookup that **errors** is treated as unknown and never fails a grade that is
      otherwise decided.
- [x] Composition is a pure exported function; 13/13 tests pass, `deno check` clean, `deno lint` at
      main's pre-existing baseline of 3.
- [ ] **Deployed to Production** — `evaluate-attempt` must go via the Supabase **CLI** with an
      explicit `--workdir`, not the MCP deploy tool.
- [ ] **Post-deploy verification**: submit a wrong MCQ on a labelled item (Statistics) and an
      unlabelled one (a Physics item), and confirm both read correctly and neither names the answer.

## Open questions for the Product Owner

1. **The 34 historical rows.** Existing `grading_results` still hold the placeholder text. Leave
   them as an honest record of what the student was actually shown, or backfill? Recommendation:
   **leave them.** Rewriting delivered feedback falsifies the record, and the students in question
   are pilot/internal accounts.
2. **Immediate re-practice.** "Give the student a similar, bite-sized problem right away" is the one
   strategy from your 2026-09-29 note that this task cannot satisfy — it is a serving decision. It
   needs its own task against the next-best-action path. Should that be launch-gating too?
3. **Generated feedback.** A model call per wrong MCQ would produce a genuinely bespoke probe rather
   than a rotation of four shapes. It adds per-answer cost and latency to a path that is currently
   free and instant. Not proposed for launch; flagged as the obvious next step if the rotation still
   reads mechanical to Orly.
