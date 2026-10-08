# TASK-0065 — Generate Open Hand Teaching Questions (One per Topic, Never Scored)

**Status:** Units 1–3 done — 91 items live in Production (2026-10-06, APPROVAL-0125). Units 4+ not started.  
**Tier:** Standard for authoring in Development; Hard-Gate for Production publish and designation  
**Owner:** Claude session (authoring); outside-family checkers via AI Gateway  
**Product Owner:** David Bloom  
**Date opened:** 2026-10-06  
**Parent:** `TASK-0064` (teaching pool), `DECISION-0087` ("reserved teaching pool")

## Why

Open Hand now shows everything on load and draws only from `app.open_hand_teaching_items`, which are
never scored. On 2026-10-06, 95 topics lent one scored MCQ as a stopgap. Thin topics, including 25 of
27 Biology topics, have no Open Hand question at all. Generated teaching questions fill every topic
and let the borrowed items return to scoring.

## Scope

One teaching MCQ per topic for every active subject: about 214 topics, minus any topic that already
has a generated item. Priority order:
1. AP Biology and AP Statistics, the day-1 subjects
2. AP Chemistry
3. the rest by active-student count

## Item standard (from `docs/new_design/CONTENT_AND_PEDAGOGY.md`)

- The question sits squarely on the topic and is answerable from that topic's content. Its primary
  topic label must match the designated topic.
- Four choices with exactly one correct.
- **Every distractor is a named trap.** Its rationale says (a) why it tempts and (b) the one-line fix.
  The correct choice's rationale explains *why* it earns the point, never just "Credited."
- The stem never repeats the choices inline.
- How points are earned and how points are lost: three short habit lines each, consistent with the
  topic's point brief.
- No calculator-only or figure-dependent items unless the asset ships with the item.
- Validated before publish by the same model-consensus labeling and checker policy as other generated
  items (`DECISION-0085` / `DECISION-0093` pattern). Human spot-check per subject before the first
  publish.

## Delivery

- Load as drafts in Development, validate, then publish in Production on David's approval.
- For each published item, insert a row into `app.open_hand_teaching_items` with
  `source = 'generated'` for its topic, and set `released_at = now()` on that topic's `spare` row,
  which returns the borrowed item to scoring. `get_open_hand_teaching_item` already prefers
  `generated` over `spare`.
- Report per subject: topics covered, items rejected by the checker and why, spares released.

## Verification

- [ ] Each generated item passes the item standard; a sample is human-checked per subject.
- [ ] After designation, each topic's RPC call returns the generated item, and the released spare is
      served again by the selectors.
- [ ] 0 generated teaching items are served by any scored selector (same 30-seed check as TASK-0064).

## Scope decision — 2026-10-06 (David)

"Do bio, stats, chemistry and calc AB." Other subjects wait until they have real students; the QA-round
frontend routes a topic with no worked example to Practice and finds the nearest worked example.

Gap measured in Production against published topic point briefs (the topics a student can land on):
Biology 58, Statistics 41, Chemistry 84, Calc AB 69, for **252 items**. The earlier "~214 for every subject"
estimate undercounted, because it used topics with scored content rather than every brief.

Batch directory: `docs/research/open_hand_teaching_batch_2026_10_06/` (`AUTHORING_SPEC.md`,
`FACT_PACK_QUERY.sql`). Habit lines come from each topic's point brief on screen, so items carry stem,
choices and per-choice rationales only.

**Blocked:** the two outside-family checker stages (DECISION-0093). `ai-gateway.vercel.sh` is denied by
this environment's network policy, and no `AI_GATEWAY_API_KEY` is set. No item is loaded until both
checkers have cleared it.

### Finding: live topic-guide defects (AP Calculus AB) — 2026-10-06

While authoring, the Calc AB agent found two published explainers whose mini example uses a point that is
not on the curve. Re-checked in Production:
- **4.4:** `x^2 + 3xy = 20` at (2, 4) gives 4 + 24 = 28, not 20.
- **4.5:** `2xy + ln(y) = 8` at (1, 4) gives 8 + ln 4 ≈ 9.39, not 8.

Students see these in the topic guide and the deep dive. The teaching items do not reuse them. The fix
(pick points on each curve) is a separate content repair and needs David's approval to edit published
guides. 4.6 was also flagged, but it is a deliberate wrong-slope scenario, not a defect.

## Scope and checkers — 2026-10-06 (APPROVAL-0123)

