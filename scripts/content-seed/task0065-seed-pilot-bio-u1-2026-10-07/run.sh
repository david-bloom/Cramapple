#!/bin/bash
# Biology Unit 1 seed pilot: 7 topics x 3 seeds (different skill + band) x 3 variants, generate-and-select, no DB writes.
cd "$(dirname "$0")"
echo "START $(date -u +%FT%TZ) $(date +%s)" > timing.log
node ../../vercel-gateway-check/teaching_pipeline/seed_pipeline.mjs run --batch=batch --plan=plan.json --skills=bio_skills.json --variants=3 --rounds=2 --conc=4 --session=seed-pilot > run.log 2>&1
echo "END $(date -u +%FT%TZ) $(date +%s)" >> timing.log
