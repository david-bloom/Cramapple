# AP Statistics Unit 2: harder seeds and variants, publish package

Status: EXECUTED in Production 2026-11-10 under `APPROVAL-0214` (96 published, 33 retired). Blind solve by DeepSeek V4 Pro and Kimi K3.1 Pro: 96 of 96 keys agree. See the approval record for the execution log and what was not verified.
Created 2026-11-10 from the owner-session drafts in `output/stats_unit2_replacement_seeds_draft.md`.

## What it contains
- 96 new MCQs for AP Statistics Unit 2 (topics 2.1 to 2.12): 24 seeds + 72 variants, 8 per topic.
- Replaces 33 published items (8 seed families of 4 items each, plus `APSTATS-MCQ-073`). List: `superseded_keys.json`.
- Correct-answer position is balanced: 24 each of A, B, C, D.
- Every choice carries a student-facing rationale.

## Files
| File | Purpose |
|---|---|
| `items.json` | The 96 items: key, topic, title, stem, four choices with rationales |
| `load/chunk_01..11.sql` | Insert drafts (item, version 1, 4 choices each); 9 items per chunk; each chunk guards against re-loading |
| `load_manifest.json` | md5 of each item's stem + choices + rationales |
| `verify_hashes.sql` | Read-only: compares what is in the database with the manifest (expect 96 rows, `ok = true`) |
| `publish_rehearsal.sql` | Whole publish in one transaction, ends in a `REHEARSAL OK` exception and rolls back |
| `publish.sql` | Same transaction, commits |
| `retire_old_rehearsal.sql` / `retire_old.sql` | Retire the 33 superseded items; refuses to run unless all 96 new items are already published |
| `parse_draft.py`, `build_items.py`, `gen_package.py` | Regenerate everything from the draft markdown (`rationales_extra.py`, `polished_rationales.py` hold the authored rationales) |

## Order of operations (each Production step needs owner approval and an APPROVAL id)
1. Check `main` and open PRs for the highest APPROVAL number before numbering (collisions have happened); write the approval entry and the decision/activity log entries.
2. Load: run `load/chunk_01.sql` .. `chunk_11.sql` in order. Then `verify_hashes.sql` (expect 96 `ok`).
3. Rehearse: `publish_rehearsal.sql` must end with `REHEARSAL OK (rolled back): published=96, ...`.
4. Publish: `publish.sql`; re-run `verify_hashes.sql` (expect `item_status = published`).
5. Rehearse then run the retirement: `retire_old_rehearsal.sql`, `retire_old.sql`. Do this only after step 4 is verified.
6. Verify what a student actually gets: practice selector returns new items for each Unit 2 topic; no retired item is served; student-session-items edge function unaffected.

## How it follows the existing publish path
Copied from `scripts/content-seed/pipeline-v2-physcem-u13-2026-10-03/gen_load.py`: `draft -> reviewed_approved -> published` on item and version, `owner_remediation_approval` review assignment + decision, structural QA gate, serving label (`provisional_model`, then validated against `app.taxonomy_relevant_hash`), validation decision, and a primary topic cell.

## Differences from that path (read before approving)
- **No seed to inherit a label from.** The 24 seeds are new, so labels use constants: `required_units {2}`, `primary_unit 2`, taxonomy source version `dae3c72e-82ca-4960-9552-1b034bd347e5` (the one every Statistics serving label and cell uses today). Topics 2.1 to 2.12 all have existing cells in that version; the publish script refuses to run if one does not.
- **Topic-only cells**, `skill_code` null (allowed; topic-only tagging).
- **Validation decision source is `chat_review`**, not the `automated_spot_check` the model-checked runs used, because no model checker voted on these labels.
- **No two-checker pass, no topic/skill vote.** Owner decision 2026-11-10: the earlier protocol produced the over-simple seeds. The topic on each item is the author's design intent.

## Not verified (state plainly)
- (Superseded by execution.) Both rehearsals returned REHEARSAL OK, both real runs committed with the expected counts.
- Key correctness: every number was computed in Python by the author while drafting. (Superseded: a blind solve by two non-Claude models later agreed on 96 of 96.) Project memory lists independent re-derivation of keys as a hard publish precondition even with Product Owner approval; this package does not satisfy it by itself.
- Dev was not checked for drift, and no APPROVAL id has been taken.
- Student-facing text was not read by a content reviewer. Tables are written as `Row, Column: value` lines (as `APSTATS-MCQ-SV-046-v3` does); group totals are omitted and are left for the student to compute.
- 2.12 normal-probability answers assume the CLT conditions are met (stated in each stem).

## Rollback
- Before step 5: retire the 96 new items (same pattern as `retire_old.sql`, keyed on `APSTATS-MCQ-H-%` / `APSTATS-MCQ-SV-H-%`).
- After step 5: re-publish the 33 old versions (their rows are retired, not deleted; student history is intact).

## Draft approval entry (unnumbered)
> **APPROVAL-XXXX** (owner, 2026-11-10): publish 96 AP Statistics Unit 2 MCQs (24 seeds, 72 variants, topics 2.1 to 2.12) replacing 33 published items (families 050, 051, 046, 048, 054, 049, 081, 052 and MCQ-073). Authored in session, arithmetic verified by the author in Python, no model-checker pass by owner decision. Production writes: 11 load chunks, one publish transaction, one retirement transaction.
