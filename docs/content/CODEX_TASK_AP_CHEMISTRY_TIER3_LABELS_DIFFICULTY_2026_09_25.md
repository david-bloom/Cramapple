# Codex Task — AP Chemistry Tier 3: Serving Labels + Difficulty (2026-09-25, v3)

**Revision note.** v1 of this task was reviewed by Codex before starting and returned five clarifying
questions plus a list of ambiguities. v2 answered all of them, with exact numbers re-verified against
Production, and added stop conditions, a required dry-run artifact, deterministic batching, and a
local-migration-file requirement. Codex then ran a preflight against v2 and found the 12-item
duplicate-current-serving-label anomaly documented in
`docs/content/NOTE_AP_CHEMISTRY_12_ITEM_GAP_FOR_CLAUDE_2026_09_25.md`, stopped before any Production writes,
and correctly deferred the disposition decision rather than silently picking one. Claude investigated and
found the 12 split into two materially different situations (see that note's "Resolution" section, added by
Claude). **David's decision: fold the 7 items where the fix is unambiguous into this run's target set; set
the other 5 aside as a separate, documented gap — do not touch them in this task.** This v3 updates the
target set and PART A accordingly. Read this whole document before running anything — do not start from a
cached v1 or v2 copy.

**Context.** `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md` splits Tier 3 (servability
criteria 3 and 5 — serving labels and difficulty — for the nine non-Biology subjects) into pairs: one
subject to Codex, one to Claude, then cross-QA before the next pair. Pair 1 is AP Statistics (Claude) and
AP Chemistry (Codex). Claude's AP Statistics half is done: 126 serving-label rows applied to Production
(107 `provisional_model`, 19 `held`, 0 promoted to `validated`) and 170 difficulty rows applied. This task
is the Chemistry half.

## Answers to v1's clarifying questions

1. **Repo checkout.** Use whatever local checkout of `Cramapple` you normally work from — this is not a
   location Claude can dictate from its own environment. What matters: before doing anything else, `git
   fetch origin` and confirm your branch's `origin/main` history includes commit `9ce90b1c` (or later) —
   that is the commit that added `scripts/taxonomy/extend_serving_labels_mcp.mjs`,
   `scripts/taxonomy/fetch_serving_label_packets.sql`, and this task doc's first version. If
   `git log --oneline -1 origin/main` does not show that commit or later, or if
   `scripts/taxonomy/extend_serving_labels_mcp.mjs` is still missing after merging, **stop and report** —
   do not improvise a substitute script or hand-write the pipeline logic yourself.
2. **Are `stale` rows reprocessed alongside `legacy_unvalidated`/no-label rows?** Yes — see "Precise target
   set" below. `stale` means the label was computed against an older taxonomy/content version and is no
   longer trustworthy as current; treat it exactly like `legacy_unvalidated` for this run (needs a fresh
   label). Do not leave `stale` rows as-is.
3. **Cross-QA timing.** Post-apply cross-QA is fine, matching the paired plan (`Cross-QA after both land`).
   Do not wait for a pre-apply review before writing to Production.
4. **Partial difficulty CSV coverage.** Load whatever the CSV covers; report the gap, the same way Claude's
   Statistics report flagged 23 live pack items with no CSV row rather than blocking on it. Do not stop for
   approval over a coverage gap — just report it precisely (exact `content_key`s missing).
5. **Local migration files.** Yes, required — see "Local migration files" below. A report-only PR is not
   acceptable; the applied SQL must also exist in `supabase/migrations/` so the repo's history matches what
   Production actually has.

## Precise target set (updated after Codex preflight, 2026-09-25)

"Current" label row = `label_scope='serving' and superseded_by is null` (exactly one such row should exist
per content_item at any time; if you find an item with zero or more than one current row, that is itself a
data-integrity finding to report, not something to silently fix).

