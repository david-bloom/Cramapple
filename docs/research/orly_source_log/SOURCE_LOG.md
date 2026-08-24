# Orly Source Log

One row per document received under
`docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`.

| Date received | School / teacher | Subject | Document type | CED units/topics covered | Category | Mined for | Items authored from it | Rights notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-08-24 | Solebury School / Michelle Gavin | AP Calculus AB | Summer assignment, Unit 1 Part I (Flipped Math LT1.1-1.8) | 1.1-1.8 | CED-aligned unit content | Topic scope, pacing, self-assessment rubric | apcalcab-mcq-060, -070, -080, -090 (published to Prod 2026-08-24, David's direct approval) | References `calculus.flippedmath.com` video curriculum - licensed to the school, not embedded or linked by us |
| 2026-08-24 | Solebury School / Michelle Gavin | AP Chemistry | Summer assignment (no unit label) | None directly - prerequisite skills only | Prerequisite / readiness content | Confirms readiness-content is a real, distinct category (see protocol §4/§6) | None yet | Problems resemble standard textbook-style density/mole exercises; treated as restricted per protocol §2 |
| 2026-08-24 | Solebury School / Hannah Pritchett | AP Calculus BC | Summer assignment: DeltaMath problem set (Units 1 & 2) + 3 DeltaMath "Corrective Assignment" printouts (Mid-Unit 1, End-of-Unit 1, Unit 2 CA) | 1.1-1.16 (full unit), 2.1-2.10 (through quotient rule) | CED-aligned unit content, but source platform is DeltaMath (licensed third-party item bank), not teacher-authored - see protocol §2 revision below | Topic scope (both units), pacing, per-unit test cadence, corrective/remediation structure | apcalcbc-mcq-060, -070, -080, -090 (published to Prod 2026-08-24, David's direct approval) | DeltaMath is commercial curriculum software; "Corrective Assignment" packets are its own auto-generated item bank, not the school's original work - treat as *more* restricted than a teacher-authored worksheet, per the new §2 platform-content note |

**Publish note (2026-08-24):** all 8 items above went straight to Prod
`status='published'` on David's explicit approval ("simple versions of
questions assigned to Orly"), via
`supabase/migrations/20260824120000_orly_protocol_calc_unit1_unit2_items.sql`.
Each still walked `draft -> reviewed_approved -> published` so the DB's own
publish-gate and pipeline-guard triggers applied normally; `review_status`
is `answer_approved`, recording a Product Owner approval rather than a
standard second-reviewer pass. Not inserted into Dev. No
`content_taxonomy_labels` rows created yet, so these won't surface through
taxonomy-gated serving paths until the normal labeling pipeline runs.

**Correction note (2026-08-24, same day):** David caught that all 8 items had
their correct answer at choice key `A`. Fixed via
`supabase/migrations/20260824130000_randomize_orly_protocol_mcq_correct_keys.sql`
(random per-item reassignment of A/B/C/D). Also performed and recorded a
proper independent re-derivation of all 8 answers
(`supabase/migrations/20260824140000_record_independent_re_derivation_orly_protocol_items.sql`)
per the newly-added protocol §6 step 4. See the protocol's revision notes for
both fixes and the going-forward requirements.

**Taxonomy labeling note (2026-08-24, same day):** ran
`scripts/taxonomy/extend_math_serving_labels.mjs --write-db` against
Production once per content_key for all 8 items (the script only accepts a
single `--key` filter). Required temporarily relinking the Supabase CLI from
Dev to Production and back per run set — see the script's reliance on
`supabase db query --linked`. All 8 got `label_status='provisional_model'`
(two-model agreement between `openai/gpt-5.5` and `google/gemini-2.5-flash`),
matching this session's originally-authored `taxonomy_refs` exactly: AB items
-> unit 1, BC's 1.10/1.15 items -> unit 1, BC's 2.2/2.9 items -> unit 2.
`provisional_model` is not the same as `validated` (that requires a formal
validation decision per `content_taxonomy_labels_validation_check`) - these
items are now serving-eligible but still awaiting that validation pass. Note:
the script writes its run report to a fixed path per subject
(`docs/research/MATH_TAXONOMY_SERVING_LABEL_RUN_2026_08_04.md` for calc/precalc)
via overwrite, not append - running it once per content_key clobbered that
shared doc 8 times in a row; restored via `git checkout` since no data was
lost (only the DB writes matter, and those were verified independently
after). A batch mode that accepts multiple `--key` values (or writes an
append-only per-run log) would avoid this next time.

**Validation note (2026-08-24, same day):** per
`docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §T6, a model may
never write `label_status='validated'` unsupervised, and no
`validation_decision`-tracking table exists in this schema
(`validation_decision_id` is an unreferenced bare `uuid` column - a gap, not
a mistake in this write). David reviewed the primary_unit/required_units
table for all 8 items directly in chat and confirmed them explicitly; applied
via `supabase/migrations/20260824150000_validate_orly_protocol_taxonomy_labels.sql`
(`validated_by`=David, a generated placeholder `validation_decision_id`, gap
documented in each row's `source_payload.human_validation`). Verified
end-to-end: `public.select_unit_gated_practice_items` now actually returns
all 8 items at their correct unit (AB items and BC's 060/070 at unit 1, BC's
080/090 at unit 2) - the real student-facing selector, not just the label
table.

**Gap closed (2026-08-24, same day):** spawned and executed
`docs/tasks/TASK-0028-CONTENT-TAXONOMY-VALIDATION-DECISION-TABLE.md`, adding
`app.content_taxonomy_validation_decisions` and a real foreign key for
`validation_decision_id`. The 8 placeholder UUIDs above are now backed by
real decision rows (backfilled with the same IDs, so nothing was
re-validated) instead of being unreferenced. Future validations get a real
decision record from the start.
