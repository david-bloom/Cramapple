# TASK-0017 — Reusable Subject-Onboarding Harness (+ Publication-Trust P0 Repair)

**Task ID:** TASK-0017
**Title:** Build a reusable subject-onboarding and annual exam-pack harness; repair publication trust first
**Owner:** Codex (schema, adapters, verifier scaffold, migrations, tests, publication trust)
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Ready for Review
**Priority:** High
**Created Date:** 2026-07-13
**Approved Date:** 2026-07-13 (`DECISION-0039`: H0/H1 + P0 repository/local-verification stage only)
**Related:** `DECISION-0037`, `DECISION-0036`, `DECISION-0034`, `DECISION-0035`, `TASK-0016`, `TASK-0014`, `TASK-0015`, `TASK-0009`, and `docs/product/AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md`

## Product Goal

Convert repeated subject-launch machinery into a reusable, parameterized harness so a new subject or annual exam-pack revision is a validated config-and-content drop rather than a bespoke engineering project. Claude owns curriculum/content production (`DECISION-0036`); Codex owns the implementation, validation, and publication-trust lane. The harness may accelerate setup but may never weaken content, grading, rights, security/privacy, or publication gates.

## Technical Scope

### P0 — Publication-trust repair (implemented and locally verified)

Repair `supabase/functions/admin-content/index.ts` so publication:

1. identifies the exact canonical `content_item_versions.id` reviewed and requested for activation;
2. derives eligibility from stored source, rights, content-review, grading/calibration, security/privacy, and release evidence rather than client-asserted gate strings;
3. changes serving state and writes release-candidate, manifest, legacy artifact-state (when present), and publication-event records in one database transaction; and
4. rolls back every mutation if any gate, identity, manifest, or late write fails.

Repository implementation is approved and both required regressions passed against disposable PostgreSQL 17 on 2026-07-13. Applying the migration to Dev or Production is not approved by this task state.

### H0–H5 — Harness design and later implementation

- **H0 — SubjectPackage contract:** versioned Claude→Codex contract for identity, exam metadata, taxonomy, blueprint, archetypes, modalities, capabilities, inventory, verification, reviewer-policy requirements, gates, provenance, and supersession. Config never contains people, executable verifier code, or migration SQL.
- **H1 — Item-package schema:** normalized, versioned item envelope with structured parts, criteria, assets, modalities, and data-defined archetypes. Prove AP Statistics Q1–Q4 round-trip without DB staging first.
- **H2 — Exam-pack/taxonomy compiler:** support both `create-subject` and `create-exam-pack-version`, preserving historical taxonomy, content, attempts, and calibration evidence.
- **H3 — Verifier registry:** declarative checks plus reviewed plugins; config never executes arbitrary code. Preserve existing AP Statistics behavior and prove one new declarative check type.
- **H4 — Qualification policy/provisioning:** versioned, scoped, expiring, fail-closed, idempotent qualification grants; remove random policy IDs, century-long expiry, and queue inconsistency.
- **H5 — Explainable eligibility:** compute every blocking/non-blocking gate from authoritative records. Only content clearance may be waived by the Product Owner with a recorded exception; grading/calibration, rights, and security/privacy are never waivable.
- **Capability preflight:** fail explicitly when the platform cannot render or grade a declared modality.
- **Calibration interface:** emit machine-readable requirements/status, including blocked reasons.

## Canonical Decisions

- `content_item_versions.id` is the v1 canonical question-version identifier for serving, review, attempts, grading, and release manifests. Do not resurrect `artifact_versions` as a parallel canonical record.
- Canonical exam-pack year is academic-year form (`YYYY-YY`) derived from the official exam date. Legacy `school_year = '2026'` is not blanket-mapped: a May 2026 exam becomes `2025-26`; a May 2027 exam becomes `2026-27`.
- Both annual revision and true new-subject creation are first-class operations.
- Subject packages declare reviewer capabilities/policies, never named people or environment-specific grants.
- `exam_pack_manifests.artifact_version_ids` is formally deprecated for the canonical v1 path. The H0/H1 design must propose a correctly named, typed content-version manifest relation/field and a backward-compatible migration; the legacy column remains only as a temporary P0 carrier.
- Validation-suite categories move from unconstrained text to a typed/versioned registry that includes `security_privacy` as a first-class required gate category.
- H5 introduces a dedicated immutable, typed content-clearance-exception record. It must capture scope, approving Product Owner, rationale, evidence, effective/expiry bounds, and revocation/supersession. It may waive content clearance only—never grading/calibration, rights, or security/privacy.
- **TASK-0017 does not supersede TASK-0009.** TASK-0017 supplies approved v1 consumer constraints and implementation requirements; TASK-0009 retains conceptual schema/governance authority and must ratify and incorporate the manifest, validation-registry, and exception-record designs before physical DDL proceeds.
- AP Biology and AP Statistics content are authorized in principle for the August pilot after human verification, with live monitoring/checking. This release authorization does not manufacture missing evidence records, waive non-waivable grading/calibration or security/privacy gates, or declare P0 verified.
- AP Chemistry remains scaffold-only for the harness test and must not be published.

