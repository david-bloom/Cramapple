# TASK-0017 H1–H5 Local Evidence Packet

**Status:** Remediated implementation evidence complete; fresh independent re-QA pending
**Date:** 2026-07-13
**Environment:** Clean disposable PostgreSQL 17.10 cluster, local port 55443
**Shared environments:** Not contacted or mutated

## Static and contract evidence

- `deno fmt --check` — passed for harness scripts and package schemas/fixtures.
- `deno check` — passed for compiler CLI and DB regression runner.
- Contract/compiler tests — 9 passed, 0 failed.
- Covered: Q1–Q4 package validation; legacy calendar-year rejection; executable-verifier rejection; deterministic plan hash; subject- and item-derived capability checks; deterministic parameter contracts; unapproved-plugin fail-closed behavior; environment approval enforcement.

## Clean PostgreSQL execution

Executed with `ON_ERROR_STOP=1` from a clean disposable database:

1. P0 test schema.
2. P0 atomic-publication migration.
3. H1–H5 test bridge with legacy Bio/Stats/Chemistry `2026` school-year fixtures.
4. H1/H2 physical migration — committed successfully; three legacy May 2026 pack identifiers normalized to `2025-26`; an explicit preflight rejects denormalized legacy governance-year rows pending reconciliation.
5. Historical AP Statistics nine-unit taxonomy fixture.
6. H3–H5 physical migration — committed successfully.
7. Atomic rollback regression — passed (`BEGIN / DO / ROLLBACK`).
8. Exact-version regression — passed; it additionally asserted the ordered relation pins the requested version, manifest/suite evidence is immutable, and invalidated grading evidence fails closed.

## Vertical regression results

```text
TASK0017_SUBJECT_HARNESS_REGRESSION_PASS
CANONICAL_PLAN_TAMPER_REJECTED
CHEMISTRY_SCAFFOLD_PASS
CREATE_SUBJECT_ROLLBACK_PASS
H4_H5_FAIL_CLOSED_PASS
REPORTER_P0_PARITY_AND_WAIVER_HASH_PASS
DB_ITEM_CAPABILITY_FAIL_CLOSED_PASS
DB_ITEM_RENDERER_FAIL_CLOSED_PASS
DB_PARAMETER_CONTRACT_FAIL_CLOSED_PASS
REVIEW_POLICY_CONFLICT_PASS
AUTHORITATIVE_APPROVAL_FAIL_CLOSED_PASS
EXACT_APPROVAL_BINDING_REVOCATION_CONSUMPTION_PASS
CANONICAL_ITEM_IMMUTABILITY_PASS
CONCURRENT_PACKAGE_IDENTITY_PASS
```

- AP Statistics: the seeded prior nine-unit `2025-26` taxonomy and new `2026-27` pack coexist; five units + four practices persisted; Q1–Q4 round-trip payload/hash checks passed.
- AP Biology/current AP Statistics: normalized semantic snapshots preserved stems, prompt JSON, content keys, and hashes; the approved school-year correction is the only modeled identifier change.
- AP Chemistry: existing scaffold reconciled with nine taxonomy nodes; no Chemistry content was published.
- True create-subject: subject/pack/taxonomy existed inside the transaction and no row survived rollback.
- H4: scoped, typed reviewer evidence failed closed when absent, passed when current, persisted every eligibility evaluation, enforced minimum team size, allowed a qualified queue assignment, and rejected the next queue assignment after an immutable revocation event.
- H5: an exact Product-Owner content-clearance exception resolved, was pinned and included in the independently reconstructed manifest hash, and failed closed after revocation. Reporter/P0 parity passed for a publishable request; both rejected duplicate evidence IDs, and the reporter rejected a retired validation-suite type. The `evidence` CLI also rejected a nonexistent content version with eight machine-readable gate reasons. Package-managed publication additionally requires current adjudicated calibration evidence meeting the package's profile/minimum-gold contract.
- Tamper test: changing the SubjectPackage after compilation was rejected by the database canonical-plan hash check.
- Trusted-boundary tests rejected item-only unsupported modality and renderer demands, a wrong deterministic-parameter type, a same-semver review-policy hash conflict, an arbitrary Dev approval string, canonical legacy/package item mutation, parent-manifest/suite mutation, and invalidated evidence.
- Execution approval tests proved exact environment/package/package-hash/plan-hash/actor binding, revocation, one-time consumption, and idempotent retry against the same recorded application. The `dev` label existed only inside this disposable local database; no Dev project was contacted.
- Two concurrent different-hash applications for the same package/environment produced exactly one winner.
- Reapplying the same AP Statistics package returned the same application ID; counts remained one subject application and four item applications.

## Security and schema audit

```text
anon_rpc=false
authenticated_rpc=false
service_rpc=true
tables_without_rls=0
active_unapproved_plugins=0
pgrst_db_schemas=UNSET_LOCAL
```

The local database cannot prove the hosted PostgREST exposed-schema setting; the Dev preflight must verify that `app` is not Data API-exposed before migration. No Dev/Production migration, function deployment, content staging, or publication occurred.
