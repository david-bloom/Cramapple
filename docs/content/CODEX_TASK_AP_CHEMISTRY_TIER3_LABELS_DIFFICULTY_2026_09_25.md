# Codex Task — AP Chemistry Tier 3: Serving Labels + Difficulty (2026-09-25)

**Context.** `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md` splits Tier 3 (servability
criteria 3 and 5 — serving labels and difficulty — for the nine non-Biology subjects) into pairs: one
subject to Codex, one to Claude, then cross-QA before the next pair. Pair 1 is AP Statistics (Claude) and
AP Chemistry (Codex). Claude's AP Statistics half is done: 126 serving-label rows applied to Production
(107 `provisional_model`, 19 `held`, 0 promoted to `validated`) and 170 difficulty rows applied (all live
193-item pack items that had a computed CRR value). This task is the Chemistry half — an execution task,
not a QA-review task, but it ends the same way QA tasks do: a written report and a PR.

**Do not start from zero.** AP Chemistry already has a partial label run: 29 `provisional_model`, 37
`held`, 163 `legacy_unvalidated`, 34 `stale`. Your job is to run the `legacy_unvalidated`/no-label items
through the pipeline, and separately decide whether any `held` items warrant a genuine re-run (see "held
items" below — this is case-by-case, not a blanket re-run). A difficulty CSV already exists
(`docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv`) — verify it
against current Production content before loading, since item counts may have drifted.

**Hard constraint carried over from today's Statistics work: use the Supabase MCP tool for every
Production read and write. Do not use the local `supabase` CLI against Production — it is linked to Dev
(`wmgjsdkphcyhngaffbqf`), not Production (`pcntajvbdfqhbeewmdry`), and David's explicit instruction earlier
today was "use MCP, don't relink the CLI."** If your environment's Supabase MCP tool has a different name
than Claude's, use whatever MCP-based Supabase tool you have — just never shell out to `supabase db query
--linked` or similar against Production.

Paste the block below into Codex.

```text
Task -- AP Chemistry Tier 3: serving labels + difficulty, 2026-09-25.

Merge main first:

    git fetch origin
    git switch codex/apchem-tier3-labels-difficulty-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apchem-tier3-labels-difficulty-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. This makes real writes to Production
(pcntajvbdfqhbeewmdry) -- via the Supabase MCP tool only, never the local `supabase` CLI (it is linked to
Dev, not Production).

READ FIRST:
- docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md -- the pipeline section, Pair 1 table, and
  the "Explicitly not in scope" section (do not promote to `validated`, do not blanket-rerun `held` items).
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md -- criteria 3 (serving labels) and 5 (difficulty) definitions.
- scripts/taxonomy/extend_serving_labels_mcp.mjs -- the MCP-safe fork of the label pipeline (never writes
  DB directly; always writes write_labels.sql for you to review and apply yourself via apply_migration).
- scripts/taxonomy/fetch_serving_label_packets.sql -- the query that builds label-generation input packets.
- docs/research/apbio_difficulty_calibration_2026_09_22/STATISTICS_AND_CHEMISTRY.md -- validation status
  and limitations of the CRR-calibrated difficulty methodology for Chemistry specifically (MCQ difficulty
  uses a "structural characteristics" method, not pure task-verb, since MCQ stems lack explicit verbs).
- supabase/migrations/20260924240000_apbio_content_item_difficulty_load.sql -- the difficulty-load
  migration pattern to model your own load on.
- docs/research/AP_STATISTICS_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md -- Claude's just-completed Statistics
  label run report, as a template for structure and for what "done" looks like end to end.

PART A -- SERVING LABELS (criterion 3)

1. Query Production (via the Supabase MCP execute_sql tool) for AP Chemistry content items that currently
   have no current `validated`/`provisional_model` serving label (label_scope='serving') joined against
   `app.taxonomy_source_versions` where `taxonomy_confidence='verified'` -- this is the same filter Claude
   used for Statistics, adjusted to `exam_code` for Chemistry. Get an exact count before running anything.
2. Run `scripts/taxonomy/fetch_serving_label_packets.sql` via execute_sql, scoped to Chemistry's exam_code,
   and save the packets JSON to a local file (double-JSON-encoded in the tool result -- parse accordingly,
   the way `extend_serving_labels_mcp.mjs`'s own fetch step expects).
3. Run:
   node scripts/taxonomy/extend_serving_labels_mcp.mjs --packets-file=<your packets file> --subject=<chemistry exam_code>
   This calls openai/gpt-5.5 and google/gemini-2.5-flash per item (key from
   scripts/vercel-gateway-check/.env.local -- already gitignored, never paste it anywhere, the script reads
   it itself), agrees or holds on required units, and writes write_labels.sql plus a dated report under
   docs/research/. It NEVER writes to the DB itself.
4. Read write_labels.sql. If it is large, split it into small batches the way Claude did for Statistics
   (a clean paren-depth tuple split, verified with a regex check for no `),\s*,\s*\(` double-comma bug --
   do NOT hand-retype or hand-truncate the SQL; extract programmatically and verify byte-for-byte before
   applying). Apply each batch via the Supabase MCP apply_migration tool, verifying the cumulative row
   count via execute_sql after each batch (same discipline as a difficulty load -- never apply one giant
   hand-reconstructed INSERT in a single call without a verified row count).
5. This produces `provisional_model` or `held` rows only. Do NOT write `label_status='validated'` --
   that is a separate governance step per DECISION-0055, out of scope here.
6. Held items: do not force a re-run. For each held item, note in your report which reason applies
   (`model_unit_disagreement`, `rubric_preflight_failure`, `other`/scope_violation) and whether it looks
   like a genuine content issue (e.g. removed-topic content, like AP Statistics' goodness-of-fit distractors
   turned out to be) worth flagging separately, versus just an ambiguous multi-unit item that is correctly
   held pending human judgment.

PART B -- DIFFICULTY (criterion 5)

1. Read apchem_difficulty_assignments.csv. Confirm its content_key naming convention actually matches the
   live Chemistry pack's current content_keys (Statistics had a naming-convention trap here: a retired
   pilot pack used a different prefix than the live pack, so a fresh live-key list from Production and a
   set-intersection check was essential before trusting the CSV -- do the same cross-check for Chemistry,
   do not assume the CSV rows all still correspond to live, non-retired items).
2. Match content_key -> content_item_version_id via a fresh Production query (not a cached list).
3. Build the INSERT, split into small batches (~30-35 rows each) the same way Claude did for Statistics,
   apply each via apply_migration, verify the cumulative count via execute_sql after each batch.
4. Report any Chemistry live-pack items with no CSV row at all (a coverage gap), the same way Claude
   flagged 23 uncovered AP Statistics items rather than silently leaving them undifficultied.

WHAT WOULD MAKE THIS REJECTED

- Any write to Production via the local `supabase` CLI instead of the Supabase MCP tool.
- Writing `label_status='validated'` anywhere -- this task only produces provisional/held labels.
- A blanket re-run of all existing `held` items without a case-by-case rationale for each one re-run.
- Applying a large hand-reconstructed INSERT in one shot without a verified pre/post row count per batch
  (this is exactly how Claude's own first difficulty-load attempt today introduced 6 duplicate rows and had
  to be rolled back and redone in batches -- don't repeat that mistake).
- Trusting the difficulty CSV's content_keys without cross-checking them against a fresh live-pack key list
  from Production first.
- Skipping the coverage-gap report for either labels or difficulty.

DELIVERABLE

`docs/research/AP_CHEMISTRY_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md` (from the pipeline script) plus a
second doc, `docs/content/CODEX_REPORT_AP_CHEMISTRY_TIER3_LABELS_DIFFICULTY_2026_09_25.md`, covering:

- Labels: starting counts by status, how many processed, final counts by status (provisional_model / held,
  broken out by held-reason), and the held-items judgment calls from Part A step 6.
- Difficulty: starting/ending row counts, any content_key mismatches found and how resolved, any coverage
  gaps (items with no CSV row).
- A short "ready for cross-QA" section naming exactly which content_items got new label/difficulty rows
  today, so Claude's cross-QA pass (per the paired plan) can sample from a known set rather than re-deriving
  the whole diff itself.

Open a PR with the migrations and both docs when done.
```
