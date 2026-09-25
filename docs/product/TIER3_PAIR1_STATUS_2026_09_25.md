# Tier 3 Pair 1 Status (2026-09-25, end of session)

Per `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md`. This doc is the handoff record for
the next session picking this up.

## AP Statistics (Claude's half) — DONE, with one known gap

Serving labels (criterion 3): 126 rows applied to Production (`pcntajvbdfqhbeewmdry`) via the Supabase MCP
tool, in 21 batches (`load_apstats_labels_batch01` through `batch21`, all in Supabase's own migration
history via `list_migrations`). Final state: 107 `provisional_model`, 19 `held`, 0 `validated` (promotion
to `validated` is out of scope for this task per the paired plan). `model_run_id =
'serving-units-mcp-2026-09-25-20260925163249'`. Report: `docs/research/AP_STATISTICS_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md`.

Difficulty (criterion 5): 170 rows applied to Production, in 5 batches (`load_apstats_difficulty_batch1`
through `batch5`, also in Supabase's own migration history), covering all live-pack items whose
item-and-current-version status was both `published`. 23 live-pack items had no row in the source CSV
(`apstats_difficulty_assignments.csv`) and remain undifficultied — a known, reported gap, not a defect.

**Known gap: no local `supabase/migrations/*.sql` files exist for any of these 26 batches.** They exist
only in Supabase's own tracked migration history (confirmed via `list_migrations` — all 26 entries are
present there with exactly the names above), not as committed files in this repo. This is an inconsistency
with the repo's established practice (every other content migration this week has a matching local file).
Reconstructing all 26 batch files byte-exact would require either re-deriving each batch's exact applied
SQL (some batches were applied with a trimmed `source_payload` relative to the pipeline's original
`write_labels.sql` output, so the original scratch files at `/tmp/label_batch_*.sql` and
`/tmp/apstats_diff_batch_*.sql` do not match 1:1 what was actually applied for every batch) or dumping the
current DB state directly into one or two consolidated migration files. Neither was done this session —
flagged here explicitly rather than silently left. **Next session: either backfill these files (recommend:
two consolidated files, one for the 126 label rows and one for the 170 difficulty rows, generated directly
from a fresh Production query rather than from the `/tmp` scratch files, since those don't all match what
was actually applied) or explicitly decide Supabase's own migration history is sufficient and this repo's
"every migration has a local file" norm doesn't need to extend to bulk data-loads like this one.**

## AP Chemistry (Codex's half) — task handed off, not yet started

`docs/content/CODEX_TASK_AP_CHEMISTRY_TIER3_LABELS_DIFFICULTY_2026_09_25.md` is at v2, committed and
pushed (commit `c74c6b9b`). v1 was reviewed by Codex before starting and returned five clarifying questions
plus real gaps (ambiguous target set risked sweeping `held` rows, no checkout guidance, no stop conditions,
no dry-run-artifact requirement, no local-migration-file requirement). v2 answers all of it, with exact
target counts re-verified against Production during the revision:

- Label target: **72 items** (38 current `legacy_unvalidated` + 34 current `stale`; excludes 32 `held`, 1
  `provisional_model`, 43 `validated` by default).
- Difficulty target: **119 items** (item-and-current-version published); current difficulty coverage for
  AP Chemistry is 0 rows.

As of end of session, no `codex/apchem-tier3-labels-difficulty-2026-09-25` branch or PR exists yet — Codex
has not started executing the task. Next session: check `gh pr list` for that branch/PR before assuming
nothing has happened; if a PR exists, it needs the same MCP-only, batched, verified-count discipline
checked against what it actually did, then Claude's cross-QA pass per the paired plan (spot-check a sample
of Codex's unit-assignment reasoning against actual item content/rubric, confirm difficulty band placement
is defensible) before either subject is considered closed.

## Not started

- Claude's cross-QA of Codex's Chemistry output, and Codex's cross-QA of Claude's Statistics output (the
  paired plan's required step before Pair 1 is considered fully closed).
- Pair 2 (AP Calculus AB + AP Precalculus), Pair 3 (AP Physics 1 + AP Physics 2), Pair 4 (AP Physics C:
  Mechanics + AP Physics C: E&M), and AP Calculus BC (pairs with whichever finishes first, or solo).
- Promotion of any `provisional_model` label to `validated` — separate governance step, not touched.
