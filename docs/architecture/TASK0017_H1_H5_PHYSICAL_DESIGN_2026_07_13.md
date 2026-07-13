# TASK-0017 H1–H5 Physical Design and Compiler

**Status:** Ready for Hard-Gate review
**Date:** 2026-07-13
**Authority:** DECISION-0037–0040
**Execution state:** Repository implementation and disposable-local verification only; Dev and Production untouched

## Outcome

The reusable subject-onboarding harness is implemented through H5 for repository/local use. It accepts approved SubjectPackage and ItemPackage JSON, performs contract and semantic validation, emits a deterministic canonical plan, and applies that plan transactionally and idempotently to the canonical `content_items` / `content_item_versions` model.

The implementation does not create question records in `artifact_versions`. The full canonical ItemPackage JSON and SHA-256 are stored on `content_item_versions`; normalized archetype and taxonomy relations support exact querying without becoming a second question-version identity.

## Physical model

- H1: stable `item_archetypes`; immutable `item_archetype_versions`; canonical ItemPackage payload/hash/archetype pin on `content_item_versions`; full learner-visible payload immutability; concurrency-safe immutable application evidence.
- H2: `taxonomy_schemes` and immutable scheme/node/relation versions scoped to an exact `exam_pack_version`; same-scheme relation and same-identity supersession enforcement; version-level content assignments and explicit crosswalks; academic-year normalization from exam dates with a fail-closed governance-record preflight.
- Manifest replacement: immutable parent evidence plus ordered `exam_pack_manifest_content_versions`, populated server-side from the temporary legacy carrier, ambiguity-checked against `artifact_versions`, and verified against canonical content versions.
- H3: typed platform-capability, deterministic-check, and immutable reviewed-plugin-version registries; plugin-backed checks remain inactive until an exact approved plugin version is pinned. Both compiler and database derive renderer/modality demands from each item and validate deterministic parameter names/types; no executable verifier content is accepted from packages.
- H4: immutable review-policy versions; exact pack/policy-scoped grants; typed evidence and revocation events; persisted reviewer/team eligibility evaluations; machine-readable reason codes; and a package-managed review-queue trigger that rejects ineligible assignments.
- H5: immutable typed validation-suite versions layered onto existing `validation_suites`; target-kind and invalidation enforcement; immutable adjudicated calibration evidence against the package profile/minimum-gold contract; immutable Product-Owner content-clearance exceptions and revocations; hash-attested exception pinning; and a machine-readable reporter that computes the same source, rights, validation, calibration, waiver, policy, and release gates as P0. Content-clearance alone is waivable.

All new exposed-schema tables have RLS enabled with no client policies. Compiler, eligibility, and exception resolvers are service-role-only. Version/evidence records reject update/delete through immutable-record triggers.

## Compiler and execution boundary

`scripts/subject-harness/subject-harness.ts` supports:

```text
validate --subject ... --item ...
plan     --subject ... --item ...
apply    --subject ... --item ... --environment local|dev|production --actor-id ...
```

Dev and Production require an approval ID; Production also requires an explicit `--production` confirmation. The CLI never infers an environment and provides `verify` requirements plus an authoritative `evidence` gate report. The database resolves approval to an active Product-Owner assignment bound to exact environment, package identity/hash, plan hash, and actor; revocations fail closed and a consumption record prevents replay against another application. It recomputes canonical hashes, checks item-derived renderers/modalities and deterministic parameter contracts against its own registry, and rejects tampered plans. Transaction-scoped advisory locks plus unique package/environment identities make conflicting concurrent applications fail closed.

## Migration order

1. Existing P0 migration `202607130001_atomic_content_publication.sql`.
2. `20260713172806_task0017_h1_h2_subject_harness_persistence.sql`.
3. `20260713172817_task0017_h3_h5_validation_and_exceptions.sql`.
4. Updated `admin-content` Edge Function only after the RPC/schema migrations in a separately approved environment packet.

The H3–H5 migration adds typed manifest validation and ordered manifest dual-write without deleting or renaming the legacy array. Unknown legacy validation-suite types remain untyped and fail closed; an environment preflight must inventory and resolve them before migration approval.

## Rollback

- Before environment application: no rollback required; repository artifacts only.
- Before read cutover: stop new harness applications and revert callers; retain additive evidence tables for diagnosis.
- If a migration transaction fails: PostgreSQL rolls it back atomically.
- After successful shared-environment application: do not drop referenced immutable evidence. Disable new writes and use a separately reviewed forward remediation/down migration only for unreferenced additive objects.
- Publication/content rollback continues through the exact prior immutable manifest/version; never infer latest.

## Remaining Hard Gates

- Product Owner Hard-Gate decision for any target-environment application.
- Separate Dev execution approval ID and Dev evidence packet.
- Dev preflight proving `app` is absent from the PostgREST/Data API exposed-schema list.
- Authoritative grading/calibration and security/privacy evidence before any content publication.
- Separate Production proposal and approval.

Repository/local independent re-QA passed at `4b1bc07`; this does not authorize either target environment.
