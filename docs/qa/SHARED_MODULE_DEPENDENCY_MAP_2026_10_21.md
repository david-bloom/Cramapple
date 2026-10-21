# Shared-module dependency map and redeploy policy (Assessment 8)

**Verdict: 30 entry points bundle 60 of the 109 `_shared` files, and three Production bundles are stale on a `_shared` file that changed after their last deploy: `attempt-response` (v42), `evaluate-attempt` (v81) and `create-post-purchase-addon` (v8).** The bundle diff in `DRIFT_REGISTER_2026_10_21.md` confirms exactly those three on Production and adds `byoq` (`byoq.ts`) on Development. The commit-date method over-reports on Development (it flags `capture-pairing` and three `attempt-response` files whose bundled bytes are identical to `main`), so the bundle diff, not the date comparison, is the authority. Most of today's staleness is `f6230286` (2026-10-21, "Remove dead code from edge functions and web/"); whether that commit changes behaviour is **Not verified** here.

**Status:** read-only assessment, proposals only. **Date:** 2026-10-21. **Author:** Claude (Sonnet 5.5).
**Reviewed against:** Cramapple `main` at `df39cd09`; Production `pcntajvbdfqhbeewmdry`; Development `wmgjsdkphcyhngaffbqf`.
**Evidence convention:** **Verified** = read in source at the recorded commit, downloaded from the function store, or returned by a read-only query quoted in the appendix. **Inferred** = a conclusion from verified facts. **Not verified** = not demonstrated.

## 1. Method (Verified)

- Import graph: a small Python script (appendix) follows every relative `import … from "…"` / `export … from "…"` / bare `import "…"` starting at `supabase/functions/<fn>/index.ts`, transitively, and keeps the `_shared/*.ts` files it reaches. Only `index.ts` is an entry point (`Deno.serve` lives there); `handler.ts`, `store.ts` and the like are reached through it. `deno info` was not used.
- 30 function directories have an `index.ts`; 109 `.ts` files sit in `_shared` (tests included); 60 are reached by at least one function. The other 49 are tests or unused (not enumerated here).
- Staleness: `git log --since=2026-08-01 -- supabase/functions/_shared` gives 88 commits; for each non-test file changed, each dependent whose `updated_at` (from `list_edge_functions`) is earlier than the commit time is marked stale on that environment.
- Cross-check: the bundle diff against `main` in the drift register.

## 2. Matrix

### A. `_shared` file → dependent functions