Live AP Chemistry item count (via `exam_packs.exam_code = 'ap_chemistry'` joined through
`exam_pack_versions` where `retired_at is null` joined to `content_items`): **136 items** in the single live
pack version `c9ca46b2-b529-4ed3-9741-dddea455ab9b` (status `published`, `retired_at is null`). Current
serving-label integrity is not perfectly clean: 124 items have exactly one current serving-label row and 12
items have two current `legacy_unvalidated` serving-label rows. This explains the earlier 148 figure as likely a
current-serving-label-row count, not a distinct-content-item count: 124 single-current-label items + 24 current
rows on the 12 duplicated items = 148 current label rows. See below for the disposition of those 12 (7
folded into this run, 5 excluded) — David has already decided this; it is not still an open finding to
report-only.

Breakdown by first/current serving-label status across the 136 live items:

| label_status | item count |
| --- | ---: |
| `held` | 32 |
| `legacy_unvalidated` | 26 |
| `provisional_model` | 1 |
| `stale` | 34 |
| `validated` | 43 |
| **total live items** | **136** |

Of the 26 `legacy_unvalidated` items, 12 have duplicate current serving-label rows (both `legacy_unvalidated`,
both empty placeholders — `required_units=[]`, no real classification). Claude's investigation (see
`docs/content/NOTE_AP_CHEMISTRY_12_ITEM_GAP_FOR_CLAUDE_2026_09_25.md`, "Resolution" section) found these 12
split into two groups by whether either duplicate row's `validated_against_version_id` matches the item's
actual current content version:

- **Group A (7 items) — fold into this run.** The newer of the two duplicate rows matches the item's current
  content version; the older one is a stale leftover from before a content revision. Include these in the
  label target set below. **When your pipeline writes the new model-generated label for one of these 7, it
  must set `superseded_by` on *both* existing current rows for that item, not just one** — the pipeline's
  normal assumption of exactly one current row to supersede does not hold here. Verify after each of these 7
  specifically that zero rows remain with `superseded_by is null` other than the new one you just inserted.
  `apchem-frq-l-002`, `apchem-frq-l-006`, `apchem-frq-l-012`, `apchem-mcq-001`, `apchem-mcq-070`,
  `apchem-sfrq-006`, `apchem-sfrq-010`.
- **Group B (5 items) — excluded, do not touch in this task.** *Neither* duplicate row matches the item's
  current content version — these items have been revised again since (to content version 3 or 4) with zero
  labels, even placeholder ones, ever generated against that current version. Superseding one stale
  duplicate wouldn't actually fix anything for these; they need a decision beyond this task's scope. Leave
  both existing rows on each of these exactly as they are; do not touch, supersede, or generate a label for
  them. Report their exclusion in your deliverable, but they are David's decision to defer, not yours to
  resolve.
  `apchem-frq-l-013`, `apchem-frq-l-014`, `apchem-sfrq-003`, `apchem-sfrq-014`, `apchem-sfrq-024`.

Therefore the label pipeline target is 14 clean `legacy_unvalidated` + 34 `stale` + 7 Group A duplicate-fix
items = **55 items**.

- **Primary run targets (process these): 55 items** — clean single-current-label `legacy_unvalidated` (14) +
  `stale` (34) + Group A duplicate-fix (7). See the dual-supersession requirement above for the 7.
- **Excluded by default, do not touch: `held` (32), `provisional_model` (1), `validated` (43), and Group B
  (5, listed above).**
  `provisional_model` already has a current label from the earlier partial run; re-running it would just
  waste model calls and create a pointless extra version — leave it. `validated` is a human-governance
  status; never touch it in this task.
- **`held` may be re-run only with a specific, individually-recorded reason** (see "Held items" below) —
  never as a blanket re-run of all 32.


Live AP Chemistry item-and-current-version-published count (the analogous "actually servable" set Claude
used for Statistics' difficulty load, i.e. `content_items.status='published' AND` the item's most-recently-
created `content_item_versions` row also has `status='published'`): **119 items.** This is the target set
size for the difficulty load — re-derive the exact list yourself from Production rather than trusting this
number blindly, the same way Claude had to re-derive Statistics' 170 after finding the CSV's naming
convention didn't match the live pack 1:1.

Current AP Chemistry difficulty coverage in `app.content_item_difficulty`: **0 rows.** This is a clean
slate for Part B; there is no existing-row cleanup to do first.

## Held items — case-by-case, not blanket

