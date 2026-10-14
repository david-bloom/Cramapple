# More help — Lovable QA disposition and Claude review checkpoint

**Historical checkpoint:** The code/version counts below record the first Lovable remediation. See [Claude disposition](MORE_HELP_CLAUDE_QA_DISPOSITION_2026_10_13.md) and [October 14 live Gateway QA](MORE_HELP_GATEWAY_LIVE_QA_2026_10_14.md) for later fixes and observed remaining failures.

**Date:** 2026-10-13 (America/New_York)
**Status:** Remediation implemented; fresh independent QA pending; production release held
**Original review:** [Owner-supplied Lovable QA](QA_MORE_HELP_LOVABLE_2026_10_13.md), proposed FAIL on app `24fd79f` / backend `ad405dc2`
**Fresh review request:** [Claude adversarial prompt](MORE_HELP_CLAUDE_ADVERSARIAL_QA_PROMPT_2026_10_13.md)
**Current backend code:** `430fe2bda1d279670ea8518ac86d543a16cf3fc2`, [PR #435](https://github.com/david-bloom/Cramapple/pull/435)
**Current app code:** `30a65daed1ee1dd88e74b8f20f904ffffaab410b`, [draft PR #21](https://github.com/david-bloom/ap-prep-blueprint/pull/21)

## Blocking findings

| Lovable finding | Action and evidence | Disposition |
| --- | --- | --- |
| 1. Grader never hears about More help | QxView tracks delivered/reloaded receipts and sends `moreHelpUsed`; actual typed/MCQ grading calls use it in `assisted`. Added QxView interaction tests through real grading helpers with stubbed network: `create_attempt` gets coached and `evaluate-attempt` gets coached / `independent_diagnostic_evidence:false`. No duplicate ordinary hint is appended. Found and fixed photo preparation/evaluation/retry assistance too; tested photo preparation with zero ordinary hints. | Implemented; full route/deployed photo flow and concurrent receipt races still need Claude/live verification. |
| 2. Failed help coaches attempts; fresh retry IDs | New migration separates reserved, failed and delivered state. Only `commit_question_help` coaches drafts; generation/validation/commit failure produces no disclosure or coaching. Same input retries reuse a receipt/ID with a lease and bounded attempts. Client retries retain their ID; terminal duplicate/exhaustion permits a new request. Backend tests assert no commit on provider failure, failure acknowledgement, and withheld help on commit failure. Transactional SQL checks passed retry reuse, failed-generation independence and future/current draft coaching. | Implemented; failed provider calls still count toward request quotas, as abuse/cost protection. No student payment charge is introduced. Concurrency/lease review remains open. |
| 3. Unsanitized source copy and excess/unrelated hooks | All visible help/reference/hook copy passes `sanitizeStudentCopy`, preserving identifiers. Hook selector prefers owner topic, then explicit reuse tags, and returns the selected source identity. UI displays that one hook on that source only, even when two sources reuse the same hook ID. Tests cover sanitizer, topic selection and actual single-hook DOM output. | Implemented; published source-shape and formula-body data checks remain in Claude's scope. |
| 4. Highlights split LaTeX | Split the stem into whole math/plain segments before applying highlights to plain text. Shared Formula renderer gets intact math. LaTeX-stem regression passes. | Implemented; full glyph measurement/embedded figure coverage still requires review. |
| 5. Second stylesheet/component governance | Removed `more-help.css`; all layout styles are in existing `question-experience.css`. App AGENTS explicitly records the owner's October 13 real-app request and accepted separate MoreHelp template. Ordinary page, navigation and mounted answer remain in their existing implementation. | Addressed within existing owner scope; no additional owner approval requested. This is not an ordinary-page replacement. |
| 6. Real generation fails | Added diagnostics containing only upstream status/error code. Approved empty-work Development tests found `429 credit_balance_exhausted`; no successful generation. The final Development function is v4 with JWT verification. No model calls were made for the remediation deploy. | **Still blocked.** No purchase/top-up, provider/credential switch, unchanged retry or mock success. Strict-schema/model compatibility and explanation quality remain unverified against real successful responses. |

## Additional limits and fixes

- Server-reported `attempt.status:draft` or `resume.action:continue_draft` forces before-phase context, even with client `phase:after` and an old grading object. Test verifies recorded grade/answer feedback are absent. A revision that has not yet created a server draft is still limited by what the student already saw; Claude must assess that boundary.
- Delivered receipt text remains visible after grading as “More help used on this question”; it does not claim to change a prior locked grade. Touch targets are at least 44px in the help stylesheet.
- Loading announcements use a mounted status region and effect-updated text. Screen-reader behavior still needs independent verification.
- Pre-submission answer withholding remains prompt-only. The model may infer an answer from stem/choices/references. There is no deterministic semantic guarantee; adversarial content QA is a release condition.
- Visual refusal covers `hasStimulusImage`. Diagram references and stem-embedded figure dependence need further coverage/data inspection. Formula bodies are rendered as TeX following the existing reference convention; real published prose/formula shapes need independent verification.
- Global reservation lock remains a throughput constraint. Receipt-read errors remain a visible-status/race review target. Backend grading already derives stored assistance from attempt/hint counts; Claude must still trace client context and independent-evidence consistency end to end.

## Verification and limits

App: **115 files / 1,101 tests pass**; TypeScript and build pass. Backend: **9 tests** and typecheck pass. Existing rolled-back Development SQL assertions cover private grants, foreign ownership/entitlement denial, bounded same-receipt retries, duplicate denial, failed-generation independence, existing/future draft coaching, submitted-attempt preservation and fresh-session independence.

Tests use controlled fixtures and stub network responses. The new submission tests cover QxView and real grading helpers; their submit callback reproduces the route mapping and does not mount the full authenticated route. Photo test verifies preparation, not a real photo's capture/transcription/evaluation. Local scripted desktop/phone screenshots do not certify successful live generation or final published app behavior. These limits are explicit in Claude's prompt.

Development migrations `20261014001227` and `20261014005146` are applied; function v4 uses current backend source. Production is unchanged and app PR #21 remains draft/unpublished. The original FAIL is preserved. Producer remediation is not an independent PASS or a Done decision.

The temporary task-local Development QA account/session fixtures remain pending cleanup after a cancelled cleanup transaction; a subsequent read confirmed one task account and three learning sessions remain. Credentials stay in a private temporary file, are not in GitHub and must not be read by the code reviewer. This is separate from the owner's earlier declined cleanup of another test account. No cleanup completion is claimed.

Next: Claude independently challenges the current source and these claimed fixes; resolve findings and provider/subscription architecture, then obtain successful authorized real-generation QA and the exact production publication/smoke evidence. User approval already covers the real-app subject scope; it does not imply a billing purchase.
