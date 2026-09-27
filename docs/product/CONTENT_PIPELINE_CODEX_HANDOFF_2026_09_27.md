# Content Pipeline — Codex Session Handoff — 2026-09-27

## Mandatory QA correction — read this before the earlier narrative

The earlier cold-read handoff below predates the independent QA pass and is **not sufficient as an
execution verdict**. QA is now underway. Do not treat its statements that the promotion/difficulty
work is "correctly applied" as acceptance. The following issues are open:

### P0 — audit the 216 Production label promotions before trusting them

`20260926233500_promote_fresh_single_unit_two_model_labels.sql` selected candidates using
`ctl.created_at >= civ.updated_at`, then replaced `validated_against_taxo_hash` with the current
hash. That is not a valid freshness proof: an MCQ choice or FRQ criterion can change the taxonomy
hash without changing `content_item_versions.updated_at`. The original generation-time hashes must
be recovered from the committed/generated label migrations or preserved run artifacts and compared
with the current `app.taxonomy_relevant_hash()` value.

- Keep verified-fresh promotions.
- Revert mismatched or unverifiable promotions to `provisional_model`, clearing validation metadata
  consistently while preserving validation-decision history for audit.
- Correct the durable migration source to require equality between the stored generation-time hash
  and `app.taxonomy_relevant_hash(current_version_id)`.
- Do not claim the current 216 rows are fresh merely because their database label hash matches now;
  the applied migration overwrote that field.

### P1 — correct five already-applied difficulty rows

The artifact builder incorrectly put `predict` and `integrate` in the Medium task-verb regex even
though DECISION-0061's approved table assigns both to Hard. QA identified exactly five expected
Medium-to-Hard corrections:

- `apphycm-frq-017`
- `apphycm-frq-024`
- `apphycem-frq-021`
- `apphycem-frq-025`
- `apcalcbc-frq-np1-006`

Fix the generator, regenerate the durable CSV/reports, and apply a **new** strictly asserted
corrective migration. Do not replay or rewrite the already-applied `20260926234000`–`234400`
migrations as if they had not run.

### P1/P2 — migration and runner safety

- The eight directly executed Production migrations (`20260926233000`, `233100`, `233500`, and
  `234000`–`234400`) were subsequently marked `applied` in Production's migration ledger. This
  closed the future-replay hazard. Verify the ledger, but do not replay them.
- Harden `extend_serving_labels_mcp.mjs`: resume reuse must match subject, version and packet hash;
  generated SQL must abort when subject, published-pack/current-version state, or taxonomy hash has
  changed; it must not supersede a newer current label.
- The script's error text names the wrong packet-export filename. The durable file is
  `scripts/taxonomy/fetch_candidate_serving_label_packets.sql`.
- The difficulty builder depends on ephemeral `/private/tmp` packets and hard-coded supplemental
  Production UUIDs. Preserve or replace the necessary reproducibility inputs without committing
  credentials.

### Label-run state requiring reconciliation

Local completed reports exist for Calculus BC and Physics C: E&M. A Mechanics `*_ready` directory
with `write_labels.sql` also exists under `/private/tmp/cramapple-content-pipeline-2026-09-26`, even
though no durable Mechanics report/migration is present. Treat `/private/tmp` as ephemeral and verify
hashes before using any of it. None of those three subject writes is recorded as applied in this
handoff. Multi-unit agreements still require an independent third review under DECISION-0066.

### Documentation and branch state

- Several plan/census rows and all five difficulty reports are stale or contradictory about what ran
  and what reached Production. Update them only after the remediation counts are final.
- Reconcile the three-run guidance: it applies to grader-gate reachability, not the separate
  two-model serving-label agreement lane.
- This worktree is on local branch `codex/task-0042-content-pipeline-remediation` at `e76d6c68`, has
  no upstream, is dirty, and contains only uncommitted work. Current `main` has advanced. Do not
  blindly commit the shared launch-readiness docs from this base; rebase/diff
  them against current `main` first.
