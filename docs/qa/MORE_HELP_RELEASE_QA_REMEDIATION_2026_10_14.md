# More help — release QA disposition and next test plan

**Date:** 2026-10-14 (America/New_York)
**Status:** Confirmed code defects remediated; Development v8 deployed; independent/live release QA still pending
**Independent report:** [Claude release QA](QA_MORE_HELP_RELEASE_2026_10_14.md), preserved unchanged (local original commit `e5850eda`, FAIL narrow / NOT READY)
**Backend code:** `c8a978b315b50d19ad43e01c368d389f0c088468`
**App code:** `75b036b26ff39537d338ad87336b5746965e299e`
**Draft PRs:** [backend/docs #442](https://github.com/david-bloom/Cramapple/pull/442), [private app #24](https://github.com/david-bloom/ap-prep-blueprint/pull/24)

## Findings and action

| Finding | Disposition |
| --- | --- |
| F1 — answer in caution/items/hooks | Confirmed. The source predicate now scans title/body/caution, item labels/meanings and every visible hook/expansion/use/caution string before model or client disclosure. Regressions inject the observed answer in each field; the entire tainted source is removed, while graded sources stay available. |
| F2 — ordinary verdict/elimination/numeric phrasing | Confirmed coverage gap. Widened explicit tripwires to reject all five supplied examples in every generated-copy field, including follow-ups. This implements the existing targeted-plus-human decision, not a new blanket choice/number equality policy. Given values and setup guidance remain allowed; post-grade explanations retain permitted disclosure. Human red-team remains required. |
| F3 — sibling rate phrasing | Partially addressed. Explain/justify, cannot be found/computed, not defined and other observed synonyms now receive rate-specific protection across all visible source fields. MVT and Chemistry/general conceptual subparts still rely on the per-subpart instruction plus human QA; no universal semantic classifier is claimed. |
| F4 — lost response / edit-revert | Addressed. Received responses have a bounded, per-mounted-question in-memory cache; a response received during an edit can be reused after reverting. No browser-storage/transcript retention. A lost delivered response gets explicit daily-allowance copy and an explicit “Request new help” action; close/reopen cannot automatically mint a new request. Exact already-delivered requests acknowledge durable assistance without a new model call. “Charged” means allowance consumption here; no monetary student charge was demonstrated. |
| F5 — submit during loading | Addressed. TaskPane lifetime is keyed by served question/version, rather than practice/review state. Pending help survives grading; an earlier before-phase response is identified as setup guidance, without claiming it used later grading. QxView transition regression proves it remains available without a second request; an explicit scored-answer action remains available even when there are no generated follow-ups. Existing grades remain server-authoritative. |
| F6 — glyph measurement | Still open. The independent reviewer reported no measurement, not a confirmed rendered-size defect. Signed-in Development browser measurement remains part of QA. |

## Executed validation

26 backend tests and Deno index typecheck pass. App full suite: 118 files / 1,130 tests pass; TypeScript and build pass. Regressions cover F1 fields, F2 examples/allowed setup, F3 variants, delivered-request acknowledgement, lost-response recovery, edit/revert reuse and the actual QxView practice-to-review transition. A test-fixture grading shape was corrected to the real typed shape; no implementation weakening or typecheck bypass was used.

React lifecycle review: stable served-question/version key, component-scoped bounded response cache, no shared mutable module state or browser storage, existing focus/dialog semantics retained. Current/future assistance and locked-grade authority remain in the existing database/RPC contracts.

Development more-help v8 ACTIVE, JWT verification true, deployed from the backend checkpoint above; bundle SHA-256 `adaad334be1cf61b7075a74935e9e472af21afc69b9d69750f7ebccdb0c53287`. No migrations, Production mutation, Lovable publication or new model/grading/photo calls in this remediation. The original report and original failed/successful live evidence remain intact. Producer fixes do not constitute an independent PASS.

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