| `_shared` file | n | Dependent functions |
| --- | --- | --- |
| `supabase.ts` | 29 | admin-content, assign-for-review, attempt-response, byoq, cancel-trial, capture-pairing, charge-due-trials, content-intake, create-checkout-session, create-parent-payment-link, create-post-purchase-addon, deliver-transactional-email, evaluate-attempt, get-checkout-status, get-trial-status, more-help, report-question, resolve-parent-link, review-decision, review-queue, reviewer-invite, send-parent-payment-email, session-event, start-trial, storage-sign-url, stripe-webhook, student-session-items, submit-response, trial-recovery |
| `cors.ts` | 27 | admin-content, assign-for-review, attempt-response, byoq, cancel-trial, capture-pairing, content-intake, create-checkout-session, create-parent-payment-link, create-post-purchase-addon, evaluate-attempt, get-checkout-status, get-trial-status, more-help, report-question, resolve-parent-link, review-decision, review-queue, reviewer-invite, send-parent-payment-email, session-event, start-trial, storage-sign-url, stripe-webhook, student-session-items, submit-response, trial-recovery |
| `http.ts` | 27 | admin-content, assign-for-review, attempt-response, byoq, cancel-trial, capture-pairing, content-intake, create-checkout-session, create-parent-payment-link, create-post-purchase-addon, evaluate-attempt, get-checkout-status, get-trial-status, more-help, report-question, resolve-parent-link, review-decision, review-queue, reviewer-invite, send-parent-payment-email, session-event, start-trial, storage-sign-url, stripe-webhook, student-session-items, submit-response, trial-recovery |
| `auth.ts` | 21 | admin-content, assign-for-review, attempt-response, byoq, cancel-trial, capture-pairing, content-intake, create-checkout-session, create-post-purchase-addon, evaluate-attempt, get-trial-status, more-help, report-question, review-decision, review-queue, reviewer-invite, session-event, start-trial, storage-sign-url, student-session-items, submit-response |
| `stripe.ts` | 11 | cancel-trial, charge-due-trials, create-checkout-session, create-parent-payment-link, create-post-purchase-addon, deliver-transactional-email, get-checkout-status, resolve-parent-link, send-parent-payment-email, stripe-webhook, trial-recovery |
| `trial-core.ts` | 9 | cancel-trial, charge-due-trials, create-checkout-session, create-parent-payment-link, deliver-transactional-email, get-checkout-status, get-trial-status, stripe-webhook, trial-recovery |
| `growth-events.ts` | 7 | attempt-response, cancel-trial, create-checkout-session, create-parent-payment-link, evaluate-attempt, start-trial, stripe-webhook |
| `trial-notices.ts` | 7 | cancel-trial, charge-due-trials, create-checkout-session, create-parent-payment-link, deliver-transactional-email, get-trial-status, trial-recovery |
| `public-rate-limit.ts` | 6 | cancel-trial, create-checkout-session, create-parent-payment-link, get-checkout-status, resolve-parent-link, trial-recovery |
| `loops-transactional.ts` | 5 | deliver-transactional-email, report-question, send-auth-email, send-parent-payment-email, stripe-webhook |
| `addon-checkout.ts` | 4 | create-post-purchase-addon, deliver-transactional-email, get-checkout-status, stripe-webhook |
| `email-template-data.ts` | 4 | deliver-transactional-email, send-auth-email, send-parent-payment-email, stripe-webhook |
| `parent-short-link.ts` | 4 | create-parent-payment-link, deliver-transactional-email, resolve-parent-link, send-parent-payment-email |
| `trial-actions.ts` | 4 | cancel-trial, charge-due-trials, get-trial-status, trial-recovery |
| `capture-attachment.ts` | 3 | attempt-response, byoq, capture-pairing |
| `checkout-access.ts` | 2 | get-checkout-status, stripe-webhook |
| `frq-photo-rollout.ts` | 2 | attempt-response, student-session-items |
| `grading-feedback.ts` | 2 | attempt-response, evaluate-attempt |
| `grading-memory.ts` | 2 | attempt-response, evaluate-attempt |
| `image-metadata.ts` | 2 | byoq, capture-pairing |
| `learning-context.ts` | 2 | attempt-response, evaluate-attempt |
| `parent-email-lifecycle.ts` | 2 | deliver-transactional-email, send-parent-payment-email |
| `payment-email.ts` | 2 | deliver-transactional-email, stripe-webhook |
| `storage-paths.ts` | 2 | attempt-response, capture-pairing |
| `stripe-catalog.ts` | 2 | create-checkout-session, create-parent-payment-link |
| `student-memory.ts` | 2 | attempt-response, evaluate-attempt |
| `trial-checkout.ts` | 2 | create-checkout-session, create-parent-payment-link |
| `trial-promo.ts` | 2 | create-checkout-session, create-parent-payment-link |
| `assistance-state.ts` | 1 | evaluate-attempt |
| `attachment-redaction.ts` | 1 | attempt-response |
| `auth-email.ts` | 1 | send-auth-email |
| `byoq-extraction.ts` | 1 | byoq |
| `byoq.ts` | 1 | byoq |
| `capture-pairing.ts` | 1 | capture-pairing |
| `capture-quality-check.ts` | 1 | capture-pairing |
| `cell-state-persist.ts` | 1 | evaluate-attempt |
| `cell-state-signals.ts` | 1 | evaluate-attempt |
| `cell-state.ts` | 1 | evaluate-attempt |
| `checkout-routing.ts` | 1 | stripe-webhook |
| `deterministic-verifier.ts` | 1 | evaluate-attempt |
| `drawn-response-extraction.ts` | 1 | attempt-response |
| `evaluate-attempt-response.ts` | 1 | evaluate-attempt |
| `formula-notation.ts` | 1 | evaluate-attempt |
| `grading-contract.ts` | 1 | evaluate-attempt |
| `grading-repair.ts` | 1 | evaluate-attempt |
| `grading-router.ts` | 1 | evaluate-attempt |
| `grading-telemetry.ts` | 1 | evaluate-attempt |
| `loops-client.ts` | 1 | start-trial |
| `manual-grading.ts` | 1 | attempt-response |
| `math-verifier.ts` | 1 | evaluate-attempt |
| `mcq-quality.ts` | 1 | admin-content |
| `payer-email.ts` | 1 | stripe-webhook |
| `response-transcript.ts` | 1 | attempt-response |
| `statistics-verifier.ts` | 1 | evaluate-attempt |
| `storage-access.ts` | 1 | storage-sign-url |
| `stripe-webhook-ledger.ts` | 1 | stripe-webhook |
| `student-item-delivery.ts` | 1 | student-session-items |
| `trial-contract.ts` | 1 | start-trial |
| `trial-learner.ts` | 1 | stripe-webhook |
| `verification-profiles.ts` | 1 | evaluate-attempt |

