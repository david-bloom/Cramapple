# AP Statistics Phase 4 Content Authoring Brief

**Status:** Draft brief; not a gold-set or publish approval
**Related Task:** `TASK-0013`
**Product Owner:** David Bloom
**Curriculum Owner:** Orly Bloom
**Prepared:** 2026-06-30

**Blocked on:** Phase 2 (schema instantiation —
`prompts/CODEX_AP_STATISTICS_PHASE2_SCHEMA_INSTANTIATION.md`) actually
landing, since content needs a real `exam_pack_id` to attach to. This brief
is ready to act on the moment Phase 2 merges; no need to wait further once
it does.

## Purpose

Authoring brief for the AP Statistics pilot content batch — same governance
rules as AP Biology, same authoring model, different subject. This is not a
new content-authoring architecture; it's an application of the existing one
(`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`,
`CONTENT_GOVERNANCE_AND_VALIDATION.md`) to a second subject, per
`DECISION-0031`.

Platform boundary reminder: the shared platform is the prompt compiler,
grading/verification pipeline, schema, and release governance. AP Statistics
contributes subject-specific rows, labels, verification profiles, and content.
This brief only covers the subject-specific layer that sits on top of the
shared platform.

## Governing Rules (already settled, restated for this batch — not reopened)

1. Tutor-authored proprietary base packages, same model as AP Biology
   (`TASK-0007`/`TASK-0008`) — no new authoring arm.
2. No official CollegeBoard material — questions, scoring guidelines, or
   identifiable official structures — as model input, exemplar, or source.
   Same rights posture as Biology, confirmed unchanged in `DECISION-0031`.
3. Every candidate gets the same originality, scientific/statistical, and
   teaching/grading gates Biology content goes through — no shortcut for
   being "just a pilot."
4. Author-generated sample responses are development test cases, not a
   human gold set — Phase 6 calibration still requires independent blind
   tutor scoring before any grading-quality claim.

## Batch Composition (confirmed, `DECISION-0031`)

| Module | MCQs | FRQs |
|---|---|---|
| 1 | 15 | 6 |
| 2 | 5 | 2 |
| 3 | 10 | 4 |
| 4 | 6 | 5 |
| 5 | 5 | 4 |
| 6 | 10 | 4 |
| 7 | 10 | 4 |
| 8 | 5 | 2 |
| 9 | 5 | 2 |
| **Total** | **71** | **33** |

Plus the investigative-task item — **form and count still TBD**. This needs
its own scoping pass (see Open Question 1 below) before it can be authored
against; it does not block the MCQ/FRQ portion above.

No target date is set yet for this batch — revisit once you've had a chance
to weigh it against ongoing AP Biology work, per `DECISION-0031`.

## Open Questions for You (not yet decided — flagging, not deciding)

1. **Investigative task archetype.** AP Statistics' investigative task is a
   distinct task type from a standard long/short FRQ — it needs its own
   archetype definition under `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
   §6/§9 before anyone can author against it. Worth scoping with David before
   this batch is considered complete, even if the MCQ/FRQ portion ships
   first.
2. **`item_type: 'quantitative'` vs `item_type: 'frq'`.** Schema review for
   Phase 3 (`prompts/CODEX_AP_STATISTICS_PHASE3_CALCULATION_VERIFIER.md`)
   found the schema already has a third `item_type` value, `'quantitative'`,
   sitting alongside `'mcq'` and `'frq'`
   (`supabase/migrations/202606200001_initial_app_schema.sql:204`,
   `:429`) — designed in from the start but never used by any live AP
   Biology content. AP Statistics FRQs that primarily require a computed
   numeric answer (vs. primarily written scientific reasoning) may be a
   better fit for `'quantitative'` than `'frq'`, since the deterministic
   calculation-check verifier (Phase 3) is built specifically for that kind
   of response. This is a real design choice with downstream grading
   implications, not something to default silently — flag your read on it
   when you scope the batch, and loop in David if it changes how items get
   tagged.

## Unit Naming

Phase 2's migration seeds placeholder `content_labels` rows
(`label_name` like `"AP Statistics Unit 3"`) rather than guessing official
College Board unit titles, specifically to avoid a rights/sourcing question
landing in a schema migration instead of in your authoring review. Confirm
or correct the actual unit names/topics as part of authoring, the same way
you'd confirm any other content metadata.

## What This Brief Does Not Cover

- Pricing, bundling, or marketing sequencing for AP Statistics content
  (separate workstream, `docs/proposals/2026-06-23-codex-phased-plan.md`
  already lists AP Statistics as a Phase 2 SEO candidate, independent of
  this).
- Tutor recruitment or onboarding logistics — `DECISION-0031` already
  confirmed existing reviewers can be cross-credentialed, so this is
  scheduling, not a new hiring process.
- Publishing any of this content to live traffic — Phase 2's exam_pack_version
  ships `status: 'draft'` specifically so nothing here reaches a real
  student until a deliberate publish decision, separate from authoring.