- The Supabase CLI for this worktree was explicitly restored to Development
  (`wmgjsdkphcyhngaffbqf`) at session close on 2026-09-27. Verify before any database command and
  leave it on Development afterward.

### Next owner and exact next action

**Next owner:** the QA/remediation agent already underway.

**Next required action:** complete the original-hash audit of all 216 promoted labels and the
five-row difficulty corrective migration before applying any remaining Physics C/Calculus BC label
writes. Then harden the runner, reconcile the docs against current `main`, run an independent final
QA pass, and only then report Ready for Review.

**Do not touch:** do not replay the eight applied migrations; do not blanket-promote multi-unit
labels; do not infer quantity targets for the other nine subjects; do not expose gateway credentials;
do not treat the dirty local branch as synchronized or merged.

---

## Earlier cold-read handoff (retained for provenance; superseded where it conflicts above)

**Status:** Handoff (Codex ran out of context mid-task, session being paused/discarded)
**Owner:** David Bloom
**Written by:** Claude, reading the Codex worktree cold, before that session is lost
**Worktree:** `/Users/davidbloom/.codex/worktrees/179a/Cramapple.nosync` (now on local branch
`codex/task-0042-content-pipeline-remediation` at `e76d6c68`, with no upstream; Codex made **zero
commits** and everything below is uncommitted working-tree state)

Read this before resuming: it describes exactly what Codex did, what's proven vs. unproven, and one
unresolved discrepancy that needs a decision before continuing.

## Task Codex was executing

`docs/product/LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` (Cramapple's content-pipeline / question
serving-label launch section, part of `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`, plan 3). Goal: get
every subject's serving labels (`required_units`/`primary_unit`) validated and difficulty rows
populated, following the established two-model (GPT-5.5 + Gemini-2.5-flash via Vercel AI Gateway)
agreement pipeline in `scripts/taxonomy/extend_serving_labels_mcp.mjs`, then promote eligible labels
under DECISION-0066 and re-verify live selectors.

## Current state of the worktree

`git status` shows **no commits on the local branch beyond `e76d6c68`** — the worktree consists of
that base plus uncommitted changes only:

- Modified: `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`,
  `docs/product/LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`,
  `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`, `scripts/taxonomy/extend_serving_labels_mcp.mjs`
- Untracked: `docs/content/CONTENT_PIPELINE_LIVE_CENSUS_2026_09_26.md`, four
  `docs/research/AP_*_TAXONOMY_SERVING_LABEL_RUN_2026_09_26.md` run reports, a
  `docs/research/content_pipeline_difficulty_2026_09_26/` directory of CSV/report artifacts,
  `scripts/taxonomy/build_remaining_difficulty_artifacts.py`,
  `scripts/taxonomy/fetch_candidate_serving_label_packets.sql`, and 8 migration files under
  `supabase/migrations/2026092623****`–`2026092623****`.

**Important:** `main` itself has advanced past `e76d6c68` (it's now at `ac883a9e`, several commits
ahead, including an "October 2, 2026" launch-date rewrite of `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`
that this worktree does not have). Whoever resumes should rebase/re-diff against current `main`, not
assume this worktree's copies of the shared docs are current — the isolated diff below is against the
worktree's own base commit (`e76d6c68`), not against current `main`.

## What's done and verified (applied to Production, confirmed via Supabase MCP)

I checked Production (`pcntajvbdfqhbeewmdry`) and Dev (`wmgjsdkphcyhngaffbqf`) migration ledgers directly.
**All 8 of the untracked migration files in this worktree are already applied to Production**, with
matching version timestamps:

- `20260926233000_apphysics1_tier3_labels`
- `20260926233100_apphysics2_tier3_labels`
- `20260926233500_promote_fresh_single_unit_two_model_labels` — the DECISION-0066 promotion migration
  David specifically flagged. **It is applied to Production.** It has a hard-coded `raise exception`
  guard requiring exactly 216 promoted rows (both before and after the update), so its presence in the
  ledger means it ran successfully, not just that a migration file exists.
