# Prompt: Execute the Cross-Subject Content Remediation Pilot

You are revising a frozen 21-question cross-subject packet from Cramapple's
Production `changes_requested` queue.

Read completely:

1. `docs/research/content_remediation_cross_subject_pilot_2026_07_27/README.md`
2. `docs/research/content_remediation_cross_subject_pilot_2026_07_27/repair_manifest.json`
3. `docs/product/CONTENT_AUTHORING_AND_REVISION_WORKBENCH_DESIGN.md`
4. `docs/product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`
5. `docs/research/GRADING_RESEARCH_CANONICAL_PROCESS.md`

Then resolve the complete current source packages using
`source_snapshot.sql`.

## Your job

For every manifest item:

1. Verify that the resolved latest version still matches the frozen
   `source_version_num`. Stop and report drift for that item if it does not.
2. Decide one disposition:
   - `revised`;
   - `verified_no_change`;
   - `exclude`; or
   - `needs_subject_adjudication`.
3. Draft the complete successor package for every `revised` item:
   - student-visible stem and stimulus;
   - canonical answer;
   - prompt metadata, including justified total points;
   - complete FRQ criteria or MCQ choices/rationales;
   - author response to the tutor finding;
   - field-level change summary.
4. For rubric changes, provide a prompt-task-to-criterion map and explain every
   point-total change.
5. For assumption changes, identify the exact student-visible sentence that
   resolves the ambiguity and show that all dependent artifacts use the same
   convention.
6. For substantive rewrites, state the preserved assessed construct and
   explain why the revised item remains in AP course scope.
7. For `apchem-mcq-050`, adjudicate the dimensional analysis before editing.
8. For `APSTAT-MOD8-M004`, do not manufacture a change if the current version
   already satisfies the finding.

## Required verification

For each FRQ:

- prompt requirements and rubric criteria map completely;
- point totals reconcile;
- criteria are atomic and non-overlapping;
- required evidence, accepted variants, and minimum fixes are present;
- calculations, units, signs, and assumptions are independently checked.

For each MCQ:

- exactly one best answer;
- four unique choices;
- every rationale explains the actual misconception represented by its choice;
- answer length and specificity do not leak the key;
- calculations and units are independently checked.

## Independence and Production boundary

Do not overwrite a reviewed source version. Do not approve or publish your own
revision. Prepare immutable successor-version payloads and a review handoff.
The revision author is ineligible to perform either independent tutor review.

Return:

1. a 21-row disposition table;
2. successor packages for revised items;
3. validation results;
4. unresolved adjudication questions;
5. proposed independent reviewer assignments by qualification scope; and
6. a pilot report with first-pass completion, expected review burden, and
   cross-subject lessons.
