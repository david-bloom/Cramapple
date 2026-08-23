# Course Mode — Status & Handoff

STATUS: living handoff | DATE: 2026-08-23 (updated late session: canonical grounding + F4 core landed) | AUDIENCE: LLM-first entry point for NEW sessions.
Read this first. It says what exists, what is live where, and what the next workstreams are. Governing detail lives in the two companion docs (below); this doc is the map. The dated **Action log (§8)** at the bottom records what each session changed — skim it after this header.

## 0. Companion docs (read in this order)
1. `docs/teaching/COURSE_MODE_LEARNING_MODEL.md` — decisions (`CM-Dxx`), invariants (`INV-1..6`), the mastery model, current-state facts. The source of truth for WHAT and WHY.
2. `docs/teaching/COURSE_MODE_PILOT_BUILD_PLAN.md` — the Stats pilot plan (F1 / Track A / Track B / F4), acceptance, risks, decisions.
3. This doc — current status + handoff.
Prior/underlying: `LEARNING_SYSTEM.md`, `LEARNING_SYSTEM_STUCK.md`, `TEACHING_AND_PEDAGOGY_DESIGN.md` (cram-era learning loop, grading, data posture).

## 1. One-paragraph orientation
Cramapple is shifting from a 10-day AP cram tool to a year-long "efficient learn" companion for time-scarce, points-driven students (one engine, cram = its compressed final phase). The mastery unit is the **cell = (topic × skill)**, practice is a roll-up. The pilot subject is **AP Statistics**, and the strategy is **supply-engine first** (generate validated practice content) because per-cell item inventory is the binding constraint. The supply engine + its canonical grounding + the F4 servable-content path (schema, generic verifier, loader) are now BUILT and merged (§2). The NEXT work is: release + seed the content (D8 + CM-D19 + the Dev exam-pack), the learner-state runtime (F2/F3), and the student EXPERIENCE/front-end (§3, §7).