- `20260926234000_apphysics1_difficulty` through `20260926234400_apcalcbc_difficulty` (5 difficulty
  migrations)

**None of these 8 migrations are in Dev's ledger.** Dev's migration list jumps from
`20260926213508_backfill_rubric_routing_metadata_residual` straight to
`20260927004507_generalize_content_item_cells_topic_only` (a later, unrelated main-branch commit) —
it never received the Pair 3 / promotion / difficulty batch. This is a known, pre-existing pattern in
this repo (Dev's migration ledger cannot be trusted as a mirror — see `TASK-0027 schema convergence`
history) and is not itself a defect Codex introduced.

Per `docs/content/CONTENT_PIPELINE_LIVE_CENSUS_2026_09_26.md` (read in full; this is the strongest
evidence document Codex produced), the post-execution Production census shows:

- All ten live subject packs now have **complete difficulty coverage** (was 5/10, now 10/10; 486 new
  difficulty rows).
- The 216-row promotion raised "fresh validated" (live, unit-gated-selector-eligible) labels from the
  pre-run baseline to: Statistics 67, Chemistry 65, Calculus AB 31, Precalculus 52, Physics 1 77,
  Physics 2 50 (Biology unchanged at 23; Calc BC/Physics C Mechanics/Physics C E&M essentially
  unchanged at 4/0/1 — see below).
- Post-promotion `app.servable_items_census_selftest()`: 82 `ok`, 14 `skipped_capped`, 0 mismatches.
  Direct `select_unit_gated_practice_items` calls against every live pack returned the expected pool.
- Remaining provisional queue: 142 stale-by-timestamp single-unit labels + 92 multi-unit labels (63 of
  the multi-unit set are fresh enough for third review now; 29 need relabeling first). None of this was
  promoted by the 216-row batch — it's explicitly excluded per DECISION-0066's freshness/multi-unit
  rules.
- Biology quantity check: 43/600 MCQ, 59/300 short FRQ, 16/64 long FRQ against the only defined
  (Biology-only) target — 846 total items short. No target exists for the other 9 subjects; David
  decision still open.

`scripts/taxonomy/fetch_candidate_serving_label_packets.sql` is the read-only export step this pipeline
runs first: for one subject, it selects every published, non-retired item whose current serving label
is missing, `legacy_unvalidated`, or `stale`, and shapes the output into the packet JSON that
`extend_serving_labels_mcp.mjs --packets-file=<...>` consumes. I confirmed the `.mjs` script's own
`fetchPackets()` function requires exactly this JSON shape and its error message tells the caller to
run "the SQL" and save the `packets` column — so this is the connected first stage of one pipeline, not
a separate piece, even though the `.mjs` file doesn't literally `require()` or exec the `.sql` file (the
hand-off between them is: run the `.sql` via the Supabase MCP `execute_sql` tool, save its JSON output
to a file, pass that file's path to the `.mjs` script). One naming inconsistency to flag: the `.mjs`
script's own error message (line 243) still says to run `fetch_serving_label_packets.sql` — the actual
file in this worktree is named `fetch_candidate_serving_label_packets.sql`. Cosmetic, but will confuse
the next person who follows the script's own error text literally.

`scripts/taxonomy/extend_serving_labels_mcp.mjs`'s diff against `main` (isolated against the shared
`e76d6c68` base) adds: a `--gateway-env=`/`--out-dir=` CLI override, a JSON-repair fallback for
malformed model output (LaTeX backslashes / trailing commas), a `--resume-results=` flag to reuse prior
model calls instead of re-billing them, and updates the default report filename/date. All additive and
backward compatible with the version already in `main`.

## What's built but NOT verified/applied — and one real discrepancy to resolve first

Three subjects — **Calculus BC, Physics C: Mechanics, Physics C: E&M** — are described in
`LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`'s status table as **"Blocked before model transfer... explicit
Vercel-intermediary approval required."** That phrasing is stale/inaccurate for two of the three:

