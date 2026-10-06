# TASK-0065 Open Hand teaching batch: load report (2026-10-06)

## Summary

- 76 items in scope: 91 in `SCOPE_UNITS_1-3.json`, minus the 15 still blocked. Biology 15, Statistics 25, Chemistry 21, Calculus AB 15.
- **Development (`wmgjsdkphcyhngaffbqf`):** Biology (15) and Statistics (25) are loaded and verified.
- **Chemistry and Calculus AB could not be loaded in Development.** Development has no published exam pack version for either subject: Chemistry has only a draft pack (`b119fcbf-…`), and Calculus AB has no pack at all. The loader stops with `task0065: no published, non-retired exam pack version for <subject>` and writes nothing. I did not create or publish a pack in Development.
- **Production (`pcntajvbdfqhbeewmdry`):** read-only checks only. Each subject has exactly one published pack, all 76 topics exist in the subject taxonomy, there is no `-OHT-` content_key collision, and no active spare shares a topic with this batch, so no spare will be released there.

## Approach

`scripts/content-seed/task0065_load/build_load_sql.py` writes one SQL file per subject to this folder. Each file is a single `DO $oht0065$ … $oht0065$` block. The items travel as one dollar-quoted jsonb literal (`$oht0065json$`), so the text needs no escaping. The block does the following:

1. **Pack.** It finds the subject's published, non-retired exam pack version at run time, because pack ids differ between Development and Production. If a subject has more than one, it uses the pack that already holds teaching items. Development Statistics has two: `4e54bb4f-695f-41be-ac06-745fe9ad8bcc` (212 items, 3 teaching items) and `16000000-0000-4000-8000-000000000003` (7 items, none). The block chose `4e54bb4f`. Production Statistics has a single pack, `548f06be-…`.
2. **Skip loaded items.** If a content_key already exists in that pack, the item is skipped. Re-running a file is a no-op.
3. **Insert as draft.**
   - `content_items`: `mcq`, draft. The title is the topic title. `practice_format` stays NULL because the check constraint allows it only on FRQs, and the publish trigger checks FRQs only.
   - `content_item_versions`: v1, draft, `content_hash = md5(content_key)` (the convention on existing teaching and variant rows), `rubric_type 'mcq'`, `evaluator_strategy 'rule_based_mcq'`, and `canonical_answer_1` set to the correct letter.
   - `mcq_choices`: 4 rows, A to D.
4. **Topic cell.** One primary `content_item_cells` row with `assignment_status 'authored'` and source `task0065_oht_generated_2026_10_06`, on the subject's taxonomy version (the UUIDs are identical in both environments). `content_item_topic_resolution` accepts `validated` or `authored`. `authored` needs no validation decision, and it is the status the existing `course_mode_generator_f4` cells use in both environments.
5. **Publish.**
   - Version: draft → `reviewed_approved` with `review_status 'question_review_approved'`, then → `published`.
   - Item: → `reviewed_approved`, then → `published`.
   - `approved_by` is the Product Owner profile `f5a26c6b-…` if it exists. It exists in Production; in Development it is NULL.
6. **Teaching row.** Insert into `open_hand_teaching_items`: `source 'generated'`, note `TASK-0065 batch 2026-10-06`.
7. **Release spares.** Set `released_at = now()` on any active `spare` row for the same subject and topic.

**No `content_taxonomy_labels` (serving) rows are written.** The scoring selector inner-joins a validated serving label and also filters `not app.content_item_is_teaching(...)`, so these items are excluded twice over.

## Gates encountered (read with `pg_get_functiondef` in Development; definitions match Production)

