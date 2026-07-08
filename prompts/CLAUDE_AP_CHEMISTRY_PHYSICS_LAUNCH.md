# Claude Execution Prompt - AP Chemistry and AP Physics 1 Launch Support

**Draft only.** Use this prompt to create the subject-specific content and data
needed to bring AP Chemistry and AP Physics 1 into Cramapple in a governed
way.

## Context

Cramapple already has an approved multi-subject architecture and a launch
pattern established by AP Statistics. The Codex role will handle platform
adaptation for Chemistry and Physics, including taxonomy, verification
profiles, grading tests, and production-readiness work.

Your job is to own the subject-content and subject-data side:

- analyze what Chemistry and AP Physics 1 content the platform needs;
- create the relevant governed content batches;
- prepare the Supabase subject/exam-pack/taxonomy data needed for those
  subjects;
- keep the Lovable-facing subject experience current with the new subject
  state; and
- produce clear handoff evidence for Codex and David.

## Goals

1. Build the AP Chemistry and AP Physics 1 content packages needed for pilot
   use.
2. Populate the subject data required for those subjects in Supabase, using the
   repo's approved schema and governance conventions.
3. Keep the Lovable subject surfaces aligned with the current subject state so
   Chemistry and Physics are represented consistently.
4. Produce enough evidence for Codex to finish the platform-adaptation work and
   for David to review launch readiness.

## Required Inputs

- `docs/tasks/TASK-0014-AP-CHEMISTRY-LAUNCH.md`
- `docs/tasks/TASK-0015-AP-PHYSICS-LAUNCH.md`
- `docs/product/AP_CHEMISTRY_CONTENT_NEEDS_ANALYSIS.md`
- `docs/product/AP_PHYSICS_CONTENT_NEEDS_ANALYSIS.md`
- `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
- `docs/product/CRAMAPPLE_VISION.md`
- `docs/research/AP_CHEMISTRY_TAXONOMY.json`
- `docs/research/AP_PHYSICS_1_TAXONOMY.json`
- `docs/research/AP_CHEMISTRY_VERIFICATION_PROFILE.json`
- `docs/research/AP_PHYSICS_1_VERIFICATION_PROFILE.json`
- `docs/research/AP_CHEMISTRY_PHYSICS_GRADING_TEST_MATRIX.md`
- Existing AP Biology and AP Statistics content/patterns in the repo

## What To Do

### 1. Analyze the subject content needs

For each of AP Chemistry and AP Physics 1:

- identify the subject taxonomy needed for a pilot launch;
- identify the likely verification and scoring needs at the content level;
- identify which item types are needed first;
- identify any reusable platform assumptions that the subject content will
  stress;
- document the first pilot batch shape and any gaps that should be handled by
  Codex.

### 2. Create the governed content

For each subject:

- create a pilot content batch suitable for QA and calibration;
- keep the content original and aligned with the repo's rights/governance
  rules;
- avoid official College Board text, scoring material, or derived wording;
- produce content in the repo's established structured formats;
- include any subject-specific notes needed for taxonomy, rubric, and scoring
  handoff.

### 3. Populate Supabase appropriately

Prepare the additive data needed for the subjects, consistent with the repo's
existing schema and release workflow:

- subject rows;
- versioned exam-pack records;
- taxonomy scheme records or equivalent taxonomy scaffolding already used by
  the repo;
- any content records or seed payloads needed to support the pilot batch;
- any supporting mappings or metadata required by the existing flow.

If a required write would change production state, record the exact change set
and call out any approval dependency before proceeding.

### 4. Keep Lovable current

Update the Lovable-facing subject state so the frontend stays aligned with the
actual subject readiness:

- subject labels and availability state;
- subject ordering or selector notes if needed;
- any prompt amendments Lovable needs to reflect the new subject state;
- any copy or route notes needed for Chemistry and Physics 1.

Do not silently change launch policy or availability rules. If the current
Lovable state and the repo's approved subject state disagree, report it.

### 5. Produce handoff evidence

At the end, provide:

- the content files created or updated;
- the Supabase rows / seed / migration changes created or required;
- the Lovable prompt or surface updates made;
- any unresolved gaps that Codex must handle;
- any production-readiness blockers that still require David review.

## Output Format

Return a concise implementation report with:

1. What was analyzed.
2. What content was created.
3. What Supabase data was prepared or changed.
4. What Lovable state was updated.
5. What Codex still needs to do.
6. What remains blocked on approval.

## Do Not Do

- Do not change platform grading logic.
- Do not claim production launch is complete.
- Do not use official College Board content as input or exemplar material.
- Do not make unilateral launch decisions.
- Do not skip documenting missing approvals, missing data, or unresolved
  subject-gating questions.

## Success Criteria

- AP Chemistry and AP Physics 1 have governed pilot content ready for review.
- The required subject data is prepared for Supabase.
- Lovable-facing subject state is current.
- Codex can take the remaining platform-adaptation work without reconstructing
  the subject plan from scratch.
