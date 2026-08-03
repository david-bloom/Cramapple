# TASK-0019 — Server-Issued Session Targets

**Task ID:** TASK-0019  
**Title:** Persisted, server-issued targets with atomic session creation  
**Owner:** Codex (cross-repo: `Cramapple` migrations + `exam-buddy-wireframe` server adapter)  
**Product Owner:** David Bloom  
**Tier:** Hard-Gate  
**Status:** In Progress — Claude QA Round 1 remediated in Development; re-QA pending
**Priority:** High  
**Created Date:** 2026-07-30  
**Approved Date:** 2026-07-30 (implementation and Development verification only)

---

## Goal

Allow a trusted server recommendation to resolve an ordered content plan once,
return only an opaque `target_id` before start, and atomically create exactly one
learning session when that target is consumed.

TASK-0019 is an optional extension to TASK-0018. With the target feature
disabled or unavailable, TASK-0018's broad subject-scoped start path remains
fully functional.

## Scope

- Authoritative `app.session_targets` and `app.session_target_items` tables.
- No `anon` or `authenticated` table access.
- Service-role-only, security-invoker RPCs for issuance and consumption.
- Ownership, entitlement, exam-pack, status, expiry, and current-publication
  validation.
- Issuance idempotency by `(user_id, idempotency_key)` with payload-conflict
  rejection.
- Consumption idempotency: retries return the same `learning_session_id`.
- Session creation and target consumption in one database transaction.
- Explicit fail-closed invalidation when selected content or the exam pack is no
  longer published.
- A server-only frontend adapter beside the generated auth middleware.
- Optional `target_id`; the existing broad start contract is unchanged.

## Out of Scope

- Home recommendation ranking or personalized target selection.
- Course-position migrations owned by TASK-0018.
- Automatic substitution after content retirement. Reissuance is safer because
  replacement content may no longer match the recommendation shown.
- Production migration, Vercel secret provisioning, deployment, or enablement
  without the Production Hard Gate.

## Security Contract

- Browser input may describe duration, allowed formats, and an idempotency key;
  it never supplies resolved content IDs.
- The authenticated server resolves published content, then a separate
  service-role client invokes the privileged RPC.
- `SUPABASE_SERVICE_ROLE_KEY` is read only from the server environment and is
  never exposed through `VITE_*`, route state, logs, or response bodies.
- The generated `src/integrations/supabase/auth-middleware.ts` is not edited.
- The service-role RPCs are `SECURITY INVOKER`, revoked from `PUBLIC`, `anon`,
  and `authenticated`, and granted only to `service_role`.
- Target tables use RLS as defense in depth and have no user policies.

## Acceptance Criteria

- [ ] An authenticated user can request a target without providing content IDs.
- [x] Reissuing the same idempotency key and payload returns the same target.
- [x] Reusing the key with different inputs returns `idempotency_conflict`.
- [x] Another user cannot issue or consume against the first user's identity.
- [ ] Expired, invalidated, wrong-pack, retired-content, and unentitled targets
      create no learning session.
- [x] Two concurrent consumption attempts create one learning session.
- [x] A retry after successful consumption returns the original session.
- [x] Resolved items remain inaccessible through authenticated Data API access
      before consumption.
- [x] No-target session start continues to use the existing broad path.
- [x] Development migration, security advisors, tests, frontend lint, and build
      pass before any Production approval request.

## Approval State

Implementation and Development verification are approved by the 2026-07-30
instruction to execute TASK-0019.

Production migration, Vercel `SUPABASE_SERVICE_ROLE_KEY` provisioning,
deployment, and feature enablement remain separately gated.

## Execution Evidence — 2026-07-30

- Applied Development migration
  `20260730172100_server_issued_session_targets`.
- Verified `anon`/`authenticated` have no target-table access and cannot execute
  either RPC; `service_role` has the intended grants.
