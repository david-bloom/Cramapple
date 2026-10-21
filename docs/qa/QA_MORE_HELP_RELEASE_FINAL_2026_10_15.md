> **Recovered 2026-10-21.** This report was committed only on branch `claude/more-help-final` (3e4257d4) and never reached `main`. It is the 2026-10-15 point-in-time QA verdict; More help has since launched (see `docs/handoffs/MORE_HELP_REMAINING_TASKS_2026_10_17.md`). Content below is unchanged.

# More help — final independent QA on merged code

**Date:** 2026-10-15 · **Reviewer:** Claude (Sonnet 5.5) · Basis: PR #451 session-close handoff and updated prompt. Earlier reports (`QA_MORE_HELP_RELEASE_2026_10_14.md`, `…_FOLLOWUP_2026_10_14.md`) are untouched.
**Covers:** backend/docs `main` `b2169089` (More help code `8c437bd4`, #442 merged); app `main` `ce2e479` (includes #25 `7b81177`, plus unrelated #26–#28 reference-pack / periodic-table changes). No provider/grading/photo calls, no writes, no deployments by me. Supabase checks were read-only metadata/counts.

## 1. Verdict

| | Verdict |
| --- | --- |
| **Code readiness** | **PASS with one P2 and two P3 items.** Prior blockers N1 (false-positive disclosure regex), F1, F3 siblings, N3 (state resets) are fixed and verified by reproduction. Residual issues below are not merge-blocking. |
| **Release readiness** | **NOT READY** — mandatory evidence gates are still unmet (MCQ, graded/revision, authenticated browser, human review of real outputs) and **Production state has changed since the handoff in a way I cannot reconcile** (§3). |

Checks run: backend `deno test` 26/26, `deno check index.ts` clean; app `vitest` 121 files / 1,182 tests, `tsc` clean, `npm run build` succeeds.

## 2. Findings

### Verified fixed (reproduced, not just read)
- **N1:** all six legitimate strings ("matching each term…", "Eliminate a common factor…", "Rule out a sign error…", "matching data…", "matching exponents…", restated given value) now PASS; the original five red-team strings, plus "(B) is correct", "B is the best choice", "Go with B", "Option B works here", "The answer lies in choice B", "Only D fits", and the follow-up "Is B correct?" all BLOCK. Choice letters are now uppercase-only and context-anchored (`CHOICE_REFERENCE`).
- **F1/N4:** with the rate-trap stem, sources saying "not defined / does not exist / cannot be computed / 0/0 / indeterminate / gives no rate / meaningless / divides by 0" are all dropped (whole-source scan, fail-closed `reference_unavailable`).
- **N3:** `TaskPane` now resets `activeTab`, `draft`, `choice`, `revising`, `error`, photo flags on state change via an effect while keeping `MoreHelp` mounted (source-verified; the producer's mocked-browser pass covers it; I did not drive a browser).
- **F4/F5/F6:** as in the follow-up, plus display-size fractions (`displayFractions`) now applied across help, question, stimulus, choices and work; owner confirmed rendering. Served-content glyph measurement on real data remains unmeasured by me.

### R1 (P2, confirmed) — Single-letter chemistry species still trip the choice check
`"Species A remains in excess, so track B's moles."`, `"A remains constant while B changes…"`, `"If A is correct to two sig figs…"` all BLOCK as `explicit_answer`, because any standalone uppercase A–E followed by `remains` / `is correct|wrong|right` is treated as a choice. Chemistry reactant/species labels A–E are common, so a Chemistry FRQ with species A/B can have its legitimate help discarded (cost consumed, student told to narrow focus). It affects only Chemistry/limiting-reagent style items. Smallest fix: bare-letter forms apply only when the item is an MCQ (the validator already receives item type via context) or the letter is in the stimulus choice list; keep "choice/option X" and "(X)" forms for all items. Regression: the three strings PASS for an FRQ, BLOCK for an MCQ.

### R2 (P3) — "Thus the derivative is 2x…" is blocked
The conclusion branch matches `derivative … is <digit>` and so rejects an expression starting with a numeral. Debatably a true positive (it states a result); note for the human red-team. No change required.

### R3 (P3, accepted by policy) — Conclusions without "therefore/thus" still pass
"The limit is 3." and "Thus f'(2) is 12." pass (the latter because `f'(2)` is not in the quantity list). Matches the owner's targeted-plus-human decision; the five prompt examples remain blocked. Numeric paraphrase protection is human-dependent. MVT and non-rate conceptual "explain/justify" subparts have no boundary at all.

## 3. Environment — Production has changed

Read-only inspection on 2026-10-15 (the handoff recorded "no More help function or migrations; not rechecked at close"):

| Item | Development `wmgjsdkphcyhngaffbqf` | Production `pcntajvbdfqhbeewmdry` |
| --- | --- | --- |
| Four More help migrations | present, names match files | **present** (`20261014001227`…`015127`), applied after `20261013131212` |
| Table `app.question_help_receipts` | present | **present; 1 receipt and 1 attempted-call row exist** |
| RPC grants | — | new generation-fenced signatures executable by `service_role` only; old 2/4-arg signatures not executable; `has_question_help` executable by `authenticated` (as designed); client has no direct SELECT on receipts; `service_role` has UPDATE on receipts and INSERT on assistance events |
| `more-help` function | v10 (handoff), `verify_jwt` on | **v1, ACTIVE, `verify_jwt=true`, created 2026-10-15 ~01:09 UTC (evening ET Oct 14)**, bundle SHA-256 `0c1072dd…d7183ff` |
| Published MCQs (AB/BC/Chem) | 0 / 0 / 0 (FRQ 11/13/18) | 355 / 352 / 209 (unchanged) |

Consequences:
1. **The "release remains NOT READY, no deployment occurred" statement in the handoff is no longer accurate for Production's backend.** Whether this was an authorized rollout step by David/Codex I cannot tell from the repository; the handoff says no deployment occurred at close, so it happened afterward. Treat it as a deployment already performed that must be verified, not as pending.
2. The Production bundle hash (`0c1072dd…`) differs from the Dev v10 hash recorded in the handoff (`20c84b8c…`). That may be a bundling-path difference or different source; I cannot prove either. Required: compare the Production bundle to the source at `8c437bd` (or `main`), file by file, as was done for Dev.
3. The 1 receipt / 1 call row implies one real or smoke invocation occurred in Production. I did not read the row (student-record boundary). Confirm it was the owner's/QA account and that it was a smoke test, and whether it delivered (`delivered_at`) or failed.
4. App publication state was not verified (Lovable not queried). If the published app is `75c0b18`, there is no entry point to the function and the backend is dark; if it includes #21/#24/#25, students can already reach More help in Production with only the unreviewed gates above outstanding.

## 4. Coverage matrix (unchanged in substance)
| Subject | MCQ (any phase) | FRQ unanswered | FRQ graded / revision |
| --- | --- | --- | --- |
| Calc AB / BC / Chemistry | **Blocked in Development** (0 MCQs; fixture and call round unapproved). Production has the content, but I made no Production calls. | local-simulated validators + producer's 3 live empty-work calls (pre-remediation bundle) | blocked (needs fixture + authorization) |
Browser: producer's mocked-transport local pass only; authenticated Development/Production evidence: none from me. Human judgment of real generated outputs: **not yet performed by anyone**.

## 5. Minimum ordered release checklist
1. **Establish ground truth on Production now:** who deployed v1 and the migrations, under which approval; confirm the single receipt's origin; diff the deployed bundle to `8c437bd`/main; if it differs, redeploy from the reviewed commit (an owner action).
2. Confirm whether the app with More help is published, and which commit (Lovable project `56cae479…`). If published, treat remaining QA as post-deployment smoke on a QA account, not pre-release.
3. Fix R1 (small, FRQ/Chemistry-only), redeploy Dev, regression above.
4. Run the already-prepared Development MCQ mirror and ≤12-call round **only after explicit approval of that concrete plan**, with a human reading every output (include an MCQ with a leading focus, a Chemistry species-labelled FRQ, an MVT/justify FRQ).
5. Authenticated browser pass on Development: desktop + 375px, MCQ and FRQ submit-after-help, revision, refresh/two tabs, served-content glyph sizes, photo path, grading availability (separate OpenAI/Gateway grading path per TASK-0074 disposition).
6. Production signed-in smoke on the QA account with receipt/assistance verification; rollback = republish previous app version first, leave additive schema and fenced function in place; never redeploy an older unfenced function.

**Not gates:** global advisory-lock scaling, load certification, QA-account cleanup, the lost BC response.
