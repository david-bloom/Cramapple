# More help — paused demo and restart handoff

**Current fixes:** [Subpart/validation remediation](../qa/MORE_HELP_GATEWAY_FIX_QA_2026_10_14.md) is deployed in Development v7; 22 backend tests/typecheck and exact historic-AB rejection pass. Three approved live FRQs now return valid help for AB, BC and Chemistry; the observed subpart disclosure is absent. Broader independent/release QA remains open. Earlier failed-run statements below are historical.

**Latest execution:** [October 14 Gateway live QA](../qa/MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md): key configured, AB generated but appears to disclose a conceptual subpart, BC validation failed, Chemistry not called. Test entitlements restored; release blocked. This supersedes earlier runtime/key checkpoints below.

**Date:** 2026-10-13 (America/New_York)
**Owner / next decision:** David Bloom, after Micah/Orly feedback
**State at original closeout:** Paused by explicit owner instruction; documentation only in that closeout
**Branch:** codex/more-help-session-handoff
**PR:** https://github.com/david-bloom/Cramapple/pull/430
**Canonical decisions:** [MORE_HELP_DECISIONS_AND_DESIGN.md](../product/MORE_HELP_DECISIONS_AND_DESIGN.md)
**Mock/source bundle:** [README](../design-reference/more-help/README.md)

## Resumed production preparation — October 13

David reported very positive student feedback and explicitly confirmed **real Calculus AB/BC and Chemistry questions in app.cramapple.com**. The wait-for-feedback and paused Sites state below are historical. See [WORK-MORE-HELP-PRODUCTION](../tasks/WORK-MORE-HELP-PRODUCTION.md) for current implementation and live-state evidence. Backend PR #435 is implemented in Development; app PR #21 is draft and unpublished. Approved actual-generation tests failed on exhausted OpenAI API credits. Production is unchanged. The latest request is [Claude adversarial code-review QA](../qa/MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md), including the owner's API-versus-subscription question. No Site audience change or invitation has occurred.

PR #430 has landed on `main`; its former remote branch is gone. Read this handoff on `main`, retaining the original branch/PR as historical provenance. The documentation-synchronization section below records the earlier blocked merge, not the current GitHub state.

## Latest Claude QA remediation

Claude’s independent FAIL identified missing runtime-role grants. These are fixed and verified under service_role. David selected targeted disclosure checks plus human red-team QA, separate delivery/request limits and the demo’s Anthropic Gateway path. Development v5 is prepared but needs its Gateway key; Production is unchanged. See the [current disposition](../qa/MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md) for exact code/migration identities, passed rollback tests, private app snapshot and remaining release gates. Earlier resumed-orientation/provider/test counts below are historical.

## What is preserved

- Owner-approved name, mission, both entry paths, immediate focused-help behavior, two-pane layout, content grounding, hook rule and the FRQ-engine reuse opportunity.
- Actual original scripted HTML and screenshot, editable lesson facts, the question-entry screenshot, and a full source archive of the saved live-generation candidate.
- Exact Sites project/version/source identities and a bounded verification history, so no future session needs to infer state from a local directory or this chat.

## Published versus saved

Existing Site: https://cramapple-study-help-demo.bronzeolm65.chatgpt.site

Subject links: append `?subject=calc` or `?subject=chem`.

| State | Identity / evidence |
| --- | --- |
| Sites project | `appgprj_6acce98383c081919ff8366486967cbc` |
| Published scripted source | `bea990edf4fb502e6bef3c6abc3f1d4607dc028a`; preserved as `scripted-mock.html` |
| Saved live-generation source | `39d91166227c314e235e5ca2ff31de1891e0a259`; preserved in `live-demo-source.tar.gz` |
| Saved version | Version **2**, ID `appgprj_6acce98383c081919ff8366486967cbc~appgver_2362c7ec98108191a04c6df181db046e` |
| Version 2 deployment | **None** (`deployment_id:null`, re-read during this closeout) |
| Original saved deployment archive | SHA-256 `ae2c2299febcfce466bb5cc4eb14689a6db2060d6fcebf6da6d99eac068dc832`, 1,576,960 bytes, 76 files; this is the deployment package, not the full editable-source archive added to GitHub |
| Access re-read during closeout | Custom allowlist; only owner dbloom01@gmail.com. No kid viewer grants. |

David sent screenshots himself. No invitations or feedback-request email to the kids were sent by this session. Do not claim the private URL is already usable by them. Do not create a second Site, make this public, add viewers or send emails merely because feedback arrives.

The original scripted publication is an interface mock: fixed explanations, no live generation, no persistent student feedback. It carries earlier wording/steps, including a microcheck. The **later agreed flow** is the direct-to-focused-help flow documented in the product file. The saved live candidate uses that later entry pattern.

## Saved live candidate

Vinext / Cloudflare Worker; D1 binding `DB`; authenticated visitor identity; model calls made server-side through the existing AI Gateway. The checkpoint fixed model is `anthropic/claude-haiku-5.5` (catalog checked at implementation time; revalidate only if model work resumes). Structured repair fields: headline, explanation, next_step, source_ids (1–3 known IDs). Grounding: exact fixed question/solution, curated facts, answer, optional reasoning, chosen focus and same-visitor/same-subject previous help. It does not read production student histories or grade real FRQs.