- **Units 1–3 only** for the four subjects: Biology 21, Statistics 29, Chemistry 21, Calc AB 20, for
  **91 items**. The later-unit drafts stay in the batch directory but are out of scope.
- **Checkers:** Gemini 3.8 and DeepSeek 5. Their exact gateway IDs and smoke tests are recorded at batch start.
- **Still blocked:** `ai-gateway.vercel.sh` is denied by this environment's network policy, and no
  `AI_GATEWAY_API_KEY` is set.
- **Explainer repair (4.4/4.5):** approved. Migration `20261006100000_repair_calc_ab_4_4_4_5_explainer_examples`.

## Session handoff — 2026-10-06 (end of day)

**Done.**
- All 252 gap items are drafted and pass the structure self-check. The 91 in scope are in
  `docs/research/open_hand_teaching_batch_2026_10_06/SCOPE_UNITS_1-3.json`.
- The Calc AB 4.4/4.5 explainer repair is applied and verified in both Development and Production.
- The checker script is written: `scripts/vercel-gateway-check/open_hand_teaching_check.mjs`. It runs a
  blind solve plus a fact-pack audit per item per model, writes a union-of-flags report, can resume a
  partial run, and refuses Anthropic models.
- **Checker slate.** David chose DeepSeek V4 Pro because DeepSeek 5 is not on the gateway roster.
  - `google/gemini-3.8-flash`
  - `deepseek/deepseek-v4-pro`
- **Gateway unblocked.** David added `ai-gateway.vercel.sh` to the allowed domains and set
  `AI_GATEWAY_API_KEY` in the environment. A one-line test call to Gemini 3.8 through the `ai` SDK
  returned OK.
- **Env vars needed.** Node's fetch must go through the agent proxy, or every call gets a 403:
  `NODE_USE_ENV_PROXY=1 NODE_EXTRA_CA_CERTS=/root/.ccr/ca-bundle.crt`.

**Not done yet, in order.**
1. **Smoke test** (AQP §3.2 rule 4), on four items (one per subject: Calc AB 1.1, Chem 1.2, Bio 1.1,
   Stats 1.1), both models. The first attempt failed with a 403 before the proxy fix and was not re-run.
   ```
   cd scripts/vercel-gateway-check
   NODE_USE_ENV_PROXY=1 NODE_EXTRA_CA_CERTS=/root/.ccr/ca-bundle.crt \
     node open_hand_teaching_check.mjs <smoke4.json> <out_dir> \
     --models=google/gemini-3.8-flash,deepseek/deepseek-v4-pro
   ```
   Build `smoke4.json` by picking those four items from `SCOPE_UNITS_1-3.json`. The script skips items
   that already have a row in `results.jsonl`, so use a fresh output directory.
2. **Full run** on `SCOPE_UNITS_1-3.json` into `docs/research/open_hand_teaching_batch_2026_10_06/check_run_1/`.
3. **Verify every union flag** by hand, or with sympy for numeric items. Apply one patch loop, then
   re-check every patched item with both models.
4. **Record the results.** Model IDs, smoke results and cost go in a batch README, this file and
   APPROVAL-0123.
5. **Load in Development** as drafts. Insert `app.open_hand_teaching_items` rows (`source='generated'`)
   and release the matching spare rows.
6. **Production** only on David's approval (Hard-Gate).

**Supabase MCP note.** Multi-statement writes, `apply_migration`, and UPDATEs that concatenate
`source_note` hang at 60 seconds. Use single, simple statements.

**Other open items outside this task, all before the plate loop goes ON.**
- ~~David deploys `student-session-items` with the CLI.~~ **Done 2026-10-06:** Production v33, Development v21. All six
  deployed files are byte-identical to this branch (checked via the Supabase MCP); `verify_jwt` stays on.
- David gives the go-ahead on the attempt-response 409 mapping.
- Fable does a signed-in walkthrough of the published Lovable build.
- Re-enable `trg_refuse_attempt_on_teaching_item`.
- David reviews and merges PR #340.
- Next Lovable round: change the copy "↻ Revisit — the point is still available next attempt." to
  "Revisit this one."

## Supplementary checker stages — 2026-10-06 (PR #345)

A separate session built and piloted extra checks for this task before seeing #340. Reconciled with
APPROVAL-0123, which governs scope (91 items) and the decision that habit lines come from the point brief.
Record: `scripts/content-seed/task0065-bio-pilot-2026-10-06/PILOT_REPORT.md`.