| Gate | What it requires | How the load satisfies it |
|---|---|---|
| `enforce_publish_gate` | Version `published` only with review_status in {question_review_approved, difficulty_confirmed, answer_approved, mcq_answer_review_complete} | Sets `question_review_approved` at the `reviewed_approved` step |
| `tg_content_pipeline_guard_publish` (items + versions) | Publish only from `reviewed_approved` | Two-step update |
| `enforce_mcq_stem_choice_sync` | The stem must not embed `A.`/`B)` option lines that differ from `mcq_choices` | Choices are inserted before publish; no stem in the batch has option lines (checked offline for all 76) |
| `tg_require_practice_format_at_publish` | FRQs only | Not applicable; `practice_format` stays NULL (constraint) |
| `content_item_cells_validation_check` | `validated` needs validator/decision fields | Uses `authored` |

No trigger, constraint or RLS policy was disabled.

**Note for review:** the load sets `review_status` directly. It does not write `content_review_assignments` or `content_review_decisions` rows. The held-four precedent did write them, but no gate requires them. The approval basis is the batch check in `../CHECK_RESULTS.md`.

Production has a few extra objects that Development lacks: the `tg_content_versions_taxonomy_stale` and `tg_mcq_choices_taxonomy_stale` triggers (they only mark labels stale, and we write no labels), the non-empty checks on choice text and rationale (satisfied), and the `changes_requested` status. None of these affects this SQL.

## Verification in Development

| Check | Biology | Statistics |
|---|---|---|
| Items loaded / published (item + version) | 15 / 15 | 25 / 25 |
| 4 choices, exactly one correct | 15 | 25 |
| Loaded text md5 = source JSON (stem + choices + rationales) | 15/15 match | 25/25 match |
| Primary cell resolves `topic_title` + `unit_number` | 15 | 25 |
| `app.content_item_is_teaching` true | 15 | 25 |
| Serving taxonomy labels written | 0 | 0 |
| `get_open_hand_teaching_item(subject, topic)` returns the new item (entitled student `c987e62b-…`), with title, unit, 4 choices and `scoring_eligible=false` | 15/15 | 25/25 |
| Student direct read of `content_item_versions` / `mcq_choices` for these items (RLS) | 0 rows | 0 rows (202 non-teaching versions of the same pack are visible, so the RLS filter is teaching-specific) |
| `get_open_hand_teaching_topics` lists every loaded topic | 15 of 15 total | 25 (26 total, including spare 1.6) |

- **Scoring selector check.** `public.select_unit_gated_practice_items` cannot run in Development. It fails with `function app.taxonomy_relevant_hash(uuid) does not exist`, which is environment drift that predates this work: the function exists in Production but not in Development. Exclusion is instead shown structurally: no serving labels exist for the items (the selector inner-joins a label), and `content_item_is_teaching` is true (the selector's explicit filter). Repeat the selector check in Production after the load.
- **Student-visible metadata.** A student can still see the bare `content_items` row (key and title, no stem or choices) for teaching items, the same as for existing spares.
- **Pasted SQL.** The SQL applied in Development matches these files except that three comment lines were left out when pasting.

## Spares released

- Development, Statistics: `1.5` and `1.9` (Statistics spare `1.6` stays active because it has no generated item). Biology: none.
- Production preview: none for any subject.

## Files to run in Production (one at a time, each a single statement)

1. `docs/research/open_hand_teaching_batch_2026_10_06/load/biology.sql` (15)
2. `docs/research/open_hand_teaching_batch_2026_10_06/load/ap-statistics.sql` (25)
3. `docs/research/open_hand_teaching_batch_2026_10_06/load/ap-chemistry.sql` (21; not exercised in Development, see above)
4. `docs/research/open_hand_teaching_batch_2026_10_06/load/ap-calculus-ab.sql` (15; not exercised in Development)

Afterwards, run the output of `python3 scripts/content-seed/task0065_load/hash_check_sql.py` (read-only; it expects `expected = loaded = matching = 76` and `mismatched` NULL). Then repeat the RPC, RLS and selector checks above.

To regenerate the files: `python3 scripts/content-seed/task0065_load/build_load_sql.py`.