Limits at checkpoint: 1,000 output tokens; optional reasoning 1,800 characters; focus 120 characters; 100 requests/site and 30/visitor per rolling 24 hours, including failed reservations. Response shape, lengths and source IDs are checked. Same-origin authenticated feedback writes are visitor-owned and idempotent; only the owner can read collected feedback. No student identity/feedback is sent to the model.

Important source files:
- `demo-source.html` — editable UI; run `node scripts/prepare-demo.mjs` **after an authorized edit** to regenerate `app/demo-content.ts`.
- `app/lessons.ts` — fixed questions, verified solutions, facts/source IDs and focus buttons.
- `app/api/check/route.ts` — fixed MCQ checking, not production grading.
- `app/api/help/route.ts` — grounded generation and validation.
- `app/api/feedback/route.ts`, `app/feedback/page.tsx` — reviewer collection / owner reading.
- `db/schema.ts`, `drizzle/0000_moaning_sprite.sql` — local/saved D1 schema.
- `.openai/hosting.json` — existing project ID; preserve it.

`AI_GATEWAY_API_KEY` was configured through Sites as a server-only secret. No key is included in the preserved source, docs or screenshots. The local temporary secret was removed. Do not print, copy into client code or commit a credential. No new account/provider/key or payment is needed simply to reopen the scripted mock.

## Verification and last blocker

Passed at the saved checkpoint: TypeScript, Sites build, local D1 migration; browser question/choice/reasoning/check flow, opening two panes, highlighting and error recovery; feedback save/update, malformed rating, cross-origin/anonymous write rejection and non-owner read rejection.

Actual model calls returned **HTTP 402 / insufficient_funds**, twice. **No successful live-generated explanation was verified.** That was the last observed balance condition; it was not retested during this paused documentation closeout. The next session must verify the current connection only if live generation is explicitly restarted. Do not describe this as a working live demo, silently substitute scripted output or automatically top up/pay.

The `question-entry-preview.jpg` shows question/answer entry and checking, not successful live generation. The scripted screenshot is a historical scripted explanation, not AI output.

## Restart after feedback

1. Read `docs/INDEX.md`, the product decisions file and this handoff. Incorporate the kids' actual feedback and David's direction.
2. Keep the pause unless David explicitly restarts. Feedback alone does not authorize building or publishing a live demo.
3. For a requested immediate mock rendering, reopen `docs/design-reference/more-help/scripted-mock.html` (no server/model needed). Use the preserved screenshots as references. Adapt only the agreed changes; respect the later direct-to-focused-help behavior rather than blindly restoring the old microquiz gate.
4. For an explicitly requested dynamic demo, extract `live-demo-source.tar.gz` to a new working folder or reopen the same Sites source repository. Follow the current Sites skill; preserve project ID and current audience. Recheck model availability/credits and obtain a successful generation before publication or inviting students.
5. Run relevant checks for changed UI/behavior, confirm desktop/phone flow, and verify that the saved help/feedback is owned by the current reviewer. An unchanged saved version can be deployed only after live-path validation and owner direction; changed source needs a newly saved version.
6. If David asks to send links, re-read access, preserve the complete existing allowlist, add only the named reviewers and send the specific requested invitation. Do not infer this from the earlier, superseded email request.

Historical supplied recipients (not contacted here): Orly obloom27@solebury.org; Micah mbloom29@solebury.org. Their name-to-subject assignment was not confirmed; both demos are available for either child.

Suggested restart prompt:

> Restart More help from `docs/handoffs/MORE_HELP_SESSION_HANDOFF_2026_10_13.md`. Here is Micah/Orly's feedback: [paste]. Render the revised mock first, using the agreed two-pane direct-to-focused-help flow. Reuse the saved artifacts; tell me if a live generation step still has a dependency. Do not add unrelated functionality.

## Separate notification work at session end

The student issue-report feature is **not More help**. Its sole purpose is emailing David the current subject/question and optional comment, via “See something wrong or confusing?”. It is preserved separately in backend PR #428 and App PR #17, both still draft when re-read for closeout. The controlled Development email send and idempotent retry succeeded; David confirmed “Test email received. Looks good.” No new Development database rights were requested or needed.

No Production migration, report-endpoint deployment, App merge or Lovable publish occurred. The approved temporary Development test account still existed after deletion was declined (one account, checked). The temporary password file was removed. The notification record is updated on its own branch; do not silently treat its release or cleanup as completed or make it a dependency of More help. David explicitly said there is no additional review and narrowed that feature to simple notification only. An automatic tool approval check rejected changing the App PR out of draft because it interpreted that wording as forbidding a review/release-state change; do not invent a new product reviewer or broader permissions requirement.

## Do not touch on restart

- The paused demo/site, access grants and invitation emails until explicitly restarted/authorized.
- Production Cramapple, grading engines/history schema or mastery logic just to render a mock.
- Unrelated dirty work in the primary Cramapple checkout.
- Auth/payment/email-provider configuration or billing in response to the historical Gateway error.
- The separate issue-report release/cleanup without its own requested continuation.

**Next owner and action:** David supplies the kids' feedback and an explicit restart instruction. The next implementation session starts from this handoff, not a fresh demo build.

## Documentation synchronization

The complete handoff/artifact bundle is preserved on `codex/more-help-session-handoff`, PR #430. Automatic approval review rejected the attempted documentation-only merge into main because it required explicit merge approval; no merge occurred and no alternative merge path was attempted. Future sessions should open this branch/PR directly until it is promoted. This is not a demo deployment or a new product review gate.
