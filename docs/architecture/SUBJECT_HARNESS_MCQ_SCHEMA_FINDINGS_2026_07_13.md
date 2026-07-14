# Item-Package Schema — MCQ Findings (Codex / H1 schema lane)

**Prepared:** 2026-07-13 · Author: Claude (content lane, from authoring the AP Statistics slice MCQs)
**For:** Codex (owns `schemas/subject-onboarding/item-package.schema.json`) · **Task:** TASK-0017
**Evidence:** `docs/content/ap_statistics_2026_27_slice/` MCQ items +
`deno run --allow-read docs/content/ap_statistics_2026_27_slice/compile-check-mcq.ts` (8 items compile green)

## Context

Authoring the G2V slice MCQ portion (one 3-question set + one standalone MCQ per unit) exercised the
item-package contract for `item_type: "mcq"` for the first time. **All 8 MCQs compile green** and the
`choice-key` deterministic check works. But two structural gaps surfaced that real MCQ content (and
the exam's "two three-question sets") will keep hitting. Neither blocks the slice; both are worth an
explicit H1 design decision before bulk MCQ authoring.

## Finding 1 — no structured MCQ options model

The schema has no `options`/`choices` field on a part or criterion. The four answer choices had to be
embedded as free text inside `parts[].prompt` (e.g. `"...\n(A) 18\n(B) 40\n..."`), and the
`choice-key` deterministic check's `choice: "A"` parameter refers to a letter that exists **only in
that prose**. Consequences:

- No machine-readable option set → a renderer can't reliably present choices, and a grader can't map
  a student selection to a canonical option without parsing the prompt string.
- Distractor metadata (per-option rationale, common-misconception tags) has nowhere to live.
- Option shuffling / position-bias control is impossible without structured options.

**Suggested H1 direction:** add a typed `options` array to MCQ parts (e.g.
`[{ option_key: "A", text, is_correct?, rationale? }]`) and have `choice-key` reference `option_key`.
Keep it optional/additive so existing FRQ items are unaffected.

## Finding 2 — no item-set / shared-stimulus-group construct

The 3-question set had to be modeled as **3 separate item-packages that each duplicate the shared
stimulus**, with the set relationship expressed only by a `content_key` naming convention
(`…-mcq-set1-q1/q2/q3`). The archetype `mcq-four-option` is `total_points: 1`, so a single item with
3 parts is not an option (it would trip `rubric.archetype_points_mismatch`). Consequences:

- Shared stimulus is duplicated N times; edits must be kept in sync by hand, and there's no integrity
  check that set members share an identical stimulus.
- The blueprint already declares real sets ("includes two three-question sets"), but the harness
  cannot represent or validate set membership, ordering, or shared-stimulus identity.

**Suggested H1 direction:** either a first-class `item_set` package (shared stimuli + ordered member
items) or a `set_ref { set_key, ordinal }` on item-packages plus a compiler check that set members
share a stimulus hash. Additive; FRQ/standalone items unaffected.

## What is NOT needed

No change to compile items today — the slice MCQs are valid and green. These are **modeling** decisions
for representing MCQs faithfully, owned by the schema/H1 lane (Codex, routed through TASK-0009 for
schema authority). No environment or compiler change is requested by this note.
