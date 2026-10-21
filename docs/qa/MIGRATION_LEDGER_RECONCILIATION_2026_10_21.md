# Migration ledger reconciliation (Assessment 2, 2026-10-21)

**Verdict: Production's ledger is a reliable record of almost nothing on its own, but Production itself is in better shape than its ledger.** Of Production's 358 ledger rows, 2 are listed but not in effect (the known 2026-08-21 pair behind TASK-0063), 124 record SQL that no local file holds, and 32 record no SQL at all, only a repair or a note. Going the other way, 94 local migration files have their effects live in Production with no ledger row (applied by `execute_sql` or by hand), so `supabase db push` against Production today would try to re-run work that is already there. The checked effects otherwise agree with what the files say. Every function body, every table, column, index, policy and trigger a file creates, and the sampled data and grants match the newest file or have a recorded later replacement, with five exceptions, each named in §3. Development is worse than Production: 9 rows are listed but not in effect (the gold-set subsystem and the taxonomy stale triggers were never built there) and 89 local files have no visible effect there, mostly content that was only ever loaded into Production. The first repair should be the re-apply that PR #524 already prepares. Then decide the ledger strategy (§4 R3) before anyone runs `db push` or `migration repair` against either project.

**Status:** read-only assessment; proposals only. Nothing was applied, repaired, deployed, deleted or set.
**Date:** 2026-10-21. **Author:** Claude (Opus 5.5).
**Reviewed against:** Cramapple `main` at `c4896e9e` (branch `claude/assessments-2-7-2026-10-21`); Production `pcntajvbdfqhbeewmdry`; Development `wmgjsdkphcyhngaffbqf`. Every number names its project.
**Full register:** [`MIGRATION_LEDGER_RECONCILIATION_2026_10_21_REGISTER.csv`](MIGRATION_LEDGER_RECONCILIATION_2026_10_21_REGISTER.csv) has one row per version key (662 keys: 360 local files ∪ 358 Production rows ∪ 192 Development rows), with each project's class, how it was checked, the evidence and flags. This document reproduces every row that is not routine.
**Evidence convention:** **Verified** = returned by a read-only query quoted in the appendix, or read in a file at `c4896e9e`. **Inferred** = a conclusion from verified facts, with the basis given. **Not verified** = not demonstrated. A ledger row is not evidence that a migration ran; a function body, a table or a data value is.

---

## 1. Counts by class

Ledger rows are classified per project. "File only" counts local files that no ledger row on that project matches by version, by name or by identical SQL.