- `docs/research/AP_CALCULUS_BC_TAXONOMY_SERVING_LABEL_RUN_2026_09_26.md` shows a **completed** run
  (98 candidates, 63 provisional-model, 35 held) — the model calls to OpenAI/Gemini through the Vercel
  AI Gateway already happened.
- `docs/research/AP_PHYSICS_C_EM_TAXONOMY_SERVING_LABEL_RUN_2026_09_26.md` likewise shows a
  **completed** run (96 candidates, 80 provisional-model, 16 held).
- There is **no** `AP_PHYSICS_C_MECHANICS_TAXONOMY_SERVING_LABEL_RUN_2026_09_26.md` file — Mechanics
  really was only exported (76 candidates), not run. That one subject's "blocked" framing is accurate.

In other words: for Calc BC and Physics C: E&M, the actual external data transfer to OpenAI/Gemini via
Vercel that David's approval gate was meant to cover **already occurred** — only the resulting SQL
write (`write_labels.sql`, never applied per the script's own design) is what's still pending. The
launch-plan doc's current text ("explicit Vercel-intermediary approval required" as if the transfer
hasn't happened) does not match this evidence. **Flag this to David before resuming**: either the
approval was actually obtained and the doc text is just stale, or the transfer ran ahead of approval and
that needs to be addressed as its own item — this doc does not attempt to resolve which.

Related artifacts, present but not yet applied to any database:
- `docs/research/content_pipeline_difficulty_2026_09_26/` — CSV + report pairs for Physics 1/2,
  Physics C Mechanics/E&M, and Calc BC, built by `scripts/taxonomy/build_remaining_difficulty_artifacts.py`
  (an offline, Supabase-free artifact builder per its own docstring). These appear to be the source
  artifacts that were turned into the 5 applied difficulty migrations — since difficulty is now 100%
  applied per the census, these CSVs are likely superseded evidence, not a pending write, but that
  should be confirmed by diffing them against the applied migrations before deleting anything.

## What's in-flight / half-done

- `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`, `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`,
  and `docs/product/SUBJECT_SERVABILITY_CRITERIA.md` all have uncommitted edits reflecting the above
  progress (status table rows, David-decision-register text, per-subject "Applied so far" table rows
  with citations to the new migrations). These edits are internally consistent with each other and with
  the applied Production state, **but they were written against the `e76d6c68` base, not current `main`**
  — `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` in particular will conflict with `main`'s newer "October 2,
  2026 launch directive" section (added after Codex's worktree diverged).
- Nothing is committed. All of the above is sitting as working-tree changes only.

## What remains

1. Independent cross-QA of the Pair 3 (Physics 1/Physics 2) and Calc BC/Physics C: E&M label runs —
   the launch-plan doc still lists cross-QA as "Pending" for the three most recent subjects.
2. A decision on the Vercel-transfer-approval discrepancy above.
3. Independent third review for the 63 multi-unit agreements that are fresh enough to review now (63
   of 92; the other 29 need relabeling first).
4. Applying `write_labels.sql` outputs for Calc BC and Physics C: E&M (if/once cross-QA and the transfer
   question are resolved) — these are currently generated files, not yet turned into migrations.
5. Running the pipeline for Physics C: Mechanics from scratch (candidates were only exported, never
   labeled).
6. The Product Owner (David) decision on whether the other 9 subjects get an equivalent quantity target
   to Biology's 600 MCQ/300 short FRQ/64 long FRQ — explicitly still open, not inferred anywhere.
7. Rebasing the three doc edits onto current `main` before committing anything, given `main` has moved.

## Single most useful next action

**Resolve the Vercel-transfer discrepancy for Calculus BC and Physics C: E&M first** — it's a five-minute
read of the two run-report files named above plus a question to David, and it determines whether the
next agent's job is "apply the already-computed `write_labels.sql` outputs after cross-QA" (fast) or
"something more sensitive that needs to be unwound" (slow). Everything else in this worktree (the
difficulty work, the 216-row promotion, the two doc edits) is already correctly applied to Production
and just needs the doc text rebased onto current `main` and committed.