For the 32 current `held` rows, do not re-run them as part of this task's primary pass. If, while building
your packets query or reading through held rows for context, you notice a specific held item where the
hold reason looks resolvable (e.g. a `model_unit_disagreement` that resolves cleanly on inspection, or a
`rubric_preflight_failure`/`other` that turns out to be a genuine removed-topic distractor the way AP
Statistics' `APSTATS-MCQ-075`/`APSTATS-MCQ-088`/`APSTATS-MCQ-094`/`APSTATS-MCQ-098`/`APSTATS-MCQ-100` were —
note it in your report as a candidate for a follow-up task, but do not re-run it inline unless you can name
the specific `content_key` and reason in your report alongside a before/after label-row comparison. If in
doubt, leave it held and report it as a candidate rather than acting.

## Stop conditions

Stop immediately and report (do not push, do not apply further migrations) if any of these are true:

- The Supabase MCP tool is unavailable or errors in a way that would force you to fall back to the local
  `supabase` CLI against Production.
- The project ref you are about to write to is not `pcntajvbdfqhbeewmdry`.
- The live AP Chemistry item count you compute differs from 136 by more than 5 (small drift is plausible if
  content changed since this doc was written; a bigger gap means something is wrong with your query or the
  content has changed substantially — verify before trusting either number).
- Any of the 5 Group B items (`apchem-frq-l-013`, `apchem-frq-l-014`, `apchem-sfrq-003`, `apchem-sfrq-014`,
  `apchem-sfrq-024`) end up with a row count, `superseded_by` value, or label change of any kind — they are
  explicitly out of scope for this task.
- Any generated `write_labels.sql` (or your batched split of it) contains the literal string `validated` as
  a `label_status` value.
- Any generated SQL references a `content_item_id` that does not belong to the live AP Chemistry pack (a
  contamination check — see below).
- `scripts/taxonomy/extend_serving_labels_mcp.mjs` or `scripts/taxonomy/fetch_serving_label_packets.sql` is
  missing after confirming you have `origin/main` at commit `9ce90b1c` or later.

## Required dry-run artifact (before any Production write)

Before applying anything, produce and save (as part of your eventual report, not a throwaway) a dry-run
summary containing:

- Exact target item count for labels (expect 55 = 14 clean `legacy_unvalidated` + 34 `stale` + 7 Group A
  duplicate-fix items, confirm your own count independently) and the full list of target `content_key`s,
  with the 7 Group A items flagged distinctly so you apply the dual-supersession step only to them.
- Exact target item count for difficulty (expect 119, confirm your own count independently) and the full
  list of target `content_key`s, plus which of those 119 are covered by the CSV vs. not.
- Generated row count from the label pipeline script's `write_labels.sql` (should equal 55 minus any items
  the script itself holds for `rubric_preflight_failure`/`model_unit_disagreement`/scope-violation reasons —
  those still produce a `held` row, so the total row count should still be 55, just split across statuses).
- Your batch plan (how many batches, how many rows each) before you start applying.

## Local migration files (required)