### B. Function → `_shared` files (transitive)

| Function | n | `_shared` files |
| --- | --- | --- |
| `evaluate-attempt` | 23 | assistance-state.ts, auth.ts, cell-state-persist.ts, cell-state-signals.ts, cell-state.ts, cors.ts, deterministic-verifier.ts, evaluate-attempt-response.ts, formula-notation.ts, grading-contract.ts, grading-feedback.ts, grading-memory.ts, grading-repair.ts, grading-router.ts, grading-telemetry.ts, growth-events.ts, http.ts, learning-context.ts, math-verifier.ts, statistics-verifier.ts, student-memory.ts, supabase.ts, verification-profiles.ts |
| `attempt-response` | 16 | attachment-redaction.ts, auth.ts, capture-attachment.ts, cors.ts, drawn-response-extraction.ts, frq-photo-rollout.ts, grading-feedback.ts, grading-memory.ts, growth-events.ts, http.ts, learning-context.ts, manual-grading.ts, response-transcript.ts, storage-paths.ts, student-memory.ts, supabase.ts |
| `stripe-webhook` | 15 | addon-checkout.ts, checkout-access.ts, checkout-routing.ts, cors.ts, email-template-data.ts, growth-events.ts, http.ts, loops-transactional.ts, payer-email.ts, payment-email.ts, stripe-webhook-ledger.ts, stripe.ts, supabase.ts, trial-core.ts, trial-learner.ts |
| `create-checkout-session` | 12 | auth.ts, cors.ts, growth-events.ts, http.ts, public-rate-limit.ts, stripe-catalog.ts, stripe.ts, supabase.ts, trial-checkout.ts, trial-core.ts, trial-notices.ts, trial-promo.ts |
| `create-parent-payment-link` | 12 | cors.ts, growth-events.ts, http.ts, parent-short-link.ts, public-rate-limit.ts, stripe-catalog.ts, stripe.ts, supabase.ts, trial-checkout.ts, trial-core.ts, trial-notices.ts, trial-promo.ts |
| `cancel-trial` | 10 | auth.ts, cors.ts, growth-events.ts, http.ts, public-rate-limit.ts, stripe.ts, supabase.ts, trial-actions.ts, trial-core.ts, trial-notices.ts |
| `deliver-transactional-email` | 10 | addon-checkout.ts, email-template-data.ts, loops-transactional.ts, parent-email-lifecycle.ts, parent-short-link.ts, payment-email.ts, stripe.ts, supabase.ts, trial-core.ts, trial-notices.ts |
| `capture-pairing` | 9 | auth.ts, capture-attachment.ts, capture-pairing.ts, capture-quality-check.ts, cors.ts, http.ts, image-metadata.ts, storage-paths.ts, supabase.ts |
| `byoq` | 8 | auth.ts, byoq-extraction.ts, byoq.ts, capture-attachment.ts, cors.ts, http.ts, image-metadata.ts, supabase.ts |
| `get-checkout-status` | 8 | addon-checkout.ts, checkout-access.ts, cors.ts, http.ts, public-rate-limit.ts, stripe.ts, supabase.ts, trial-core.ts |
| `send-parent-payment-email` | 8 | cors.ts, email-template-data.ts, http.ts, loops-transactional.ts, parent-email-lifecycle.ts, parent-short-link.ts, stripe.ts, supabase.ts |
| `trial-recovery` | 8 | cors.ts, http.ts, public-rate-limit.ts, stripe.ts, supabase.ts, trial-actions.ts, trial-core.ts, trial-notices.ts |
| `get-trial-status` | 7 | auth.ts, cors.ts, http.ts, supabase.ts, trial-actions.ts, trial-core.ts, trial-notices.ts |
| `start-trial` | 7 | auth.ts, cors.ts, growth-events.ts, http.ts, loops-client.ts, supabase.ts, trial-contract.ts |
| `create-post-purchase-addon` | 6 | addon-checkout.ts, auth.ts, cors.ts, http.ts, stripe.ts, supabase.ts |
| `resolve-parent-link` | 6 | cors.ts, http.ts, parent-short-link.ts, public-rate-limit.ts, stripe.ts, supabase.ts |
| `student-session-items` | 6 | auth.ts, cors.ts, frq-photo-rollout.ts, http.ts, student-item-delivery.ts, supabase.ts |
| `admin-content` | 5 | auth.ts, cors.ts, http.ts, mcq-quality.ts, supabase.ts |
| `charge-due-trials` | 5 | stripe.ts, supabase.ts, trial-actions.ts, trial-core.ts, trial-notices.ts |
| `report-question` | 5 | auth.ts, cors.ts, http.ts, loops-transactional.ts, supabase.ts |
| `storage-sign-url` | 5 | auth.ts, cors.ts, http.ts, storage-access.ts, supabase.ts |
| `assign-for-review` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `content-intake` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `more-help` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `review-decision` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `review-queue` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `reviewer-invite` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `session-event` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `submit-response` | 4 | auth.ts, cors.ts, http.ts, supabase.ts |
| `send-auth-email` | 3 | auth-email.ts, email-template-data.ts, loops-transactional.ts |

