# Calculus Three-Subject Atomic Harness Evidence

**Date:** 2026-07-17

**Subjects:** AP Calculus AB, AP Calculus BC, AP Precalculus

**Status:** Repository and clean-database verification passed; Production application not authorized or attempted

## Outcome

The three calculus subjects now use the governed TASK-0017 subject-onboarding
contract used for AP Chemistry. Each SubjectPackage is an annual/reconciliation
operation against the subject and `2025-26` exam-pack scaffold that already
exists in Production. The 108 previously authored drafts remain the exact
ItemPackages consumed by the harness:

| Subject | MCQ | FRQ | Total | Atomic plan SHA-256 |
|---|---:|---:|---:|---|
| AP Calculus AB | 20 | 16 | 36 | `81fada6c7f0db72234033bc2f8bb9caded90c7cc46d551ffc653bb2ccc572ebc` |
| AP Calculus BC | 20 | 16 | 36 | `d11c8b88fb731d562491fbd5861c5ebaeb5749fefcd3e40eaf509daa70ceffe8` |
| AP Precalculus | 20 | 16 | 36 | `64125943a932fbf06dcd16f6bbdaa013c8feaa1e01cffc89ab5f26d35158e4b5` |

All three compiled with zero advisories.

## Repository changes

- Updated the three SubjectPackages to `create-exam-pack-version`, with an
  exact `existing_subject_key` and `preserve-prior-pack` supersession policy.
- Kept every authored ItemPackage, content key, content version, rubric,
  taxonomy reference, and canonical content hash aligned to the draft corpus.
- Added migration
  `20260718014159_add_atomic_draft_package_adoption.sql`.
  It:
  - reconciles the trusted declarative-check registry with the already-supported
    compiler aliases;
  - keeps non-operational advisories outside the signed execution plan while
    validating their transport shape;
  - allows only an exact, untouched, unassigned, unreviewed draft to acquire
    immutable ItemPackage snapshot fields; and
  - leaves mismatched, reviewed, assigned, manifested, published, or
    already-managed rows on the existing fail-closed conflict path.
- Added a calculus-specific database regression that pre-seeds all 108 versions
  in the same unmanaged-draft form, applies the three real plans, and verifies
  exact adoption and idempotent replay without duplication, publication, or
  reviewer assignment.

## Verification

### Static and contract checks

- `deno check` passed for the generator and both database regression runners.
- 22 contract/compiler/math tests passed, 0 failed.
- Calculus content verification passed: 108 unique content keys, 20 MCQ + 16
  FRQ per subject, all course units covered, all four difficulty levels covered,
  canonical item hashes valid, and zero compiler advisories.
- `git diff --check` passed.

### Clean PostgreSQL 17 stack

A new disposable PostgreSQL cluster on local port 55447 received, in order:

1. TASK-0017 P0 test schema and atomic-publication migration;
2. the harness compatibility bridge;
3. H1/H2 persistence;
4. the historical-taxonomy fixture;
5. H3-H5 validation/governance; and
6. the new atomic draft-adoption migration.

The generic harness regression passed:

```text
CANONICAL_PLAN_TAMPER_REJECTED
CHEMISTRY_SCAFFOLD_PASS
CREATE_SUBJECT_ROLLBACK_PASS
MATCHING_DRAFT_ATOMIC_ADOPTION_PASS
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

The real calculus plans then passed:

```text
AP_CALCULUS_AB_ATOMIC_HARNESS_PASS
AP_CALCULUS_BC_ATOMIC_HARNESS_PASS
AP_PRECALCULUS_ATOMIC_HARNESS_PASS
```

The RPC privilege audit returned `anon=false`, `authenticated=false`, and
`service_role=true`.

## Production read-only preflight

The linked Supabase source of truth was queried read-only. It contains, for each
of the three subjects, exactly 20 MCQ and 16 FRQ; all 36 rows are still draft,
have no review status, have a payload provenance hash equal to `content_hash`,
and have zero reviewer assignments. Therefore all 108 rows satisfy the content
conditions for exact adoption.

Production does not yet contain
`app.apply_subject_package_atomic(jsonb,uuid,text,text)`, and migration
`20260718014159` is not recorded. No Production schema, data, function, review
assignment, or publication state was changed in this work.

## Production hard gate

Production application requires a separate Product Owner approval record bound
to the exact environment, package ID, package SHA-256, plan SHA-256, authorized
actor, effective window, and one-time consumption record. The existing
`APPROVAL-0038` is Development-only; `APPROVAL-0039` is limited to the reviewer
queue Edge Function. Neither authorizes this migration or these three package
applications.

The eventual Production run must apply the reviewed TASK-0017 harness migration
stack before this migration, register three exact Production execution
approvals, apply each plan through the service-role-only RPC, and rerun the
counts/hash/status/assignment checks. It must not create Tutor assignments or
publish content as part of onboarding.
