# TASK-0065 — Generate Open Hand Teaching Questions (One per Topic, Never Scored)

**Status:** In progress — drafts done; outside checkers ready to run (paused 2026-10-06)  
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
- **Open for David:** should a `Fix:` line have to be an action, which means rewriting 25 items' fixes, or may
  it state the correct fact?
- These results feed the patch loop (step 3 of the handoff above). They clear nothing on their own.