For every `apply_migration` call you make, the corresponding SQL must also be committed to
`supabase/migrations/` in this PR — a report-only PR without matching local files is not acceptable (this
is a gap in today's Statistics work Claude is separately backfilling; do not repeat it for Chemistry).
Name files following the existing convention, e.g.
`supabase/migrations/20260925180000_apchem_serving_labels_batch_01.sql`,
`supabase/migrations/20260925181500_apchem_difficulty_batch_01.sql`, incrementing the timestamp per batch
so ordering is unambiguous. Each file's content should be exactly what you passed to `apply_migration` for
that batch (including the `begin`/`commit` wrapper and the `superseded_by` update logic), not a
paraphrase.

## Deterministic batching

- Label batches: 25-35 tuples per batch.
- Difficulty batches: 30-35 rows per batch.
- After each batch's `apply_migration` call, verify the cumulative row count via a fresh `execute_sql`
  count query keyed on `model_run_id` (labels) or your load's `proposal_run` value (difficulty) — the same
  discipline Claude used for Statistics (verify count after every single batch, not just at the end).
- Never hand-retype or hand-truncate SQL from the pipeline script's output. If `write_labels.sql` is too
  large for one `apply_migration` call, split it programmatically (a paren-depth-aware tuple extractor) and
  verify the split has no truncated/malformed tuples (regex-check for a `),\s*,\s*\(` double-comma bug —
  this exact bug appeared in Claude's first attempt at this for Statistics and was caught before applying,
  not after) before applying any batch.

## Idempotency

Before applying each label batch, confirm none of its `content_item_id`s already has a label row with the
same `model_run_id` (guards against a partial-failure retry creating duplicates). Before applying each
difficulty batch, confirm none of its `content_item_version_id`s already has a row in
`app.content_item_difficulty` (there should be none, since current coverage is 0, but verify rather than
assume). This directly guards against the duplicate-row incident Claude had on the very first Statistics
difficulty-load attempt (170 expected, 176 found, caused by hand-reconstructing a large INSERT — the
transaction rolled back cleanly, but do not create that risk in the first place by batching small and
verifying every step as described above).

## Contamination check

Before applying any batch, confirm every `content_item_id` (labels) or `content_item_version_id`
(difficulty) it touches actually belongs to a live AP Chemistry item (join back through
`exam_pack_versions`/`exam_packs.exam_code = 'ap_chemistry'` with `retired_at is null`). This guards against
copy-paste contamination from the Statistics pipeline run this task's instructions were modeled on.

Paste the block below into Codex.

```text
Task -- AP Chemistry Tier 3: serving labels + difficulty, 2026-09-25 (v3).

Merge main first:

    git fetch origin
    git switch codex/apchem-tier3-labels-difficulty-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apchem-tier3-labels-difficulty-2026-09-25 origin/main
    git merge origin/main

Confirm `git log --oneline -1 origin/main` is at or after commit 9ce90b1c, and that
scripts/taxonomy/extend_serving_labels_mcp.mjs and scripts/taxonomy/fetch_serving_label_packets.sql exist
in your checkout. If either is missing after merging, STOP and report -- do not improvise.

The checkout must be clean before starting. This makes real writes to Production
(pcntajvbdfqhbeewmdry) -- via the Supabase MCP tool only, never the local `supabase` CLI (it is linked to
Dev, not Production). Read the full body of
docs/content/CODEX_TASK_AP_CHEMISTRY_TIER3_LABELS_DIFFICULTY_2026_09_25.md (this v3 revision, not any
cached v1 or v2) before running anything -- it defines the precise 55-item label target set (including the
7 Group A duplicate-fix items and their dual-supersession requirement, and the 5 Group B items that are
explicitly excluded), the 119-item difficulty target set, stop conditions, the required dry-run artifact,
batching rules, idempotency checks, the contamination check, and the local-migration-file requirement.
Follow all of it.

READ ALSO:
- docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md -- the pipeline section and "Explicitly
  not in scope" section (do not promote to `validated`, do not blanket-rerun `held` items).
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md -- criteria 3 and 5 definitions.
- docs/research/apbio_difficulty_calibration_2026_09_22/STATISTICS_AND_CHEMISTRY.md -- validation status
  and limitations of the CRR-calibrated difficulty methodology for Chemistry specifically.
- supabase/migrations/20260924240000_apbio_content_item_difficulty_load.sql -- the difficulty-load
  migration pattern to model your own load on.
- docs/research/AP_STATISTICS_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md -- Claude's completed Statistics
  label run report, as a template for structure.

PART A -- SERVING LABELS (criterion 3), target = 55 items (14 clean legacy_unvalidated + 34 stale + 7 Group A
duplicate-fix items, current rows only)

1. Independently re-derive the 55-item target list from Production (do not trust this doc's count blindly;
   confirm it, and stop per the stop conditions if it differs by more than 5). Separately confirm the 7
   Group A content_keys (`apchem-frq-l-002`, `apchem-frq-l-006`, `apchem-frq-l-012`, `apchem-mcq-001`,
   `apchem-mcq-070`, `apchem-sfrq-006`, `apchem-sfrq-010`) each currently have exactly two current serving-
   label rows, and that the 5 Group B content_keys (`apchem-frq-l-013`, `apchem-frq-l-014`,
   `apchem-sfrq-003`, `apchem-sfrq-014`, `apchem-sfrq-024`) are excluded from your target list entirely.
2. Run scripts/taxonomy/fetch_serving_label_packets.sql via execute_sql, scoped to
   ep.exam_code = 'ap_chemistry', filtered to exactly the 55 target content_item_ids (not all 136 -- do not
   regenerate labels for held/provisional_model/validated items or the 5 excluded Group B items). Save the
   packets JSON locally.
3. Run:
   node scripts/taxonomy/extend_serving_labels_mcp.mjs --packets-file=<your packets file> --subject=ap_chemistry
   (confirm the exact --subject value the script expects by checking its SUBJECTS config, same as the
   Statistics run used --subject=ap_statistics). This writes write_labels.sql and a dated report under
   docs/research/ -- it never writes to the DB itself.
4. Produce the required dry-run artifact (see main doc) before applying anything.
5. Split into batches of 25-35 tuples, apply each via apply_migration, verify row count after each batch,
   commit each batch's exact SQL to supabase/migrations/ with the naming convention in the main doc. For the
   7 Group A items specifically, your migration SQL must set `superseded_by` on both of that item's existing
   current rows, not just one -- verify with a per-item count query (`superseded_by is null`) equal to 1
   after the batch that touches it.
6. Only `provisional_model` or `held` label_status values are acceptable output -- never `validated`.

PART B -- DIFFICULTY (criterion 5), target = 119 items (item-and-current-version published)

1. Independently re-derive the 119-item target list from Production.
2. Cross-check apchem_difficulty_assignments.csv's content_keys against that live list -- report any
   mismatch or naming-convention drift before trusting the CSV (Statistics had a retired-pilot-pack naming
   trap here; do not assume Chemistry's CSV is clean without checking).
3. Match content_key -> content_item_version_id via a fresh Production query.
4. Batch 30-35 rows per apply_migration call, verify cumulative count after each batch via execute_sql,
   commit each batch's exact SQL to supabase/migrations/.
5. Report any of the 119 items with no CSV row (a coverage gap) by exact content_key, the same way Claude
   flagged 23 uncovered AP Statistics items.

WHAT WOULD MAKE THIS REJECTED

- Any write to Production via the local `supabase` CLI instead of the Supabase MCP tool.
- Writing `label_status='validated'` anywhere.
- Touching any `held`, `provisional_model`, or `validated` current label row without an individually
  recorded reason per the main doc's "Held items" section.
- A blanket re-run of all 32 `held` items.
- Applying a large hand-reconstructed INSERT in one shot without a verified pre/post row count per batch.
- Trusting the difficulty CSV's content_keys without cross-checking them against a fresh live-pack key list.
- Skipping the coverage-gap report for either labels or difficulty.
- A report-only PR without the matching local migration files under supabase/migrations/.
- Skipping the contamination check (any row touching a non-Chemistry content_item).
- Touching any of the 5 Group B items (`apchem-frq-l-013`, `apchem-frq-l-014`, `apchem-sfrq-003`,
  `apchem-sfrq-014`, `apchem-sfrq-024`) in any way.
- For the 7 Group A items, superseding only one of the two existing current rows instead of both.
- Continuing past this task into cross-QA of your own work, or into Pair 2, or into promoting anything to
  `validated`.

DELIVERABLE

`docs/research/AP_CHEMISTRY_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md` (from the pipeline script) plus
`docs/content/CODEX_REPORT_AP_CHEMISTRY_TIER3_LABELS_DIFFICULTY_2026_09_25.md`, covering:

- The dry-run artifact contents (target counts and lists, as independently re-derived by you).
- Labels: starting counts by status (with the "current" definition stated explicitly), items processed,
  final counts by status broken out by held-reason, and any held-item candidates noted per "Held items".
  Explicitly confirm each of the 7 Group A items ended with exactly one current row, and that the 5 Group B
  items were left untouched (row counts and `superseded_by` values unchanged from this doc's baseline).
- Difficulty: starting/ending row counts, any content_key mismatches found and how resolved, coverage gaps.
- A short "ready for cross-QA" section naming exactly which content_items got new label/difficulty rows
  today, so Claude's cross-QA pass can sample from a known set.
- Confirmation that every applied batch has a matching file under supabase/migrations/.

Open a PR with the migrations and both docs when done. Stop there -- do not start cross-QA of your own work
and do not start Pair 2.
```
