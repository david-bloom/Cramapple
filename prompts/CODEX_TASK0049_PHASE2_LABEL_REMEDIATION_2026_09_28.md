# CODEX_TASK0049_PHASE2_LABEL_REMEDIATION — 2026-09-28

**Task:** TASK-0049 — Close Six-Criterion Gaps for AP Biology and AP Statistics
(`docs/tasks/TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md`)
**Tier:** Hard-Gate — every Production write in this prompt still needs David's explicit
per-batch approval. Nothing below is pre-approved; read-only audit/planning may proceed under
standing approval.
**Phase:** Phase 2 — the mechanical/reconciled promotion pass (Phase 1) is done. This is what's
left.

## Session-start requirement

Read `docs/team_charter/CRAMAPPLE_SESSION_START.md` and the TASK-0049 task doc before touching
anything. Then read `docs/tasks/TASK-0049-CLAUDE-INDEPENDENT-AUDIT-2026-09-28.md` for what an
earlier Claude session found and already promoted (100 items, 2026-09-28) — don't re-derive that
baseline from scratch, verify it's still current with a fresh live query and move on.

## What's already closed (don't redo)

Live-verified as of 2026-09-28 (`pcntajvbdfqhbeewmdry`): Biology validated 43/118 (was 23),
Statistics validated 143/170 (was 67). Two migrations applied:
`20260928130000_task0049_promote_claude_confirmed_single_unit.sql` (96 items) and
`20260928131500_task0049_promote_multi_unit_reconciled.sql` (4 items). Both are real Production
writes, not proposals — verify against live state, don't re-promote.

## Scope — three categories, 93 items total, none require Production writes to start

### 1. Biology no-active-serving-label — 43 items

These have **no** stored serving-label row at all. Use the existing TASK-0042 pipeline
(`scripts/taxonomy/fetch_candidate_serving_label_packets.sql` → `extend_serving_labels_mcp.mjs`,
which needs AI Gateway credentials in `scripts/vercel-gateway-check/.env.local` — the prior Claude
session did not have these in its sandbox and could not run this step; confirm you do before
starting). Do not invent a new labeling mechanism.

`APBIO-FRQ-S-021, -023, -025, -026, -028, -029, -031, -032, -033, -036, -038, -040, -045, -046,
-047, -048, -051, -052, -058, -062, -063, -064, -066, -068, -070, -071, -073, -074, -076, -080,
-081, -084, -085, -086, -087, -090, -094, -095, -097, -099, -101, -102, -103`

### 2. Held items — 30 items (11 Biology + 19 Statistics)

These already have a `held` label. **Investigate the specific hold reason per item before touching
anything** — the prior session's `.md` source (a separate ChatGPT/Codex run this session compared
against) reported the aggregate hold-reason buckets as "model-unit disagreement, rubric-preflight
failure, empty-required-units, and a Statistics `other` bucket" but did not resolve any of them.
"Close gaps" does not mean promoting through a hold — each item needs its specific hold reason read
(`content_taxonomy_labels.source_payload` and any linked `content_taxonomy_validation_decisions`
row) and either a genuine fix or an explicit, documented reason it stays held.

Biology (11): `APBIO-FRQ-L-012, -013, -014, -015, -017, -031`, `APBIO-HDG-2026-GRAPH-008`,
`APBIO-MCQ-011, -017, -024, -027`

Statistics (19): `APSTAT-MOD4-H001-INV`, `APSTATS-HDG-2026-GRAPH-019`, `APSTATS-MCQ-002, -009,
-013-CAL, -016-CAL, -018-CAL, -020, -055, -069, -075, -079, -088, -094, -096, -097, -098, -100`,
`APSTATS-SFRQ-010`

### 3. Biology legacy_unvalidated / stale — 20 items

These have a stored serving label, but it's `legacy_unvalidated` or `stale`, not `provisional_model`
in the fresh two-model lane. A prior audit this session ran caught that a separate independent
run's own gap manifest never itemized these 20 at all (it only covered `promotion_candidate` +
`multi_unit_nonconfirmed` + `no_active_serving_label` + `held`, missing this category entirely for
Biology) — confirm you're not repeating that omission. These likely need the same TASK-0042
labeling pipeline as category 1 (they're effectively unlabeled-for-practical-purposes), but verify
each one's actual `label_status`/`validated_against_taxo_hash` freshness live before assuming that.

`APBIO-FRQ-S-003, -006, -007, -010, -011, -016, -017, -019, -020`, `APBIO-HDG-2026-GRAPH-002, -003,
-010`, `APBIO-MCQ-025, -030, -033, -046, -055, -064, -088, -094`

## A lesson from Phase 1, worth carrying forward

Before promoting any multi-unit item, cross-check the proposed item-level `required_units` against
that item's own stored `required_units_by_criterion` (for FRQs). Phase 1 found two items
(`APSTAT-MOD7-H002-INV`, `APSTAT-MOD5-H001-INV`) where a third-model review's item-level correction
directly contradicted evidence already stored in that same item's own per-criterion column — nobody
had checked that consistency before. Do this check as a matter of course, not just when something
looks suspicious.

Also worth knowing: `app.subjects.subject_key` uses a different naming convention than
`app.taxonomy_source_versions.subject_key` — the former is `'biology'` / `'ap-statistics'`
(hyphenated, no `ap-` prefix on Biology), the latter is `'ap_biology'` / `'ap_statistics'`
(underscored). Getting this wrong silently pulls in every other subject's rows — Phase 1's first
migration attempt did exactly that and was caught only by its own count guard. Always add a hard
`if count <> N then raise exception` guard on any promotion migration before the actual write.

## Out of scope for this prompt

- The 4 hand-drawn Biology FRQs missing `canonical_answer_1` (`APBIO-HDG-2026-GRAPH-002, -003,
  -008, -010`) — this is a Product Owner policy call (author canonical evidence vs. explicit
  exclusion/retirement), not an engineering task. Flag it back to David rather than resolving it
  unilaterally.
- `APBIO-MCQ-043` — a genuine, still-unresolved 2-way split between the original model candidate
  and the third review; needs a fourth independent read or David's call, not a default.
- Anything outside Biology/Statistics.
- Any Production write without David naming the specific batch, the same way Phase 1 required.

## Acceptance criteria

- Per category, an explicit disposition for every one of the 93 listed items: labeled+promoted,
  labeled+held-with-reason, or explicitly excluded-with-reason. No item silently dropped.
- Every promotion migration has a hard count guard and is live-verified against
  `app.servable_items_census_selftest()` (zero mismatches) after applying.
- Migration files committed to a dedicated branch (not `main` directly), with the same
  before/after evidence discipline Phase 1 used.
- Fresh independent QA on anything promoted, per this repo's standard bar
  (`docs/team_charter/DEFINITION_OF_DONE.md`).
