# TASK-0027 - Development / Production Schema Convergence

**Task ID:** TASK-0027
**Title:** Development / Production Schema Convergence
**Owner:** Product Owner with Claude
**Product Owner:** David Bloom
**Status:** In Progress
**Tier:** Infrastructure
**Priority:** High
**Created Date:** 2026-08-21
**Source:** Discovered while QA-ing Progress Dashboard v1
(`docs/product/PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md` §7, §9)

## Problem

The Development project (`wmgjsdkphcyhngaffbqf`) and the Production project
(`pcntajvbdfqhbeewmdry`) are not two copies of one schema at different
migration depths. They are **substantially different databases**.

Object inventory, `app` + `public` schemas, measured 2026-08-21
(tables + views + functions, excluding `pg_trgm` extension functions):

| | Count |
| --- | --- |
| Production objects | 214 |
| Development objects | 233 |
| **Shared** | **168** |
| Present in Prod, absent in Dev | 46 |
| Present in Dev, absent in Prod | 65 |

Roughly a fifth of each database does not exist in the other.

**Numbers corrected 2026-08-21.** This table first read 184 / 199 / 135 / 49 /
64. Those came from hand-transcribed object lists and undercounted. The figures
above are produced by `scripts/qa/dev_prod_drift_qa.sql`, are reproducible, and
count distinct qualified names (overloaded functions collapse to one entry).
The conclusion is unchanged and the named object clusters below were each
verified individually; only the totals moved.

**Missing from Dev (46)** includes whole shipped subsystems: the gold-set
verification layer (`gold_set_answers`, `gold_set_elements`,
`gold_set_element_marks`, `gold_set_verification_assignments` and their five
RPCs), the taxonomy layer (`taxonomy_source_versions`, `taxonomy_units`,
`taxonomy_topics`, `content_taxonomy_labels`, `seed_taxonomy_*`), Stripe
checkout (`stripe_checkout_sessions`, `stripe_checkout_session_attempts`), the
publish gate (`enforce_publish_gate`, `content_item_is_published`,
`tg_require_practice_format_at_publish`), MCQ stem/choice sync, content asset
and visual-requirement metadata, and the practice selection RPCs
(`select_practice_frqs`, `select_unit_gated_practice_items`).

**Dev-only (65)** is a parallel governance and packaging architecture that
Production never adopted: `execution_approvals` (+ consumptions, revocations),
`reviewer_capability_*`, `governance_role_assignments`, `item_archetypes`,
`verifier_plugins`, `calibration_sets`, `content_clearance_exceptions`,
subject/item packaging (`apply_subject_package_atomic`,
`item_package_applications`), grading experiments, and a **different taxonomy
design** — `taxonomy_schemes`, `taxonomy_scheme_versions`,
`taxonomy_node_versions`, `taxonomy_node_relations`, `taxonomy_crosswalks`,
all currently **0 rows** and present in no repository migration.

### The migration ledger cannot be trusted

Dev records `20260804170000` (the migration that creates
`app.taxonomy_source_versions`) as applied, yet the table does not exist there.
The ledger and the schema disagree.

The two ledgers are also not comparable by version id. From 2026-08-04 to
2026-08-19 Dev received repo-style round timestamps (`20260804170000`) while
Production received generated ones (`20260804193850`) — the same intent applied
through two different channels. Repo migrations `20260821060000`–`20260821072000`
are applied to neither database.

## Impact

- **`public.get_student_taxonomy` fails in Dev** with `42P01` on
  `app.taxonomy_source_versions`, and did so before this task opened.
  **Correction (2026-08-21):** this was first written as "that RPC powers the
  live topic-guide / Learn More surface". It does not. `get_student_taxonomy`
  has **zero consumers** anywhere — the topic-guide surface is served by
  `public.get_topic_point_guides`, which reads `app.topic_point_briefs` and
  `app.topic_explainers` directly and never touches the taxonomy tables. The
  Dev failure had no user-visible effect. Its only real consumer today is
  `get_student_progress_dashboard`, via `app.taxonomy_units`.
