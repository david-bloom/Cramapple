# More help — fixes after first live Gateway QA

**Date:** 2026-10-14 (America/New_York)
**Status:** Implementation tested and deployed to Development; bounded live verification pending approval; release blocked
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

## Next controlled check

A renewed approval request is pending for up to six live requests through Vercel AI Gateway to Anthropic: same three authored unanswered FRQs, published facts, existing disposable QA account, empty work/focus, 2,500-output-token cap per request, no real student data, no automatic retry loop. Inspect any failure before another call. The previous exact approval was capped at three requests and stopped at failure; it does not authorize unlimited retries.

Temporarily extend only the existing three expired QA subject entitlements when executing the approved check and restore their original expiry afterward. Preserve credentials and authored outputs privately. Verify actual returned content and receipt state; passing offline checks alone does not certify no leakage, BC/Chemistry runtime success, the full MCQ/after-grade/revision matrix or release readiness.
