#!/bin/bash
# Arms experiment: A (baseline), B (feedback regeneration), C (stem+key, help-leak gate, then distractors).
# Same plan, same settings, run one after another so wall-clock is comparable. Controls from today's run are reused (same checkers/rubric).
cd "$(dirname "$0")"
P=../../vercel-gateway-check/teaching_pipeline
S=$P/inputs/skills/ap-physics-c-mechanics.json
CTRL=../more-help-gap-fill-bio-phy1-2026-10-16/batch_bio/controls_result.json
for arm in A B C; do
  mkdir -p batch_$arm; cp -n $CTRL batch_$arm/controls_result.json
  echo "{\"arm\":\"$arm\",\"started\":\"$(date -u +%FT%TZ)\"}" > batch_$arm/arm_meta.json
  node $P/seed_pipeline.mjs run --arm=$arm --batch=batch_$arm --plan=plan.json --skills=$S --variants=0 --rounds=2 --conc=8 > run_$arm.log 2>&1
  echo "{\"arm\":\"$arm\",\"finished\":\"$(date -u +%FT%TZ)\"}" >> batch_$arm/arm_meta.json
done
echo ALL-DONE > run_arms.done