- Verified same-key issuance replay, payload-conflict rejection, wrong-user
  non-disclosure, wrong-pack rejection, and expiry rejection.
- Ran two concurrent consume requests: one created the session and the other
  returned an idempotent replay of the same session.
- Removed all integration-test targets and learning sessions after verification.
- Frontend target resolver: 5 tests passed; targeted ESLint, TypeScript, and
  production build passed.
- Advisors report the intentional `RLS enabled, no policy` informational notice
  for both target tables. Direct grants and RPC execution remain service-only.

Remaining before frontend activation:

1. TASK-0018 must align Development with
   `profiles.active_exam_pack_version_id`; the adapter deliberately refuses to
   trust a client-provided active pack.
2. Provision `SUPABASE_SERVICE_ROLE_KEY` in the approved Vercel server
   environment and verify it never enters the browser bundle.
3. Import/wire the feature-gated server functions from the approved Home/session
   integration. The current placeholder session runner must not consume exact
   targets because it does not yet render the resolved production content.
4. Exercise content-retirement invalidation end to end with a disposable
   Development fixture; do not mutate reviewed published inventory for this
   test.

## Claude QA Round 1 Remediation — 2026-07-30

Round 1 was accepted as materially correct. The following forward remediation
was implemented without changing Production:

- Removed the obsolete pending migration that could create a second,
  conflicting `public.session_targets`. Both sections of that pending draft
  were already superseded: course position by TASK-0018 and targets by
  `app.session_targets`.
- Added a migration assertion that fails closed if a relation named
  `public.session_targets` exists. The authoritative relation is only
  `app.session_targets`.
- Aligned the adapter candidate query with the RPC publication predicate by
  requiring both the version and its embedded parent content item to be
  published and in the active exam-pack version.
- Added coded malformed-UUID, duplicate-item, compatible-item-type, and FRQ-form
  validation before any target write.
- Replaced MD5 issuance fingerprints with SHA-256 while allowing existing
  32-character Development fingerprints during the forward transition.
- Added a per-user limit of 10 live issued targets. Issuance is serialized per
  user so concurrent fresh keys cannot bypass the limit.
- Added a daily Postgres Cron retention sweep: issued targets are marked expired
  after TTL, terminal expired/invalidated targets are retained 30 days, and
  consumed targets are retained 90 days.
- Persisted the first target item's real `practice_format` on the atomic
  `learning_sessions` insert.
- Prevented target consumption from creating a second active learning session
  for the same user.
- Removed service-role UPDATE and DELETE privileges from target items. The
  issued plan is immutable through privileges; no mutation trigger was added
  because a DELETE trigger would also obstruct the intended parent-row cascade
  used by retention cleanup.
- Added runtime validation for SQL status, error-code, item-type, and
  practice-format unions.
- Replaced client-visible raw database/PostgREST messages and inventory counts
  with stable error codes and optional correlation IDs. Structured server logs
  record only a stage and safe database/contract code.
- Made `target_wrong_pack` explicitly reissuable.
- Composed target activation with TASK-0018's server-side rollout: the target
  kill switch, Home global kill switch, and unexpired own-user `home-v2`
  assignment must all pass.
- Added a rollback-only SQL integration test and a repeatable two-transaction
  concurrency harness.

### Round 1 reconsideration notes

No finding was rejected outright. Two points were refined:

1. The stale `public.session_targets` draft was a real deployment footgun even
   though current Supabase Data API settings may require explicit grants before
   a new public table is exposed. The file was removed and the forward
   migration now asserts the namespace invariant.
2. A row-level immutability trigger was not added to
   `app.session_target_items`. Least-privilege grants now permit only SELECT and
   INSERT to `service_role`; UPDATE and DELETE are structurally unavailable to
   the application role. Parent-target deletion must retain its cascade for
   scheduled garbage collection.

The retired-content disposable-fixture test and authenticated adapter test with
a profile carrying `active_exam_pack_version_id` remain activation gates until
they are executed and recorded.
