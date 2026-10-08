#!/bin/bash
# Biology Unit 3 fill: 5 topics x 2 seeds (practice-level skill targets, no difficulty target; DECISION-0101) x 1 variant.
cd "$(dirname "$0")"
echo "START $(date -u +%FT%TZ)" > timing.log
node ../../vercel-gateway-check/teaching_pipeline/seed_pipeline.mjs run --batch=batch --plan=plan.json --skills=bio_skills.json --variants=1 --rounds=2 --conc=5 --session=bio-u3 > run.log 2>&1
echo "END $(date -u +%FT%TZ)" >> timing.log