- Any QA performed in Dev is not evidence about Production behaviour for the
  49 objects Dev lacks. "Dev QA passed" has been, for those paths, a
  meaningless statement.
- Progress Dashboard v1 could not be QA'd in Dev and was QA'd directly against
  Production instead.

## Scope

In scope: making Dev a trustworthy pre-production environment for the
student-facing surfaces, and establishing why the ledgers diverged.

Out of scope: adopting Dev's 64-object governance architecture into
Production, or deciding its future. That is a product/architecture decision,
not an infrastructure repair.

## Acceptance Criteria

- [x] Object-level inventory diff produced for both projects, and made
      reproducible as `scripts/qa/dev_prod_drift_qa.sql`.
- [x] Root cause of the taxonomy failure identified (ledger/schema mismatch,
      not migration lag).
- [x] Taxonomy layer restored in Dev; `get_student_taxonomy` returns subjects.
- [x] `get_student_progress_dashboard` executes end-to-end in Dev.
- [x] AP Statistics taxonomy topics seeded from the CED (55) in both projects.
- [x] Disposition decided for the Dev-only objects: **retired**. Approved by
      the Product Owner and executed 2026-08-21.
- [ ] Disposition decided for the remaining 46 objects missing from Dev.
- [ ] Repo migrations `20260821060000`–`20260821072000` applied or retired.
- [ ] Single migration application path agreed, or a scheduled object-level
      drift check in place.
- [ ] Product Owner accepts the convergence state.

## Execution Log

**2026-08-21 — Steps 1-3 executed.** See "Done Decision" for what remains.

1. **Production declared authoritative.** It matches the repository's taxonomy
   design, serves live students, and holds the real data (10 verified subjects,
   306 topic point briefs). Dev is converged toward Prod, never the reverse.
2. **Ledger audit completed** — the object diff above replaces the ledger as
   the source of truth about what each database actually contains.
3. **Taxonomy layer restored in Dev** — `taxonomy_source_versions`,
   `taxonomy_units` and `taxonomy_topics` created with Production's DDL,
   constraints, RLS (enabled, no policies, so the raw tables stay private) and
   grants, via migration `task0027_restore_taxonomy_layer_from_production`.
   Populated from Production: 10 source versions, 72 units.

   Verified in Dev afterwards:
   - `public.get_student_taxonomy(null)` returns **10 subjects** (was `42P01`).
   - `public.get_student_progress_dashboard('ap_statistics')` returns
     `state: "ready"` with **5 units** (was `42P01`).

4. **AP Statistics taxonomy topics seeded in both environments** —
   `20260821090000_ap_statistics_taxonomy_topics_seed.sql`, 55 topics
   transcribed from the CED "Course at a Glance" (printed pp. 15-17):
   13 / 12 / 15 / 10 / 5 across Units 1-5. The migration asserts a final count
   of exactly 55 and fails otherwise. Verified in Production and Development.

   AP Statistics had units but zero topics; the units were seeded 2026-08-04
   and the topics never were.

   **Scope of the effect, corrected:** this seed fills a genuine gap in the
   verified CED reference map, but it changes nothing a student sees today.
   AP Statistics' 40 published briefs and 40 explainers were already being
   served through `get_topic_point_guides`, which does not read
   `taxonomy_topics`. An earlier note claiming the seed "turned on" previously
   unreachable content was wrong.

## Not Executed, and Why

- **The five 0-row `taxonomy_scheme*` / `taxonomy_node*` / `taxonomy_crosswalks`
  tables were NOT dropped.** They are empty and in no repo migration, but
  dropping is irreversible and they may be the intended design for a
  taxonomy-versioning effort. Requires an explicit Product Owner decision.
- **The remaining 46 objects missing from Dev were NOT created.** Gold sets,
  Stripe checkout, the publish gate and MCQ sync carry data-model and
  governance implications; recreating them wholesale without deciding whether
  Dev should mirror Production's content pipeline would be guessing.
