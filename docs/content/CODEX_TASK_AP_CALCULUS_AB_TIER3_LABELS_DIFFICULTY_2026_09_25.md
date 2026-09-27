# Codex Task — AP Calculus AB Tier 3: Serving Labels + Difficulty (2026-09-25, v1)

**Context.** `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md` splits Tier 3 (servability
criteria 3 and 5 — serving labels and difficulty — for the nine non-Biology subjects) into pairs: one
subject to Codex, one to Claude, then cross-QA before the next pair. Pair 1 (AP Statistics/Claude, AP
Chemistry/Codex) is CLOSED — see `docs/product/TIER3_PAIR1_STATUS_2026_09_25.md`. This is Pair 2's Codex
half: **AP Calculus AB**. Claude is doing AP Precalculus in parallel; the two halves cross-QA each other
once both land, per the paired plan.

Read the whole document before running anything. This is a v1 — unlike the Chemistry task (which went
through four revisions after Codex's own preflight caught real issues), nobody has preflighted this one
yet. **Expect to find discrepancies between this doc's numbers and live Production** (content drifts daily)
and between this doc's difficulty-methodology plan and what the actual item text supports. Re-derive
everything yourself; treat every count below as "last verified 2026-09-25, re-check before trusting."

## Baseline (Claude verified against Production, 2026-09-25, before writing this doc)

Live AP Calculus AB items (via `exam_packs.exam_code = 'ap_calculus_ab'` joined through
`exam_pack_versions` where `retired_at is null`, joined to `content_items`): **128 items**. No
duplicate-current-serving-label-row anomaly found (unlike Chemistry's 12-item case) — every item has exactly
0 or 1 current row.

Current serving-label status breakdown (current = `label_scope='serving' and superseded_by is null`, table
`app.content_taxonomy_labels`):

| status | item count |
| --- | ---: |
| no current row at all | 34 |
| `held` | 16 |
| `legacy_unvalidated` | 46 |
| `provisional_model` | 6 |
| `stale` | 17 |
| `validated` | 9 |
| **total** | **128** |

Servable set (item AND its latest content_item_version both `status='published'`): **122 items** — this is
the difficulty-load target set. Current `app.content_item_difficulty` coverage for AP Calculus AB: **0
rows** (clean slate, same as Chemistry was).

## PART A — Serving labels (criterion 3)

**Target: no-current-row (34) + `legacy_unvalidated` (46) + `stale` (17) = 97 items**, restricted to
`ci.status='published' AND` latest `content_item_version.status='published'` (the same standard the
packet-fetch query and the difficulty criterion both use — expect the 97 to shrink somewhat once you filter
to published, the way Chemistry's 55 became 42). **Do not touch** `held` (16), `provisional_model` (6), or
`validated` (9) — see "Held items" below for the one narrow exception.

1. Independently re-derive the exact target list and its content_keys from Production. Confirm the 128/34/
   16/46/6/17/9 baseline above is still accurate within a handful of items; if it's off by more than 5,
   stop and report rather than trusting either your number or this doc's blindly.
2. Check for the same duplicate-current-row and non-published-item traps that Chemistry hit:
   - Any content_item with more than one current serving-label row? (Baseline check found none — verify
     yourself, don't just trust that.)
   - Any target item where `ci.status != 'published'` or its latest version isn't `published`? Drop those
     from the target set the same way Chemistry's 13 non-published items were dropped — do not attempt to
     label unpublished/disapproved/retired content.
3. Fetch packets via the Supabase MCP `execute_sql` tool using `scripts/taxonomy/fetch_serving_label_packets.sql`
   scoped with `and ep.exam_code = 'ap_calculus_ab'`, save the `packets` column's text value to a local JSON
   file. If you hit the same MCP-result-to-local-file friction Codex hit on the Chemistry task, that's a
   known rough edge — work around it however you can inside your own tool boundary (write the result to a
   file via your own file tools rather than trying to pipe the MCP tool's return value directly), but do not
   fabricate or hand-type packet content — it must come from the actual query result.
4. Run `node scripts/taxonomy/extend_serving_labels_mcp.mjs --packets-file=<your file> --subject=ap_calculus_ab`.
   This writes `write_labels.sql` and a dated report under `docs/research/` — it never writes to the DB
   itself.
5. Produce a dry-run artifact (see "Required dry-run artifact" below) before applying anything.
6. Batch 25-35 tuples per `apply_migration` call. After each batch, verify the cumulative row count via a
   fresh `execute_sql` count keyed on `model_run_id`. Commit each batch's exact applied SQL to
   `supabase/migrations/` (see naming convention below) — do not hand-retype or hand-truncate the script's
   output; if a batch is too large for one call, split it programmatically and regex-check for a
   `),\s*,\s*\(` double-comma bug before applying (this exact bug hit Claude's first Statistics attempt).
7. Only `provisional_model` or `held` are acceptable output label_status values — never `validated`
   (governance-gated, separate step, out of scope here).

### Held items — case-by-case, not blanket

Do not re-run any of the 16 current `held` rows as part of the primary pass. If you notice a specific held
item where the hold reason looks resolvable on inspection (e.g. a `model_unit_disagreement` that resolves
cleanly, or a `rubric_preflight_failure`/`other` that turns out to be a removed-topic distractor — see AP
Statistics' `APSTATS-MCQ-075/088/094/098/100` in `docs/product/TIER3_PAIR1_STATUS_2026_09_25.md` for the
pattern), name the specific `content_key` and reason in your report as a candidate for follow-up. Do not
re-run it inline. If in doubt, leave it held.

## PART B — Difficulty (criterion 5)

**There is no existing difficulty-assignment CSV for AP Calculus AB** — unlike Chemistry and Statistics,
which already had `apchem_difficulty_assignments.csv` / `apstats_difficulty_assignments.csv` ready to load.
You have to build the assignment first, then load it. Read
`docs/research/apbio_difficulty_calibration_2026_09_22/README.md` in full before starting this part — it is
the governance record for the method, its validation, and its known limitations (the Medium band is
undiscriminated; 37/118 of Biology's own first-pass assignments were judgment calls, not measurement; the
`explain` verb split is the single biggest lever in the method). Do not deviate from the documented method
without saying so explicitly in your report.

**The method (Method A, task-verb tier, from the README's §3):** an item's difficulty is the modal tier of
its rubric criteria's task verbs (ties broken upward), or the stem's task verb for MCQ.

- Easy verbs: identify, state, name, list, label, annotate, indicate, select, classify, recall (and their
  inflections).
- Medium verbs: describe, determine, compare, contrast, distinguish, construct, represent, write, analyze,
  apply, trace, graph, plot, and `explain` **unless** the criterion text carries argumentation markers
  (claim, argument, supports the, refute, justify, evidence that, evaluate) — those `explain` instances are
  Hard.
- Hard verbs: justify, predict, evaluate, design, propose, support (a claim), synthesize, integrate,
  critique, calculate.

This verb-tier classifier is **subject-agnostic by design** — Biology's `assign_difficulty.py` uses exactly
this method with no Biology-specific keyword tuning. Chemistry deviated and built subject-specific
regex cues instead (`assign_difficulty_chem.py`) because its item phrasing didn't classify cleanly on verbs
alone; you may need to do the same for Calculus AB (heavy on "calculate", "find", "determine", "show that",
proof-style language) if a spot-check of the generic verb method against real item text looks wrong. **Spot-
check before committing to either approach**: pull ~15 real AP Calculus AB item stems/rubric-criteria texts
from Production, hand-classify them yourself using the method, and see whether the generic verb list gives
sane results or whether Calculus-specific phrasing (e.g. "find the value of", "show that", "write an
equation for") needs its own cue patterns the way Chemistry needed `PRED`/`JUST`/`HARDX`/`MEDX`/`EASYV`/
`CALC` regexes. Report which approach you used and why, with your spot-check evidence.

`crr_calibration_all_subjects.csv` in that same directory has AP Calculus AB's per-criterion CRR attainment
data (54 scored points, mean 0.439, tertile cuts Hard ≤ 0.36 / Easy ≥ 0.54 per the README's table) —use it
the way Biology's README §3 "Validation against real AP attainment" did: score your assignments against
these external, published attainment ratios for the subset of items whose CRR-matched criterion you can
identify, and report an agreement/kappa figure if you can compute one, or explain why you can't (e.g. if
the CRR rows don't map cleanly to your item IDs, the way `verb_auto`/`attr_method` in that CSV are flagged
"unverified automated extraction, must not be used as-is" in the README's Limitations §6).

1. Independently re-derive the 122-item servable target list from Production (item AND latest version both
   `published`).
2. Pull each target item's stem (MCQ) or criteria text (FRQ) from Production via `execute_sql` — build your
   own extraction script modeled on `assign_difficulty_chem.py`'s pattern (query via MCP, save result to a
   local JSON, classify, write a CSV) rather than trying to reuse Biology's `bio_full.json`/`judge.py` files
   directly (those are Biology-specific local artifacts, not committed to the repo, and won't exist in your
   checkout).
3. Produce `docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv`
   (content_key, item_type, difficulty, basis, rationale — same shape as the Biology/Chemistry CSVs) and a
   short methodology note (can be a section in your final report rather than a separate doc) covering: which
   classification approach you used and why, the Easy/Medium/Hard distribution overall and by item_type, how
   many assignments were basis=`task verb`/regex-cue vs basis=`judgement`, and your CRR-agreement check.
4. Load it into `app.content_item_difficulty`, batching 30-35 rows per `apply_migration` call, verifying
   cumulative count after each batch via `execute_sql`, committing each batch's exact SQL to
   `supabase/migrations/`. Model the load SQL on
   `supabase/migrations/20260924240000_apbio_content_item_difficulty_load.sql`.
5. Report any of the 122 target items your classifier couldn't confidently assign (a coverage gap), by exact
   content_key, the same way Chemistry and Statistics reported theirs.

## Required dry-run artifact (before any Production write)

Before applying anything, produce (as part of your eventual report, not a throwaway):

- Exact label target count and content_key list (expect roughly 97 minus any non-published drops — confirm
  your own number).
- Exact difficulty target count and content_key list (expect 122 — confirm your own number).
- The `write_labels.sql` generated row count and its status split (should sum to your label target count).
- Your difficulty CSV's Easy/Medium/Hard distribution and basis split, plus your CRR-agreement check result.
- Your batch plan for both parts (how many batches, how many rows each) before you start applying.

## Stop conditions

Stop immediately and report (do not push, do not apply further migrations) if any of these are true:

- The Supabase MCP tool is unavailable or errors in a way that would force a fallback to the local
  `supabase` CLI against Production.
- The project ref you are about to write to is not `pcntajvbdfqhbeewmdry`.
- The live AP Calculus AB item count you independently derive differs from 128 by more than 5.
- You find a duplicate-current-serving-label-row item (the Chemistry-style anomaly) — this baseline found
  none; if you find one, stop and report it the way Codex did for Chemistry rather than silently picking a
  resolution.
- Any generated `write_labels.sql` (or your batched split of it) contains the literal string `validated` as
  a `label_status` value.
- Any generated SQL references a `content_item_id` or `content_item_version_id` that does not belong to the
  live AP Calculus AB pack (contamination check — see below).
- `scripts/taxonomy/extend_serving_labels_mcp.mjs` or `scripts/taxonomy/fetch_serving_label_packets.sql` is
  missing from your checkout after merging `origin/main`.
- You cannot get either the generic verb method or a subject-specific regex variant to produce results you
  can defend on a hand-spot-check of ~15 items — report the disagreement rather than shipping a classifier
  you don't trust.

## Local migration files (required)

For every `apply_migration` call, commit the corresponding SQL to `supabase/migrations/` in this PR. Name
files following the existing convention, e.g.
`supabase/migrations/20260925220000_apcalcab_serving_labels_batch_01.sql`,
`supabase/migrations/20260925223000_apcalcab_difficulty_batch_01.sql`, incrementing the timestamp per batch.
Each file's content must be exactly what you passed to `apply_migration` for that batch, not a paraphrase. A
report-only PR without matching local files is not acceptable (this was a real gap in the original
Statistics run, backfilled after the fact — do not repeat it).

## Deterministic batching

- Label batches: 25-35 tuples per batch.
- Difficulty batches: 30-35 rows per batch.
- Verify cumulative row count via a fresh `execute_sql` count query after every single batch, not just at
  the end.
- Never hand-retype or hand-truncate SQL from a script's output; if output is too large for one
  `apply_migration` call, split it programmatically (paren-depth-aware tuple extraction) and regex-check for
  a `),\s*,\s*\(` double-comma bug before applying.

## Idempotency

Before applying each label batch, confirm none of its `content_item_id`s already has a label row with the
same `model_run_id`. Before applying each difficulty batch, confirm none of its `content_item_version_id`s
already has a row in `app.content_item_difficulty` (should be none, since current coverage is 0 — verify
rather than assume).

## Contamination check

Before applying any batch, confirm every `content_item_id` (labels) or `content_item_version_id`
(difficulty) it touches actually belongs to a live AP Calculus AB item (join back through
`exam_pack_versions`/`exam_packs.exam_code = 'ap_calculus_ab'` with `retired_at is null`). This guards
against copy-paste contamination from whatever other subject's pipeline run your instructions were modeled
on.

## What would make this rejected

- Any write to Production via the local `supabase` CLI instead of the Supabase MCP tool.
- Writing `label_status='validated'` anywhere.
- Touching any `held`, `provisional_model`, or `validated` current label row without an individually
  recorded reason (see "Held items").
- A blanket re-run of all 16 `held` items.
- Applying a large hand-reconstructed INSERT in one shot without a verified pre/post row count per batch.
- Fabricating or hand-typing difficulty classifications without grounding them in actual item text pulled
  from Production.
- Skipping the CRR-agreement check or the hand-spot-check justifying your classification approach.
- Skipping the coverage-gap report for either labels or difficulty.
- A report-only PR without matching local migration files under `supabase/migrations/`.
- Skipping the contamination check.
- Continuing past this task into cross-QA of your own work, into Pair 3, or into promoting anything to
  `validated`.

## Deliverable

`docs/research/AP_CALCULUS_AB_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md` (from the pipeline script) plus
`docs/content/CODEX_REPORT_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md`, covering:

- The dry-run artifact contents (target counts and lists, as independently re-derived by you).
- Labels: starting counts by status (with the "current" definition stated explicitly), items processed,
  final counts by status broken out by held-reason, any held-item candidates noted per "Held items", and any
  non-published or duplicate-row items excluded (with exact content_keys).
- Difficulty: your classification methodology (generic verb method vs subject-specific regex, and why),
  Easy/Medium/Hard distribution, basis split, CRR-agreement result, coverage gaps by exact content_key.
- A short "ready for cross-QA" section naming exactly which content_items got new label/difficulty rows
  today, so Claude's cross-QA pass (of your AP Calculus AB output) can sample from a known set — and note
  that you should independently review a sample of Claude's AP Precalculus output in return, once Claude's
  half lands and is reported (check back on
  `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md` / the PR list for that).

Open a PR with the migrations and both docs when done. Stop there — do not start cross-QA of your own work
and do not start Pair 3.

---

Paste the block below into Codex.

```text
Task -- AP Calculus AB Tier 3: serving labels + difficulty, 2026-09-25 (v1, run overnight).

Merge main first:

    git fetch origin
    git switch -c codex/apcalcab-tier3-labels-difficulty-2026-09-25 origin/main

Confirm scripts/taxonomy/extend_serving_labels_mcp.mjs and scripts/taxonomy/fetch_serving_label_packets.sql
exist in your checkout (added in commit 9ce90b1c, used for the AP Chemistry run in PR #192). If either is
missing, STOP and report -- do not improvise a substitute pipeline.

The checkout must be clean before starting. This makes real writes to Production (pcntajvbdfqhbeewmdry) --
via the Supabase MCP tool only, never the local `supabase` CLI (it is linked to Dev, not Production). Read
the full body of docs/content/CODEX_TASK_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md (this v1) --
this is a fresh task, not yet preflighted, so expect to find and report discrepancies between its baseline
numbers and live Production the way the AP Chemistry task (v1->v4) did. Follow all of it: the label target
derivation, the difficulty-methodology-needs-building requirement (there is no existing CSV for this
subject -- you have to design and validate a classifier, not just load one), stop conditions, the required
dry-run artifact, batching rules, idempotency checks, the contamination check, and the local-migration-file
requirement.

READ ALSO:
- docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md -- the pipeline section and "Explicitly
  not in scope" section (do not promote to `validated`, do not blanket-rerun `held` items).
- docs/product/TIER3_PAIR1_STATUS_2026_09_25.md -- how Pair 1 (Statistics/Chemistry) actually went,
  including two real bugs caught mid-run (a double-comma tuple-splitting bug, a silently-dropped-column
  format() bug) -- do not repeat either.
- docs/research/apbio_difficulty_calibration_2026_09_22/README.md -- the difficulty method in full: its
  governance basis, the task-verb classifier, its validation and limitations. Read this before writing any
  classifier code.
- docs/research/apbio_difficulty_calibration_2026_09_22/assign_difficulty_chem.py -- an example of building
  a subject-specific regex-cue classifier when the generic verb method doesn't fit the subject's phrasing
  (Chemistry needed this; Biology didn't). Use it as a pattern, not a copy -- Calculus AB's cues will differ.
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md -- criteria 3 and 5 definitions.
- supabase/migrations/20260924240000_apbio_content_item_difficulty_load.sql -- the difficulty-load
  migration pattern to model your own load on.

PART A -- SERVING LABELS (criterion 3), target ~= 97 items before published-filtering (34 no-current-row +
46 legacy_unvalidated + 17 stale), expect it to shrink once filtered to ci.status='published' AND latest
content_item_version.status='published' -- re-derive the exact final count and content_key list yourself.

1. Independently re-derive the target list from Production (do not trust this doc's counts blindly; stop
   per the stop conditions if the live 128-item total differs from baseline by more than 5). Check for
   duplicate-current-row items and non-published target items, dropping the latter the way Chemistry's 13
   non-published items were dropped.
2. Fetch packets via scripts/taxonomy/fetch_serving_label_packets.sql (Supabase MCP execute_sql tool,
   scoped `and ep.exam_code = 'ap_calculus_ab'`), save to a local JSON file.
3. Run: node scripts/taxonomy/extend_serving_labels_mcp.mjs --packets-file=<your file> --subject=ap_calculus_ab
4. Produce the required dry-run artifact before applying anything.
5. Split into batches of 25-35 tuples, apply each via apply_migration, verify row count after each batch,
   commit each batch's exact SQL to supabase/migrations/ with the naming convention in the main doc.
6. Only `provisional_model` or `held` label_status values are acceptable output -- never `validated`.

PART B -- DIFFICULTY (criterion 5), target = 122 items (item-and-current-version published), 0 existing
rows, NO existing assignment CSV -- you must build one.

1. Independently re-derive the 122-item target list from Production.
2. Read docs/research/apbio_difficulty_calibration_2026_09_22/README.md in full. Pull ~15 real item stems/
   criteria texts and hand-classify them against the generic task-verb method; decide whether it fits
   Calculus AB's phrasing or whether you need subject-specific regex cues the way Chemistry did. Report
   your spot-check evidence either way.
3. Build the classifier, run it against all 122 items' actual Production text, write
   docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv
   (content_key, item_type, difficulty, basis, rationale).
4. Cross-check against crr_calibration_all_subjects.csv's AP Calculus AB rows (54 points, mean 0.439,
   tertile cuts documented in the README) for an agreement/kappa figure where you can map items to CRR
   points; explain any gap where you can't map cleanly.
5. Batch 30-35 rows per apply_migration call, verify cumulative count after each batch via execute_sql,
   commit each batch's exact SQL to supabase/migrations/. Model the load SQL on
   supabase/migrations/20260924240000_apbio_content_item_difficulty_load.sql.
6. Report any of the 122 items your classifier can't confidently assign, by exact content_key.

WHAT WOULD MAKE THIS REJECTED

- Any write to Production via the local `supabase` CLI instead of the Supabase MCP tool.
- Writing `label_status='validated'` anywhere.
- Touching any `held`, `provisional_model`, or `validated` current label row without an individually
  recorded reason.
- A blanket re-run of all 16 `held` items.
- Applying a large hand-reconstructed INSERT in one shot without a verified pre/post row count per batch.
- Fabricating difficulty classifications not grounded in actual Production item text.
- Skipping the CRR-agreement check or the classification-approach spot-check.
- Skipping the coverage-gap report for either labels or difficulty.
- A report-only PR without the matching local migration files under supabase/migrations/.
- Skipping the contamination check (any row touching a non-Calculus-AB content_item).
- Continuing past this task into cross-QA of your own work, or into Pair 3, or into promoting anything to
  `validated`.

DELIVERABLE

docs/research/AP_CALCULUS_AB_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md (from the pipeline script) plus
docs/content/CODEX_REPORT_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md, covering the dry-run
artifact, labels before/after counts and exclusions, difficulty methodology + distribution + CRR-agreement
+ coverage gaps, and a "ready for cross-QA" section naming exactly which content_items got new rows today.

Open a PR with the migrations and both docs when done. Stop there -- do not start cross-QA of your own work
and do not start Pair 3.
```
