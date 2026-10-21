# Test-gate inventory (assessment 5)

**Status:** read-only inventory · **Date:** 2026-10-21 · **Read against:** `main` `73206cde` (`origin/main`) · **Branch:** `claude/assessments-5-6-2026-10-21` · **Companion:** `ENVIRONMENT_PARITY_2026_10_21.md` · **Changes:** none to code, workflow, deployment, secrets or data.

## Summary

**Verified.** The repository has 30 edge-function directories under `supabase/functions/` (excluding `_shared`), and 61 `*_test.ts` files. Eleven functions have at least one test file; 19 have none (table below). CI's `minimal-ci.yml` runs 22 of the 61 test files; 39 are not run. Under the current narrow `--allow-env` list, 50 of 61 pass. All 61 pass once granted the names and flags they ask for (permission-discovery run from the author's shell). In a clean environment (`env -i`) with the proposed flags, 60 pass, and they pass together in one process. The exception, `create-post-purchase-addon/handler_test.ts`, needs unrestricted `--allow-env`: the Stripe SDK reads process environment names that depend on the machine running the tests, so no fixed list covers it. The current CI command runs 255 passing tests in a clean environment; the proposed command below runs 760 passing tests across 60 files in one clean-environment process.

**Corrections to the prompt and the refactor review (verified).** (1) `attempt-response` does not fail "on `OPENAI_API_KEY` under the CI list". Its first missing name under the CI list is `GRADING_ENTITLEMENTS_ENABLED`, and it needs about twelve names in total. (2) The refactor review's list for `attempt-response` (`OPENAI_API_KEY`, `FRQ_PHOTO_RESPONSES_ENABLED`, `FRQ_PHOTO_SUBJECTS`, `GRADING_ENTITLEMENTS_ENABLED`) is incomplete. Full lists are in the per-file table. (3) Two tests need more than env names: `byoq` and `capture-pairing` call `Deno.serve` when their module loads, so they need `--allow-net`; `email-template-data` and `payer-email` read `docs/email/transactional/manifest.json`, so they need `--allow-read`.

**Not verified.** That GitHub Actions runs the proposed command (it was not pushed or run in CI). That the tests pass with networking disabled: only the two `Deno.serve` tests needed a network permission, but I did not run an offline pass. The "clean environment" is `env -i` on this Mac, not the GitHub runner image.

## Edge functions and their tests

| Function | Test files | Entry `index.ts` importable by a test (no server starts) | Entry exports `handle…(req, deps)` | Test files in CI | Note |
|---|---|---|---|---|---|
| admin-content | none | no (`Deno.serve` at load) | no | — | |
| assign-for-review | none | no | no | — | |
| attempt-response | `index_test.ts` (9) | yes (main guard) | yes | no | needs the env names in the table above |
| byoq | `index_test.ts` (29) | **no**: `Deno.serve` at load binds `0.0.0.0:8000` | yes | no | needs `--allow-net` |
| cancel-trial | none | no | no | — | |
| capture-pairing | `index_test.ts` (32) | **no**: as byoq | yes | no | needs `--allow-net` |
| charge-due-trials | `handler_test.ts` (10) | n/a: test imports `handler.ts` | no (`handler.ts`) | yes | |
| content-intake | none | no | no | — | not deployed to Production or Development |
| create-checkout-session | none | no | no | — | |
| create-parent-payment-link | none | no | no | — | |
| create-post-purchase-addon | `handler_test.ts` (1) | n/a: test imports `handler.ts` | yes (`handler.ts`) | no | needs unrestricted `--allow-env` (Stripe SDK, see below) |
| deliver-transactional-email | none | no | no | — | |
| evaluate-attempt | `index_test.ts` (14) | yes (main guard) | yes | no | needs the env names in the table above |
| get-checkout-status | none | no | no | — | |
| get-trial-status | none | no | no | — | |
| grade-frq | none (no source directory in repo) | n/a | n/a | — | deployed to both projects, no source here; see the environment-parity document |
| more-help | `contract_test.ts` (38), `grounding_test.ts` (2) | n/a: tests import helper modules | no | no | |
| report-question | `handler_test.ts` (11) | n/a: test imports `handler.ts` | no | no | |
| resolve-parent-link | none | no | no | — | |
| review-decision | none | no | no | — | |
| review-queue | none | no | no | — | |
| reviewer-invite | none | no | no | — | |
| send-auth-email | none | no | no | — | |
| send-parent-payment-email | none | no | no | — | |
| session-event | none | no | no | — | |
| start-trial | `index_test.ts` (10) | yes (main guard) | yes | **yes** | |
| storage-sign-url | none | no | no | — | |
| stripe-webhook | `trial_test.ts` (18) | n/a: test imports `trial.ts`; the webhook entry is untested | no | **yes** | |
| student-session-items | `index_test.ts` (40) | yes (main guard) | yes | no | needs `FRQ_PHOTO_SUBJECTS` |
| submit-response | none | no | no | — | not deployed to Production or Development |
| trial-recovery | none | no | no | — | |

