# TASK-0017 — Reusable Subject-Onboarding Harness (+ Publication-Trust P0 Repair)

**Task ID:** TASK-0017
**Title:** Build a reusable, parameterized harness for onboarding new subjects and new annual exam-pack versions; repair the publication-trust ordering defect first
**Owner:** Codex (implementation lane: schema, adapters, verifier scaffold, migrations, tests, publication-trust)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Proposed — **design approval required before any Dev migration**
**Priority:** High
**Created Date:** 2026-07-13
**Related:** `DECISION-0037` (this task + its policy calls), `DECISION-0036` (AI-led authoring — the harness's content producer), `DECISION-0034` (per-subject verification profile), `DECISION-0035` (tutor-review waiver), `TASK-0016` (verifier implementation), `TASK-0014`/`TASK-0015` (AP Chem/Physics launches), `TASK-0009` (schema/governance reconciliation), `docs/product/AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md` (first consumer). Originated from `prompts/CODEX_SUBJECT_ONBOARDING_HARNESS_2026_07_13.md` and Codex's 2026-07-13 review.

## Product Goal

Convert the repeated per-subject launch machinery — schema/taxonomy instantiation, ingestion/staging, deterministic verification, reviewer qualification, publication gating — into a reusable, parameterized harness, so a new subject (or a new annual version of an existing subject) is a validated **config-and-content drop**, not a bespoke engineering project. Content authoring is already parallelized by Anthropic models (`DECISION-0036`); the dominant repeat-work bottleneck is now this validation-and-infrastructure layer. The harness makes subjects fast to **stand up**, never fast to **publish** — every content/grading/publication gate stays a hard stop.

## Decisions (David, 2026-07-13)

1. **Sequencing:** fix the publication-trust **P0 first**, then an **H1 vertical slice** (AP Stats Q1–Q4 round-trip), then the rest under design approval.
2. **Gate waivability:** publication eligibility is evidence-derived. A Product Owner may waive **content-clearance only** (tutor/content review — consistent with `DECISION-0035`), with a recorded exception. **Grading/calibration, rights, and security/privacy gates are never waivable.**
3. **AP Chem (TASK-0014) / AP Physics (TASK-0015):** adopt the harness once it's ready; **do not start net-new bespoke scaffolding** for them in the meantime. Not paused, not forced to wait — but no new one-offs to migrate later.
4. **Canonical school-year identifier:** **`2026-27` academic-year form.** Existing `"2026"` / `"2025-26"` values normalize to this convention.

### Adopted from Codex review (defaults, override on request)

- **Canonical question-version record (v1): `content_item_versions.id`** used by serving, review, attempts, grading, and release manifests. `artifact_versions` has 0 rows in Production; do **not** create a second parallel "canonical" record (that decision belongs to `TASK-0009` if ever revisited).
- **Support both operations:** `create-subject` **and** `create-exam-pack-version` (annual revision preserving historical taxonomy, labels, content, attempts, calibration evidence).
- People/reviewer identities stay **out** of reusable subject configs; capability preflight required; declarative check registry + reviewed verifier plugins (config never executes arbitrary code); machine-readable calibration status; golden fixtures for AP Biology + current AP Statistics.

## P0 — Publication-Trust Repair (do first; blocks building on the publish path)

**Confirmed defect** in `supabase/functions/admin-content/index.ts`, `changeArtifactState`:

- Line ~615–628 inserts the `artifact_state_events` row with `new_state: 'published'`.
- Line ~638–660 updates `content_items.status` and the latest `content_item_versions.status` to `'published'` and stamps `published_at` — **the exact tables `evaluate-attempt` gates serving/grading on**.
- Line ~663–668 *only then* requires the release manifest; line ~707–714 *only then* runs `enforceGatePolicy`.

These are separate service-role calls, not one transaction. A request that fails `missing_release_manifest` or a gate has **already flipped content live**, with no rollback. Repair:

1. Resolve authoritative evidence and **compute eligibility server-side** (not from client-supplied gate values — see the existing `content_gate` "client-asserted-but-unverified" comment).
2. Perform state change, serving projection, release records, manifest creation, and the publication event **atomically**; roll everything back if any check fails.
3. Prove the **exact reviewed version is the exact version activated**.
4. Add a regression test that a failing-gate publish leaves content **un**published.

## Scope (H0–H5)

- **H0 — Subject Package Contract.** One versioned `SubjectPackage` schema = the Claude↔Codex interface. Includes: subject identity/display; exam code + `2026-27` school-year convention; official exam date + source metadata; taxonomy scheme + version; units/topics/LOs/practices/skills; official weights + blueprint; question archetypes + point structures; supported response modalities; required platform capabilities; content inventory targets; verifier-requirements manifest; reviewer-qualification *policy* requirements (not people); content/grading/release-gate policies; prompt/fact-pack versions + provenance; supersession/retirement behavior. Claude supplies the package; it never supplies executable verifier code or migration SQL.
- **H1 — Versioned item-package schema.** Replace Biology-era enums (`frq_form in ('short','long')`; the fixed `short_frq_prompt_target`/`long_frq_prompt_target` columns in `question_coverage_targets`) with a small normalized item envelope + `package_schema_id`/`package_schema_version` and a validated structured payload (parts, sub-parts, criteria, assets, modalities, archetypes). Archetypes are **versioned data, not DB enums**; `frq_form` derived only for legacy consumers. Prove AP Stats Q1–Q4 round-trips. **Vertical slice first, no DB staging.**
- **H2 — Exam-pack/taxonomy compiler.** Real taxonomy versioning: today `app.content_labels` is `exam_pack_id`-scoped with `(exam_pack_id, label_key)` uniqueness — it cannot hold both the 2026 nine-unit and the 2026-27 five-unit AP Stats taxonomies. Introduce a versioned taxonomy scheme (e.g. `taxonomy_schemes` / `_versions` / `_nodes` / `exam_pack_version_taxonomies` / `content_version_taxonomy_assignments`) or, at minimum, label versioning bound to `exam_pack_version_id`. Support new-subject **and** annual-revision; test both.
- **H3 — Verifier registry.** Two layers: a **declarative check registry** (numeric targets, tolerances, intervals, categorical equality, formula equivalence, required units, ordered values, dependency/ECF) and **reviewed verifier plugins** (novel spatial/diagrammatic/chemical-notation/symbolic). Claude supplies requirements + canonical test cases; Codex maps to existing check types or writes a reviewed plugin. Config never executes arbitrary code. Prove existing AP Stats behavior unchanged + one new declarative check type.
- **H4 — Qualification policy & provisioning.** Fix: `reviewer-invite` random `qualification_policy_version_id` + ~100-year expiry; the `review-queue` fail-open vs `assign-for-review` strict inconsistency. Establish versioned qualification policies, required evidence/credential fields, subject/school-year/artifact-type/environment scope, effective/expiration rules, suspension/revocation, **fail-closed** queue filtering, idempotent grants (no delete-recreate gap). Subject *requirements* live in the package; actual people + grants are environment-specific ops.
- **H5 — End-to-end eligibility proof.** Compute and **explain** every blocking/non-blocking gate from authoritative records — not just `ineligible` but "Q3 criterion c7 lacks two adjudicated negative boundary cases." Honors the waivability policy above (content-clearance waivable with recorded exception; grading/rights/security never).
- **Capability preflight.** Compare package-declared requirements (typed multipart, math/chemical notation, graph construction, image upload, diagram annotation, symbolic equivalence, units/sig-figs, spatial grading, calculator assumptions) against a versioned platform-capability registry; fail with `unsupported_capability: <cap>`. Never "onboard" a subject the product can't render or grade.
- **Calibration interface.** Even with gold-set tooling out of scope, the harness emits machine-readable calibration requirements + status (`grading_clearance: blocked` with reasons), never stopping at "verifier scaffold installed."

## Operating Interface

Version-controlled CLI with plan/apply separation:

```
subject-harness validate  subject-package.json
subject-harness plan      subject-package.json --environment dev
subject-harness apply     subject-package.json --environment dev
subject-harness verify    ap-statistics --school-year 2026-27
subject-harness evidence  ap-statistics --school-year 2026-27
```

Protections: never infer target from the currently linked Supabase project; require an explicit project reference; refuse Production unless a distinct production flag **and** a recorded approval ID are supplied; all data changes transactional + idempotent; emit human-readable plan + machine-readable JSON; record input hashes, tool version, applied operations, evidence, rollback instructions. **Schema changes remain ordinary reviewed migrations; subject instances are declarative data applied transactionally — not a new migration per subject.**

## Delivery Sequence (Hard-Gate)

1. **TASK-0017 design:** subject-package contract, canonical-record decision, taxonomy versioning, capability model, security review → Product Owner design approval.
2. **P0 publication repair:** server-resolved gates + atomic publication.
3. **H1 minimal vertical slice:** versioned item-package schema + AP Stats Q1–Q4 round-trip, no DB staging first.
4. **Dev persistence:** approved migration + transactional adapter.
5. **H2 compiler:** test a new subject **and** an annual revision.
6. **H3 verifier registry:** AP Stats unchanged + one new declarative check type.
7. **H4 qualification policy:** remove fail-open + placeholder policies.
8. **H5 eligibility:** compute/explain every gate from authoritative records.
9. **Full harness proof:** stable fixture or transaction rollback (not informal create/delete).
10. **Production proposal:** separate Hard-Gate review with migration, rollback, evidence packet.

**Test matrix:** AP Statistics 2027 = the annual-revision mode; AP Chemistry = the new-subject mode. Passing both proves the two real onboarding modes. Golden fixtures for AP Biology + current AP Statistics must reproduce byte-for-byte or explain the migration.

## Out of Scope (separate)

- **Content authoring** — Claude/Anthropic models (`DECISION-0036`).
- **Gold-set adjudication / calibration throughput tooling** — a later, separate Codex task; calibration itself stays Claude + Learning Quality. The harness only *emits* calibration status.
- **Frontend implementation** — the harness *reports* missing UI capabilities and generates a Lovable handoff/work-order; it does not auto-build frontend.

## Approval Gate

Product Owner design approval required before any Dev migration. Dev migrations separately approved. Production is a distinct Hard-Gate review (migration + rollback + evidence packet). No harness component may publish content or bypass the content/grading gates.
