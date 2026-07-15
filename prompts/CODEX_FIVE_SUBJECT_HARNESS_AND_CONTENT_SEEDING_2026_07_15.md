# Codex — Five-Subject Launch Harness + Content Seeding

**Prepared:** 2026-07-15
**Authoritative scope:** This prompt covers subject-onboarding harness instantiation and content seeding for five new subjects. The harness infrastructure (TASK-0017 H1/H2/H3-H5 tables) is already applied to Dev and proven by APPROVAL-0038 QA evidence.
**Related:** `TASK-0014` (Chemistry), `TASK-0015` (Physics), `DECISION-0037`, `APPROVAL-0038`, `docs/qa/TASK0016_0017_DEV_RECONCILE_AND_APPLY_EVIDENCE_2026_07_15.md`

## Goal

Instantiate subject launch harnesses and seed governed content for five subjects so tutor reviews can begin:

| Subject | subject_key | exam_code | Target items |
|---|---|---|---|
| AP Chemistry | `ap-chemistry` | `ap_chemistry` | 20 MCQ + 16 FRQ |
| AP Physics 1 | `ap-physics-1` | `ap_physics_1` | 20 MCQ + 16 FRQ |
| AP Physics 2 | `ap-physics-2` | `ap_physics_2` | 20 MCQ + 16 FRQ |
| AP Physics C: Mechanics | `ap-physics-c-mechanics` | `ap_physics_c_mechanics` | 20 MCQ + 16 FRQ |
| AP Physics C: E&M | `ap-physics-c-em` | `ap_physics_c_em` | 20 MCQ + 16 FRQ |

Total: 180 items across 5 subjects.

## Current state (verified 2026-07-15)

### Dev database (`wmgjsdkphcyhngaffbqf`)
- AP Chemistry: subject row + exam_pack + content_labels exist (migration `202607070005`). Exam pack version school_year has been normalized to `2025-26`. Zero content items.
- AP Physics 1: subject row + exam_pack + content_labels exist (same migration). Zero content items.
- AP Physics 2, Physics C: Mech, Physics C: E&M: **no rows at all**.
- TASK-0017 H1/H2 harness tables (`item_archetypes`, `item_archetype_versions`, `taxonomy_schemes`, `taxonomy_scheme_versions`, `taxonomy_node_versions`, `taxonomy_node_relations`, `content_version_taxonomy_assignments`, `taxonomy_crosswalks`, `exam_pack_manifest_content_versions`, `subject_package_applications`, `item_package_applications`) are all present and proven.
- TASK-0017 H3-H5 validation objects are present (reference tables, publication functions, `app.config`).

### Production database (`pcntajvbdfqhbeewmdry`)
- No Chemistry or Physics rows of any kind. Do NOT touch Production in this task.

## Deliverable sequence

### Phase 1 — Schema: add missing subject rows (migration)

Write a single migration that adds the three missing Physics subjects and their exam packs/versions/labels. Follow the exact pattern of `202607070005_chemistry_physics_schema_instantiation.sql`:

1. **AP Physics 2** — `ap-physics-2`, exam_code `ap_physics_2`, display_name `AP Physics 2: Algebra-Based`, school_year `2025-26`, official_exam_date `2026-05-06`
2. **AP Physics C: Mechanics** — `ap-physics-c-mechanics`, exam_code `ap_physics_c_mechanics`, display_name `AP Physics C: Mechanics`, school_year `2025-26`, official_exam_date `2026-05-12`
3. **AP Physics C: E&M** — `ap-physics-c-em`, exam_code `ap_physics_c_em`, display_name `AP Physics C: Electricity and Magnetism`, school_year `2025-26`, official_exam_date `2026-05-12`

Use the academic-year form for `school_year` per DECISION-0037 (exam in May 2026 → `2025-26`).

Content labels for each — use the taxonomy from the CED fact packs that Claude will supply in `docs/product/`:
- `AP_CHEMISTRY_CED_FACT_PACK.md` (already existing for Chemistry)
- `AP_PHYSICS_1_CED_FACT_PACK.md`
- `AP_PHYSICS_2_CED_FACT_PACK.md`
- `AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md`
- `AP_PHYSICS_C_EM_CED_FACT_PACK.md`