## Test files (61)

Each row was produced by running `deno test` on that file (Deno 2.8.2) with `NO_COLOR=1`. Columns: current narrow CI list; `--allow-env` with no list (all names, default read and net); names the test asks for, found by iterating until it passed; the extra flags it needed; and a clean-environment run with the proposed flags.

| Test file | In CI | Narrow CI allow-env (current workflow) | `--allow-env` (all), default flags | Extra names the test needs | Extra flags | Clean env, proposed flags |
|---|---|---|---|---|---|---|
| `_shared/addon-checkout_test.ts` | yes | pass (5) | pass (5) | — | — | pass (5) |
| `_shared/assistance-state_test.ts` | no | pass (4) | pass (4) | — | — | pass (4) |
| `_shared/attachment-redaction_test.ts` | no | pass (6) | pass (6) | — | — | pass (6) |
| `_shared/byoq-extraction_test.ts` | no | pass (17) | pass (17) | — | — | pass (17) |
| `_shared/byoq_test.ts` | no | pass (14) | pass (14) | — | — | pass (14) |
| `_shared/capture-attachment_test.ts` | no | pass (20) | pass (20) | — | — | pass (20) |
| `_shared/capture-pairing_test.ts` | no | pass (35) | pass (35) | — | — | pass (35) |
| `_shared/capture-quality-check_test.ts` | no | pass (28) | pass (28) | — | — | pass (28) |
| `_shared/cell-state-signals_test.ts` | yes | pass (31) | pass (31) | — | — | pass (31) |
| `_shared/cell-state_test.ts` | yes | pass (16) | pass (16) | — | — | pass (16) |
| `_shared/checkout-access_test.ts` | yes | pass (10) | pass (10) | — | — | pass (10) |
| `_shared/checkout-routing_test.ts` | yes | pass (6) | pass (6) | — | — | pass (6) |
| `_shared/deterministic-verifier_test.ts` | yes | pass (10) | pass (10) | — | — | pass (10) |
| `_shared/drawn-response-extraction_test.ts` | no | pass (13) | pass (13) | — | — | pass (13) |
| `_shared/email-template-data_test.ts` | no | FAIL (4 failed, 3 passed) | FAIL (1 failed, 6 passed) | TRANSACTIONAL_MAILING_ADDRESS,AUTH_EMAIL_WELCOME_URL,LOOPS_SIGNUP_TRANSACTIONAL_ID,LOOPS_INVITE_TRANSACTIONAL_ID,LOOPS_MAGICLINK_TRANSACTIONAL_ID | `--allow-read=.` | pass (7) |
| `_shared/formula-notation_test.ts` | yes | pass (7) | pass (7) | — | — | pass (7) |
| `_shared/frq-photo-rollout_test.ts` | no | pass (3) | pass (3) | — | — | pass (3) |
| `_shared/grading-arm-a_test.ts` | no | pass (9) | pass (9) | — | — | pass (9) |
| `_shared/grading-contract_test.ts` | no | pass (16) | pass (16) | — | — | pass (16) |
| `_shared/grading-control-chars_test.ts` | yes | pass (12) | pass (12) | — | — | pass (12) |
| `_shared/grading-feedback_test.ts` | yes | pass (21) | pass (21) | — | — | pass (21) |
| `_shared/grading-partial-credit_test.ts` | yes | pass (15) | pass (15) | — | — | pass (15) |
| `_shared/grading-router_test.ts` | yes | pass (11) | pass (11) | — | — | pass (11) |
| `_shared/grading-telemetry_test.ts` | no | pass (3) | pass (3) | — | — | pass (3) |
| `_shared/growth-events_test.ts` | no | pass (2) | pass (2) | — | — | pass (2) |
| `_shared/image-metadata_test.ts` | no | pass (19) | pass (19) | — | — | pass (19) |
| `_shared/loops-client_test.ts` | no | FAIL (4 failed, 0 passed) | pass (4) | LOOPS_SECRET_KEY | — | pass (4) |
| `_shared/manual-grading_test.ts` | no | pass (14) | pass (14) | — | — | pass (14) |
| `_shared/math-verifier_test.ts` | no | pass (13) | pass (13) | — | — | pass (13) |
| `_shared/mcq-quality_test.ts` | no | pass (4) | pass (4) | — | — | pass (4) |
| `_shared/parent-email-lifecycle_test.ts` | no | FAIL (5 failed, 1 passed) | pass (6) | PARENT_EMAIL_LIFECYCLE_ENABLED,PARENT_EMAIL_USE_SHORT_LINKS,APP_BASE_URL,PARENT_REMINDER_LEAD_SECONDS | — | pass (6) |
| `_shared/parent-short-link_test.ts` | yes | pass (11) | pass (11) | — | — | pass (11) |
| `_shared/payer-email_test.ts` | no | FAIL (3 failed, 0 passed) | FAIL (1 failed, 2 passed) | TRANSACTIONAL_MAILING_ADDRESS | `--allow-read=.` | pass (3) |
| `_shared/public-rate-limit_test.ts` | yes | pass (6) | pass (6) | — | — | pass (6) |
| `_shared/response-transcript_test.ts` | no | pass (8) | pass (8) | — | — | pass (8) |
| `_shared/statistics-verifier_test.ts` | no | pass (8) | pass (8) | — | — | pass (8) |
| `_shared/storage-access_test.ts` | no | pass (4) | pass (4) | — | — | pass (4) |
| `_shared/storage-paths_test.ts` | no | pass (3) | pass (3) | — | — | pass (3) |
| `_shared/stripe-catalog_test.ts` | no | pass (6) | pass (6) | — | — | pass (6) |
| `_shared/stripe-webhook-ledger_test.ts` | no | pass (3) | pass (3) | — | — | pass (3) |
| `_shared/student-item-delivery_test.ts` | no | pass (47) | pass (47) | — | — | pass (47) |
| `_shared/transactional-email_test.ts` | no | FAIL (8 failed, 0 passed) | pass (8) | LOOPS_SECRET_KEY,SEND_EMAIL_HOOK_SECRET,AUTH_EMAIL_WELCOME_URL,LOOPS_SIGNUP_TRANSACTIONAL_ID,LOOPS_INVITE_TRANSACTIONAL_ID,LOOPS_MAGICLINK_TRANSACTIONAL_ID,TRANSACTIONAL_MAILING_ADDRESS,LOOPS_PAYMENT_EMAILS_ENABLED | — | pass (8) |
| `_shared/trial-actions_test.ts` | yes | pass (10) | pass (10) | — | — | pass (10) |
| `_shared/trial-checkout_test.ts` | yes | pass (11) | pass (11) | — | — | pass (11) |
| `_shared/trial-contract_test.ts` | no | pass (3) | pass (3) | — | — | pass (3) |
| `_shared/trial-core_test.ts` | yes | pass (6) | pass (6) | — | — | pass (6) |
| `_shared/trial-learner_test.ts` | yes | pass (5) | pass (5) | — | — | pass (5) |
| `_shared/trial-notices_test.ts` | yes | pass (14) | pass (14) | — | — | pass (14) |
| `_shared/trial-promo_test.ts` | yes | pass (10) | pass (10) | — | — | pass (10) |
| `attempt-response/index_test.ts` | no | FAIL (1 failed, 0 passed) | pass (9) | GRADING_ENTITLEMENTS_ENABLED,FRQ_PHOTO_RESPONSES_ENABLED,OPENAI_API_KEY,FRQ_TRANSCRIPT_MODEL,OPENAI_MODEL,FRQ_TRANSCRIPT_TIMEOUT_MS,FRQ_TRANSCRIPT_RESERVED_COST_USD,OPENAI_DAILY_CAP_USD,FRQ_TRANSCRIPT_DAILY_RUNS,FRQ_PHOTO_DAILY_CAP_USD,FRQ_PHOTO_SUBJECTS | — | pass (9) |
| `byoq/index_test.ts` | no | FAIL (1 failed, 0 passed) | FAIL (1 failed, 0 passed) | BYOQ_EXTRACTION_ENABLED,OPENAI_API_KEY,BYOQ_EXTRACT_MODEL,OPENAI_MODEL,BYOQ_EXTRACT_TIMEOUT_MS,BYOQ_EXTRACT_RESERVED_COST_USD,OPENAI_DAILY_CAP_USD,BYOQ_EXTRACT_DAILY_CAP_USD | `--allow-net` | pass (29) |
| `capture-pairing/index_test.ts` | no | FAIL (1 failed, 0 passed) | FAIL (1 failed, 0 passed) | OPENAI_API_KEY,OPENAI_DAILY_CAP_USD,CAPTURE_QUALITY_MODEL,CAPTURE_QUALITY_TIMEOUT_MS,CAPTURE_QUALITY_RESERVED_COST_USD | `--allow-net` | pass (32) |
| `charge-due-trials/handler_test.ts` | yes | pass (10) | pass (10) | — | — | pass (10) |
| `create-post-purchase-addon/handler_test.ts` | no | FAIL (1 failed, 0 passed) | pass (1) | STRIPE_SECRET_KEY,APP_BASE_URL,ANTIGRAVITY_CLI_ALIAS,CLAUDECODE | — | FAIL (1 failed, 0 passed) |
| `evaluate-attempt/index_test.ts` | no | FAIL (1 failed, 0 passed) | pass (14) | GRADING_ENTITLEMENTS_ENABLED,OPENAI_API_KEY,OPENAI_MODEL,OPENAI_MAX_OUTPUT_TOKENS,OPENAI_INPUT_PRICE_PER_1M,OPENAI_OUTPUT_PRICE_PER_1M,OPENAI_DAILY_CAP_USD,EVALUATE_ATTEMPT_PROMPT_VERSION,GRADING_ARM,OPENAI_REQUEST_TIMEOUT_MS | — | pass (14) |
| `more-help/contract_test.ts` | no | pass (38) | pass (38) | — | — | pass (38) |
| `more-help/grounding_test.ts` | no | pass (2) | pass (2) | — | — | pass (2) |
| `report-question/handler_test.ts` | no | pass (11) | pass (11) | — | — | pass (11) |
| `start-trial/index_test.ts` | yes | pass (10) | pass (10) | — | — | pass (10) |
| `stripe-webhook/trial_test.ts` | yes | pass (18) | pass (18) | — | — | pass (18) |
| `student-session-items/index_test.ts` | no | FAIL (1 failed, 0 passed) | pass (40) | FRQ_PHOTO_SUBJECTS | — | pass (40) |

