# Codex Execution Prompt - TASK-0013 Phase 4: AP Statistics Pilot Content Batch

**Draft only.** This prompt prepares the AP Statistics pilot content batch described in `docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`.

## Context

AP Statistics content is a subject-specific layer that sits on top of the shared platform. The platform is already in place; this work is about generating the first real AP Statistics practice items in the same governed content pipeline used for AP Biology.

Use the AP Statistics subject/module taxonomy from:
- `prompts/content/AP Statistics MCQ Prompt.txt`
- `prompts/content/AP Statistics Short FRQ Prompt.txt`
- `docs/product/AP_STATISTICS_PHASE4_CONTENT_AUTHORING_BRIEF.md`

## Goal

Generate a pilot batch of AP Statistics FRQs that can be staged for tutor review and later promotion into the content pipeline.

## Scope

1. Generate exactly 18 short FRQs, 2 per AP Statistics module, covering modules 1 through 9.
2. Use the subject/module names already defined in the AP Statistics prompt files.
3. Keep every item typed-response only.
4. Do not use hand-drawn responses for this batch.
5. Do not copy or paraphrase official College Board wording.
6. Make the items statistically sound, self-contained, and suitable for criterion-based grading.
7. Keep the content batch distinct from AP Biology scenarios and from any other question batch in the repo.

## Output Requirements

Return a single JSON array using the AP Statistics short-FRQ schema already established in `prompts/content/AP Statistics Short FRQ Prompt.txt`:

- `content_key` format: `APSTATS-SFRQ-001` through `APSTATS-SFRQ-018`
- `subject`: `AP Statistics`
- `item_type`: `frq`
- `frq_form`: `short`
- `modules`: one or more module numbers as strings
- `subtopics`: the best-fitting AP Statistics CED subtopic label(s)
- `intended_difficulty`: use a balanced spread across Easy / Medium / Hard / Very Hard
- `hand_drawn`: `false`
- `stem`: can be null if the stimulus fully frames the item
- `parts`: exactly 4 parts, `a` through `d`
- `criteria`: exactly one criterion per part

## Quality Rules

- Every part requiring a numeric answer must supply enough information to compute it exactly.
- Criteria that depend on a computed value should state the expected value and tolerance plainly.
- Use AP Statistics reasoning, not generic math exercises.
- Vary the scenarios across the 18 items.
- Make sure the module coverage is even: two FRQs per module, one item can cover multiple modules only if needed and clearly justified.

## What Not To Do

- Do not add hand-drawn parts.
- Do not use `quantitative` unless explicitly directed elsewhere.
- Do not invent new subject taxonomy labels.
- Do not output commentary outside the JSON array.

## Validation Notes

After generation, the batch should be schema-checked and staged for tutor review through the normal AP content workflow.