## Routes / Components / Systems Affected

- `supabase/functions/admin-content/index.ts`
- new reviewed Supabase migrations/RPCs and focused publication regression tests
- content/review/governance tables and exact-version release manifests
- future `subject-harness` CLI, SubjectPackage/item-package schemas, taxonomy compiler, verifier registry, capability registry, qualification provisioning, evidence reporter, and normalized golden fixtures

## Data / Security / Integration Impact

- Publication becomes fail-closed and transactional; the service role alone may execute the publication RPC.
- RPC functions use least privilege, fixed search paths, exact identifiers, and short deterministic transactions.
- No environment target may be inferred from the currently linked Supabase project.
- Dev requires separate migration approval. Production requires a separate approval ID, migration/rollback packet, and Hard-Gate review.
- Existing dirty-worktree changes and unrelated files must be preserved.

## Operating Interface (proposed)

```text
subject-harness validate  subject-package.json
subject-harness plan      subject-package.json --environment dev
subject-harness apply     subject-package.json --environment dev
subject-harness verify    ap-statistics --school-year 2026-27
subject-harness evidence  ap-statistics --school-year 2026-27
```

Plan/apply are separate. Schema changes remain reviewed migrations; subject instances are declarative, transactional, and idempotent data applications. Production requires both an explicit production flag and recorded approval ID.

## Acceptance Criteria

1. A publish request with a missing/failed/mismatched gate leaves the target item/version unpublished and creates no successful release/manifest/publication records.
2. A successful publish activates exactly the reviewed `content_item_versions.id`, never an inferred latest version.
3. AP Statistics 2027 proves annual revision while preserving the prior nine-unit pack.
4. AP Chemistry proves reconciliation/import of its existing bespoke subject/exam-pack/taxonomy scaffold into the canonical harness model; it does not require or authorize Chemistry content publication.
5. A transaction-rolled-back fixture proves true `create-subject` behavior without durable test data.
6. AP Biology and current AP Statistics golden fixtures compare normalized semantic snapshots that exclude generated UUIDs, timestamps, and audit fields; stable hashes cover canonical config and payload content. Any intentional semantic difference has an approved migration explanation.
7. Capability preflight blocks unsupported modalities with an actionable capability code.
8. Qualification and eligibility paths fail closed and emit machine-readable evidence/reasons.
9. No Dev/Production mutation occurs without its required approval state.

## QA Plan

- SQL/integration regression: fail a gate and a late transactional write; assert content status, exact version status, release candidate, manifest, artifact state, and publication event are unchanged.
- Exact-version test: create two versions and prove only the requested reviewed ID becomes published.
- Contract/schema tests for valid/invalid SubjectPackages and item packages.
- AP Statistics Q1–Q4 round-trip before persistence.
- AP Chemistry scaffold-reconciliation fixture plus transaction-rolled-back true-create fixture. Assert that no Chemistry content becomes published.
- Normalized semantic golden comparisons for AP Biology and current AP Statistics.
- Security review of RPC grants, search path, environment targeting, idempotency, and Production approval enforcement.

## Delivery Sequence

1. Implement and review the authorized P0 repository repair; do not apply it to an environment yet.
2. Produce H0/H1 design packet: contracts, canonical mapping, taxonomy versioning, capability model, security review, and migration/rollback proposal.
3. Obtain Product Owner design approval and separate Dev migration approval.
4. Prove H1 AP Statistics Q1–Q4 round-trip, then Dev persistence.
5. Implement H2–H5 in gated slices.
6. Reconcile the AP Chemistry scaffold without publishing Chemistry; run the transaction-rolled-back create-subject fixture.
7. Assemble QA/evidence/handoff packet.
8. Submit a separate Production proposal.

## Out of Scope