## Proposed diff for `.github/workflows/minimal-ci.yml` (not applied)

Adds the 38 test files that pass in the clean environment, the union of the env names they need, `--allow-read=.` and `--allow-net`. Excluded: `create-post-purchase-addon/handler_test.ts` (needs unrestricted `--allow-env`), and the 22 files already in CI. The 60-file combined command was run in a clean environment: 760 passed, 0 failed, one process, no `AddrInUse` error between the two `Deno.serve`-on-import tests.

```diff
--- .github/workflows/minimal-ci.yml	2026-10-21 10:19:47
+++ /private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple-nosync/90dac6bc-f9c4-49d3-8d11-67f51659beab/scratchpad/a5/minimal-ci.proposed.yml	2026-10-21 14:29:40
@@ -36,7 +36,9 @@
       - name: Run deterministic Deno tests
         run: >-
           deno test
-          --allow-env=SUPABASE_URL,SUPABASE_ANON_KEY,SUPABASE_SERVICE_ROLE_KEY,ALLOWED_ORIGINS,POSTHOG_PROJECT_API_KEY,POSTHOG_PROJECT_TOKEN,POSTHOG_API_KEY,POSTHOG_HOST
+          --allow-env=SUPABASE_URL,SUPABASE_ANON_KEY,SUPABASE_SERVICE_ROLE_KEY,ALLOWED_ORIGINS,POSTHOG_PROJECT_API_KEY,POSTHOG_PROJECT_TOKEN,POSTHOG_API_KEY,POSTHOG_HOST,APP_BASE_URL,AUTH_EMAIL_WELCOME_URL,BYOQ_EXTRACTION_ENABLED,BYOQ_EXTRACT_DAILY_CAP_USD,BYOQ_EXTRACT_MODEL,BYOQ_EXTRACT_RESERVED_COST_USD,BYOQ_EXTRACT_TIMEOUT_MS,CAPTURE_QUALITY_MODEL,CAPTURE_QUALITY_RESERVED_COST_USD,CAPTURE_QUALITY_TIMEOUT_MS,EVALUATE_ATTEMPT_PROMPT_VERSION,FRQ_PHOTO_DAILY_CAP_USD,FRQ_PHOTO_RESPONSES_ENABLED,FRQ_PHOTO_SUBJECTS,FRQ_TRANSCRIPT_DAILY_RUNS,FRQ_TRANSCRIPT_MODEL,FRQ_TRANSCRIPT_RESERVED_COST_USD,FRQ_TRANSCRIPT_TIMEOUT_MS,GRADING_ARM,GRADING_ENTITLEMENTS_ENABLED,LOOPS_INVITE_TRANSACTIONAL_ID,LOOPS_MAGICLINK_TRANSACTIONAL_ID,LOOPS_PAYMENT_EMAILS_ENABLED,LOOPS_SECRET_KEY,LOOPS_SIGNUP_TRANSACTIONAL_ID,OPENAI_API_KEY,OPENAI_DAILY_CAP_USD,OPENAI_INPUT_PRICE_PER_1M,OPENAI_MAX_OUTPUT_TOKENS,OPENAI_MODEL,OPENAI_OUTPUT_PRICE_PER_1M,OPENAI_REQUEST_TIMEOUT_MS,PARENT_EMAIL_LIFECYCLE_ENABLED,PARENT_EMAIL_USE_SHORT_LINKS,PARENT_REMINDER_LEAD_SECONDS,SEND_EMAIL_HOOK_SECRET,TRANSACTIONAL_MAILING_ADDRESS
+          --allow-read=.
+          --allow-net
           supabase/functions/_shared/grading-router_test.ts
           supabase/functions/_shared/formula-notation_test.ts
           supabase/functions/_shared/deterministic-verifier_test.ts
@@ -59,6 +61,44 @@
           supabase/functions/charge-due-trials/handler_test.ts
           supabase/functions/_shared/parent-short-link_test.ts
           supabase/functions/_shared/public-rate-limit_test.ts
+          supabase/functions/_shared/assistance-state_test.ts
+          supabase/functions/_shared/attachment-redaction_test.ts
+          supabase/functions/_shared/byoq-extraction_test.ts
+          supabase/functions/_shared/byoq_test.ts
+          supabase/functions/_shared/capture-attachment_test.ts
+          supabase/functions/_shared/capture-pairing_test.ts
+          supabase/functions/_shared/capture-quality-check_test.ts
+          supabase/functions/_shared/drawn-response-extraction_test.ts
+          supabase/functions/_shared/email-template-data_test.ts
+          supabase/functions/_shared/frq-photo-rollout_test.ts
+          supabase/functions/_shared/grading-arm-a_test.ts
+          supabase/functions/_shared/grading-contract_test.ts
+          supabase/functions/_shared/grading-telemetry_test.ts
+          supabase/functions/_shared/growth-events_test.ts
+          supabase/functions/_shared/image-metadata_test.ts
+          supabase/functions/_shared/loops-client_test.ts
+          supabase/functions/_shared/manual-grading_test.ts
+          supabase/functions/_shared/math-verifier_test.ts
+          supabase/functions/_shared/mcq-quality_test.ts
+          supabase/functions/_shared/parent-email-lifecycle_test.ts
+          supabase/functions/_shared/payer-email_test.ts
+          supabase/functions/_shared/response-transcript_test.ts
+          supabase/functions/_shared/statistics-verifier_test.ts
+          supabase/functions/_shared/storage-access_test.ts
+          supabase/functions/_shared/storage-paths_test.ts
+          supabase/functions/_shared/stripe-catalog_test.ts
+          supabase/functions/_shared/stripe-webhook-ledger_test.ts
+          supabase/functions/_shared/student-item-delivery_test.ts
+          supabase/functions/_shared/transactional-email_test.ts
+          supabase/functions/_shared/trial-contract_test.ts
+          supabase/functions/attempt-response/index_test.ts
+          supabase/functions/byoq/index_test.ts
+          supabase/functions/capture-pairing/index_test.ts
+          supabase/functions/evaluate-attempt/index_test.ts
+          supabase/functions/more-help/contract_test.ts
+          supabase/functions/more-help/grounding_test.ts
+          supabase/functions/report-question/handler_test.ts
+          supabase/functions/student-session-items/index_test.ts
 
       - name: Run AP Statistics checker tests
         run: python -m unittest scripts/ap_statistics_calculation_check/test_checker.py
```

