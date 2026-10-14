# More help — fixes after first live Gateway QA

**Date:** 2026-10-14 (America/New_York)
**Status:** Sampled fixes verified with three successful live FRQ responses; broader independent/release QA remains open
**Backend code:** `9ac7ee3a3fc1a00497844604650c9952e9dd863c`, [PR #439](https://github.com/david-bloom/Cramapple/pull/439)
**Original evidence:** [First Gateway run](MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md), preserved unchanged

David asked to fix the AB conceptual-subpart disclosure, BC validation failure and missing Chemistry coverage. No general provider switch, credit purchase, new credentials, student data, migrations or Production change is introduced.

## Implementation

- Protect each FRQ subpart in the system instructions, including conceptual explain/justify answers, rather than withholding only final numerical answers for the whole question.
- For the observed average-rate “explain why this does not work/cannot give a value” trap, exclude answer-bearing undefined-at-a-point facts from both the before-phase model context and the returned reference list. Keep available broader limit guidance; fail honestly if no suitable facts remain. After-grade sources are preserved.
- Reject the observed undefined/zero-denominator/no-elapsed-time conclusions before submission. This is targeted protection for the observed pattern, not a universal semantic classifier or blanket matching against every choice/number. Given endpoint values and method/inspection guidance remain usable. Independent human red-team QA across other conceptual prompts is still needed.
- Make the existing local limits explicit in schema field descriptions and model instructions: headline 100 characters, explanation 1,400, next step 400, at most three follow-ups of 100 characters each. Keep strict local validation; do not truncate scientific explanations, silently accept malformed output or add automatic extra model retries.
- Log only an allowlisted validation reason (JSON, field type/empty/length, follow-up count/type/length, source IDs, explicit disclosure or conceptual subpart). No field values, prompt, work, identity, provider body or token enter diagnostics or the public error response.

Schema descriptions follow the [Anthropic structured-output guidance](https://platform.claude.com/docs/en/build-with-claude/structured-outputs): unsupported native constraints can be described while application validation still enforces them. More help keeps the [Gateway Chat Completions schema interface](https://vercel.com/docs/ai-gateway/sdks-and-apis/openai-chat-completions/structured-outputs). This is code compatibility evidence, not a claim that the lost original BC output is now understood.

## Verification

22 backend tests and Deno index typecheck pass. New regressions cover answer-bearing fact exclusion, no suitable remaining source, preserved post-grade sources/answers, observed conceptual conclusions versus valid setup, withheld overlength output, no delivery commit on validation failure, malformed follow-ups and diagnostic privacy. Offline replay of the exact first-run AB response is rejected with `conceptual_subpart`.

Development more-help v7 ACTIVE / verify_jwt true, bundle SHA-256 `dc41c5a7318cda1bd630c9c868d25cdd30be3687c1f92bc498e4bdb866a9bca6`, deployed from the code checkpoint above. The first deployment attempt omitted shared imports; its bundle was rejected without changing the active function. The complete shared-dependency bundle was then deployed successfully.

Original BC raw output was deliberately not persisted by the runtime, so its precise validation failure remains unproven. These changes supply missing bounds and a safe diagnosis for a reproduction; do not claim the original cause was definitively a long headline. Chemistry was not called in the first run and must receive actual coverage.

## Approved live verification — completed

David explicitly replied **“I approve the bounded QA request.”** The approved ceiling was six requests through Vercel AI Gateway to Anthropic using the same three authored unanswered FRQs, published facts and disposable QA account; empty work/focus, 2,500-output-token cap, no real student data or automatic retry loop. Only **three of six** requests were needed. No second round or extra diagnostic calls were made.

| Subject / before-phase FRQ | Actual HTTP outcome | Elapsed | Sources | Producer content inspection |
| --- | --- | --- | --- | --- |
| Calculus AB | 200 / ok true | 4.85 s | 1 | Prompts inspection of numerator/denominator meanings and interval endpoints; does not state the withheld undefined/zero-denominator conclusion. The answer-bearing convention is absent. |
| Calculus BC | 200 / ok true | 3.33 s | 1 | Supplies a setup/calculator action without computed averages or the conceptual conclusion; passes every local output limit. |
| Chemistry | 200 / ok true | 5.32 s | 3 | Guides mass → moles → particles/atoms and units; provides no calculated numeric answers. |

Requests started at 08:54:34, 08:54:39 and 08:54:42 New York on October 14 (12:54 UTC). Each new durable receipt is **delivered** with exactly one attempted-call row and generation 1. The three sessions have zero existing drafts, so these calls do not certify the real grade/submission flow; earlier role-correct SQL tests cover the underlying draft-propagation mechanism.

Only the existing three expired QA subject entitlements were temporarily extended. Original expiry was restored on all three rows, with affected-row count verified. No new Auth identity, email, real student record, Production change, key extraction or credit purchase occurred. Task-fixture cleanup remains a separate action; restored entitlement dates are not a claim of account deletion.

Private output artifact: `/private/tmp/more-help-gateway-fix-results-2026-10-14.json`, permissions 0600, SHA-256 `f614da59227175ad3a17fb4fc67396c4f3ce4466b71b98a33fe3d6b76fa601ed`. It contains authored/generated content but no credentials or real student work; do not upload it to this public repository. Gateway token usage and dollar spend were not returned by the student-facing endpoint, so no cost estimate is asserted.

## Disposition and limits

The three reported issues are addressed for these sampled cases: the observed AB disclosure is rejected offline and absent in the new live response/reference list; BC now returns valid live help; Chemistry has actual successful live coverage. The original BC raw output was not retained, so its exact historic cause remains unknown. Added bounds and safe diagnostics improve the contract without pretending that cause was recovered.

This is producer verification, not an independent PASS or universal semantic no-leakage guarantee. Independent/human red-team review, Development MCQ fixtures, MCQ/after-grade/revision coverage, actual authenticated submission/photo/visual flows, exact publication delta and Production rollout/smoke remain open. Existing grader provider setup was not changed or retested. App PR #21 remains draft. Production was not modified by this verification.