### C. Commit-date staleness (commits since 2026-08-01 touching a non-test `_shared` file; only dependents deployed before the commit)

| Commit | Date | `_shared` file | Dependent | Production | Development |
| --- | --- | --- | --- | --- | --- |
| `fce40d1d` | 2026-10-06 | `addon-checkout.ts` | create-post-purchase-addon | prod stale | dev stale |
| `01d97ce9` | 2026-10-09 | `capture-pairing.ts` | capture-pairing | prod ok | dev stale |
| `81d18124` | 2026-10-10 | `attachment-redaction.ts` | attempt-response | prod ok | dev stale |
| `81d18124` | 2026-10-10 | `frq-photo-rollout.ts` | attempt-response | prod ok | dev stale |
| `81d18124` | 2026-10-10 | `response-transcript.ts` | attempt-response | prod ok | dev stale |
| `6f8b500f` | 2026-10-14 | `grading-feedback.ts` | attempt-response | prod stale | dev stale |
| `6f8b500f` | 2026-10-14 | `grading-feedback.ts` | evaluate-attempt | prod stale | dev stale |
| `e09e394a` | 2026-10-17 | `byoq.ts` | byoq | prod ok | dev stale |
| `2e45aa73` | 2026-10-18 | `growth-events.ts` | attempt-response | prod stale | dev stale |
| `2e45aa73` | 2026-10-18 | `growth-events.ts` | evaluate-attempt | prod stale | dev stale |
| `2edcae34` | 2026-10-18 | `stripe.ts` | create-post-purchase-addon | prod stale | dev stale |
| `a7959a01` | 2026-10-18 | `growth-events.ts` | attempt-response | prod stale | dev stale |
| `a7959a01` | 2026-10-18 | `growth-events.ts` | evaluate-attempt | prod stale | dev stale |
| `ce52138c` | 2026-10-18 | `growth-events.ts` | attempt-response | prod stale | dev stale |
| `ce52138c` | 2026-10-18 | `growth-events.ts` | evaluate-attempt | prod stale | dev stale |
| `f6230286` | 2026-10-21 | `math-verifier.ts` | evaluate-attempt | prod stale | dev stale |
| `f6230286` | 2026-10-21 | `student-memory.ts` | attempt-response | prod stale | dev stale |
| `f6230286` | 2026-10-21 | `student-memory.ts` | evaluate-attempt | prod stale | dev stale |
## 3. Reading section C

