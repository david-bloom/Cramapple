# More help — release QA disposition and next test plan

**Date:** 2026-10-14 (America/New_York)
**Status:** Confirmed code defects remediated; Development v10 deployed; independent/live release QA still pending
**Independent report:** [Claude release QA](QA_MORE_HELP_RELEASE_2026_10_14.md), preserved unchanged (local original commit `e5850eda`, FAIL narrow / NOT READY)
**Backend code:** `8c437bd4d96456e3693fcee067412e532774d1da`
**App code:** `e1d49d9ed4ed1be1e14897c6db967f9d49b5042b` (phase reset plus nested-fraction fix)
**Review PRs:** [backend/docs #442](https://github.com/david-bloom/Cramapple/pull/442), merged; [private app phase reset #25](https://github.com/david-bloom/ap-prep-blueprint/pull/25), merged at `7b81177`. App #24 merged externally before this fix was pushed; it contains the original pending-help/cache changes.

## Findings and action

| Finding | Disposition |
| --- | --- |
| F1 — answer in caution/items/hooks | Confirmed. The source predicate now scans title/body/caution, item labels/meanings and every visible hook/expansion/use/caution string before model or client disclosure. Regressions inject the observed answer in each field; the entire tainted source is removed, while graded sources stay available. |
| F2 — ordinary verdict/elimination/numeric phrasing | Confirmed coverage gap. Widened explicit tripwires to reject all five supplied examples in every generated-copy field, including follow-ups. This implements the existing targeted-plus-human decision, not a new blanket choice/number equality policy. Given values and setup guidance remain allowed; post-grade explanations retain permitted disclosure. Human red-team remains required. |
| F3 — sibling rate phrasing | Partially addressed. Explain/justify, cannot be found/computed, not defined and other observed synonyms now receive rate-specific protection across all visible source fields. MVT and Chemistry/general conceptual subparts still rely on the per-subpart instruction plus human QA; no universal semantic classifier is claimed. |
| F4 — lost response / edit-revert | Addressed. Received responses have a bounded, per-mounted-question in-memory cache; a response received during an edit can be reused after reverting. No browser-storage/transcript retention. A lost delivered response gets explicit daily-allowance copy and an explicit “Request new help” action; close/reopen cannot automatically mint a new request. Exact already-delivered requests acknowledge durable assistance without a new model call. “Charged” means allowance consumption here; no monetary student charge was demonstrated. |
| F5 — submit during loading | Addressed. TaskPane lifetime is keyed by served question/version, rather than practice/review state. Pending help survives grading; an earlier before-phase response is identified as setup guidance, without claiming it used later grading. QxView transition regression proves it remains available without a second request; an explicit scored-answer action remains available even when there are no generated follow-ups. Existing grades remain server-authoritative. |
| F6 — glyph measurement | Local browser pass found innermost nested fraction digits at 11.7px; More help now opts into display-sized fractions, measuring 23.4px in the tested expressions. [Browser evidence](MORE_HELP_BROWSER_QA_2026_10_14.md) covers actual components with mocked transport/scoring at 1280/375 CSS px. David confirmed correct rendering on October 14; owner visual acceptance is recorded. Authenticated served-content measurement remains open because the confirmation does not specify environment/version. |

**Session close:** QA docs #448 merged at `c06860b3`; owner rendering confirmation recorded. See [current handoff](../handoffs/MORE_HELP_SESSION_CLOSE_2026_10_14.md) for next owner/action and remaining gates. Earlier draft-state statements below are historical.

## Latest follow-up action

[Local browser QA and action record](MORE_HELP_BROWSER_QA_2026_10_14.md): N3 controls, pending-help retention and keyboard/layout checks executed in real components with synthetic transport/scoring. Additional nested-fraction fix is pushed to draft app #25. Current app validation: 119 files / 1,144 tests, TypeScript and build pass. Backend #442 merged externally; no new deployment. These producer checks do not close the independent/live release gates. Earlier counts/checkpoints below remain historical evidence.

## Executed validation

26 backend tests and Deno index typecheck pass. App full suite: 119 files / 1,142 tests pass; TypeScript and build pass. Regressions cover F1 fields, F2 examples/allowed setup, F3 variants, delivered-request acknowledgement, lost-response recovery, edit/revert reuse and the actual QxView practice-to-review transition. A test-fixture grading shape was corrected to the real typed shape; no implementation weakening or typecheck bypass was used.

React lifecycle review: stable served-question/version key, component-scoped bounded response cache, no shared mutable module state or browser storage, existing focus/dialog semantics retained. Current/future assistance and locked-grade authority remain in the existing database/RPC contracts.

Development more-help v10 ACTIVE, JWT verification true, deployed from the backend checkpoint above; bundle SHA-256 `20c84b8c4dd2a2f1c81b1f4473f7d9dedc5b9c50f3a89e30884357b18d3a6aee`. No migrations, Production mutation, Lovable publication or new model/grading/photo calls in this remediation. The original report and original failed/successful live evidence remain intact. Producer fixes do not constitute an independent PASS.

## Claude follow-up: N1–N4 (original preserved)

[Claude follow-up report](QA_MORE_HELP_RELEASE_FOLLOWUP_2026_10_14.md), original commit `e365d52b`, is preserved unchanged. Its FAIL verdict covers the prior c8a978b3 / 75b036b2 code, not this new remediation. A new independent verdict is still required.

- **N1 confirmed and fixed:** choice keywords ignore case, while bare choice letters must be uppercase standalone tokens; explicitly labelled/parenthesized choices also work in lowercase. Word beginnings and the article “a” cannot match. The broad “so … value is” conclusion branch is removed. All six supplied legitimate setup examples pass; all five original disclosure examples still fail. Extra controls cover capitalized words, mixed-case keywords and multi-letter symbols. Deno/JavaScript uses a separate captured-letter check; no unsupported inline regex modifier is introduced.
- **N2 targeted additions:** ordinary explicit choice verdicts `(B) is correct`, `B is the best choice`, `Go with B`, `Option B works here`, `The answer lies in choice B`, `Only D fits` and the generated follow-up `Is B correct?` are now rejected before submission and allowed after grading. Generic numeric paraphrases remain human-dependent. This stays within the owner's targeted-plus-human policy; it does not compare output against stored choice text or canonical numeric answers.
- **N3 reachable state retention addressed locally:** state transitions reset comparison tabs, typed draft, MCQ selection, revision/error and photo-control flags, while More help remains mounted. Three new mounted interaction regressions cover FRQ comparison/draft reset, same-question MCQ selection reset and photo availability after a disabled preparation; the pending-help grading-transition regression still passes. Real signed-in browser verification remains open.
- **N4 supplied rate conclusions covered:** `0/0`, `indeterminate` and `gives no rate` now receive the same rate-specific source/output filter. MVT and Chemistry/general conceptual boundaries remain human-dependent; no universal protection is claimed.

Concurrent main updates are preserved: backend documentation merged from `b7c51219`; app main `2563209751c618e52aa69ccc392ea1d9ecf780e2` includes merged #23/#24. App phase reset is in new draft #25, code change `d5ba602e`, integrated checkpoint pinned above. No force push or merge/publication performed by this remediation.

Current validation: 26 backend tests and typecheck; 119 app files / 1,142 tests, typecheck and build pass. No model, grading or photo provider calls were made. Photo preparation in these local tests is mocked; this is not provider/browser evidence.

Development v10 was deployed from backend `8c437bd4`. `get_edge_function` returned all nine deployed entrypoint/dependency files; every name/content matched the exact upload graph byte-for-byte, with no missing or extra files. JWT verification is enabled; bundle SHA-256 is pinned above. This is producer source/deployment verification, available for independent repetition. No database writes, migrations, Production change or app publication occurred.

## PR #442 review blocker — restored rate predicate

GitHub reported BLOCKED despite passing checks and a branch current with main. Main requires all review conversations resolved; the unresolved Vercel thread identified a real missing `zero denominator` / `zero change` alternative. Restored that targeted predicate and added four regressions for spelled/numeric zero, checking both source filtering and generated-copy validation on sibling rate stems. All 26 backend tests and typecheck pass. Development v10 is active with JWT verification; all nine returned source files match the upload graph. No paid call, database write or Production change. The PR conversation can be resolved after this fix is published; release QA gates remain separate.

## Concrete Development MCQ mirror proposal — not executed

Read-only Production queries selected three published, approved MCQs with validated primary cells and no stimulus image; all have four choices and one correct key, agreeing with canonical_answer_1. The exact content keys are absent from Development; published subject packs and matching taxonomy versions already exist. Development lacks the Production serving-unit/difficulty tables, so use the canonical content-only Development copy approach; do not silently create schema or claim full bank parity.

| Subject | Production content key | Version UUID | Topic |
| --- | --- | --- | --- |
| AB | `apcalcab-mcq-u1v-011-v1` | `a007e995-d5a9-480d-b863-2946387f76a1` | 1.10 |
| BC | `apcalcbc-mcq-060` | `50921ffc-23eb-4c4d-ba0b-060753fa1ce9` | 1.10 |
| Chemistry | `apchem-mcq-001` | `d22a425d-8702-43f4-bc38-554f355e04ae` | 1.1 |

Private source export `/private/tmp/more-help-approved-prod-mcq-mirror-2026-10-14.json`, permissions 0600, SHA-256 `6e100f5b8398bcf678d0c95b9cccf9e649da69a3a67efa15d8e33c49898a3140`. Planned Development UUIDs are pinned in `/private/tmp/more-help-mcq-mirror-manifest-2026-10-14.json`. These contain authored bank content/correct answers; keep them outside the public repository.

Proposed writes: 3 items, 3 versions, 12 unchanged choice/rationale rows and 3 copied validated primary topic cells; minimal copied-content approval metadata through the existing Development publication path, clearly attributed to an owner-authorized unchanged Production copy, without inventing a new human/model review. Use the existing Development automation/admin actor per the canonical content-only loader. Walk draft/assigned/reviewed_approved/published without disabling any guard. No existing question is overwritten. Rehearse atomically, verify all text/choice/rationale fields and counts against the pinned export, then commit only the identical verified transaction after authorization.

Prepare up to four QA-owned sessions/items: three MCQ sessions plus one existing Chemistry conceptual FRQ (`7b2c203a-bcea-4615-8461-3ed1830a92b1`, topic 1.3, stem MD5 `5763c2446315e15222ec5171ace166b2`). Existing Calc AB/BC conceptual FRQ sessions and Chemistry calculation FRQ are reused. No Auth account, email, real student data, new content authoring, Production write or provider purchase.

## Proposed bounded live round — not executed

At most **12 More help Gateway requests**, four per subject:

1. Unanswered mirrored MCQ with leading synthetic focus requesting the key/elimination. Expected: safe setup or refusal, never a choice verdict/elimination.
2. Existing FRQ with synthetic partial setup work. Expected: method guidance without finishing a numeric or conceptual subpart.
3. Mirrored MCQ after a real synthetic incorrect submission through the rule-based MCQ grader. Expected: recorded-feedback explanation, unchanged locked score, correct durable assistance. Three synthetic attempts/responses/grade records are part of this test; MCQ routing is rule-based, no OpenAI generation assumed.
4. Conceptual explain/justify FRQ, including Chemistry topic 1.3, with leading synthetic focus. Expected: inspection/setup without the requested conclusion in generated or displayed reference/hook copy.

All requests use the existing task QA account, Cramapple-authored question text, published facts, explicitly synthetic work/focus and recorded QA feedback only. No real student identity/history/work. Gateway model/output cap/timeout unchanged: Anthropic through the existing Vercel Gateway, at most 2,500 output tokens each. No automatic retry loop, extra calls, fallback, top-up or key creation. Inspect any failure before another call, coordinate call counts with browser actions, and do not treat a safe refusal as failed content QA merely because it is not 200.

Temporarily extend only the existing QA subject entitlements and restore their exact original values afterward. Run a signed-in Development desktop/phone/browser pass using these fixtures; measure glyphs and exercise work preservation, real MCQ/typed submission and recovery without exceeding the call budget. Prepare question/output evidence privately for **human reading of every output**; producer/automated inspection is not the required human sign-off.

Open outside this round: full correct/wrong/revision matrix, real FRQ grading and photo pipeline availability (existing OpenAI connection not retested), independent source follow-up, Production migrations/function/app publication/smoke. This proposal grants no write or paid-call permission by itself. Obtain the owner's separate fixture-write and bounded-call decisions first; do not infer them from earlier empty-work FRQ approvals.
