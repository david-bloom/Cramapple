# Codex Prompt — review-decision / review-queue: Categorical Scoring

**Status:** DO NOT EXECUTE until `DECISION-0038` is confirmed and this change is
cleared for implementation. Backend half of the review-scoring model change.
**Related:** `DECISION-0038`, migration
`supabase/migrations/202607140001_review_decision_categorical_scoring.sql`,
`docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`.

## Scope

Update `supabase/functions/review-decision/index.ts` (and any read paths in
`review-queue/index.ts`) to use the categorical decision model instead of the
numeric 1–3 tutor score. The migration `202607140001` has already added
`tutor_decision`, `difficulty_action`, and extended `reader_decision`.

## Required changes

1. **Ingest.** Accept `tutor_decision` ∈ {`approve`,`approve_with_edits`,
   `disapprove`} for tutor stages and `reader_decision` ∈ same set for the reader
   stage. Accept `difficulty_action` ∈ {`agree`,`propose`} with `difficulty_label`
   required only when `propose`. Reject the old numeric `tutor_score` for new
   submissions (or accept and map, behind a flag, during transition — pick one and
   document it). Update the `missing_required_fields` / `invalid_*` errors
   accordingly.

2. **Tutor aggregate (replaces `scoreA + scoreB`).** Given the two tutors'
   `tutor_decision` values:
   - both `approve` → create the `reader_question` assignment (advance).
   - no `disapprove`, at least one `approve_with_edits` → flag
     `modification_reserved` (edit-and-recycle → new version → two tutors).
   - any `disapprove` → flag `excluded`.
   This changes the old behavior where Maybe+Maybe (aggregate 4) was excluded:
   two `approve_with_edits` now routes to edit-and-recycle, not exclusion.

3. **Difficulty (replaces exact-label agreement).** Confirm difficulty only when
   **all** reviewers' `difficulty_action` = `agree`; if any `propose`, set
   `review_status = 'difficulty_discussion'`. Never average. `validated_difficulty`
   (confirmed) = the intended difficulty when all agree.

4. **Reader stage.** Map `approve` → pass (MCQ: fan out `tutor_answer`; FRQ:
   `question_review_approved`); `approve_with_edits` → `modification_reserved`;
   `disapprove` → `excluded`. Keep legacy `agree`→approve / `disagree`→disapprove
   mapping for historical rows.

5. **decision_payload / decision_hash.** Keep populating the audit payload with the
   full submitted structure (now categorical). No change to the hashing contract.

## Tests / QA

- Unit-test each aggregate combination (approve+approve, approve+edits,
  edits+edits, any+disapprove) and each difficulty action combination.
- Regression: existing AP Biology / AP Statistics review rows (legacy `tutor_score`
  / `agree`/`disagree`) must still resolve correctly via the backfilled columns.
- This is Hard-Gate (touches live review pipeline + a migration): fresh-context QA
  required before merge; migration goes through the Database Migrations gate.
