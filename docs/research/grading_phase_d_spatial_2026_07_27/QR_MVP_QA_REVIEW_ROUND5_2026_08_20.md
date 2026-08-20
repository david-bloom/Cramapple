# TASK-0016 Phase D Stage D2 — Independent QA Review, Round 5 (2026-08-20)

**Reviewed:** backend `ad3cd5a` (on `5ce92ec`), frontend `7d09188` (on `668a2cd`) — rework pass 3,
responding to Round 4's B1/S1/S2/S3/L1/L2/L5. Neither merged, pushed, or deployed. Method: full
diff read, B1's lock-order evidence independently re-derived from scratch (not reused from Round
4) via fresh `EXPLAIN` on both Development **and** Production, live catalog queries for
signature/grants/nullability/lock-site enumeration, both suites re-run, deployment discipline
re-verified independently.

## Bottom line: MERGE WITH MINOR FIXES

All seven claimed fixes (B1, S1, S2, S3, L1, L2, L5) hold up under independent re-derivation.
**No blocking findings. No regressions.** One serious finding is pre-existing (not introduced by
this pass) and can be recorded rather than gate the merge.

## Disposition

All of B1/S1/S2/S3/L1/L2/L5: **FIXED**, independently confirmed — not just re-read from the
rework's account. Notably, B1's fix (the lock-order reorder in `bind_response_attachment`) was
re-derived with fresh `EXPLAIN` plans on both Dev and Production (not reused from Round 4),
confirmed to fail closed under every interleaving the reviewer could construct, confirmed to
introduce no new race between its own three statements, and confirmed globally sufficient — this
is the only routine in the database that locks both `attempts` and `response_versions`, so
pairwise agreement with `submit_response` is enough.

## New findings

### Serious (pre-existing, not introduced by this pass)

**S-1 — `attach_capture_failed` (a genuine 500) is classified as a student-facing `blocked`
refusal, not a `technical` bug.** Mirror image of S2, on the same mapper this pass edited. A
real bind failure for an unmapped reason is shown to the student as a legitimate refusal and
**never gets bug-logged**. One-line fix: exempt `attach_capture_failed` from the
`attach_capture_*` prefix rule before merge.

### Lower

L-1 (B1's fix has no automated regression guard — the labeled test doesn't actually cover the
lock-order property, since it would pass unchanged on the pre-fix code; recommend a
cross-reference comment in `submit_response`'s own migration so future editors see the order
coupling from both sides); L-2 (S1's untested `attempt-response` leg is cheaper to fix than the
rework judged — extracting the mapper into a testable module is a pure move, not a refactor of
the deployed server); L-3 (the error-code extraction helper duplicates a more complete one
elsewhere in the codebase — currently unreachable, but drift risk); L-4 (the guard adds a new
cross-feature lock contention point on core answer submission — intentional and bounded, should
be recorded as an accepted cost); L-5/L-6 (minor, already-known-shape items, no action needed).

## What was independently verified, not just re-checked

`create or replace` compatibility re-verified live on both projects fresh (signature, security
definer, search_path, grants — not reused from Round 4, since the function body changed again
this pass); predicate equivalence confirmed via live nullability constraints (no NULL-bypass
hole); the untouched 54-line remainder of the function confirmed byte-identical across all three
migration versions; the frontend outcome-refactor confirmed to have no lingering
boolean-truthiness bug; every error code across both backend functions enumerated and confirmed
classified correctly on the frontend (except S-1); test quality spot-checked as real assertions,
not tautologies (except the L-1 gap).

Deployment discipline re-verified independently and clean: neither commit on any remote, neither
migration applied to Dev or Production, `bind_response_attachment` confirmed byte-identical (fresh
`md5`) and un-deployed on both projects, no edge function deployed to either.

## Recommendation

**Merge with minor fixes.** Apply S-1 (one line) and ideally L-1 (a comment) before merging;
L-2 through L-6 are legitimate follow-ups, not gates. This is the first clean verdict after 4
rounds of rework — earned through 5 consecutive independent reviews, not assumed from a trend.
