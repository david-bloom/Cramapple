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
Seeds selected. **Blocked on `AI_GATEWAY_API_KEY`** (not in this environment). Nothing loaded to any database; no variant written yet (S0a audit comes first).