Also update the existing Chemistry and Physics 1 content_labels from placeholder names (`AP Chemistry Unit 1`, etc.) to real CED unit names from the fact packs.

### Phase 2 — Subject packages: apply harness per subject

For each of the 5 subjects, Claude will supply a `subject-package.json` file under `content/subject-packages/`. Each conforms to `schemas/subject-onboarding/subject-package.schema.json`.

For each subject package:

1. Validate the package against the JSON schema.
2. Insert/upsert the taxonomy scheme, taxonomy nodes, and taxonomy node relations into the H2 tables.
3. Insert/upsert the item archetypes and archetype versions into the H1 tables.
4. Record the application in `app.subject_package_applications` with `environment='dev'`.
5. Verify the round-trip: query back the inserted rows and confirm counts match the package.

Use `service_role` for all inserts. Use the Dev session pooler (`CRAMAPPLE_DEV_DB_URL`).

### Phase 3 — Content seeding: apply item packages

Claude will supply item package JSON files under `content/item-packages/{subject_key}/`. Each conforms to `schemas/subject-onboarding/item-package.schema.json`.

For each item package:

1. Validate against the JSON schema.
2. Create the `content_item` row (status `draft`, `item_type` from package, `content_key` from package).
3. Create the `content_item_version` row with:
   - `item_package_schema_version` = `1.0.0`
   - `item_package_payload` = the full package JSON
   - `item_package_sha256` = SHA-256 of the canonical JSON
   - `archetype_version_id` = look up from the archetype inserted in Phase 2
   - `status` = `draft`
   - For MCQ: `canonical_answer_1` = the correct choice key (e.g. `"C"`)
   - For FRQ: `canonical_answer_1` = a short canonical answer string; `canonical_answer_2` = null unless multi-part
4. Create `content_version_taxonomy_assignments` linking the version to its taxonomy nodes.
5. Record in `app.item_package_applications`.

### Phase 4 — Tutor review batch setup

For each subject, create a B1 review batch:
- 10 MCQ + 10 FRQ per subject (or all items if fewer than 10 of a type)
- Assign to the review queue via the existing `review-queue` edge function pattern
- Do NOT assign to specific tutors — new tutors are being hired; leave the assignments unassigned/pooled

### Phase 5 — Verification

For each subject, verify:
1. Content item count matches target (20 MCQ + 16 FRQ).
2. All content_item_versions have non-null `item_package_sha256`.
3. All taxonomy assignments exist.
4. All archetype references resolve.
5. REST probe with Dev anon key returns 401 for the `app` schema (no public exposure).
6. No ERROR-level security advisors.

Write a `verify_five_subjects.sql` script that checks all of the above.

## Hard guardrails

- **Dev only** — every mutation targets `wmgjsdkphcyhngaffbqf` via `CRAMAPPLE_DEV_DB_URL`. No Production mutations. No inferred targets.
- **No auto-publish** — all content stays `status='draft'`. Nothing sets `published`.
- **No official CB content** — all item stems, answer keys, and rubric notes come from Claude's authored packages. Do not copy College Board questions.
- **Backward compatible** — AP Biology and AP Statistics content must be unaffected. Run a pre/post count check.
- **Schema-validated** — every package must pass JSON schema validation before insert.
- **Idempotent** — use `ON CONFLICT` / upsert patterns so the migration can be re-run safely.

## Input dependencies (from Claude)

Before starting each phase, confirm these files exist:

| Phase | Required input | Source |
|---|---|---|
| 1 | CED fact packs (5 files in `docs/product/`) | Claude authors these |
| 2 | Subject packages (5 files in `content/subject-packages/`) | Claude authors these |
| 3 | Item packages (180 files in `content/item-packages/`) | Claude authors these |

If a fact pack or package file is not yet present for a subject, skip that subject and proceed with the others. Pipeline by subject — do not wait for all 5 to start.

## Branch and commit

Work on a branch named `codex/five-subject-harness-and-content`. Commit after each phase completes per subject. Reference TASK-0014 and TASK-0015 in commit messages.

## Report back

After each subject completes Phases 1–5:
1. Content item counts (MCQ, FRQ) and their statuses.
2. Taxonomy node count and archetype count.
3. Any schema validation failures or insert errors.
4. The verification query results.
5. Any decisions or ambiguities that need David's sign-off.
