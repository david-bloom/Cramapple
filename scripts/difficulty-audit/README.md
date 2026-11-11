# Difficulty audit tool

Read-only. Pulls published MCQs, has two different-family models tier each (R1 one-step, R2 apply a method, R3 interpretation or misconception reasoning) and name the misconception behind each distractor, detects semantic duplicates, and writes `items.csv` and `summary.csv`. Plan and rubric: `docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`.

```
python3 audit.py --subject "AP Chemistry" --topics 3.1,3.2,3.3 --out OUT
python3 audit.py --subject all --units 1-3 --workers 20 --out OUT
python3 audit.py --subject "AP Calculus AB" --out OUT --no-model     # fetch + duplicates only
```
- Reads Production through `supabase db query --linked` run from `--workdir` (default `~/supabase`, which links Production). SELECT only; it never writes to the database.
- Needs `AI_GATEWAY_API_KEY` (environment or `scripts/vercel-gateway-check/.env.local`).
- Results are cached in `OUT/cache.json` by item hash, so a rerun only pays for changed items.
- Final tier is the lower of the two models' tiers; `models_disagree` marks items where they differ. Tiers are triage until calibrated against a subject-matter reader.
- `key_disputed` means a model thinks the keyed answer is not correct; read the item before acting.