- **Proven on a Biology pilot:** 4 of 4 planted defects caught by both checkers in every round.
- **Kept as stages beside `open_hand_teaching_check.mjs`:** C3 named-trap audit
  (`teaching_item_check.mjs`), the lint (`lint.py`), and the CED-text topic probe (Biology only).
  The per-item habit-line check (C6) is retired.
- **Run on the 91 drafts (unpatched):**
  - Lint: 2 fail (Calculus AB 1.11 and 1.13 use `!=`).
  - C3: 38 blocked. 13 for an unnamed temptation. 25 only because a `Fix:` line states a fact rather than an action.
  - Biology topic probe: 21 of 21 pass.
- **David (2026-10-06): fix lines must be actions.** I rewrote 44 fix lines across the 25 items,
  in both copies of each item. On re-check, all 25 clear lint, C3 and `open_hand_teaching_check.mjs`.
  Two single-checker flags were adjudicated: one as variance, one as a wrong flag on ozone's octet.
  Still open: 13 items with an unnamed temptation (7 of them also have fact-style fixes).
- These results feed the patch loop (step 3 of the handoff above). They clear nothing on their own.

## Generate-and-select pipeline replaces hand-patching — 2026-10-06 (David)

> **Superseded for Units 1–3; see "Reconciliation" at the end of this file.** The pipeline stays as the route for
> Units 4 and later. Items 2–3 of the decision below did not happen: #348 was merged, and the 15 blocked items were
> fixed, checked and loaded.

David asked why reviewed questions kept failing new checks, and asked for "a way to add questions without
needing to edit them using at least 4 models and multiple sessions".

**Diagnosis.** The rules were applied after the items were written: the named-trap and action-fix rules
caused 25 of the 38 blocks. Earlier reviews checked other things. Single model calls are noisy. Every
hand patch needed a full re-check. Two sessions also worked to different specs.

**Decision (David, 2026-10-06).**
1. Build a generate-and-select pipeline. No item is ever edited.
2. Regenerate all 38 topics that C3 blocked.
3. Hold PR #348 (the 25 hand-patched items; now a draft) and discard the 13 unchecked rewrites.

**Pipeline:** `scripts/vercel-gateway-check/teaching_pipeline/` (`README.md`).
- **One rubric** (`rubric.mjs`, 10 rules plus a deterministic lint). Both the author and the checkers
  are prompted with it.
- **Authors:** two per round, Claude Opus 5.5 and GPT-6.1, stateless. The correct answer's position is
  randomized.
- **Checkers:** four families, never the author's own: OpenAI, Google, DeepSeek, Moonshot, Anthropic,
  minus the author. Each does a blind solve, then a rubric audit with the CED fact pack and the unit's
  topic list.
- **Variance and selection:** a checker that flags is re-sampled once, and only a repeated flag counts.
  The first clean candidate is accepted. After 2 rounds with none, the topic is escalated to a human.
- **Controls and sessions:** six planted-defect controls run before any generation, and the batch is
  void if one is accepted. Per-topic lock files let sessions on one machine share a batch; separate
  machines use `--shard`.

**Smoke test:**
- All 6 controls were caught at the expected stage, by all four checkers. The one exception: the
  false-fact control was caught by Gemini under the accuracy rule and by the other three under other rules.
- Biology 1.1 was accepted on its first candidate.
- My spot check of that accepted item found rationales longer than the design's one to three sentences.
  A `concise` rule was added to the rubric and lint (60 words per rationale, 25 per fix) before the
  pilot. The human spot-check stays required.

**Biology pilot (units 1–3, 21 topics), batch `scripts/content-seed/task0065-generate-select/bio-u1-3-2026-10-06/`:**
- **Controls:** 6 of 6 caught.
- **First pass:** 21 of 21 accepted from 38 candidates, with 17 rejected at the audit. Every Claude
  rejection came from GPT-6.1 alone, and GPT never checked GPT-written items, so the bar depended on
  the author.
- **Veto added:** the author's own family can reject but never approve, so every accepted item has
  passed all five families. Applied to the 21, it vetoed 3 GPT-written items (1.5, 2.10, 3.3).
  Their regeneration rounds were also rejected.
- **Result:** 18 accepted (12 GPT-authored, 6 Claude), 3 escalated, 0 edited. 0 failed calls out of about 600.
- **Escalated, for David:**
  - 2.10 and 3.3: the topic point brief students see requires content the Biology CED fact pack lacks
    (circular organelle DNA and binary fission for 2.10; ATP coupling for 3.3). No item can satisfy
    both. Decide which source is right.
  - 1.5 Lipids: its content overlaps 2.3 (phospholipid orientation), and GPT consistently places
    lipid-structure items in 2.3.
