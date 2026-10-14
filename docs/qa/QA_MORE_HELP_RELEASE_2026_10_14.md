# More help — independent release QA

**Date:** 2026-10-14 · **Reviewer:** Claude (Sonnet 5.5), adversarial pass per `MORE_HELP_RELEASE_QA_PROMPT_2026_10_14.md`
**Scope covered:** backend `david-bloom/Cramapple` main `70f4a348` (contains runtime fix `9ac7ee3`); app `david-bloom/ap-prep-blueprint` main `75c0b18` (feature `172c540` + prose-math delta #22, which touches `QuestionExperience.jsx`; no More help logic changed). Remote heads re-verified; neither advanced.

## 1. Verdict

| | Verdict | Why |
| --- | --- | --- |
| **Code readiness** | **FAIL (narrow)** | One confirmed leak path in the pre-answer protection that the producer describes as fixed (F1), plus a trivially bypassed validator (F2). Everything else in the persistence/quota/fencing design held up under source review and the supplied SQL tests. |
| **Release readiness** | **NOT READY** | Production has none of the four migrations and no More help function (verified). MCQ cannot be tested anywhere but Production. No signed-in browser evidence exists. |

No code was changed, nothing was deployed or written. No model, grading or photo calls were made (no new authorization; the earlier approval covered six bounded empty-work FRQ calls, three used). All Supabase queries were read-only and returned counts/metadata only.

## 2. Evidence labels

- **Observed-live (read-only):** Dev function `more-help` v7 ACTIVE, `verify_jwt=true`, bundle `dc41c5a7…9bca6` (matches prompt). Dev ledger has exactly the four migrations with names matching committed files. Prod: **0 of 4 migrations, 0 `*question_help*` functions, no `app.question_help_receipts`, no `more-help` function**; Prod max migration `20261013131212`, so the new versions sort after it (no `db push` ordering trap).
- **Observed-live inventory:** Dev published items: AB 11 FRQ / 0 MCQ; BC 13 FRQ / 0 MCQ; Chemistry 18 FRQ / 0 MCQ. **Prod: AB 355 MCQ + 93 FRQ; BC 352 + 77; Chem 209 + 69.**
- **Local-executed:** backend `deno test` 22/22, `deno check index.ts` clean; app `vitest` 1,127/1,127 (118 files), `tsc` clean. My own reproducers (§3). `npm run build` not run.
- **Source-only:** SQL permission/fencing logic, app component behavior, CSS.
- **Not verified:** that the deployed v7 bundle equals `contract.ts`@70f4a348 (hash cannot be recomputed from source without the CLI bundler); the Lovable-published app version; grading availability.

## 3. Findings

### F1 (P1, confirmed) — Conceptual-subpart source filter only scans title and body; the rest of each source is sent to the model and rendered to the student

`contract.ts` filters sources with `/\bundefined\b/i.test(s.title + " " + s.body)`. A source's `caution`, `items[].meaning` and `memoryHooks[]` (hookText, expandsTo, whenToUse, caution) are not scanned, yet all are (a) sent to the model as `facts` and (b) returned verbatim and rendered by `CheckedFact` (`MoreHelp.tsx`: items `<dl>`, `source.caution`, hook block). **Trigger:** rate-trap stem + any cited source whose body is clean but whose caution/item/hook states the convention. **Reproduced** (`helpContext`): body-clean source with caution "…the rate is undefined", item meaning "undefined", and a hook is kept; `caution` and hook survive intact. Expected: the answer-bearing fact absent from model input and rendered list (the prompt requires checking "the entire rendered help/reference list"). Impact: the exact observed answer reaches the student pre-answer, without the model misbehaving.
**Smallest fix:** apply the predicate to a flattened string of every student-visible/model-visible field of the source (or drop the field), and strip `memoryHooks` from sources when `rateTrap`. **Regression:** the repro above as a contract test.

### F2 (P1/P2, confirmed gap vs. an accepted tripwire) — Before-phase validator misses ordinary disclosure phrasing

Executed against `validateHelp(..., before=true)`; all of these **pass**: "Choice B is right.", "Eliminate A and C; B remains.", "So f'(2) equals 12, matching (B).", "The result you want is 12.", "Therefore the limit is 3." Only "answer is/=", "correct|final choice|option|value|result is" and "select/choose/pick X" are caught. Choice elimination is explicitly forbidden by the system prompt but has no tripwire. David accepted targeted checks plus human red-team, so this is not a contract breach; it means **the human red-team is the only real control for MCQ and numeric FRQ**, and it has not occurred (all three live outputs were empty-work unanswered FRQs, no MCQ). Cheap strengthening that stays targeted: reject `\b[A-E]\b` adjacent to `right|correct|remains|eliminate|rule out|wrong`, and "eliminate/rule out" generally for MCQ items; for MCQ also reject output containing a choice's full text next to "is correct".

### F3 (P2, confirmed) — Rate-trap detector and "undefined" predicate are single-phrasing

`conceptualRateTrap` requires "average velocity|rate" + "explain why" + "does not work|cannot give a value". Repro: "Explain why the average rate of change cannot be found on [3,3]", "Explain why the average velocity is not defined on [2,2]" and "Justify why the Mean Value Theorem does not apply" produce no `coachingBoundary` and keep the source. Likewise sources saying "is not defined / does not exist / cannot be computed / is meaningless" pass the `undefined` filter. The producer stated this is observed-case targeted; this confirms **no protection exists for sibling phrasings or other conceptual FRQs in all three subjects** (Chemistry "explain why…" parts have no equivalent). Treat as a known, human-red-team-dependent risk, not a blocker by itself.

### F4 (P3, confirmed by source) — Lost response / same-signature reuse charges twice and shows a generic error

`MoreHelp.tsx` reuses `requestId` for an identical `[focus, work, before]` signature. If the first call committed but the response was lost, or the student edits work then reverts it (help hidden, `pending` still holds the delivered id), the retry returns `request_already_used` (409), which has no entry in `helpErrorCopy` and renders "More help couldn't connect". "Try again" then mints a new id and consumes a second delivered allowance. Content is intentionally not stored, so it cannot be re-served. Fix: dedicated copy and, on `request_already_used`, auto-mint a fresh id once (accepting the second charge) or tell the student their allowance was used.

### F5 (P3, source) — Submitting while help is loading discards a charged, delivered response

`TaskPane` is keyed on `state`, so submit remounts `MoreHelp`; the in-flight response is dropped (`mounted`/`epoch`), but the server may already have committed. Allowance consumed, nothing shown; pre-submit coaching is correctly *not* applied (attempt already submitted). The trigger is disabled while `busy`, so only a click-then-submit race reaches it. Low impact.

### F6 (P3, not measured) — Math glyph floor
CSS text is ≥16px, square, no transitions, ≥44px targets (source-only). KaTeX scripts render below 16px; I did not measure the smallest rendered glyph (needs an authenticated page). **BLOCKED.**

### Verified sound (source + supplied SQL tests; not re-run against a database)
Invoker runtime privileges: `service_role` holds baseline `UPDATE` on `app.attempts`; migration 3 adds receipts `UPDATE` and events `SELECT/INSERT`; old function signatures revoked from `service_role`; no SECURITY DEFINER added (the only definer functions are the pre-existing trigger and `has_question_help`). Generation fencing (`delivery_attempts = p_generation`, lease check) rejects stale/expired workers; lease 50s > model timeout 35s. Attempts are always inserted as `status:'draft'`, so the `AFTER INSERT` trigger coaches future drafts. Delivered-allowance vs attempted-call accounting is separate and advisory-locked. Server forces before-context when a draft exists or grading is absent; `uncertain` after-phase returns 409. Ordinal/session/question/subject/entitlement gates run before any model call. Diagnostics are allowlisted and content-free. Client cannot supply a grade or phase that weakens protection (client "after" on ungraded forces "before"; client "before" on graded is stricter).

## 4. Prior findings status
P0-1 fixed (source + SQL test). P1-1 tripwire only, see F1–F3. P1-2 **still open** (Dev has 0 MCQs). P1-3 app now reviewed (this report). P1-4 Gateway path chosen. P2-1…P2-5, P3-6…P3-10 fixed/retained as the follow-up report states; I found no contradiction in source. P2-4 (hook metadata) fixed for `sourceNote`, but see F1: the *allowlisted* hook/caution fields bypass the conceptual filter.

## 5. Coverage matrix (L = observed-live, S = source-only, X = executed locally, B = blocked)

| Subject | MCQ unanswered | MCQ graded wrong/partial | MCQ correct | MCQ revision | FRQ unanswered | FRQ graded wrong/partial | FRQ correct | FRQ revision |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Calc AB | B (0 Dev MCQs) | B | B | B | S/X; producer L (empty work, 1 call) | S | S | S |
| Calc BC | B | B | B | B | S/X; producer L | S | S | S |
| Chemistry | B | B | B | B | S/X; producer L | S | S | S |

Photo/hand-drawn submit-after-help: **B** (needs Dev FRQ with photo pipeline, grading connection unverified). Browser (desktop/phone/a11y/keyboard): **B**, no authenticated session or approved Dev app target. Human judgment of generated outputs: **not performed by me** (no calls); only the producer's three empty-work FRQ outputs exist, and no human red-team of them is recorded.

## 6. Minimum ordered release checklist
1. Fix F1 (+ regression); decide on F2 strengthening and F4 copy (small).
2. Provide an MCQ fixture in Dev: unchanged mirror of approved Prod MCQs (≥1 per subject) with their reference entries/labels; prerequisite for any MCQ cell. Needs new write authorization; I prepared none.
3. Authorize a bounded live round (suggest ≤12 Gateway calls on the QA account): per subject one MCQ unanswered with a deliberately leading `focus`, one FRQ with partial work, one after-grade; human reads every output; include a conceptual "explain/justify" FRQ in each subject.
4. Authenticated Dev browser pass (desktop + 375px, keyboard/Escape/focus return, live-region, glyph measure, submit-after-help for MCQ, typed FRQ, photo).
5. Verify grading separately (OpenAI connection credit status; not retested by Gateway success).
6. Apply the four migrations to Prod in order (all newer than `20261013131212`); check filenames vs ledger; run `more_help_runtime.sql` as `service_role` in a rolled-back transaction.
7. Deploy `more-help` to Prod with `verify_jwt=true`; compare bundle hash to Dev; confirm `ALLOWED_ORIGINS` contains `https://app.cramapple.com` and Gateway key works via one smoke call (values never printed).
8. Publish the app at a named commit (`75c0b18` or later) and record the published version; signed-in Prod smoke on a QA/own account.
9. Rollback: Lovable republish of the previous app version first (hides the entry point); keep the new function and tables in place (additive; old function signatures fail closed per P3-10). Do not redeploy an older function as rollback.

**Later, not gates:** pilot lock scaling/global advisory lock, load certification, Dev fixture cleanup, recovery of the lost BC response, semantic leakage classifier.

## 7. Open questions for the owner
- Is F2's wider tripwire (choice elimination / "X is right") in scope, or does the targeted-plus-human decision stand as is?
- Authorization and call ceiling for step 3, and for writing the Dev MCQ mirror in step 2.