- Curriculum/content authoring (Claude/Anthropic lane).
- Gold-set adjudication throughput tooling; the harness only reports calibration requirements/status.
- Frontend implementation; the harness reports capability gaps and emits a Lovable work order.
- Any Dev or Production migration/application in the current approval state.

## Implementation Summary

Repository/local H1–H5 implementation is complete under DECISION-0040 and ready for fresh independent re-QA after two remediation passes. P0 remains atomic/exact-version and delegates only the content-clearance waiver and package calibration requirements to typed H5 resolvers. H1 freezes the full learner-visible canonical payload for package and legacy manifested/published versions. H2 adds integrity-checked multi-scheme taxonomy and fail-closed year reconciliation. H3 validates item-derived renderers/modalities and deterministic parameter contracts at both compiler and database boundaries. H4 adds policy/pack-scoped typed reviewer evidence, revocations, persisted reviewer/team eligibility, minimum-reviewer enforcement, and operational queue enforcement. H5 adds immutable adjudicated calibration evidence, Product-Owner exceptions, hash-attested exact manifest pinning, revocations, and a P0-equivalent machine-readable gate report. Execution approvals bind exact environment/package/package hash/plan hash/actor with revocation and consumption evidence; advisory locks and unique identities protect concurrency. Dev and Production remain untouched.

## Test Results

- `deno check supabase/functions/admin-content/index.ts` — passed 2026-07-13.
- `git diff --check` for the four scoped implementation/documentation files — passed 2026-07-13.
- Added `supabase/tests/task0017_atomic_publication_regression.sql`, including a deliberately late failure after transactional writes and assertions that serving/release state rolls back.
- Added `supabase/tests/task0017_exact_version_publication.sql`: with versions 1, 2, and 3 present, the requested reviewed version 2 publishes, version 1 retires, and the newer unreviewed version 3 remains an untouched draft; the manifest pins version 2.
- PostgreSQL 17 clean-schema run — passed 2026-07-13: P0 fixture + migration + rollback regression + exact-version regression all completed with `ON_ERROR_STOP=1` (`BEGIN / DO / ROLLBACK` for each test).
- The first real PostgreSQL run exposed ambiguous PL/pgSQL `source_id`/`run_id` aliases that static/type checks did not catch. The SQL was corrected with explicit aliases and both regressions then passed from a clean schema.
- Independent SQL/security review tightened evidence integrity: duplicate evidence IDs, unknown/extraneous rights IDs, rights for unlisted sources, expired licenses, overdue rights review, and missing required legal approval now fail closed.
- RPC privilege query returned `anon=false`, `authenticated=false`, `service_role=true` for `EXECUTE`.
- `deno test --allow-read scripts/subject-harness/validate-contracts_test.ts` — passed 2026-07-13 (3 tests): valid AP Statistics SubjectPackage/Q1–Q4 packages, legacy calendar-year rejection, and executable verifier-field rejection.
- Post-DECISION-0039 clean-cluster rerun against PostgreSQL 17.10 — passed 2026-07-13. Both SQL regressions completed with `ON_ERROR_STOP=1`; evidence: `docs/qa/evidence/TASK0017_P0_POST_APPROVAL_SQL_2026_07_13.log`.
- The fixture deliberately installs pgcrypto in `public`; the migration relocates the extension to `extensions` and asserts `extensions.digest(text,text)` exists before compiling the RPC. Explicit query returned `pgcrypto_schema=extensions` and `extensions.digest(text,text)`.
- Exact-version regression now independently reconstructs and matches the canonical manifest hash over the ordered content relation and exact evidence/policy version references.
- `deno test --allow-env supabase/functions/admin-content/publication-request_test.ts` — passed 2026-07-13 (3 tests): complete Edge→RPC request, fail-closed missing evidence categories, and authenticated-admin approval default. Evidence: `docs/qa/evidence/TASK0017_EDGE_RPC_CONTRACT_2026_07_13.log`.
- `deno check supabase/functions/admin-content/index.ts` — passed after Edge→RPC contract extraction.
- `deno test --allow-read scripts/subject-harness/validate-contracts_test.ts scripts/subject-harness/compiler_test.ts` — passed 2026-07-13 (7/7).
- PostgreSQL 17.10 clean-stack run on disposable port 55443 — passed: P0 + H1/H2 + H3–H5 migrations; rollback and exact-version regressions; exact manifest-relation pin; manifest/suite immutability; invalidation fail-closed.
- AP Statistics annual-revision/Q1–Q4 round-trip and Bio/Stats normalized golden snapshots — passed.
- AP Chemistry scaffold reconciliation — passed with zero Chemistry publication.
- Transaction-rolled-back true `create-subject` fixture — passed with no durable rows.
- Canonical-plan tamper rejection; item-derived modality/renderer and parameter-type checks; review-policy conflict; exact approval binding/revocation/consumption; legacy/package canonical immutability; H4 queue/evidence/revocation/team evaluation; H5 calibration, exception hash attestation, reporter fail-closed behavior; concurrent conflict; and idempotent reapply — passed.
- Security/schema audit: `anon_apply=false`, `authenticated_apply=false`, `service_apply=true`, zero new tables without RLS, zero missing FK indexes.
- Evidence: `docs/qa/TASK0017_H1_H5_LOCAL_EVIDENCE_2026_07_13.md`.