- **Lint additions from the pilot:** stray HTML, and more than three sentences in an explanation.
- **Next:** the accepted items need the per-subject human spot-check before any Development load.
  Statistics, Chemistry and Calculus AB (70 topics) have not been run.
## Checker run on all 91 — 2026-10-06 (`open_hand_teaching_check.mjs`)
Results are in `docs/research/open_hand_teaching_batch_2026_10_06/CHECK_RESULTS.md`.
- The smoke test and canary passed: both models caught 4 of 4 planted wrong keys.
- Full run: 182/182 calls succeeded. Every blind solve matched its key, and neither model disputed a key.
- 13 items were flagged. 4 were real rationale errors (Calc AB 1.5 B; Stats 1.5 A, 3.14 A, 3.15 D). I fixed them on
  top of #348's action fix lines. The other 9 were verified as non-defects (scope supported by the published briefs;
  calculator use allowed in Statistics, keys recomputed).
- The 4 fixes re-check clean on this checker and pass lint. On C3, 3 pass. Stats 3.14 still fails, but on choice
  D, which is outside my edits.

**Open before loading:** the 13 C3 temptation-blocked items and the 2 lint failures from #345/#348.

## Loaded to Production — 2026-10-06 (APPROVAL-0125)
- **Batch 1:** the 76 items that cleared every stage.
- **Batch 2:** the 15 C3/lint-blocked items, after the `fix15/` rewrite. All 15 now pass lint, C3 and the
  solve/audit checks on both checkers. The one DeepSeek scope flag, on Bio 3.3, was adjudicated: the published brief
  covers energy coupling.
- **Live:** Bio 21, Stats 29, Chem 21, Calc AB 20 = 91. Every Units 1–3 gap topic in the four subjects now has a
  worked example.
- **Verified:** content hashes match; Open Hand serves the new items; students cannot read them directly; scoring
  never serves them.
- `SCOPE_UNITS_1-3.json` now holds the final text of all 91, with the fix15 rewrites merged in.
- **Follow-up:** add energy coupling and ATP hydrolysis to the 3.3 entry of `AP_BIOLOGY_CED_FACT_PACK.md`, so the
  checker stops flagging it.

## Reconciliation of the two Units 1–3 tracks — 2026-10-06 (merge of PR #351)
Two sessions worked TASK-0065 Units 1–3 in parallel with different plans. This records what actually happened, so
the file states one plan.

- **Live:** the hand-patch track. PR #348 was merged, not held. The 13 temptation-blocked items plus the 2 lint
  failures were rewritten in `fix15/` and checked (lint, C3 and solve/audit on both checkers). All 91 Units 1–3
  items were loaded to Production under APPROVAL-0125.
- **Not loaded:** the generate-and-select Biology pilot's 18 accepted items
  (`scripts/content-seed/task0065-generate-select/bio-u1-3-2026-10-06/`). They must not be loaded for Units 1–3.
  Every one of those topics already has a live generated teaching item, and a second active row per topic would be
  shadowed (`get_open_hand_teaching_item` picks the earliest designated `generated` row).
  If David prefers a pipeline item for a topic, release the live row first (`released_at = now()`), then load the
  replacement. One active generated row per topic.
- **Kept:** the pipeline itself (`scripts/vercel-gateway-check/teaching_pipeline/`) is the route for Units 4 and
  later. It generates without edits and runs four checker families plus an own-family veto.
- **Still open for David, common to both tracks:** Biology 2.10 and 3.3. The published topic point briefs require
  content (circular organelle DNA and binary fission; ATP coupling) that `AP_BIOLOGY_CED_FACT_PACK.md` omits.
  Decide which source is right. If it is the briefs, add that content to the fact pack.