- **No Dev-only object was removed.** 65 objects representing real prior work.
- **Development's taxonomy gap is CLOSED (2026-08-21).** Development now holds
  all 607 taxonomy topics across all ten subjects, matching Production exactly.

  Closed in two steps: Biology's 60 were seeded from the repository's own block
  in `20260804170000_taxonomy_label_layer.sql`; then
  `app.seed_taxonomy_topics` (one of the 46 Production-only objects) was created
  in Development from `20260804203000_extend_math_taxonomy_registries.sql`, and
  the 240 Calculus AB / BC / Precalculus topics were loaded.

  **Verified by hash, per subject and in total:**

  | | Topics | Hash (Dev == Prod) |
  | --- | --- | --- |
  | ap_biology | 60 | `373823b5e4e432c8` |
  | ap_calculus_ab | 85 | `8e9d834dbf96cf39` |
  | ap_calculus_bc | 111 | `25471db0e98bbc9a` |
  | ap_chemistry | 91 | `fb1a27721be67349` |
  | ap_physics_1 | 43 | `00ead9a6282f3992` |
  | ap_physics_2 | 46 | `b26d9d6db6b1c039` |
  | ap_physics_c_em | 31 | `266cda11cb72b1e1` |
  | ap_physics_c_mechanics | 41 | `10e49197d1bcee3d` |
  | ap_precalculus | 44 | `0afb3dc26e10e8a6` |
  | ap_statistics | 55 | `f588b12887966812` |
  | **TOTAL** | **607** | **`0ddc76de97168eaf`** |

  Post-checks in Development: `get_student_taxonomy` returns 10 subjects and 10
  units for Calculus BC; per-unit alignment and topic-code/unit-number
  consistency both pass.

  Development is therefore now at **full taxonomy parity** with Production, and
  holds 45 of the 46 previously Production-only objects' worth of taxonomy
  capability (`seed_taxonomy_topics` was the one adopted; the other 45 remain
  open under P1-P4 of the Codex query).

### CORRECTION (2026-08-21): the "300 topics have no repo migration" finding was wrong

An earlier version of this task recorded that the 300 Biology / Calculus /
Precalculus taxonomy topics existed in Production with **no repository
migration**, and that Production could not be rebuilt from the repo. **That was
false.** Codex flagged it and was right. The seeds are in the repo:

- Biology — `20260804170000_taxonomy_label_layer.sql:379`
- Calculus AB/BC, Precalculus — `20260804203000_extend_math_taxonomy_registries.sql:71,73,75`

**Root cause of the error:** both files were judged by `wc -l` taken from a
`head`-truncated grep. `extend_math_taxonomy_registries.sql` is 80 *lines* but
**39,454 bytes** — line 71 alone is 13,304 characters of jsonb. Line count was
a meaningless proxy for content, and the cited lines were never opened. This is
the same failure mode as the earlier `get_student_taxonomy` error: concluding
from a partial view instead of reading the thing.

**Row-level verification then performed** (hash of `topic_code:topic_title`
ordered by `unit_number, topic_code, topic_title`, repo-parsed vs Production):

| Subject | Result |
| --- | --- |
| AP Biology (60) | identical — `373823b5e4e432c8` |
| AP Calculus AB (85) | identical — `8e9d834dbf96cf39` |
| AP Precalculus (44) | identical — `0afb3dc26e10e8a6` |
| AP Calculus BC (111) | **one row differed** |

Calculus BC `10.7`: the repo carried `Alternating Series Test for Convergence`,
Production carried the truncated `Alternating Series Test`. The CED (*AP
Calculus AB and BC CED*, Course at a Glance, printed p. 21) confirms the full
title, so the **repository was correct and Production was wrong**. Production
was corrected on 2026-08-21; Calculus BC now hashes `25471db0e98bbc9a` on both
sides.

**All 300 topics now match between the repository and Production.** The
repository does reproduce Production. There is no reproducibility gap.

## Open Content Gap (separate from convergence)

