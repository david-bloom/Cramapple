# APPROVAL-0200 — TASK-0078 A6 and A7: `evaluate-attempt`, `attempt-response` and `create-post-purchase-addon` deployed to Production from `main` (executed)

- **Date:** 2026-10-21 (Development about 21:30 UTC; Production about 21:31 UTC).
- **Granted by:** David Bloom (Product Owner), in session: "Run the production deploys for A6 and A7", given together with "Signed-in subject fix works as intended" (closing the A10 live check) and "Lovable publishing complete" (A8 published).
- **Related:** TASK-0078 rows A6, A7, A8, A10; PRs #535 (grade-store failure handling), #525–#531 (helper extractions), #527 (`requireEnv`), `fce40d1d` (add-on ownership check); TASK-0074 (control characters); APPROVAL-0198, APPROVAL-0199.
- **Why:** Production's grading functions carried `_shared` modules from before the 2026-10-14 control-character fix and before the merged grade-store and helper changes; the add-on function lacked the 2026-10-06 ownership check while the Lovable publish had just made the offer link reachable.

## Scope

Source: `main` `9d13a252` (checkout at deploy time; #549 and #550 merged afterwards touch only migration filenames and documents, no function code). Deployed with `supabase functions deploy <fn> --project-ref <ref> --use-api --no-verify-jwt`, preserving `verify_jwt = false` on all three.

| Function | Development | Production | Bundle hash (identical on both) |
| --- | --- | --- | --- |
| `create-post-purchase-addon` | v37 | v9 (was v8 of 2026-10-02) | `11071d866244527df4049437a7886fa1f8495aa9059115f00fc7f0080b32fcc0` |
| `evaluate-attempt` | v60 | v82 (was v81 of 2026-10-10) | `a1336c20810779f8594203376decc25d97125bbfe37f8c4d65d929c6fd57578c` |
| `attempt-response` | v47 | v43 (was v42 of 2026-10-10) | `b80d8b3211394ac478ad630b02e9c6ce2a9dcf0474a416c02ac50e27b170913f` |

## Rehearsal and verification

- Local suites at the deployed commit: `evaluate-attempt/index_test.ts`, `attempt-response/index_test.ts`, `create-post-purchase-addon/handler_test.ts` → 49 passed, 0 failed, including the forced grade-store failure and recovery cases (`grade_store_failed`, `grade_store_retry_failed`, "repeated failed recovery stays retryable; a changed body conflicts and corrupt checkpoints fail closed").
- Development deployed first; the three bundles were downloaded back and diffed file by file against `main`: 41 files, zero differences. Unauthenticated POST: add-on 401, grading functions 400 (body validation precedes auth), as the handlers specify.
- Production deployed second; the same download and diff: 41 files, zero differences; the same unauthenticated responses; hashes equal Development's.
- Production state before and after: `app.grading_results` holds 99 `graded` and 9 `uncertain` rows and no `processing` rows, so the new stale-row and recovery paths touch no existing row.

## Not done

- No signed-in grade on Development or Production after the deploy (needs a student session). The recovery path is covered by the 49 local tests, not by a live run.
- No signed-in Stripe test-mode add-on purchase on Development. The add-on page is now reachable in Production through the published payment-result offer; the first real add-on purchase is the live confirmation, and `app.stripe_checkout_sessions` rows with `purchase_type = 'post_purchase_addon'` are where it will show.

## Rollback

Redeploy from commit `df39cd09` (pre-session `main`) for `evaluate-attempt` and `attempt-response`, or from `73206cde` for the add-on function's previous Development build (v36). Production's previous bundles were `6e91564f…` (v81), `a8cb95c7…` (v42) and `fc503329…` (v8). None depends on a migration applied today, so a rollback of the functions alone is safe; the add-on rollback re-opens the ownership gap while the offer link stays published, so unpublish the offer first in that case.
