#!/bin/bash
# Chemistry Unit 2 fill: 9 seeds (practice-level targets inside each topic's skill grid; no difficulty target) x 1 variant.
cd "$(dirname "$0")"
echo "START $(date -u +%FT%TZ)" > timing.log
node ../../vercel-gateway-check/teaching_pipeline/seed_pipeline.mjs run --batch=batch --plan=plan.json --skills=../../vercel-gateway-check/teaching_pipeline/inputs/skills/ap-chemistry.json --variants=1 --rounds=2 --conc=5 --session=chem-u2 > run.log 2>&1
echo "END $(date -u +%FT%TZ)" >> timing.log
