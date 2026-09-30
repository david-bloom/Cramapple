# AP Biology Units 1-2 seeded-variant pilot (class A seeds) — 2026-09-30

Protocol: `docs/research/SEEDED_ITEM_GENERATION_PROTOCOL_2026_09_30.md` (draft v0.1), `DECISION-0093`.
Comparison run: `scripts/content-seed/calc-ab-pilot-2026-09-30/PILOT_REPORT.md`.

## Pre-run answers (Product Owner, 2026-09-30; AQP §2.1)
- Subject / scope: AP Biology, Units 1 and 2, MCQ only.
- Variants: **2 per seed**.
- Seed class: **A only** (items already in Production that Cramapple authored). No class B/C material.
- Checkers: `deepseek/deepseek-v4-pro` (DeepSeek) + `google/gemini-3.5-flash` (Google). Chosen for direct comparison with the Calc AB work.
  Note: the Calc AB pilot ran `google/gemini-3.8-flash` (see its `analyze.py` price table); Calc Unit 1 ran 3.5 flash. Re-check both against the live gateway roster before spend (smoke test).
- Author: Claude Sonnet 5.5 (Anthropic family, so never a checker).

## Seeds (8, published, from Production `pcntajvbdfqhbeewmdry`)
Selection rule: published MCQ, `label_status = validated`, primary unit 1 or 2. Only two Unit 1 items qualify.
Excluded: `APBIO-MCQ-061` (provisional topic 1.6 but validated unit 6), `APBIO-MCQ-099` (provisional topic 2.1 but validated unit 8) — label conflicts.

| Seed | Unit | Topic (provisional) | Difficulty |
|---|---|---|---|
| APBIO-MCQ-005 | 1 | 1.3 | Medium |
| APBIO-MCQ-008 | 1 | 1.1 | Medium |
| APBIO-MCQ-014 | 2 | 2.1 | Medium |
| APBIO-MCQ-016 | 2 | 2.7 | Medium |
| APBIO-MCQ-018 | 2 | 2.5 | Hard |
| APBIO-MCQ-021 | 2 | 2.1 | Medium |
| APBIO-MCQ-022 | 2 | 2.1 | Hard |
| APBIO-MCQ-023 | 2 | 2.3 | Hard |

## Status
Seeds selected and extracted to `seed_items.json` (verbatim from Production published versions, 2026-09-30; stimulus folded into `stem`; keyed letters match `is_correct`).
The cloud session had no `AI_GATEWAY_API_KEY` and no route to the gateway, so no model check has run. Nothing loaded to any database; no variant written yet (S0a audit comes first).

## Runbook: S0a seed audit (run on a machine with `scripts/vercel-gateway-check/.env.local`)
```
git fetch origin && git checkout claude/seeded-question-generation-9rxlqc && git pull
cd scripts/vercel-gateway-check
# 1. smoke test both models on one item (should print 4 calls, no ERROR lines)
node apbio_seeded_math_check.mjs ../content-seed/apbio-seeded-pilot-2026-09-30/seed_items.json ../content-seed/apbio-seeded-pilot-2026-09-30/out_smoke --models=google/gemini-3.5-flash,deepseek/deepseek-v4-pro --only=APBIO-MCQ-014
# 2. full S0a: blind solve + rationale audit, 8 seeds x 2 models
node apbio_seeded_math_check.mjs ../content-seed/apbio-seeded-pilot-2026-09-30/seed_items.json ../content-seed/apbio-seeded-pilot-2026-09-30/out_seed_audit --models=google/gemini-3.5-flash,deepseek/deepseek-v4-pro
```
Then commit and push `out_seed_audit/results.jsonl` (and `out_smoke/` if the smoke test failed). If a model id is rejected, list the live roster first and tell Claude; do not substitute silently.
`apbio_seeded_math_check.mjs` is the Calc AB math check with the role prompt changed to AP Biology and "mathematics" wording removed; structure and output format are identical, so results compare directly. It logs token usage per call.

Next (Claude, after results are pushed): adjudicate flags by hand, repair or drop flawed seeds, write 16 variants, then CED check against the Biology fact pack, label probe, report.