| Class | Production ledger rows | Development ledger rows |
| --- | ---: | ---: |
| `applied, effective` (has a local file; effects checked or nothing checkable contradicts them) | 191 | 110 |
| `applied, no local file` (no local file holds this row's SQL) | 124 | 32 |
| `superseded` (a later row, or a later change applied outside the ledger, replaced what it did) | 41 | 41 |
| `listed, not effective` | **2** | **9** |
| **Total ledger rows** | **358** | **192** |
| `file only` (local file, no ledger row) | 115 | 191 |
| — effects present (applied outside the ledger) | 94 | 74 |
| — effects absent or differ | 2 | 89 |
| — Development-targeted by name, not meant for Production | 7 | n/a |
| — superseded by a later ledger row | 1 | 1 |
| — not checkable (no function, object or distinctive literal to test) | 11 | 27 |

**Rows that are not what the ledger says** (the three-fact summary):

| Problem | Production | Development |
| --- | ---: | ---: |
| Listed, but the database does not run it | 2 | 9 |
| Listed with no SQL of the migration (`migration repair` row with null statements, a note, or a comment) | 32 (11 null, 17 notes, 4 comments) | 7 (2 null, 5 comments) |
| Listed, but no local file holds its SQL | 124 (103 share literals with a local file under another version, 3 same-name variants, 3 with no SQL, **15 with no local trace**) | 32 (17 same-name variants, 15 with no local trace) |
| Local file whose effects are live but which no ledger row lists | 94 | 74 |

How checked (Production ledger rows): 311 of 358 have a recorded check: function bodies, DDL objects, data literals or grants. Of the 263 rows dated 2026-08-22 or later (the 60-day window), 238 are checked; the 25 that are not are listed in §3.6. Development: 150 of 192 checked; 78 of the 92 in the 60-day window.

Version keys (Verified, recount): 357 distinct version prefixes across 360 files, because **three version prefixes are used by two files each** (§3.7). 123 of the 357 prefixes have a same-version Production row; 235 of 358 Production rows have no same-version file (the handoff's 234/357/235 figures, recounted against today's files). This is why every match here is by name or SQL first, never by version alone.

---

## 2. Findings

### F1. The 2026-08-21 session RPC pair is listed but not in effect on Production (Verified; reproduces REFACTOR_PLAN_REVIEW F6 and DRIFT_REGISTER §3 rows 1–2)

| Ledger row (Production) | How it was recorded | What Production runs |
| --- | --- | --- |
| `20260821011456 allow_subject_switch_archive_active_session` | CLI push (`created_by` null, 6 statements, identical to the local file) | `public.set_active_exam_pack_version` is **not** this body |
| `20260821011843 remember_subject_session_state_on_switch` | CLI push, 11 statements, identical to the local file | `public.set_active_exam_pack_version` `md5 1363d6ea…` = the body from `20260731170200`; it still raises `active_session_blocks_subject_switch` (errcode 55000) when the current pack has any active session (body excerpt in appendix A.9) |
| `20260821014327 allow_home_sessions_for_selectable_subjects` | CLI push, 6 statements, identical to the local file | `app.start_home_learning_session_for_user` `md5 de584bfd…` = the body from `20260731171000` |

Development runs the August bodies (`5a71a24d…`, `dbc35186…`). A third row in the cluster, `20260821011456`, is also not live on either project, but `20260821011843` replaced it on paper, so it counts as `superseded`.

**Explanation search (step 3):** `grep` for the three versions, and for `set_active_exam_pack_version`, `active_session_blocks_subject_switch` and `remember_subject_session_state`, over `docs/activity_log` (including a targeted search of the archive), `docs/tasks`, `docs/handoffs` and `docs/qa` finds only today's assessment documents and TASK-0063/TASK-0078. No record of a later re-application or a `migration repair` exists. `git log` shows all three files added in `a3a97c3d` (2026-08-21 07:51 EDT). The comment block in `20260821050000_learning_session_leak_fix.sql`, committed in `411efe49` at 12:16 EDT the same day, still describes `set_active_exam_pack_version` as refusing the switch. **Not explained.** Inferred: the July bodies were re-created on Production after the August push, by an unledgered run of the `20260731170200`/`20260731171000` SQL or an equivalent edit. No query can show when a function body was last replaced.

**Who it touches today (Verified):** Production has 4 `active` learning sessions across 3 accounts, none on a retired pack. One `student`-role account with 10 active entitlements holds 2 active sessions on its current pack (created 2026-09-23/24; no activity since 2026-09-24). Under the July body, that student cannot switch subjects until those sessions end. This is the TASK-0063 defect, already reported and tracked as TASK-0078 A10, so I did not stop for it. I am stating it because it is live.

### F2. 94 local files are in effect on Production with no ledger row (Verified)

The largest group is the 2026-08-21 to 2026-08-26 topic-guide and explainer work: 66 files between `20260821070000` and `20260826173616` (every `repair_*_explainers`, `*_topic_guides` and `*_seed` file). A 60-character literal taken from each file is present in Production's content tables, and no Production ledger row contains it. The rest:

- the publish-gate, Stripe and trial files of 2026-08-09 to 2026-08-15: function bodies live;
- `20260826120000` (confirm-transfer selector): body live after the `20261006005950` in-place rewrite;
- `20260828120000` (home start queue): body live, comments stripped;
- the 2026-09-25 consolidated content files (`20260925010000` to `20260925190000`): their content arrived through 103 smaller ledger-only batch rows (F3);
- `20260927004700`.

These files are the danger in `db push`. The CLI would treat them as pending and re-run them, and most are non-idempotent data writes. Full list: register, `prod_class = file only — effects present`.

### F3. 124 Production ledger rows record SQL no local file holds (Verified)

- **103** share at least one 60-character literal with a local file under a different version. These are mostly the 2026-09-25 per-batch rows (`apcalcab_canonical_answers_batch_*`, `apphysics*_canonical_answers_batch_*`, `apstats_canonical_answers_batch_*`, `load_apstats_labels_batch*`, `load_apstats_difficulty_batch*`, the `fix_p0_*` rows). The repository instead holds a consolidated rewrite per subject (for example `20260925010000_apcalcab_canonical_answers_33_items.sql`). For 100 of them the row's own literals, or the shared literals, are also present in Production's data (`own literals found in data n/n` in the register). The rows are effective; the files are not the same SQL.
- **3** are same-name variants (an earlier or later draft of a migration whose file holds different SQL), for example `20260821022844 learning_session_leak_fix` (MCP) against the file `20260821050000`. Production runs the bodies from `20260821022844`; the file's bodies match them once comments are removed.
- **3** have no SQL (`20260814190000`, `20260814200000`, `20260814210000`: `migration repair` rows, null statements).
- **15 have no local trace** by version, name or literal (§3.3). Their SQL exists only in `supabase_migrations.schema_migrations.statements` on Production.

This reconciles the memory note "≥72 migrations exist only in Production (185 vs 113)". Today the figure is 124 by SQL, or 15 with no local trace at all.

### F4. 32 Production rows carry no migration SQL (Verified)

- 11 have `statements` null (`migration repair --status applied`).
- 17 hold one placeholder statement, *"applied verbatim from repo file on main @9f287db via MCP, 2026-08-02 release session"* (`created_by = claude-fable-release-20260802`): `20260731160100` to `20260731171300`.
- 4 hold only a comment, for example `20260930190000`: *"Deviation from the file: the view was not dropped … prompt_json is projected as NULL::jsonb instead"*.

For each, the effect was judged against the local file. All the checked ones hold, including the deviation: `public.content_item_versions` projects `NULL::jsonb AS prompt_json`, and `authenticated` has no column grant on `prompt_json` (Verified).

### F5. Function bodies: two kinds of benign mismatch hide real drift (Verified)

A plain `md5(prosrc)` comparison wrongly flags two kinds of change.

- **Comment-stripped re-application.** Several live bodies equal the file's body with its `--` comments removed. Examples: `app.sweep_learning_sessions`, `public.end_active_learning_session`, `public.get_home_start_queue`, `public.get_graded_mcq_feedback`, `app.set_assistance_event_derived_fields`, `public.get_student_progress_dashboard`, `public.get_open_hand_item`.
- **The in-place rewrite in `20261006005950`.** It edits the four selectors with `pg_get_functiondef` + `replace` + `execute`, so no file holds the resulting body. All four live bodies, on both projects, carry the inserted `content_item_is_teaching` predicate.

Once both are accounted for (three equality tiers: exact, whitespace-insensitive, comment- and whitespace-insensitive), the only live bodies on Production that match no file and no recorded later change are the F1 pair. On Development, `20260731160000` (baseline) still differs from the live body for 4 functions (`enforce_content_items_frq_form`, `prevent_profile_role_change`, `prevent_review_decision_mutation`, `tg_content_pipeline_on_decision`), and `public._epv_is_selectable` is absent.

### F6. Corrections to DRIFT_REGISTER §3 (Verified)

| DRIFT_REGISTER said | Now shown |
| --- | --- |
| `get_student_progress_dashboard`: neither environment matches `20260821080000` | Production equals the file with comments removed (it carries `pointsWithheld`). Production's ledger row `20260821154017 progress_dashboard_v1` holds the earlier variant. Development equals its own ledger row `20260821153751 progress_dashboard_v1_exclusion_visibility`, so Development is behind Production on this function |
| `progress_estimated_ap_score` / `progress_status_token`: Production matches none | Production equals `20260821080000` with comments removed |
| `select_confirm_transfer_item`: neither matches `20260826120000` | Both carry the `20261006005950` rewrite (marker Verified; exact text Inferred) |
| `get_open_hand_item`: neither matches `20260928023843` | `20260928023843` is superseded. Both projects equal `20260929034129` with comments removed. Production's `20260929034129` row has no statements (hand repair, `created_by = claude-task-0051-owner-override-2026-10-05`) |
| `invoke_trial_worker`, `trial_record_attempt`: versions absent from Production | Production lists them as `20261021010400` and `20261021010317`, identical SQL under MCP-stamped versions (timestamp drift), and the bodies are live |
| `select_student_practice_items`: neither matches `20261008113000` | Production row `20261008113000` is a comment that points at the file. The body is superseded by `20261009230917` (`frq_photo_responses_content`), whose body is live on Production. Development equals it with comments removed |

### F7. Development differs from Production in ways that matter for rehearsals (Verified)

- **Not built on Development although its ledger lists them:** the gold-set subsystem (`20260803120000`, `…140000`, `…180000`, `…220000`, `20260805140000`, `…150000`: 4 tables, 8 functions); the taxonomy stale-label triggers and their 3 functions (`20260804170000`); `app.seed_taxonomy_units` (`20260804183000`).
- **Missing on Development and in no Development ledger row:** `app.content_item_difficulty` and `app.content_taxonomy_validation_decisions` (tables), `app.servable_items_census*`, `app.taxonomy_scope_selftest`.
- **2026-10-15 security handoff §7 item 6 is still open on Development:**
  - `public.scc_rehearsal_chunks_20261006` exists with RLS off (Production: absent).
  - 12 `SECURITY DEFINER` functions in `app`/`public` are executable by `anon`, including two in the exposed `public` schema: `public.select_unit_gated_practice_items` and `public.content_review_invariant_report`.
  - The handoff's "Production does not show these" needs one correction. Production shows 11 such functions, but all are in `app` (mostly trigger functions, plus `app.servable_items_census`) and none are in `public`. Whether `app` is reachable through PostgREST is **Not verified**; the API exposes `public` by default.

### F8. Two files never took effect on either project (Verified)

- `20260828170000_chosen_distractor_rationale_rpc.sql`: `public.get_chosen_distractor_rationale` is absent on both projects. The live app still calls it (`src/hooks/use-session.ts:901`, fail-soft, inside the retired `/session` flow). See the dormant-surface review.
- `20260827120000_ap_statistics_unit1_score_impact_topic_guides.sql` (a Course Mode pilot rewrite of AP Statistics Unit 1 topic guides): neither literal is present on either project, and Production's 13 Unit 1 explainer rows were last updated 2026-08-22, before the file's date. Whether it was deliberately never promoted is **Not verified**.

---

## 3. Register exceptions (every non-routine row)

### 3.1 `listed, not effective`

| Version | Name | Project | Not in effect | Explanation found |
| --- | --- | --- | --- | --- |
| `20260821011843` | remember_subject_session_state_on_switch | Production | `public.set_active_exam_pack_version` runs the `20260731170200` body | none (F1) |
| `20260821014327` | allow_home_sessions_for_selectable_subjects | Production | `app.start_home_learning_session_for_user` runs the `20260731171000` body | none (F1) |
| `20260731160000` | schema_baseline | Development | 4 function bodies differ (F5); `public._epv_is_selectable` absent; indexes `content_items_exam_pack_practice_format_idx` and `profiles_active_epv_idx` absent; policy `review_decisions/deny_authenticated_all` absent | TASK-0027 (`411efe49`) records that Development was fed through a different channel 2026-08-04 to 08-19 |
| `20260803120000` | gold_set_verification | Development | 4 tables and 5 functions absent | same |
| `20260803140000` | gold_set_review_permission | Development | `app.gold_set_reader_is_eligible`, `public.gold_set_access` absent | same |
| `20260803180000` | fix_gold_set_sibling_gap | Development | `app.seed_gold_set_verification_assignments` absent | same |
| `20260803220000` | gold_set_exclude_fixtures | Development | `public.gold_set_verification_progress`, column `gold_set_answers.is_fixture` absent | same |
| `20260804170000` | taxonomy_label_layer | Development | 3 stale-label functions and their 3 triggers absent | `411efe49` says exactly this ("Dev records 20260804170000 as applied while the table it creates does not exist there") |
| `20260804183000` | unit_serving_registry | Development | `app.seed_taxonomy_units`, index `taxonomy_units_source_assessed_idx` absent | same |
| `20260805140000` | gold_set_admin_cc_marking | Development | `public.submit_gold_set_verification`, `public.gold_set_admin_overview` absent | same |
| `20260805150000` | gold_set_verification_skip | Development | `public.gold_set_verification_next` absent | same |

### 3.2 Production rows judged `superseded` by evidence outside the ledger

The other 37 Production `superseded` rows were replaced by a later ledger row; the register lists them. The rows below were judged by evidence:

| Version | Why |
| --- | --- |
| `20260808195103 publish_gate_full_allowlist` | `app.enforce_publish_gate` body is the one in `20260809150000` (file only on Production, body live) |
| `20260821154017 progress_dashboard_v1` | live body = file `20260821080000` with comments removed (F6) |
| `20260821011456 allow_subject_switch_archive_active_session` | replaced on paper by `20260821011843`, which is itself not in effect (F1) |

Two rows are counted `applied, effective` by judgment: `20260824121115 orly_protocol_calc_unit1_unit2_items`, whose helper `app._orly_20260824_publish_mcq` is dropped inside the same migration by design, and `20261006004005 open_hand_teaching_pool` (see §3.5).

### 3.3 Production rows with no local trace (SQL exists only in the ledger)

| Version | Name | Effect check |
| --- | --- | --- |
| `20260806013726` | question_reports | `public.question_reports` exists (0 rows) |
| `20260821021652` | close_stale_active_learning_sessions_pilot_account | not checked (one-off data fix) |
| `20260922005214` | apbio_canonical_qa_http_timeout | `app.qa_grade_frq` body live |
| `20260923172857` | task0038_promote_apbio_hdg_002_human_graded_pilot | own literal found in data |
| `20260924140953` | biology_coverage_labels_restore_and_anchor | own literal not found (later relabelling likely superseded it; Not verified) |
| `20260924141344` | biology_serving_reanchor_after_m1_m4 | same |
| `20260924142401` | biology_mcq_serving_reanchor_after_qa | same |
| `20260925012754` | apchem_frq_l_012_canonical_answer | own literals found in data (4/4) |
| `20260925112543` | fix_apcalcab_frq_005_rubric_constant | not checked |
| `20260925124234` | retire_apstats_pilot_pack | not checked |
| `20260926211349` | create_grade_disputes | `public.grade_disputes` exists (0 rows) |
| `20260926213523` | backfill_rubric_routing_metadata_residual | not checked |
| `20260927004624` | migrate_biology_topic_labels_into_cells | not checked; a file with a similar name exists (`20260927004600_biology_topic_labels_into_cells.sql`) |
| `20260927004656` | create_content_item_topic_resolution_view | view exists; similar-name file `20260927004700_content_item_topic_resolution_view.sql` |
| `20260927005019` | gate_content_item_topic_resolution_on_validated_status | view exists |

Development's 15 no-trace rows (for example `20260820222450 align_published_pack_subject_status`, `20260821161106 task0027_restore_taxonomy_layer_from_production`, `20260928132903 task0041_reconcile_checkout_persistence`) are in the register.

### 3.4 Production `file only` rows that are not "effects present"

| File | Reading |
| --- | --- |
| `20260827120000_ap_statistics_unit1_score_impact_topic_guides.sql` | never applied on either project (F8) |
| `20260828170000_chosen_distractor_rationale_rpc.sql` | function absent on both projects (F8) |
| `20260928023843_open_hand_answer_key_contract.sql` | superseded by `20260929034129` |
| `20260821120000_task0027_drop_task0017_harness_dev_only.sql`, `20260822180000_mirror_publish_gate_cluster_into_dev.sql`, `20260822190000_mirror_content_review_invariants_cluster_into_dev.sql`, `20260823120000_course_mode_converge_dev_additive_columns.sql`, `20260823120100_course_mode_converge_content_taxonomy_labels_cluster.sql`, `20260824030000_converge_dev_civ_published_rls_recursion.sql`, `20261015175807_restore_taxonomy_hash_for_development_qa.sql` | Development-targeted by name. They should not live in a directory that `db push` sends to Production |
| `20260805110000`, `20260805130000_backfill_practice_format_all_subjects`, `20260816120000`, `20260817015348`, `20260821072000`, `20260821150000`, `20260821280000`, `20260824060000`, `20260824130000`, `20260924180000`, `20260924240000`, `20260927004600` | not checkable by this method. Four are earlier drafts of a same-name migration that is listed under another version (`purchase_refunded_event`, `widen_learning_sessions_entry_path`, `trial_entitlement`, `retire_free_score_check`) |

### 3.5 Local file differs from what ran

36 Production rows and 26 Development rows match a local file by version or name while the recorded SQL differs. In most of them the live state equals the ledger SQL, and the file is a later edit or an earlier draft; the register flags each one (`ledger SQL differs from the local file`). The one where the difference matters is `20261006004005 open_hand_teaching_pool`. Production's row has no statements; Production and Development both run Development's ledger SQL for `public.get_open_hand_teaching_item` (`af8c1fd2…`, 22 live lines not in the file), not the committed file. Re-running the file would replace the live body.

### 3.6 Production rows in the 60-day window with no recorded check (25)

`20260823224031`, `20260824020851`, `20260924130141`, `20260924135654`, `20260924140953`, `20260924141344`, `20260924142401`, `20260925010422`, `20260925112543`, `20260925124234`, `20260925132534`, `20260926032732`, `20260926032821`, `20260926032907`, `20260926032948`, `20260926213523`, `20260927004624`, `20260927181002`, `20260929071941`, `20260929102858`, `20260929102917`, `20261002164510`, `20261006100000`, `20261007181153`, `20261010210000`. These are data or constraint rows whose literals are short, absent from the tables probed (for example `app.figures`), or overwritten later (the `apprecalc_difficulty_batch_*` rows were corrected by `20260926121707`). Rows before 2026-08-22 were sampled, not checked in full: functions and DDL for every row, data literals where the file had them, and the grants listed in A.8.

### 3.7 Duplicate version prefixes in the repository (Verified)

| Version | Files |
| --- | --- |
| `20260805130000` | `backfill_practice_format_all_subjects.sql`, `gold_set_question_parts.sql` |
| `20260805140000` | `gold_set_admin_cc_marking.sql`, `require_practice_format_at_publish.sql` |
| `20260823120000` | `course_mode_converge_dev_additive_columns.sql`, `update_2027_official_exam_dates.sql` |

The CLI keys migrations by version, so two files cannot both be tracked. In the register the second file of each pair carries a `b` suffix (`20260805130000b`).

---

## 4. Repair plan (proposals only, ordered by student impact)

Every step is Hard-Gate unless marked otherwise. Every step is verified by querying the database, never by reading the ledger.

| # | Proposal | Rows | Type | Development rehearsal | Success query |
| --- | --- | --- | --- | --- | --- |
| **R1** | **Re-apply the August session RPC bodies as a new migration: adopt PR #524's `20261021153710_task0063_reconcile_session_rpc_bodies.sql`** (TASK-0078 A10). I checked it independently. Its two bodies hash to `dbc35186dc…` and `5a71a24d2f…`, the exact Development bodies and the bodies in `20260821014327`/`20260821011843`. Its guards refuse to run unless the current body is the known July or August hash (`de584bfd…`/`1363d6ea…` or the August ones), which also makes it idempotent. `create or replace` plus grants is otherwise idempotent. | `20260821011843`, `20260821014327` (and `20260821011456` on paper) | re-apply as a new migration | Apply on Development: a no-op for the bodies, which proves the guards accept them. Then with a test student holding an active session on pack A, call `set_active_exam_pack_version(B)` and expect success | `select p.proname, md5(p.prosrc) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where (n.nspname,p.proname) in (('public','set_active_exam_pack_version'),('app','start_home_learning_session_for_user'));` → `5a71a24d2fc753b91f0150aa0ac2161e`, `dbc35186dc642ac15e19295f3601186b` on Production |
| R2 | Commit the SQL of the 15 no-trace Production rows (and the 15 Development ones) **verbatim from `statements`** to files under their ledger versions. Do the same for `20261006004005`: replace the committed file with the SQL that actually ran (Development's ledger statements). Until R3 is decided, these files go in a non-applied folder (`supabase/migrations_recovered/`) so `db push` cannot pick them up | 30 + `20261006004005` | write recovered SQL to a local file | none (no database change). Check: `md5(array_to_string(statements,''))` per version equals `md5` of the committed file's content | the file hashes recorded in the PR |
| R3 | **Decide the ledger strategy before any `db push` or `migration repair`.** Option A (recommended): re-baseline. Take a schema dump of Production (`supabase db dump --linked --schema app,public` against `pcntajvbdfqhbeewmdry`), commit it as a new baseline, move today's 360 files to an archive folder, and set Production's ledger to the baseline with one `migration repair`. Option B: incremental. `migration repair --status applied` for the 94 "effects present" files, local files for the 124 remote-only rows, and move the 7 Development-targeted files out of `supabase/migrations/`. Option A removes the problem; Option B keeps the history but needs ~220 per-row decisions | all | ledger repair only | Do the same on Development first, from a Development dump, and compare `supabase migration list` before and after | `supabase migration list --linked` shows no local-only or remote-only versions, and `pg_proc`/`pg_tables` hashes are unchanged before and after (the repair runs no SQL) |
| R4 | Rename the second file of each duplicate prefix (§3.7) to an unused version (Standard, repository only). Under R3-B, also `migration repair --status applied` the new versions on each project where the effects are present (`20260805234943`, `20260823224031` already list the same content on Production) | 3 files | repository fix | n/a | `ls supabase/migrations | cut -c1-14 | sort | uniq -d` returns nothing |
| R5 | Decide the two files that never took effect (F8): apply `20260828170000` (the app calls the function) or delete the calls with the dormant `/session` flow (recommended, see the dormant-surface review); archive `20260827120000` unless the Course Mode pilot rewrite is wanted | 2 | decide | if applying: run on Development and call it as a student with a missed MCQ | `select to_regprocedure('public.get_chosen_distractor_rationale(uuid,uuid)')` |
| R6 | Development: rebuild from Production's schema rather than repair 9 not-effective rows and 191 file-only rows (DRIFT_REGISTER question 3). Close security item 6 in the same pass (drop `scc_rehearsal_chunks_20261006`; revoke `anon` execute on the 12 definer functions) | Development | rebuild | is itself the rehearsal of R3-A | advisor ERROR count 0; `has_function_privilege('anon', …)` false for the 12 |

**What not to do:**

- Do not run `supabase db push` against either project until R3 is done. It would try to re-run up to 94 Production files whose effects are already present, or refuse on 124 remote-only versions.
- Do not run `migration repair --status reverted` on the F1 pair. The ledger rows are correct about intent; the bodies are what is wrong.
- Do not trust a `migration repair` row as proof. 32 of today's rows are exactly that.

### 4.1 Approval request text (for David to sign)

**R1 (A10).**
> I approve applying migration `20261021153710_task0063_reconcile_session_rpc_bodies.sql` (PR #524 as merged) to Development `wmgjsdkphcyhngaffbqf`, and, after the Development rehearsal shows a subject switch succeeding with an active session present, to Production `pcntajvbdfqhbeewmdry`. The migration only replaces the bodies of `public.set_active_exam_pack_version` and `app.start_home_learning_session_for_user` with the 2026-08-21 versions already running in Development, guarded by the current-body hashes. Success is `md5(prosrc)` = `5a71a24d…` and `dbc35186…` on Production. Rollback is `create or replace` with the July bodies recorded in the PR. No data changes.

**R3, option A (re-baseline).**
> I approve re-baselining the migration history. First Development, then Production: dump the `app` and `public` schemas, commit the dump as `<new version>_schema_baseline_2026_10.sql`, move the existing files to `supabase/migrations_archive/`, and run `supabase migration repair` so that each project's ledger lists only the new baseline. No SQL is executed against either database. The `pg_proc` and `pg_tables` hash inventories must be identical before and after on both projects.

**R3, option B (incremental), if chosen instead.**
> I approve `supabase migration repair --status applied` on Production for the 94 versions listed as "file only — effects present" in `MIGRATION_LEDGER_RECONCILIATION_2026_10_21_REGISTER.csv`, run with `--workdir` pointed at a directory linked to `pcntajvbdfqhbeewmdry` and `--debug` to confirm the project ref, after the same run on Development for its 74. The 7 Development-targeted files are moved out of `supabase/migrations/` first.

**R6.**
> I approve rebuilding Development `wmgjsdkphcyhngaffbqf` from Production's schema (no Production data), including dropping `public.scc_rehearsal_chunks_20261006` and revoking `anon` execute on the 12 `SECURITY DEFINER` functions listed in the reconciliation document.

---

## 5. Reconciling the project memory

- "≥72 migrations exist only in Production (185 applied vs 113 files)": stale. Today Production has 358 rows, of which 124 have no local file holding their SQL and 15 have no local trace at all. In the other direction, 94 local files are in effect on Production without a ledger row.
- "`apply_migration` writes no local file": confirmed. 273 Production rows have `created_by` set to David's account email (the MCP connector), with versions stamped at apply time. These are the source of the timestamp drift, which affects 122 Production rows matched to a file under another version.
- "Development's ledger cannot be trusted": confirmed and quantified (F7, §3.1).
- 2026-10-15 security handoff §7 item 6 (Development-only RLS-less table and `anon`-executable definer functions): still true on Development; Production's side needs the correction in F7.

## 6. Questions for David

1. Approve R1 (PR #524) for Development rehearsal, then Production? It also unblocks the weekly sweep caveat in TASK-0078 §3.
2. Ledger strategy: re-baseline (A) or incremental repair (B)?
3. Rebuild Development from Production's schema (R6)?
4. `20260828170000` and `20260827120000`: apply, or archive?
5. Should a rule be added that hand-inserted ledger rows (`created_by` like `claude-%`, null statements) are forbidden, so that every ledger row carries the SQL that ran?

## 7. DRIFT_REGISTER rows reused

Reused without re-deriving: §1.1 and §1.2 function inventories (versions, dates, source directories) as inputs to the dormant-surface review; §2 counts (171 Production / 152 Development functions after excluding `pg_trgm`; 19 Production-only). I re-pulled both inventories and the counts match. From §3 I reused the F6 rows and the ledger totals, and corrected six rows (F6). I did not re-check §1 bundle hashes.

---

## Appendix A. Queries and method

All queries were `SELECT`s through the Supabase MCP `execute_sql` tool, on the project named. Long results were checked for transcription with an `md5` of the result string, computed in the query and again locally after saving. Every check matched.

**A.1 Ledgers (both projects).**
```sql
with l as (select version, name, coalesce(array_length(statements,1),0) n,
  case when statements is null then '-' else left(md5(regexp_replace(regexp_replace(regexp_replace(
    lower(array_to_string(statements,'')), '/\*.*?\*/', '', 'g'), '--[^\n]*', '', 'g'), '[\s;]+', '', 'g')),10) end nh
  from supabase_migrations.schema_migrations),
b as (select string_agg(version||'|'||coalesce(name,'')||'|'||nh||'|'||n, E'\n' order by version) blob from l)
select md5(blob), blob from b;
```
Production: 358 rows, `md5 6089d587…`. Development: 192 rows, `md5 b6e3eca9…`. Local files get the same normalisation in Python (lower-case, strip `/*…*/`, strip `--…`, strip whitespace and `;`), and a parity test on four versions matched. Matching tiers: same version; version embedded in the ledger name; same name with identical normalised SQL; identical normalised SQL under any name; then same name with different SQL.

**A.2 Ledger provenance (Production).**
`select coalesce(created_by,'(null)'), idempotency_key is not null, count(*), min(version), max(version) from supabase_migrations.schema_migrations group by 1,2;` → David's account email 273; null 63; `claude-fable-release-20260802` 18; `claude-task-0064` 3; `claude-task-0051-owner-override-2026-10-05` 1.

**A.3 Live function bodies (both projects).**
`select n.nspname||'.'||p.proname, left(md5(p.prosrc),10), left(md5(regexp_replace(p.prosrc,'\s','','g')),10), left(md5(regexp_replace(regexp_replace(regexp_replace(p.prosrc,'/\*.*?\*/','','g'),'--[^\n]*','','g'),'\s','','g')),10) from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname in ('app','public','private','audit') and p.prokind in ('f','p') and p.proname !~ '^(gin_|gtrgm_|similarity|word_similarity|strict_word_similarity|set_limit|show_limit|show_trgm)';` → Production 171, Development 152.

**A.4 Function bodies inside ledger statements** (rows whose SQL is not identical to a file). The statements were split on `create (or replace) function`; the name was read with `^\s*("?[A-Za-z0-9_]+"?(\.…)?)\s*\(`. The body is the text between the first dollar tag (which must precede the first `;`) and its closing tag, hashed three ways as in A.3. A parity test against the Python extractor on two versions matched. Production: 38 definitions in 148 rows; Development: 55 in 50.

**A.5 DDL existence (both projects).** 596 distinct objects parsed from every file (tables, views, added columns, indexes, policies, triggers; DDL inside dollar-quoted blocks excluded), sent as a `VALUES` list and checked against `pg_tables`, `pg_views`/`pg_matviews`, `information_schema.columns`, `pg_indexes`, `pg_policies` and `pg_trigger` (non-internal). Production missing 7, all removed by later files (`free_score_checks` ×5 by `20260815181856`; `trial_orders.recovery_seen_error` by `20261020233210`; policy `attempts_owner_insert` by `20260731160200`). Development missing 31 (§3.1, F7). Three more columns from the duplicate-prefix files were checked separately: all present on Production; `gold_set_verification_assignments.completed_by` absent on Development.

**A.6 Data literal probe (both projects).** For each of the 218 data-only files, up to two 60-character windows of the first and last literal of ≥80 characters (no quote, backslash or newline): 273 windows. Each window was tested with `strpos` against the row text of `content_item_versions`, `canonical_answer_spans`, `content_taxonomy_labels`, `content_item_difficulty`, `topic_explainers`, `topic_point_briefs`, `taxonomy_topics`, `frq_criteria`, `mcq_choices`, `content_item_cells`, `content_items` and `subjects`, and against every ledger row's statements. The echo hash of the window set matched on both projects (`383a791b…`). A second pass took each Production ledger-only row's own first four windows (`regexp_matches(t, '''([^''\n"\\]{60})', 'g')`) and tested them the same way, adding `taxonomy_skills`, `taxonomy_cells`, `taxonomy_units`, `content_taxonomy_validation_decisions`, `exam_pack_versions` and `home_release_manifest`. A third pass hashed those windows (`left(md5(w),10)`) for the 124 no-local-file rows and matched them locally against every file's windows: 102 of 111 rows with windows hit a file.

**A.7 Line diffs, live vs file (Production).** Per-line `left(md5(btrim(line)),8)` hashes of a file body were sent in a `VALUES` list; the server returned live lines whose hash was absent. Used for `sweep_learning_sessions`, `end_active_learning_session`, `set_assistance_event_derived_fields`, `get_home_start_queue`, `get_graded_mcq_feedback` (differences: comment lines only), `get_open_hand_teaching_item` (22 live lines not in the file), and, against the ledger SQL, `get_student_progress_dashboard` (live adds `pointsWithheld`).

**A.8 Grants and policies (both projects, all true unless noted).**
- `cm_d19_*` not executable by `anon`/`authenticated`.
- No table-level `SELECT` on `app.content_item_versions` for `authenticated`; column `stem` granted.
- `frq_criteria` column grants limited to the six listed columns.
- `mcq_choices.is_correct` hidden from `authenticated`.
- `app.merge_response_parts` is security invoker.
- `service_role` has `UPDATE` on `question_help_receipts`.
- Policy `content_item_versions_select_published` calls `content_item_is_teaching`.
- Every `dashboard_*_v1` view is `security_invoker`.
- `parent_payment_links` is unreadable by `anon`/`authenticated`.
- All four selectors carry the teaching exclusion.
- `app.byoq_items`: `authenticated` has 20 column grants, without `extraction`/`captured_work`, and no table grant.
- `learning_sessions_entry_path_check` = the 7 values in `20260817015400`.

**A.9 F1 detail (Production).**
- `select substr(prosrc, position('active_session_blocks_subject_switch' in prosrc)-520, 600) from pg_proc … where proname='set_active_exam_pack_version'` (guard text quoted in F1).
- Active sessions: `select … from app.learning_sessions ls join app.exam_pack_versions v … where ls.status='active'` → 4 sessions, 3 users, 0 on retired packs.
- The per-account role, entitlement count, current-pack check and last-activity queries used `left(md5(user_id::text),8)` references only.

**A.10 Development security item 6.**
`select count(*) from pg_tables where schemaname='public' and tablename='scc_rehearsal_chunks_20261006'` and `relrowsecurity`; `select n.nspname||'.'||p.proname from pg_proc p … where p.prosecdef and has_function_privilege('anon', p.oid, 'EXECUTE')`. Development 12 (list in F7); Production 11, all in `app`.

**A.11 Repository.**
- `ls supabase/migrations`: 360 files, 357 prefixes.
- `git log` on the F1 files: `a3a97c3d`. `git show 411efe49`: leak-fix comment.
- PR #524 migration read with `git show origin/codex/task-0063-session-rpc-reconciliation:supabase/migrations/20261021153710_task0063_reconcile_session_rpc_bodies.sql`; bodies hashed with the A.4 extractor.

**Limits.**
- The DDL parser skips DDL built dynamically inside `DO` blocks.
- The function parser recognises only dollar-quoted bodies.
- Overloads are compared by name (a body counts as live if any overload matches).
- Data checks prove presence of a literal, not that every row of a file landed.
- A literal that is absent can mean "never applied" or "overwritten later". The register says which was concluded and why.
- Scratch scripts and intermediate files stayed in the session scratchpad and are not committed; the queries above are enough to reproduce the results.