**Trade-off for David.** The `--allow-read=.` and `--allow-net` flags apply to the whole test run, not only to the two or three tests that need them. A narrower option is a second `deno test` step for the files that need them. Either way, the env names must be kept in step with what the functions read. The environment-parity document lists the names the code reads that neither project sets.

## Files not run in CI, and why

- **Needs an unrestricted `--allow-env`:** `create-post-purchase-addon/handler_test.ts`.
- **Needs `--allow-net`:** `byoq/index_test.ts`, `capture-pairing/index_test.ts` (module-load `Deno.serve`).
- **Needs `--allow-read`:** `_shared/email-template-data_test.ts`, `_shared/payer-email_test.ts`.
- **Needs live services:** none found. Test files reference example hosts (`dev.example.com`, `example.test`) and `app.cramapple.com` as strings; the tests passed with no network permission except the two `Deno.serve` files. A fully offline run is not verified.

## Recommendations (for a later session, not this one)

1. Give `byoq` and `capture-pairing` a `handle(req, deps)` export behind a main guard (they already export `handle`, but `Deno.serve` runs at import), so their index tests stop binding port 8000 when loaded and no longer need `--allow-net`.
2. For `create-post-purchase-addon`, either keep the unrestricted `--allow-env` for that single file in its own step, or change the test so it does not import the Stripe SDK.
3. Add tests for the 19 functions with none. The highest-risk ones by the refactor review are `session-event`, `storage-sign-url` and `submit-response` (`submit-response` is not deployed).

