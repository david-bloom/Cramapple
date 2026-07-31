# TASK-0019 — Claude QA Round 1 Disposition

**Date:** 2026-07-30

**Scope:** Review and remediation of Claude's first TASK-0019 QA report.

**Environment changed:** Development only

**Production changed:** No

## Finding dispositions

| Finding | Disposition | Result |
| --- | --- | --- |
| P1-1 stale pending `public.session_targets` | Accepted | Deleted the obsolete pending migration, added a forward namespace assertion, and added an integration assertion that only `app.session_targets` exists. |
| P2-1 candidate/RPC publication mismatch | Accepted | Adapter now inner-embeds the parent content item and filters both parent and version status plus active exam-pack version. Mapping fails closed on malformed parent rows. |
| P2-2 uncoded malformed IDs/item types | Accepted | SQL validates JSON object shape and UUID syntax before casting, rejects duplicates, and requires supported item type/FRQ form before writing. |
| P2-3 missing session `practice_format` | Accepted | Atomic consumption reads the first ordered item format and writes it to `app.learning_sessions.practice_format`. |
| P2-4 raw error disclosure | Accepted | Client receives stable typed failures and an optional correlation ID. Server logging records only stage and safe code; raw PostgREST text and inventory counts are not returned or logged. |
| P2-5 quota/garbage collection | Accepted | Added a concurrency-safe limit of 10 live issued targets per user and a daily Postgres Cron retention sweep. |
| P3-1 wrong-pack recovery | Accepted | `target_wrong_pack` is reissuable. |
| P3-2 MD5 fingerprint | Accepted | New fingerprints use SHA-256. The forward constraint accepts 32–128 lowercase hex so existing Development MD5 rows remain valid during transition. |
| P3-3 surplus DELETE/immutability | Accepted with refinement | Removed UPDATE and DELETE from the application role. No row trigger was added: SELECT+INSERT-only privileges enforce application immutability while preserving parent-row cascade deletion for retention. |
| P3-4 unchecked TypeScript unions | Accepted | Added runtime validation for target status, failure code, item type, practice format, UUIDs, and success shapes. |
| P3-5 process-wide-only target flag | Accepted | Target calls now require the target kill switch, Home global kill switch, and an unexpired own-user `home-v2` assignment. |
| P3-6 advisory lock collision note | Accepted | Added a comment clarifying that a collision causes only temporary serialization and the unique constraint remains the idempotency guarantee. |

## Additional remediation

Target consumption now serializes session creation per user and returns
`target_active_session_exists` rather than creating another active learning
session. This closes the main TASK-0018/TASK-0019 lifecycle race before the
Home integration is enabled.

Candidate selection is now explicitly ordered before `limit(100)`, so retry
resolution does not depend on unspecified PostgREST row order.

## Verification evidence

- Forward migration `20260731020326_harden_server_issued_session_targets`
  applied to Development.
- Exactly one database relation named `session_targets` exists:
  `app.session_targets`.
- Target and target-item tables contain zero residual QA rows.
- `service_role` target-item privileges are SELECT+INSERT only.
- Postgres Cron job `task0019-sweep-session-targets` is active daily at
  `03:17 UTC`.
- Rollback-only SQL integration test passes:
  - namespace and privilege hygiene;
  - malformed UUID and non-object rejection with coded errors;
  - same-key issuance replay;
  - cross-user non-disclosure;
  - wrong-pack rejection;
  - consumption replay;
  - persisted `practice_format`;
  - active-session collision rejection;
  - live-target quota.
- Repeatable two-transaction concurrency harness passes:
  - both requests return the same learning-session ID;
  - exactly one request is the idempotent replay;
  - disposable target/session rows are cleaned afterward.
- Frontend full suite passes: 16 files, 159 tests.
- Focused target suite passes: 2 files, 15 tests.
- TypeScript, targeted ESLint, and production build pass.
- Public build scan finds no service-role key marker, secret-key marker,
  server-only client path, or target RPC/table internals.
- Supabase schema lint reports only the pre-existing unrelated
  `app.content_publication_gate_status` warning.
- Supabase security advisor reports no TASK-0019 findings.

## Reconsideration requested

Please reconsider only the trigger portion of P3-3. A target-item UPDATE/DELETE
trigger is unnecessary after privilege reduction and would complicate or block
the intentional `ON DELETE CASCADE` used by retention cleanup. The application
role cannot update or delete target items; only the table owner retains
administrative capability.

All other findings were accepted and remediated.

## Remaining activation gates

- Re-run Claude QA against the remediation commits.
- Exercise authenticated adapter issuance with a Development profile that has
  an approved active exam-pack version and an explicit `home-v2` assignment.
- Exercise retired-content and expired-entitlement invalidation with disposable
  Development fixtures.
- Keep both feature kill switches and all per-user assignments off until re-QA
  passes.
- Production migration, secret provisioning, deployment, and enablement remain
  separately prohibited without the Production Hard Gate.