`app.taxonomy_topics` is still empty for **five subjects in both
environments** — AP Chemistry (9 units) and all four AP Physics subjects
(28 units between them). Those courses have a verified unit map and no topic
map at all.

**Closed 2026-08-21.** All five were seeded from primary sources:
AP Chemistry 91 (from the CED fact pack's verified topic map), AP Physics 1 43,
AP Physics C: Mechanics 41, AP Physics 2 46, AP Physics C: E&M 31 (all read
directly from each CED's "Course at a Glance", PDF pp. 20-22). Applied to both
projects; repo-file content hashes match deployed Production exactly for all
four Physics subjects.

Validation: across all ten subjects there are now **zero orphan briefs and zero
orphan explainers** — every one of the 306 published topic point briefs and 306
published explainers matches a taxonomy `topic_code`. Since those were authored
independently of this transcription, a mistyped code would have surfaced.

Note on numbering: AP Physics 2 units are numbered 9-15 and AP Physics C: E&M
8-13 **by the College Board itself**, continuing from AP Physics 1's 1-8. That
is CED numbering, not a Cramapple renumbering — an earlier assumption that an
offset had to be applied was wrong.

**The original concern was also overstated:** Their published briefs and
explainers are served today by `get_topic_point_guides` independently of the
taxonomy tables — AP Chemistry alone has 26 published briefs and 26 explainers
covering Units 1-3 (1.1-1.8, 2.1-2.7, 3.1-3.11), all currently served. The gap
is in the reference map only, and is worth closing for correctness rather than
to unblock anything.

Current topic coverage, Production:

| Subject | Units | Topics |
| --- | --- | --- |
| ap_calculus_bc | 10 | 111 |
| ap_calculus_ab | 8 | 85 |
| ap_biology | 8 | 60 |
| **ap_statistics** | 5 | **55 (seeded 2026-08-21)** |
| ap_precalculus | 4 | 44 |
| ap_chemistry | 9 | **0** |
| ap_physics_1 | 8 | **0** |
| ap_physics_2 | 7 | **0** |
| ap_physics_c_mechanics | 7 | **0** |
| ap_physics_c_em | 6 | **0** |

## Dev-only objects: origin established, 2026-08-21

Codex was asked a narrow factual origin question
(`prompts/CODEX_DEV_ONLY_SCHEMA_ORIGIN_2026_08_21.md`) and answered. **Every
checkable claim was independently verified.**

### Codex's answer

The objects are **TASK-0017, the five-subject subject-onboarding harness**,
built roughly 13-18 July 2026. Clusters:

| Cluster | Purpose |
| --- | --- |
| `execution_approvals`, `governance_role_assignments` | Dev-only approval to apply generated subject packages, with actor/role/package-hash checks |
| `reviewer_capability_*`, `eligibility_evaluations`, `qualification_evidence_records` | reviewer qualifications and review-scope eligibility |
| `item_archetypes`, `item_package_applications`, `subject_package_applications`, `apply_*_package_atomic` | atomic application of generated content packages with provenance |
| `verifier_plugins`, `deterministic_check_types`, `validation_suite_types`, `platform_capabilities` | validation capabilities a package requires vs. what the platform supports |
| `taxonomy_schemes`, `taxonomy_node_*`, `taxonomy_crosswalks` | an **earlier** versioned taxonomy model, scoped to exam pack versions |

Intended at the time as a possible governed content-ingestion path, but Dev-only
in practice and never adopted into the Production lineage. Not live work. No
known Production dependency. The taxonomy model was an earlier alternative,
**never approved to replace** the live Production model. The repo record was
stranded during branch consolidation.

### Verification performed

| Claim | Result |
| --- | --- |
| Tag `archive/codex-five-subject-20260727` exists | **Verified — present locally AND on `origin`**, so the record is durable, not machine-local |
| The six cited files exist in that tag | **Verified** — all six, 106KB of SQL across the four migrations plus the design doc and prompt |
| Those migrations create the Dev-only objects | **Verified** — 18 of 18 sampled Dev-only objects are created there |
| No Production dependency | **Verified** — 0 Production functions reference any harness or `taxonomy_schemes` object |
| Repo record stranded | **Verified** — `docs/tasks/TASK-0017-SUBJECT-ONBOARDING-HARNESS.md` exists in the tag but **not on mainline**; its archived status reads "Repository Build Complete — Ready for Dev Hard-Gate" |

### Revised recommendation: dropping is now safe

The earlier recommendation in this task was **document and defer**, and the
stated reason was that the origin was unknown. **That condition no longer
holds.** All four preconditions for a safe drop are now met:

1. **The design record is durable** — tag on `origin`, containing the
   migrations, the physical-design doc, the authoring prompt and the task
   record.
2. **There is no operational data** — 36 of 39 tables empty; the other three
   hold only seeded lookups (15 / 9 / 6 rows).
3. **The author confirms it is not live**, was never adopted, and has no
   Production dependency — independently confirmed against Production.
4. **The drop is reversible.** The four migrations are recoverable from the tag
   and could be re-applied to Dev if the harness is ever revived.

Dropping removes 65 phantom objects that will otherwise distort every future
drift audit and keep Dev from being a meaningful pre-production mirror.

**Still requires explicit Product Owner approval before execution** — it is
destructive, and the approval gate below is unchanged.

### Executed 2026-08-21 — approved and complete

Migration `20260821120000_task0027_drop_task0017_harness_dev_only.sql`, applied
to **Development only**. Every statement is `IF EXISTS`, so it is a safe no-op
against Production.

Removed: 39 tables, 25 functions (all overloads), 1 view
(`app.validation_suite_versions`), plus **three harness-era FK columns on
retained tables** — `content_item_versions.archetype_version_id`,
`validation_suites.suite_type_key` and
`exam_pack_manifests.content_clearance_exception_id`. None of the three exist
in Production and all were 100% NULL in Development, so dropping them converged
the schemas and lost nothing.

The safety analysis was load-bearing. It found three foreign keys pointing from
**retained** tables into harness tables, which a naive `DROP ... CASCADE` would
have stripped silently. The migration asserts its preconditions before touching
anything: zero operational harness rows, and no retained row using any harness
FK column.

The first attempt **failed and rolled back cleanly** — the column drops were
ordered before the view and functions, and a trigger
(`validation_suites_assign_type`) depended on `suite_type_key`. Nothing was
partially applied. Reordered to view → functions (CASCADE removes the trigger)
→ columns → tables, and re-applied successfully.

Result:

| | Before | After |
| --- | --- | --- |
| Development objects | 233 | **168** |
| Dev-only objects | 65 | **0** |
| Production objects | 214 | 214 |

**Development is now a strict subset of Production.** The remaining divergence
is one-directional — 46 objects Production has that Development lacks — which
is tractable rather than a two-way fork.

Verified intact after the drop: `get_student_taxonomy` returns 10 subjects,
`get_student_progress_dashboard` returns `ready`, 307 taxonomy topics unchanged,
all `content_item_versions` rows unchanged, and only the 3 canonical taxonomy
tables remain (the 5 alternative-model tables are gone).

Restore path, recorded in the migration header: re-apply the four harness
migrations from `archive/codex-five-subject-20260727`.

### Separate gap this surfaced

**TASK-0017 had no record on mainline** — the repository silently skipped from
TASK-0016 to TASK-0018. **Closed 2026-08-21:** the archived record was restored
to `docs/tasks/TASK-0017-SUBJECT-ONBOARDING-HARNESS.md` from the tag, with a
banner recording that it was never adopted into Production, that its Dev
objects were dropped under this task, and that the implementation is preserved
in the tag. Approved by the Product Owner.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard gate before any destructive step (dropping Dev-only
objects) or before declaring Dev a valid QA environment for content-pipeline
work.
**Decision:** Pending

## Done Decision

**Decision:** Pending
**Date:** Pending
