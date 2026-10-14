# More help — release QA follow-up (remediation review)

**Date:** 2026-10-14 · **Reviewer:** Claude (Sonnet 5.5). The original `QA_MORE_HELP_RELEASE_2026_10_14.md` is untouched.
**Covers:** backend PR #442 head `faba88f1` (code `c8a978b3`, base `70f4a348`); app PR #24 head `75b036b2` (base `75c0b18`). Both PRs still draft/open. Environments: Development (read-only metadata), Production (read-only metadata). No model/grading/photo calls, no writes.

## 1. Verdict

| | Verdict |
| --- | --- |
| **Code readiness** | **FAIL (narrow)** — the F2 widening introduced a new false-positive defect (N1) that rejects ordinary correct help; one concrete fix needed. F1, F4, F5 fixes verified. |
| **Release readiness** | **NOT READY** — Production still has 0 of 4 migrations, no receipts table, no function (re-verified); MCQ, after-grade, browser and human-review evidence still absent; approvals pending as you stated. |

Checks run: backend `deno test` 26/26, `deno check` clean; app `vitest` 118 files / 1,130 tests, `tsc` clean (build not re-run by me). Dev `more-help` v8 ACTIVE, `verify_jwt=true`, `ezbr_sha256` `adaad334…3287` matches the stated value; **bundle-to-source correspondence is not independently proven** (metadata only).

## 2. Findings

### N1 (P1, confirmed) — Widened choice-disclosure regex is case-insensitive, so ordinary English trips it
`validateHelp` (`contract.ts`, the new "Explicit conclusions/choice disclosures" test) uses `[A-E]` under the `/i` flag, so the article "a" and any word starting a–e match as choice letters. Executed against `validateHelp(..., before=true)` — all **BLOCKED as `explicit_answer`**, though they are legitimate setup guidance:
- "Try matching each term to the power rule." / "Start by matching data in the table…" / "…matching exponents on both sides." (`matching\s+\(?[A-E]\)?` has no word boundary)
- "Eliminate a common factor first, then differentiate." / "Rule out a sign error by checking the units." (`eliminate|rule out … [A-E]\b`)
- "Since the table gives it, so the value is 3 at x=2; use that as your starting point." (restating a given value after "so")

**Impact:** a model response containing such phrasing — "matching" is very common in calculus/chemistry tutoring — is discarded; the student gets `answer_disclosure` ("try a narrower focus"), no help, a consumed attempted-call (cost), a released delivered allowance. Intermittent, model-dependent, and invisible to the 26 tests because they use only the five red-team strings. The 1,130 app tests cannot see it.
**Smallest fix:** keep the word alternatives case-insensitive but make letter classes case-sensitive and context-anchored (`(?-i:[A-E])` or split into two regexes), require `\b` after the letter, and require "choice|option|answer" or parentheses for `matching`/`eliminate`/`rule out`; drop or tighten the `so … value is <digit>` branch (it fires on restated given values, which the contract says must stay usable). **Regression:** the six strings above must PASS; the five originals must BLOCK.

### N2 (P2, confirmed gap, expected under the owner's decision) — Tripwire remains phrase-specific
Still PASS: "(B) is correct.", "B is the best choice.", "Go with B.", "Option B works here.", "The answer lies in choice B.", "Only D fits.", "Thus f'(2) is 12.", "The limit is 3.". Follow-ups are scanned but only by the same regexes ("Is B correct?" passes). This is the targeted-plus-human design, so it is not a defect; it means MCQ/numeric pre-answer safety rests on human red-team that has not happened.

### N3 (P2, source-only hypothesis needing browser) — TaskPane no longer remounts on state change
App change: `TaskPane key` was `session:ordinal:state`, now `session:ordinal:versionId` (needed so More help survives grading). TaskPane keeps `activeTab`, `draft`, `choice`, `revising`, `photoOff` in local state initialised from `state` (e.g. `activeTab = state==='review' ? null : firstOpen`). Previously practice→review reset these; now they persist (reference tab stays open after scoring; MCQ `choice` and FRQ `draft` stay populated; any review→practice transition for the same version keeps the old choice/draft). Unit tests pass, but none assert the old reset. Needs a mounted check on: post-submit tab state, MCQ revise/retry choice reset, FRQ draft after scoring, photo panel flags.

