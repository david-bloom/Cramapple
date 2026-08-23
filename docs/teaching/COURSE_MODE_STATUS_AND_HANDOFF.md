# Course Mode — Status & Handoff

STATUS: living handoff | DATE: 2026-08-23 | AUDIENCE: LLM-first entry point for NEW sessions.
Read this first. It says what exists, what is live where, and what the next two workstreams are (front-end/UX experience, and seed content). Governing detail lives in the two companion docs (below); this doc is the map.

## 0. Companion docs (read in this order)
1. `docs/teaching/COURSE_MODE_LEARNING_MODEL.md` — decisions (`CM-Dxx`), invariants (`INV-1..6`), the mastery model, current-state facts. The source of truth for WHAT and WHY.
2. `docs/teaching/COURSE_MODE_PILOT_BUILD_PLAN.md` — the Stats pilot plan (F1 / Track A / Track B / F4), acceptance, risks, decisions.
3. This doc — current status + handoff.
Prior/underlying: `LEARNING_SYSTEM.md`, `LEARNING_SYSTEM_STUCK.md`, `TEACHING_AND_PEDAGOGY_DESIGN.md` (cram-era learning loop, grading, data posture).

## 1. One-paragraph orientation
Cramapple is shifting from a 10-day AP cram tool to a year-long "efficient learn" companion for time-scarce, points-driven students (one engine, cram = its compressed final phase). The mastery unit is the **cell = (topic × skill)**, practice is a roll-up. The pilot subject is **AP Statistics**, and the strategy is **supply-engine first** (generate validated practice content) because per-cell item inventory is the binding constraint. The student EXPERIENCE and the servable content pipeline are the NEXT work — that's what new sessions pick up.

## 2. What is DONE and verified (2026-08-23)
All on branch `course-mode/stats-generator-pilot`.
- **F1 — skill taxonomy + cell registry**: `app.taxonomy_skills` (18) + `app.taxonomy_cells` (131 = topic × skill, from CED fact-pack §3) **applied + verified in Dev**, RLS-enabled, keyed to ap_statistics `taxonomy_source_version dae3c72e-82ca-4960-9552-1b034bd347e5`. Migration: `supabase/migrations/20260823115605_...`.
- **Track A — computational generator** (`scripts/course_mode_stats_generator/`): 5 stdlib-exact procedures (one-prop CI 3.3×3.E, two-prop z-test 3.13×3.E, LSRL predict 5.3×3.B, normal prob 2.11×3.C, summary stats 1.7×3.B). Gated emission, misconception-tagged distinct distractors, deterministic checks. **Fable QA: PASS (GO)** after fixes. 400 instances / 3,040 invariant checks + 5 meta-props pass.
- **Track B — one 4.B slot-frame** (cell 1.9×4.B, observational-only): validated across all slot combinations; yields an authoring-cost estimate (~1 frame family per Practice-4 skill).
- **Schema convergence of the 4 pilot tables**: `content_item_versions`, `grading_results`, `exam_pack_versions`, `content_taxonomy_labels` are now **column-identical Dev↔Prod** (verified by matching colhashes). Includes Prod adopting the item-package columns (`item_package_{schema_version,payload,sha256}`, `exam_pack_semver`) and Dev gaining the labels cluster + grading columns. Migrations `...120000/120100/120200`.

## 3. What is NOT built (the next work)
- **The student EXPERIENCE / front-end.** Not designed or built. See `COURSE_MODE_LEARNING_MODEL.md` §10 (deferred): per-cell micro-experience flavored by trigger `reason` (maintenance / consolidation / reopened-miss / confirm); the "your 20 minutes" session assembly; the fortress/progress surface. NOTE: the frontend is a **separate Lovable repo** (see memory `project_frontend_repo_and_deploy_topology`), deployed via Lovable publish — UX work happens there against the backend contract, not in this repo.
- **The learner-state runtime (cell store + triggers).** F2/F3 (cell mastery store `student_cell_state`, deterministic evidence-weight classifier + Phase-1 tier/trigger rule engine) are SPEC'd in the plan but NOT built. Phase-1 triggers only (decay + direct-miss + provisional-confirm + new-exposure); graph triggers deferred.
- **F4 — generated-instance → servable content path.** NOT built. Needs: persist per-instance deterministic checks (new `content_item_checks` table, NOT the deprecated `frq_criteria`), a generic data-driven `evaluator_strategy`, an item→cell tag (new `content_taxonomy_labels` scope `cell` OR `content_item_cells`), and the CM-D19 template-release machine-stamping. GOOD NEWS: `content_item_versions.item_package_payload` (jsonb) now exists in BOTH envs — the intended home for generated item packages.
- **Seed content at scale.** The generator produces validated items but they are `release_status: unreleased_generated_pending_review` and NOT served. Turning them into seed content needs F4 + the release/review flow.
- **t / χ² computational procedures.** scipy dependency is APPROVED (env was stdlib-only). Not yet built; would extend Track A to the inference-heavy computational cells.

## 4. Open decisions (carry forward)
- **D8 — release bars** (validation sample sizes / gold-regression thresholds before a template is "released"): **ON HOLD — David is still thinking.** Do not set defaults or build the release gate until he decides.
- **F4 item→cell tag home**: proposed new `content_taxonomy_labels` scope `cell` vs a `content_item_cells` table — confirm at build.
- **Phase-2 graph triggers** (prereq / thread-sibling) + the CED principle graph: DEFERRED.
- **Extending beyond Stats / science item→topic backfill**: DEFERRED.

## 5. Settled decisions to respect (do not relitigate)
- Mastery unit = cell (topic × skill); practice = roll-up (CM-D05). Store fine, present coarse (INV-1: never show letter codes to students).
- No general LLM item generation (INV-3): content ships only if its correctness is independently checkable (computation: recompute; conceptual: authored slot-frames/keys).
- Threading resurfaces, never pools evidence (INV-2). Determinism for state transitions (INV-4). Supported success is provisional (INV-5). A miss reopens, never zeroes (INV-6).
- Template-level release (CM-D19) APPROVED with a sampled spot-audit; David is SME reviewer of record (D2) and consciously amended the fact-pack "SME-before-bulk-authoring" precondition.
- Negative-value distractors are acceptable (faithful misconception output). scipy is an acceptable authoring dependency.

## 6. Gotchas for any new session
- **Production has zero real students** — all attempts trace to pilot/David's account (`project_production_zero_real_students`). `content_item_versions` had 8 rows in Dev.
- **Subject-key namespace trap**: registry/subjects use hyphens (`ap-statistics`... actually `subjects.subject_key` hyphenated), taxonomy uses underscores (`ap_statistics`). Join by UUID (`subject_id`, `taxonomy_source_version`), never raw text.
- **Dev migration ledger cannot be trusted** (`project_task0027_schema_convergence_status`): verify object existence/counts directly, not via `list_migrations`.
- Broader Dev↔Prod schema drift beyond these 4 tables still exists (the wider TASK-0027 gap) — out of scope for course-mode; don't assume full parity.

## 7. Suggested first moves for the next sessions
- **UX session**: start from `COURSE_MODE_LEARNING_MODEL.md` §10 + §5 (trigger `reason` → experience mapping); design the per-cell loop and the "20 minutes" session assembly; prototype in the Lovable frontend against a defined backend contract. Decide what the student sees for a cell at each tier.
- **Content session**: decide D8 with David; then build F4 (persisted checks + generic verifier + item→cell tag + CM-D19 stamping) so generator output becomes servable; optionally add the scipy-based t/χ² procedures to widen computational coverage; run the generator to seed Stats cells.
