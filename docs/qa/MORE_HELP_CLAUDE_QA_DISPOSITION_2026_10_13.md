# More help — Claude QA disposition and owner decisions

**Current fixes:** [Subpart/validation remediation](MORE_HELP_GATEWAY_FIX_QA_2026_10_14.md) is deployed in Development v7; 22 backend tests/typecheck and exact historic-AB rejection pass. Three approved live FRQs now return valid help for AB, BC and Chemistry; the observed subpart disclosure is absent. Broader independent/release QA remains open. Earlier failed-run statements below are historical.

**Latest execution:** [October 14 live Gateway QA](MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md) supersedes the earlier missing-key/no-generation state below. Development key is present; AB generated but disclosed a conceptual subpart, BC failed local validation, Chemistry was not called. Gateway setup is resolved; release remains blocked.

**Date:** 2026-10-13; verification completed 2026-10-14 (America/New_York)
**Status:** Code remediation implemented and locally/Development tested; independent follow-up and real generation pending
**Independent report:** [Claude adversarial QA](QA_MORE_HELP_CLAUDE_ADVERSARIAL_2026_10_13.md), preserved unchanged, proposed FAIL / release BLOCKED
**Backend code:** `d2959e596185522e98227a62b73e9b7255ed22f9`, [PR #435](https://github.com/david-bloom/Cramapple/pull/435)
**App code:** `172c540d2c67cef90aba3e341f961377d13854ec`, [draft PR #21](https://github.com/david-bloom/ap-prep-blueprint/pull/21)

## Decisions supplied by David

David asked to review Claude's report, act on findings and ask about disagreements. He selected:

1. **Target explicit answer/key disclosure, plus human red-team QA.** Rejected a blanket equality test against every choice text/canonical numeric answer: legitimate given values/setup can match those strings, and string equality is not a semantic leakage guarantee. No private canonical answer lookup is added to the before-phase payload.
2. **Separate delivered-help allowance from attempted-call limits.** Failed/refused calls do not consume delivered-help allowance, but attempted requests remain bounded for abuse/cost protection.
3. **Prepare the demo's Anthropic gateway path.** No credit purchase, new key creation, grading-provider migration or billable model call is inferred.

The larger rolled-back SQL batch was initially declined twice by the approval tool, without a reason. David then explicitly instructed **“Execute using the qa account.”** The test reused the existing task-owned synthetic account, created no Auth identity, temporarily adjusted only its entitlement, wrote synthetic attempts/receipt/call counters and rolled the entire transaction back. It passed. Earlier declined/cancelled cleanup of accounts is not silently treated as authorized deletion.

## Findings and action

| Claude finding | Disposition and evidence |
| --- | --- |
| P0-1 runtime write permissions | **Confirmed and fixed.** Earlier owner-role checks missed it. New migration grants receipt UPDATE and assistance-event SELECT/INSERT only to service_role; keeps SECURITY INVOKER, RLS and client/RPC gates. Preferred explicit least-privilege grants over changing functions to SECURITY DEFINER merely to bypass missing permissions. Direct service-role delivery/fail/retry test passed after this fix. |
| P1-1 pre-submit leakage | **Owner-selected mitigation implemented; semantic gap remains.** Before-phase generated copy rejects explicit answer/final-result claims and “Select/Choose/Pick [key]” instructions. Given values remain usable. Tests cover rejected leaks, allowed setup and permitted post-grade disclosure. Human-reviewed live adversarial MCQ/FRQ outputs remain required; regex checks do not certify this boundary. |
| P1-2 no Development MCQs | **QA-data blocker retained.** The independent report found 0 published MCQs for these subjects. No new MCQs were authored or published here. Prepare a small unchanged mirror of already approved Production MCQs for Development before the live matrix; do not test unreviewed code on Production to bypass this gap. Exact fixture import still needs preparation/verification. |
| P1-3 app access | **Access blocker addressed with a private snapshot; independent review still pending.** GitHub confirms app repo private / backend repo public. A complete tracked src/package/config archive was prepared locally, excluding .env, .git, dependencies, builds and QA credentials. It was not uploaded to the public repo. Existing app source tests pass; producer tests are not independent review. |
| P1-4 provider/billing | **Owner selected Anthropic Gateway.** Adapter now uses the demo's exact Chat Completions endpoint and `anthropic/claude-haiku-5.5`, verified in the live Gateway catalog. No OpenAI fallback. Grading's existing OPENAI_* configuration stays unchanged. Development has no AI_GATEWAY_API_KEY; local shell has none either. Adapter fails before reservation when unconfigured. Live Gateway credentials/credits and successful generation remain pending; this path is separately metered API usage. |
| P2-1 quota/refusal | **Implemented.** 30 delivered helps per rolling 24 hours; active leases temporarily reserve allowance slots. Separate attempted-request limits: 6/minute, 90/user/24h, 1,000/site/24h. Timestamped private call metadata makes retry windows accurate. Failed/refused reservations release the delivery slot. Retry-after information and distinct client copy distinguish delivery allowance from request limits. Refusal/provider-configuration/pending-review errors do not automatically retry the unchanged input. |
| P2-2 uncertain grade | **Fixed conservatively.** Explicit `help_grade_pending` (409) for requested after-phase on an uncertain result, unless the server reports a draft. No guessed final score/feedback or silent conversion to before phase. Regression passes. |
| P2-3 all reservation errors 403 | **Fixed.** Ownership/entitlement 403, conflict/in-progress/duplicate 409, limits/exhaustion 429, malformed input 400, service failures 503. Tests assert actual handler statuses and retry-after data. |
| P2-4 raw hook metadata | **Fixed.** Hook and symbol fields are allowlisted; sourceNote/visualAssetRef and other internal fields are omitted. Choices are also restricted to key/text. Regression confirms authoring metadata is absent from provider/client context. Client copy sanitizer remains necessary for published prose. |
| P2-5 obsolete worker | **Fixed with fencing.** Reserve returns generation number; commit/fail require it. Old signatures lose runtime EXECUTE. A worker from an expired/retried generation cannot commit or release a newer lease. Actual service-role SQL assertions passed stale commit/fail and expired-lease recovery. |
| P3-6 legacy receipts | **Pending task-fixture cleanup.** Old v1/v2 failed-call metadata is preserved; no retrospective grade/assistance inference is made from it. Account cleanup remains separate from this approved rollback test. |
| P3-7 RPC diagnostics | **Fixed.** Operation name and bounded SQLSTATE only; no error body, prompt, work, identity or token. Fail RPC errors are checked instead of silently ignored. Privacy regression passes. |
| P3-8 math highlights | **Fixed on server as well as app.** Only plain-text occurrences outside supported math delimiters survive; cap 4. Regression covers inline/delimited math and crossing highlights. |
| P3-9 global reservation lock | **Retained for pilot.** It makes site/user quotas atomic; throughput ceiling is a scaling issue. No claim of load certification. |
| P3-10 rollback | **Updated.** New commit/fail signatures fence generation. Older Edge versions against the new database fail closed at revoked RPCs; do not describe an old function-only redeploy as a working rollback. |

## Executed verification

- **Backend:** 18 tests pass; Deno index typecheck passes. Gateway requests use a stub fetch in tests. No actual generation, provider-credit restoration or billable model call occurred.
- **App:** 115 files / 1,102 tests pass; TypeScript and build pass. New regression covers refusal, close/reopen and preserved work. Full authenticated route/photo flow and independent app visual QA remain open.
- **Development:** migrations `20261014014023_more_help_runtime_permissions` and `20261014015127_more_help_quota_and_delivery_fencing` applied with exact committed ledger filenames. Function v5 ACTIVE with JWT verification; compiled source matches the backend checkpoint above. Gateway preflight currently reports unconfigured before reserving a request.
- **Role-correct SQL:** [runtime regression batch](../../supabase/tests/more_help_runtime.sql), instantiated with the existing task QA account, passed and rolled back: private/old-signature grants, reserve/commit/fail/retry, existing/future drafts, submitted preservation, foreign/entitlement denial, independent fresh session, stale-worker fencing, failures versus delivered allowance, exact 29/30 delivered-allowance and 89/90 daily-attempt boundaries, and burst limits. JSON assertions are null-safe; missing error/state fields cannot silently pass. Site-wide 1,000 cap is source-reviewed, not a separate load/boundary test.
- **Advisors:** reviewed after DDL. Private receipt/call RLS tables intentionally have no client policies ([linter explanation](https://supabase.com/docs/guides/database/database-linter?lint=0008_rls_enabled_no_policy)); authenticated receipt lookup intentionally uses a caller/ownership-checked definer ([linter explanation](https://supabase.com/docs/guides/database/database-linter?lint=0029_authenticated_security_definer_function_executable)). New delivery RPCs remain invokers. No new unrestricted client grant was added.

## Private app review artifact

Local directory: `/private/tmp/cramapple-more-help-private-review/`.
Archive: `app-source-172c540.tar.gz`; SHA-256 `c39e12041d10c2e34ac36ee3179a839b5f9767996e3b1dcc9dcb0a42b0b1db17`; 3,509,629 bytes. `manifest.json` and `README.md` identify scope, exclusions and follow-up instructions. Review locally or provide it privately to Claude; do not publish private app code in the public docs repository. GitHub access to the private repo is an alternative.

## Gateway setup and release conditions

The adapter follows the [Gateway structured-output API](https://vercel.com/docs/ai-gateway/sdks-and-apis/openai-chat-completions/structured-outputs) and [reasoning controls](https://vercel.com/docs/ai-gateway/sdks-and-apis/openai-chat-completions/reasoning), with 35-second timeout, 2,500 output-token cap, reasoning effort none and strict schema/local validation. The live catalog confirms the selected model supports structured output and none effort. This verifies documentation/code compatibility, not successful runtime generation.

Install an existing server-owned AI_GATEWAY_API_KEY securely in Development; never put its value in this document, chat or committed source. Supabase's `secrets set --env-file` supports a private local file; discover installed CLI flags before running it. No credential was created/transferred in this remediation. Then approve/execute controlled authored-content Gateway QA, provide Development MCQ fixtures, and obtain human red-team and independent app review. The existing grader still needs its own functioning model connection for the full after-grade flow.

Production remains unchanged; app stays draft/unpublished. Claude's original FAIL is preserved. This disposition is producer evidence and does not declare independent PASS, successful end-to-end generation or Done.