### N4 (P3) — Sibling source phrasings still survive
With the rate-trap stem, sources saying "has width zero so it gives 0/0", "is indeterminate", "gives no rate" are kept; "not defined / does not exist / cannot be computed / is meaningless / divides by 0" are dropped (reference then fails closed: `reference_unavailable`). Stems "Justify why the Mean Value Theorem does not apply…" and "…is not the same as f'(2)" still trigger no boundary (correctly out of the targeted rule). Stems containing "undefined" with "explain how…" do trigger it (false positive, harmless: extra boundary). All human-dependent as stated.

### Fix verification
| Finding | Result |
| --- | --- |
| F1 whole-source scan | **Fixed.** `sourceVisibleCopy` covers title, body, caution, items, hook text/whenToUse/caution/expandsTo; my original caution/item/hook reproducer is now dropped. |
| F2 wider tripwire | **Original five now blocked; over-broad (N1).** |
| F3 sibling phrasings | **Partially fixed**: "cannot be found", "is not defined" now trap; MVT/Chemistry remain human-QA, as disclosed. |
| F4 lost response | **Fixed.** Server flags `assistanceRecorded` on `request_already_used`; client has dedicated copy, "Request new help" mints a fresh id and discloses the extra allowance; bounded in-memory cache (8) lets edit/revert reuse received help with no call. Not persisted to storage. |
| F5 grading transition | **Fixed in source**: receipt-in-flight response is shown after state flips, with a "requested before you submitted" notice and an "Explain my scored answer" action. Behavior in a real browser unverified; see N3 for the key change's side effects. |
| F6 glyph measurement | **Open** (needs signed-in page). |

## 3. Coverage (unchanged from the first report except where noted)
All MCQ cells and all graded/revision FRQ cells: **blocked** (Dev still has 0 MCQs; no authorization for the fixture or the 12-call round; no browser). FRQ unanswered: observed-live by the producer only (three empty-work calls, pre-remediation v7 content). Remediation logic: local-executed (my reproducers) plus source-only. **Human review of any generated output: not performed.** Original SQL runtime tests were not re-run; migrations are unchanged by the remediation (backend diff touches only `contract.ts`, `handler.ts`, tests, docs).

## 4. Minimum ordered release checklist
1. Fix N1 with the regression above; re-run the 26 tests plus the six new passing strings.
2. Mounted-browser check of N3 (post-submit state, MCQ retry/revise, photo flags) — can be done on the app PR build against Development.
3. Merge #442/#24 after review; redeploy Dev v9 and compare bundle hash to source built at the merge commit.
4. Authorize and create the pinned Dev MCQ mirror; run the bounded live round (suggested ≤12 calls) with a human reading every output, including a conceptual FRQ per subject and an MCQ with a leading focus.
5. Signed-in Dev browser pass: desktop and 375px, keyboard/Escape/focus return, live regions, 16px glyph measurement (F6), submit-after-help for MCQ, typed FRQ, photo.
6. Verify grading availability (separate OpenAI connection).
7. Production: four migrations in order (all sort after `20261013131212`); rolled-back `more_help_runtime.sql` as `service_role`; deploy `more-help` `verify_jwt=true`; confirm origin list includes the app origin and one Gateway smoke call; publish app at a named commit; signed-in Production smoke.
8. Rollback: republish the previous app version first; keep new tables/functions in place (additive, older function versions fail closed against revoked signatures). Do not redeploy an older function as rollback.

**Later (not gates):** global advisory-lock scaling, load certification, Dev fixture/account cleanup, recovery of the lost BC response, a semantic leakage classifier.
