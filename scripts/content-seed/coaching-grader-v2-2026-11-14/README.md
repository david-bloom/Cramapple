# Coaching via the grader engines: offline test harness (2026-11-14)

Evidence for `docs/product/COACHING_VIA_GRADER_V2_PLAN_2026_11_14.md`. Everything here is offline and synthetic: no student data, no writes to Development or Production, model calls through the Vercel AI Gateway only. Total model spend for all runs was a few cents (per-call usage, not a billing statement).

## Files

| File | What it does |
|---|---|
| `run_test.py` | 10 MCQ + 10 FRQ: synthetic submit, grade leg (MCQ rule-based; FRQ stand-in `gpt-5.4-mini`, not the deployed grader), coaching leg (`claude-haiku-5.5`, reasoning off), post-checks, timing and cost. Output `results.json`. |
| `render_test.mjs` | Headless Chromium on the `web/` prototype: click Submit to feedback card painted, 10 MCQ + 10 FRQ screens. |
| `seq_test.py` | One scripted student, 5 MCQs in sequence, arms A (no history), B (model counts history), C (B + earlier rationales), D (code computes facts and directive). Output `seq_results.json`. |
| `lean_test.py` | The three ideas: lean three-rule prompt, code-computed history, post-generation checks with one retry. Part A: 20 missed MCQs (current prompt vs lean vs lean+retry). Part B: 3 scripted 5-question sequences (model-counted vs code-computed history). Output `lean_results.json`; `lean_A_enriched.json` adds the source-rationale leak check. |
| `BLIND_READ_PACKET.md`, `BLIND_READ_KEY.md` | The 10-item blind read given to the owner, and its key. |

## Re-running

The scripts expect these files in the same directory (not committed, they are copies of Development content):
`items.json`, `versions.json`, `choices.json`, `criteria.json`, `topics.json`. Pull them from the Development project REST API with the `Accept-Profile: app` header:
`content_items?select=id,content_key,item_type,frq_form,response_policy&status=eq.published`,
`content_item_versions?select=id,content_item_id,stem,stimulus,version_num,rubric_type,evaluator_strategy,prompt_json&status=eq.published`,
`mcq_choices?select=*`, `frq_criteria?select=*`,
`content_item_topic_resolution?select=content_item_version_id,topic_code,topic_title,unit_number,skill_code,is_primary&is_primary=eq.true`.
Set `AI_GATEWAY_API_KEY` in the environment (never commit it). Run `python3 run_test.py`, `python3 seq_test.py`, `python3 lean_test.py`. `render_test.mjs` needs the `web/` dev server on port 5199 and a Chromium path (edit the two paths at the top).

## Method notes and limits

- Models: coaching `anthropic/claude-haiku-5.5` with `reasoning: {enabled: false}` (with reasoning on, the model spent its token budget on hidden reasoning and returned empty text). FRQ grade stand-in and the second leak judge: `openai/gpt-5.4-mini`; first leak judge: `google/gemini-3-flash`. A text counts as naming the answer if either judge flags it; the two disagreed on 5 to 9 of 20 per arm, and none of it is human-verified.
- Seeds are fixed in each script; generations are not deterministic, so reruns differ in detail.
- The first run of `run_test.py` was invalid (empty coaching text, reasoning on) and was rerun; only the rerun is reported.
- `seq_test.py` has a corrected judge-label mapping (an inverted X/Y mapping in its first version was fixed before the reported run). Its pairwise judge results are not relied on.
- Small samples: one scripted student per sequence (3 in `lean_test.py`), 20 items per arm. These are feasibility signals, not rates.
- `lean_test.py` part B originally let the two arms draw wrong answers from one shared random stream, so they saw different distractors (caught in PR review). It now fixes one script of items and answers per sequence before the arms run; part B was rerun and `lean_results.json` replaced. Headline unchanged (model-counted history: 6 of 15 wrong counts, 0 of 3 step-back on the third miss; code-computed: 0 wrong counts, 3 of 3). Answer-naming flags on missed steps are now 5 of 9 in both arms (they were 4 and 6 in the first run). `seq_test.py` already used one chosen answer per step shared by all arms.
