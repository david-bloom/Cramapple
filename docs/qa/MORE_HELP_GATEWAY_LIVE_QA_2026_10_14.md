# More help — first live Anthropic Gateway QA

**Date:** 2026-10-14 (America/New_York)
**Verdict:** Gateway connectivity confirmed; code/content QA FAIL; production release BLOCKED
**Source:** backend code `d2959e596185522e98227a62b73e9b7255ed22f9`; unchanged Development bundle SHA-256 `4a03983c4c067fff0609fadb87a740c636432ceeaeb32eb577461b8051a6757b`. Function listing is now v6 ACTIVE / verify_jwt true, with the same bundle as reviewed v5. Backend PR #435 merged; private app PR #21 remains draft at `172c540d2c67cef90aba3e341f961377d13854ec`.

## Authorization and scope

David completed the Vercel-key/Development-secret setup. Secret-name inspection confirmed `AI_GATEWAY_API_KEY` present without exposing its value. Automatic approval review rejected inferred live-call authorization because the earlier approval named OpenAI. David then explicitly approved up to three live Vercel/Anthropic Gateway requests: one unanswered FRQ per Calculus AB, Calculus BC and Chemistry, existing disposable QA account, authored question/published facts, empty work/focus, no real student data, 2,500-output-token cap, stop on failure. No credits were bought or key value read by the agent.

Initial AB invocation returned 403 `entitlement_required` before reaching a provider. The task QA account's three existing subject entitlements had expired. They were extended for 30 minutes for this test; original expiry was subsequently restored on all three rows, with affected-row count verified. No new Auth account, email, real-student record or Production mutation occurred.

## Actual outcomes

| Case | Observed result | Durable metadata | Coverage limit |
| --- | --- | --- | --- |
| Calculus AB, unanswered FRQ | HTTP 200 / ok true at 08:31:55 New York; 4.58 seconds, 2 validated reference sources | Receipt delivered; 1 attempted call; no existing draft | Real generation/commit succeeded; content failed the pre-submit subpart boundary described below |
| Calculus BC, unanswered FRQ | HTTP 502 `invalid_model_output` at 08:31:59 New York; 3.84 seconds | Receipt failed, no delivery; 1 attempted call | Output withheld; exact validation failure not yet observable |
| Chemistry, unanswered FRQ | Not called | No new request receipt | Test stopped at the BC failure as approved |

Two provider requests were attempted. No retry or remaining third model call was made. Exact token usage and Gateway dollar spend were not available in the returned student-facing response; no cost estimate is asserted. Runtime logs confirm 200/502 but contain no raw provider output or validation-specific reason.

## Findings requiring remediation

1. **Pre-submission conceptual-subpart disclosure (P1, observed content failure).** AB's stem asks the student to explain why a proposed formula fails in part (a). The generated explanation directly states the requested reason, while the next step asks the student to repeat that reason. It withholds later numerical results but appears to supply a complete answer to that individual subpart. Treat this as a failed content check under the existing rule against a complete rubric-earning response, rather than a successful no-leak test. The targeted phrasing guard does not catch this form. Remediation should explicitly apply the boundary to each FRQ subpart and test conceptual prompts, keeping David's selected targeted guard plus human red-team approach. Do not silently replace that decision with blanket choice/number matching. Independent human review is still needed.
2. **BC validation failure without a safe reason (P1 reliability, P2 diagnostic gap).** The upstream call reaches local output validation but returns only `invalid_model_output`. Source can throw that for invalid JSON, missing/empty/overlength fields or malformed/overlength follow-ups. The raw output was intentionally neither logged nor persisted by the runtime, so it is not possible to identify which condition failed from this test. Do not claim a proven model/schema/length root cause. Add bounded content-free validation-reason diagnostics and reproduce within a separately approved QA run; preserve all local validation and disclosure gates.

## Evidence and remaining gates

Private local authored-content artifact: `/private/tmp/more-help-gateway-live-results-2026-10-14.json`, SHA-256 `57dbbe06bcda31e0725e49274fb1352ac38c8eceb505861f7c81c14c568f511d`. Question RPC contexts are in `/private/tmp/more-help-gateway-qa-contexts-2026-10-14.json`. These files contain no credentials or real student work but include authored question/generated content; do not publish them in this public repository. The durable runtime still stores only request/assistance metadata, not the generated copy.

QA-account SQL readback confirmed one delivered AB receipt, one failed BC receipt and one attempted-call row each. Neither session had an existing draft, so this smoke test does not certify real submit/assistance propagation; the separate role-correct rollback tests cover that mechanism. Restoring the entitlement expiry is not account cleanup, which remains a separate action.

Gateway key setup is resolved, and at least one real generation succeeded. Successful BC/Chemistry generation, MCQ fixtures/coverage, before/after/revision matrix, conceptual-subpart red-team QA, independent private-app review, actual submission/visual checks and exact Production rollout/smoke remain open. The existing grader's separate OpenAI connection was not changed or retested. No Production release or independent PASS is inferred.