**David's decisions on the Biology escalations (2026-10-06, APPROVAL-0127):**
- **2.10:** the brief was wrong (the CED does not list circular DNA or binary fission). The brief was fixed in Development and Production.
- **3.3:** the fact pack was wrong (it dropped EK 3.3.A.2.ii, energy coupling). The fact pack was fixed and the brief left as is.
- Both topics were regenerated after the controls were re-run (6/6), and both were accepted.
- **1.5:** David said to keep it, saying an occasional question may use a concept taught previously. But phospholipid orientation is taught **later**, in 2.3. Awaiting confirmation before accepting candidate r1-openai (it passed the four independent checkers and was rejected only by GPT's topic veto).
- **Biology units 1–3 now:** 20 of 21 accepted.
- **Review page (private Claude artifact):** https://claude.ai/artifact/CiBQWsfy6YHsJNfLaH45eh (renderer: `scripts/content-seed/task0065-generate-select/render_review.py`).

**Biology pilot cost:** $20.13 at live gateway prices for 21 topics (about $1.12 per accepted item), plus $3.04 for the controls.

**Method test designed:** `docs/product/OPEN_HAND_CONTENT_METHOD_TEST_DESIGN_2026_10_06.md`. It compares legacy and pipeline on quality (key accuracy, option accuracy, CED faithfulness), speed and cost, using held-out judges and planted defects. Not yet run; awaiting David's approval of the design and decision rule.

## Method test run — 2026-10-06/07 (legacy vs generate-and-select)

David asked for the test to be executed with units 1–3 for every subject. Full results:
`scripts/content-seed/task0065-method-test-2026-10-06/RESULTS.md`.

**Setup:** 24 topics, 6 per subject. Three arms were judged blind by three held-out families (Mistral, GLM,
MiniMax) against CED PDF text, with 4 planted defects mixed in (all 4 caught):
- a fresh legacy run;
- the pipeline;
- the 24 items live in Production for the same topics.

**Items with a confirmed accuracy or CED defect:** legacy 4/24, pipeline 1/23, live 3/24.
- Every key was correct in every arm (33 numeric keys recomputed).
- The pipeline came out clean on every pedagogy and "publish as is" judgement.

**Cost and speed:**
- Pipeline: $0.77 per defect-free item, 13.7 minutes.
- Legacy: about $0.19 per defect-free item, 10.3 minutes.
- So the pipeline is 3.5–4.9× the cost, which fails the proposed 3× cap.
- With n = 24 the quality difference is not significant (p = 0.35).

**Found along the way:**
1. **Live defects in Production:**
   - Stats 1.10: a fix line says random assignment defines an experiment.
   - Stats 2.12: the key needs σ/√n, which is CED 4.1.
   - Bio 2.10: a false rationale, and a key that needs evidence outside the CED.
   - Roughly 11 of the 91 live items may be affected (extrapolated, not counted).
2. **Statistics 2.12 brief overreach:** it asks for "sample size tightens the spread" (CED 4.1). It caused the
   same defect in all three arms.

**Open for David:**
- the decision on the method;
- whether to replace the defective live items;
- whether to fix the 2.12 brief;
- human confirmation of Claude's provisional adjudication of 17 disputed items;
- the Q* and pedagogy ratings.

## Live replacements and Statistics 2.12 brief fix — 2026-10-07 (APPROVAL-0129)

- The Statistics 2.12 brief was fixed to CED 2.12 in Development and Production.
- The three defective live items (Stats 1.10, Stats 2.12, Bio 2.10) were replaced in Development and Production
  with pipeline items checked by four model families and three held-out judges.
- The old items are retired. The real teaching function now serves the replacements.
- Details: APPROVAL-0129.

## Cost levers and Biology Unit 1 seed pilot — 2026-10-07

**Cost levers.**
- Muse Spark is now the fourth checker, and the unit-scoped fact pack is the default.
- Cost per item fell from $0.28 to $0.20 with no quality loss.
- See `scripts/content-seed/task0065-cost-levers-2026-10-07/RESULTS.md`.

**Seed pilot** (`scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07/RESULTS.md`): Biology 1.1–1.7, 3 seeds per topic and 3 variants per seed, made with `seed_pipeline.mjs` and no hand edits.
- 21/21 seeds and 61/63 variants were accepted.
- Blind held-out judges found 0 defects in the seeds and in a 21-variant sample, and caught 4/4 planted defects.
- Cost was $25.73 on the pre-lever config.
- Difficulty targeting failed: no item was voted Hard.
- Skill targeting is reliable at the practice level (17/21) but not at the sub-skill level (14/21).

**Open for David:**
- the difficulty and skill handling (see the RESULTS recommendations);
- whether to load the pilot items (Hard-Gate, needs approval);
- human confirmation of the 15 provisional adjudications;
- whether to run the Orly spec-guided seed A/B on Chemistry or Calculus.

## Biology Unit 1 seed-pilot items published — 2026-10-07 (APPROVAL-0131)

- All 82 pilot items (21 seeds, 61 variants) are now published Production practice MCQs, with labels set per DECISION-0101 and no human review per DECISION-0102.
- Biology's published MCQs went from 79 to 161, and the real selector serves all 82.
- Load scripts: `scripts/content-seed/task0065-seed-pilot-bio-u1-2026-10-07/load/`.
