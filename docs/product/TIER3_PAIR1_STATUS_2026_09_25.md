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

**Known gap, CLOSED 2026-09-25 (follow-up session):** the missing local files were backfilled as two
consolidated migrations, generated directly from a fresh Production query (not from the `/tmp` scratch
files, which didn't match 1:1 what was actually applied) —
[`supabase/migrations/20260925180000_apstats_serving_labels_backfill.sql`](../../supabase/migrations/20260925180000_apstats_serving_labels_backfill.sql)
(126 rows) and
[`supabase/migrations/20260925190000_apstats_difficulty_backfill.sql`](../../supabase/migrations/20260925190000_apstats_difficulty_backfill.sql)
(170 rows). Both are idempotent (`not exists` / `on conflict do nothing` guards keyed on `content_key`) and
were verified by actually executing them: against Production via the Supabase CLI (`supabase db query
--file ... --linked`, temporarily re-linking from Dev), where both were confirmed no-ops (counts unchanged
at 107/19 and 170) since the rows already exist there; and against Dev, where the labels migration is a
partial no-op (only 1 of 126 content_keys exist in Dev) and the difficulty migration currently fails
outright because `app.content_item_difficulty` doesn't exist in Dev yet (a pre-existing Dev/Prod schema
gap, not something this backfill caused or fixes — see the `content_item_difficulty` table's own migration
note about Biology facing the same issue). One caught bug worth noting for future backfills of this shape:
the first draft of the labels migration silently dropped a column because a Postgres `format()` call had
one fewer `%L` placeholder than arguments (extra args are silently ignored, not an error) — caught only by
actually running the migration, not by inspection.

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

## Pair 1 CLOSED — 2026-09-25, later same session

Both halves landed and both cross-QA passes are done:

- AP Chemistry (Codex): [PR #192](https://github.com/david-bloom/Cramapple/pull/192), merged. 42 label rows
  (33 `provisional_model`, 9 `held`), 119 difficulty rows (53 Easy/52 Medium/14 Hard), 0 contamination.
  Claude's cross-QA (in-session, not a separate PR) verified all counts, the 6 Group A dual-supersession
  repairs, and confirmed the FRQ/MCQ difficulty-basis split against the methodology doc's own validated
  baseline — no issues found.
- AP Statistics (Claude): migration-file backfill in this doc's earlier sections, plus
  [PR #193](https://github.com/david-bloom/Cramapple/pull/193), merged — Codex's cross-QA report at
  `docs/content/CODEX_CROSS_QA_AP_STATISTICS_2026_09_25.md`. Verified counts, 0 contamination, and (as of
  this merge) confirmed the difficulty run's coverage is actually 170/170 with 0 gap — the earlier "23
  live-pack items missing a CSV row" note in this doc is superseded: those 23 are items whose current
  *version* is `retired` even though the *item* row still reads `published`, so they were never in-scope
  under the strict item-and-current-version-published criterion to begin with, not a live coverage gap.

**Deferred follow-up list from Codex's Statistics cross-QA** (none block Pair 1 closure; none are live
defects — they're candidate refinements for whoever next touches AP Statistics taxonomy/difficulty):

- Held rows Codex judges are likely resolvable rather than genuinely ambiguous: `APSTATS-MCQ-002`,
  `APSTATS-MCQ-020`, `APSTATS-MCQ-075`, `APSTATS-MCQ-100` (plus the other 7 `model_unit_disagreement` holds,
  if a taxonomy owner wants to resolve all 11 at once).
- Unit-boundary question: `APSTATS-MCQ-058` — Unit 3 vs Unit 4 under the current 5-unit taxonomy.
- Possible overbroad secondary-unit tagging: `APSTATS-MCQ-091` and `APSTATS-MCQ-099` (primary Unit 4 agreed
  correct; secondary Unit 3 may not be intentional).
- `other`-held items Codex reads as legitimate out-of-scope-under-2026-27-course-model content, not defects:
  `APSTATS-MCQ-016-CAL`, `APSTATS-MCQ-018-CAL`, `APSTATS-MCQ-088`, `APSTATS-MCQ-094`, `APSTATS-MCQ-098`.
- Difficulty-band boundary calls worth a second look if Statistics gets a higher-rigor difficulty pass:
  `APSTAT-MOD5-M001` (Easy → possibly Medium), `APSTAT-MOD6-H002-INV` (Medium → possibly Hard).

Next: Pair 2 (AP Calculus AB + AP Precalculus).