## 2. What is DONE and verified (2026-08-23)
Everything below is **merged to `main`** (PRs #93 pilot, #94/#95 grounding, #96 F4-core, #97 loader+QA). The generator/catalog code lives in `scripts/course_mode_stats_generator/`.
- **F1 — skill taxonomy + cell registry**: `app.taxonomy_skills` (18) + `app.taxonomy_cells` (131 = topic × skill, from CED fact-pack §3) **applied + verified in Dev**, RLS-enabled, keyed to ap_statistics `taxonomy_source_version dae3c72e-82ca-4960-9552-1b034bd347e5`. Migration: `supabase/migrations/20260823115605_...`.
- **Track A — computational generator**: 5 stdlib-exact procedures (one-prop CI 3.3×3.E, two-prop z-test 3.13×3.E, LSRL predict 5.3×3.B, normal prob 2.11×3.C, summary stats 1.7×3.B). Gated emission, deterministic checks, seeded option-shuffle. **Track B** — one 4.B slot-frame (cell 1.9×4.B, observational-only). Current harness: **400 instances / 5,040 invariant checks + 8 meta-props pass, 0 rejects**; slot-frame 60 / 600.
- **Canonical content grounding (A5 + scenarios)** — the distractor and scenario layers are no longer invented in code, each carries a cited source:
  - `misconceptions.py` — 24-entry catalog; every MCQ distractor cites a source (fact-pack §10 / CED / trusted study guides Albert·Fiveable·Khan) + evidence tier. Generation FAILS on a non-catalog tag.
  - `scenarios.py` — per-procedure FRQ framing (archetype §5 / task verb §6 / modality §7 / validity rules) + context banks; every emitted item carries `scenario_provenance`. Contexts are original synthetic (rights: DECISION-0031/0033, no CB content).
- **F4 CORE — servable-content path** (merged #96, **applied + proven in Dev**): migration `20260823130000_course_mode_f4_servable_content_path.sql` adds `app.content_item_checks` (persist deterministic_checks), `app.content_item_cells` (item→cell tag, composite-FK'd to `app.taxonomy_cells`), and the `data_driven_deterministic` evaluator_strategy value (RLS service_role-only). Generic verifier `supabase/functions/_shared/deterministic-verifier.ts` grades numeric/interval responses against persisted checks (abstains on unknown/unparseable; INV-4); `grading-router.ts` routes the new strategy to a `data_driven` target. **End-to-end proven in Dev** (2026-08-23): a generated instance's checks persisted, cell tag `3.3×3.E` resolved to a registered cell via the composite FK, stayed `review_status NULL`/`draft`, and the verifier graded the Dev-persisted checks correctly (correct/incorrect/abstain); proof rows deleted afterward.
- **F4 intake/loader** (merged #97): `scripts/course_mode_stats_generator/build_load_sql.py` → `out/f4_load_DRAFT.sql`, a fail-closed transactional load that lands each generated item as an UNRELEASED draft plus its `item_package_payload` + `mcq_choices` + `content_item_checks` + `content_item_cells`.
- **QA**: two Fable QA passes over the extension. Round-1 GO-WITH-CONDITIONS → 4 majors + 2 minors fixed (grading fail-open guard, key-passes-own-check, option shuffle, verifier leading-decimal regex, loader dollar-quote guard). Round-2 re-QA: **GO, no regressions.**
- **Schema convergence of the 4 pilot tables** (prior): `content_item_versions`, `grading_results`, `exam_pack_versions`, `content_taxonomy_labels` column-identical Dev↔Prod. `content_item_versions.item_package_payload` (jsonb) exists in BOTH envs — the home for generated packages.

## 3. What is NOT built (the next work)
- **F4 live-grading wiring (the last F4 piece).** The `data_driven` verifier exists and is proven, but in the live `evaluate-attempt` path such items are currently **safely HELD** (routed to shadow review), not graded — see `evaluate-attempt/index.ts` (the `data_driven` branch in the shadow-review condition). Full wiring = fetch `content_item_checks` → `gradeAgainstChecks` → write `grading_results`/`attempts`. Deliberately deferred: it has ZERO runtime effect until items are released (D8-gated), can't be validated without deploying the shared grader, and needs the serving-form decision (§4) + F2/F3 to be meaningful. Do this at the release milestone (write as a reviewed PR + Fable pass + Dev edge-function deploy).
- **CM-D19 template-release machine-stamping.** NOT built (gated on D8). Until it exists, every generated item stays `review_status NULL` / `unreleased_generated_pending_review` and is never served — which is why F4 core is safe to have live.
- **The learner-state runtime (cell store + triggers).** F2/F3 (cell mastery store `student_cell_state`, deterministic evidence-weight classifier + Phase-1 tier/trigger rule engine) are SPEC'd in the plan but NOT built. Without F2, a graded attempt cannot update cell mastery — F4 core stops at "graded + cell-tagged," not "mastery updated."
- **The student EXPERIENCE / front-end.** Not designed or built (per-cell micro-experience by trigger `reason`; the "your 20 minutes" session assembly; the fortress/progress surface). The frontend is a **separate Lovable repo** (`david-bloom/exam-buddy-wireframe`), deployed via Lovable publish — UX work happens there against the backend contract, not in this repo.
- **Seed content at scale (blocked on a Dev prerequisite).** The loader is ready but Dev has **no ap_statistics `2026-27` exam-pack version** (only `2025-26`), so `build_load_sql.py`'s fail-closed `into strict` resolution aborts. Creating that exam-pack version (with an official exam date) is a governance object — a David/Orly decision, not to be fabricated. Once it exists, run the loader; items land unreleased pending CM-D19.
- **t / χ² computational procedures.** scipy dependency is APPROVED (env was stdlib-only). Not yet built; would extend Track A to the inference-heavy computational cells.

## 4. Open decisions (carry forward)
- **D8 — release bars** (validation sample sizes / gold-regression thresholds before a template is "released"): **ON HOLD — David is still thinking.** Do not set defaults or build the release gate / CM-D19 stamping until he decides. This gate is why nothing is served yet.
- **F4 item→cell tag home**: RESOLVED at build → a dedicated `app.content_item_cells` table (NOT a `content_taxonomy_labels` scope `cell`, whose scope/payload constraints are unit/topic-shaped). Composite FK to `taxonomy_cells`.
- **Serving form of generated computational items** (NEW, needed before live-grading wiring): the items are MCQ *and* carry numeric checks. The loader sets `evaluator_strategy=data_driven_deterministic` (numeric-entry grading via the verifier) with `rubric_type NULL`, but `mcq_choices` are also loaded so they *can* serve as MCQ (`rule_based_mcq`). Decide which form the pilot serves before wiring live grading.
- **ap_statistics 2026-27 exam-pack version in Dev** (NEW): must exist before the loader can run (see §3). David/Orly.
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
- **Content / release session**: decide D8 with David; then (a) create the ap_statistics 2026-27 exam-pack version in Dev, (b) run `build_load_sql.py` → apply `out/f4_load_DRAFT.sql` to Dev to seed cells (unreleased), (c) build CM-D19 template-release stamping, (d) write the F4 live-grading branch (replace the shadow-hold in `evaluate-attempt` with real verifier grading) + Fable pass + Dev edge deploy. Optionally add scipy-based t/χ² procedures.
- **Learner-state session (F2/F3)**: build `student_cell_state` + the deterministic evidence-weight classifier + Phase-1 rule engine so a graded attempt updates cell mastery (the piece that makes F4 grading meaningful). Route cell writes on ATTEMPT/ITEM identity, not session presence (see `COURSE_MODE_LEARNING_MODEL.md` §8).
- **UX session**: start from `COURSE_MODE_LEARNING_MODEL.md` §10 + §5 (trigger `reason` → experience mapping); design the per-cell loop and the "20 minutes" session assembly; prototype in the Lovable frontend (`exam-buddy-wireframe`) against a defined backend contract.

## 8. Action log (newest first)
- **2026-08-23 (late session — grounding + F4 core, all merged to `main`):**
  - `misconceptions.py` canonical distractor catalog (A5) — PR #94 (merged).
  - `scenarios.py` canonical FRQ-framing + `scenario_provenance` on every item — PR #95 (merged; note PR #94's merge raced past this commit, so it was recovered as its own PR).
  - F4 core — `content_item_checks` + `content_item_cells` migration, `deterministic-verifier.ts`, router `data_driven` target, tests — PR #96 (merged).
  - F4 intake/loader (`build_load_sql.py`) + Fable QA remediation (grading fail-open guard, key-passes-own-check + summary_stats tol, option shuffle, verifier leading-decimal regex, loader guards) — PR #97 (merged).
  - Two Fable QA passes: GO-WITH-CONDITIONS → all conditions fixed → re-QA GO, no regressions.
  - **Dev apply**: F4 migration applied + verified in Dev (`wmgjsdkphcyhngaffbqf`); end-to-end servable path proven with a throwaway proof row (checks persist, cell FK resolves, verifier grades correctly), then deleted. Prod (`pcntajvbdfqhbeewmdry`) untouched.
- **2026-08-23 (earlier — pilot):** F1 registry, Track A generator + Track B slot-frame, 4-table schema convergence — PR #93 (merged). (Original Fable QA GO on the generator.)