## Appendix: commands run (all read-only)

```bash
git fetch origin && git rev-parse --short origin/main            # 73206cde
ls supabase/functions/ ; find supabase/functions -name '*_test.ts' | sort
# per function: grep for `Deno.serve(`, `import.meta.main`, `^export (async )?function handle`, test files
deno --version                                                    # deno 2.8.2
# per test file, NO_COLOR=1 set:
deno test --allow-env=SUPABASE_URL,SUPABASE_ANON_KEY,SUPABASE_SERVICE_ROLE_KEY,ALLOWED_ORIGINS,POSTHOG_PROJECT_API_KEY,POSTHOG_PROJECT_TOKEN,POSTHOG_API_KEY,POSTHOG_HOST <file>
deno test --allow-env <file>
# permission discovery: iterate until pass, parsing "NotCapable: Requires env access to ...", "read access", "net access"
# clean environment (proposed flags): env -i PATH=$PATH HOME=$HOME NO_COLOR=1 deno test --allow-env=<list> [--allow-read=.] [--allow-net] <file>
# combined proposed command: env -i ... deno test --allow-env=<union> --allow-read=. --allow-net <60 files>   -> 760 passed, 0 failed
# baseline (current CI command, clean env): 22 files -> 255 passed, 0 failed
```

Working files (per-file logs, the permission-discovery script and the generated tables) are in the session scratchpad, not in the repository.