| Dependent | Production | Development | Confirmed by bundle diff |
| --- | --- | --- | --- |
| `attempt-response` | stale on `student-memory.ts`, `grading-feedback.ts`, `growth-events.ts` | stale on the same three | Yes, both environments (the same bundle hash `a8cb95c7…` on both) |
| `evaluate-attempt` | stale on `student-memory.ts`, `grading-feedback.ts`, `math-verifier.ts`, `growth-events.ts`; `index.ts` also differs by 7 lines | same | Yes, both (hash `6e91564f…` on both) |
| `create-post-purchase-addon` | stale on `stripe.ts`, `addon-checkout.ts`, and `index.ts` differs by 152 lines | same | Yes, both. Hash `fc503329…` on both |
| `byoq` | ok | stale on `byoq.ts`; `index.ts` differs by 3 lines | Development only |
| `capture-pairing` | ok | flagged by date only | **No.** Bundled bytes equal `main`; false positive: Development was deployed 2026-10-09 23:13 UTC, six minutes before the commit's recorded time (23:19 UTC), yet its bundled bytes match `main`, so the commit time post-dates the content (rebase or amend) |
| `attempt-response` (`attachment-redaction.ts`, `frq-photo-rollout.ts`, `response-transcript.ts`) on Development | ok | flagged by date only | **No.** Bytes equal `main`; false positive |

Two things the date method cannot see, both **Verified** in the drift register: `review-decision`, `admin-content`, `assign-for-review` and `reviewer-invite` differ from `main` in `index.ts`, not in `_shared`; and `storage-sign-url` bundles `cors.ts` and `supabase.ts` older than `main` on both projects although no commit since 2026-08-01 touched those two files (`git log --since=2026-08-01` on those two files returns nothing, **Verified**; the older copies were bundled at an earlier deploy), so a commit-date rule would call it current. A hash comparison does not have that gap.

## 4. Proposed release rule (proposal only; not added to any charter document)

When a file in `supabase/functions/_shared/` changes, the PR description lists the functions that bundle it (the section B row set, generated by the script in the appendix, not by hand), and every listed function is redeployed to Development in the same release, then to Production on its own approval, unless the PR states why a dependent is exempt. The deployer proves each deployment by downloading the deployed bundle (`supabase functions download <slug> --project-ref <ref> --use-api`) and showing that `index.ts` and every bundled `_shared/*.ts` is byte-identical to the merge commit, or by recording the `ezbr_sha256` from `list_edge_functions` before and after and the downloaded-bundle diff for the files that changed. The release record keeps one line per function per project: slug, version, `ezbr_sha256`, merge commit. A `_shared` change with a dependent that is not redeployed is recorded as a known drift row with an owner, not left implicit. Behaviour-neutral cleanups such as `f6230286` still go through the rule so the register stays at zero rows; the PR may mark them "no behaviour change, redeploy at next functional release" if David accepts that exemption.

## 5. Questions for David

1. Is `f6230286` ("Remove dead code from edge functions and web/") behaviour-neutral by intent? If yes, the three Production-stale functions can wait for the next functional release; if not, they need a redeploy and a Development rehearsal first.
2. Should the release rule be adopted as written, with the hash proof, or with the lighter "ezbr hash before and after" only?
3. Should `create-post-purchase-addon` (index differs by 152 lines on both projects, last source change 2026-10-06 `fce40d1d`) be treated as a payments redeploy? Its Production version (v8) predates that fix. Whether the add-on path is reachable by a customer today is **Not verified**.

## 6. Appendix: commands and queries

All commands ran from `/Users/davidbloom/Documents/Cramapple.nosync` on branch `claude/assessments-1-3-4-8-2026-10-21` (from `origin/main` `df39cd09`).

```text
git rev-parse HEAD                       -> df39cd0901b50f30e457496c9618b357d0cbfab0
python3 -I graph.py supabase/functions graph.json   # import graph (regex over import/export-from lines)
git log --since=2026-08-01 --format='@%h %cI' --name-only -- supabase/functions/_shared   # 88 commits
python3 -I stale.py graph.json stale.json            # 376 commit×dependent rows; 18 stale rows
mcp list_edge_functions project_id=pcntajvbdfqhbeewmdry   # updated_at, ezbr_sha256, verify_jwt
mcp list_edge_functions project_id=wmgjsdkphcyhngaffbqf
supabase functions download <slug> --project-ref <ref> --workdir <scratch>/<env>/w_<slug> --use-api
```

`graph.py`, `stale.py` and the raw JSON are in the session scratchpad and are not committed; the script logic is the method in section 1. Counts above come from those runs: 30 functions, 60 `_shared` files used, 109 `_shared` files total, 88 commits, 376 rows, 18 stale rows.