## Risks / Issues

- The legacy `artifact_version_ids` array remains as a compatibility carrier. The ordered canonical relation and server-side dual-write are implemented locally, but read cutover/removal remain later separately approved migrations.
- Current evidence must contain target-bound grading/calibration and security/privacy validation runs; absent evidence correctly blocks publication.
- Content-clearance exceptions are implemented locally and exact-scope/Product-Owner/revocation/expiry checked; grading, rights, source, security/privacy, and release approval remain non-waivable.
- Deployment order matters: the RPC migration must precede the updated Edge Function in any approved environment rollout.
- The August Biology/Statistics release remains execution-blocked until the authoritative gate records required by the RPC exist and a Dev/Production execution packet is separately approved. Product Owner release authorization is recorded; it is not itself a substitute for those records.
- P0 is locally verified, not deployed. Real Supabase Dev verification remains part of a separately approved execution step.
- The Edge request contract now requires callers to send `grading_calibration_validation_run_ids` and `security_privacy_validation_run_ids` separately. Any future admin UI/client request builder must adopt this contract before environment rollout; omission fails closed.
- TASK-0009 fast-track slices are ratified and the physical implementation is ready for review. A separate Dev execution approval ID is still required before any Dev migration (not yet issued).

## Approval State

- **Product Owner approval (2026-07-13, `DECISION-0039`):** H0/H1 contracts approved (independently verified green by Claude); P0 repair approved at the **repository + local-verification stage only** — not "done" for any environment until both SQL tests are re-run green in the Dev execution packet; manifest-relation/registry/exception designs endorsed, routed through TASK-0009 M0. **No Dev/Production application authorized.** Required before any environment application: an edge-function↔RPC integration test (caller supplies all evidence IDs) and replacing the interim request-payload `manifest_sha256` with the canonical content/relation hash. Noted open item: the fail-closed evidence contract puts TASK-0010 grading calibration on the critical path to any publish — explicit acceptance pending.
- **Product Owner execution clarification (2026-07-13, `DECISION-0040`):** repository/local implementation of H1/H2, the compiler/persistence layer, and H3–H5 is approved, including additive migration artifacts and local PostgreSQL verification. This does not authorize applying those artifacts to an environment.
- **Approved:** documentation remediation; P0 repository implementation/review; H1–H5 repository/local implementation; formal deprecation/replacement design and additive migration artifacts for `artifact_version_ids`; a typed validation-suite registry including `security_privacy`; an immutable typed H5 content-clearance-exception record; the TASK-0017/TASK-0009 authority split; Chemistry scaffold reconciliation for AC4; and release intent for human-verified AP Biology/AP Statistics content in the August pilot with live checking.
- **Not approved:** applying a migration or function to Dev without a separate Dev execution approval ID; any Production migration/deployment/publication; publishing AP Chemistry; or any unrecorded gate bypass.

## QA Result

Implementation-agent evidence is green after remediating the initial independent-QA blockers, including clean disposable PostgreSQL execution, concurrent-apply verification, and security/schema audits. Fresh independent re-QA against the frozen remediation commit is required before a proposed final verdict. Dev/Production remain untouched. The Dev preflight must additionally prove `app` is not in PostgREST's exposed-schema list. Physical design: `docs/architecture/TASK0017_H1_H5_PHYSICAL_DESIGN_2026_07_13.md`; local evidence: `docs/qa/TASK0017_H1_H5_LOCAL_EVIDENCE_2026_07_13.md`.

## Done Decision

Not done. Repository/local implementation is Ready for Review. Next checkpoints: fresh independent QA; Product Owner Hard-Gate physical migration decision; then a separate Dev execution approval ID and Dev evidence run. Production remains a distinct Hard Gate.
