#!/bin/bash
# Round 2 (added after 1.2 slot B escalated at the seed-vs-seed similarity gate: all 4 candidates were the inverse
# "find the abundance from the average mass" calculation, too close to seed A). One new 1.2 seed slot D (skills 5.A/5.B)
# with 1 variant, to reach 5 accepted items on 1.2. Slot B is left escalated; nothing is patched.
set -e
cd "$(dirname "$0")"
P=../../vercel-gateway-check/teaching_pipeline
python3 -c "
import json
p=json.load(open('plan_seed_only.json'))
p[0]['slots']=[dict(slot='D', practice='5', skills=['5.A','5.B'])]
json.dump(p,open('plan_round2.json','w'),indent=1)"
echo "ROUND2 START $(date -u +%FT%TZ)" >> timing.log
node $P/seed_pipeline.mjs run --batch=batch --plan=plan_round2.json --skills=$P/inputs/skills/ap-chemistry.json --variants=1 --rounds=2 --conc=1 --session=chem-u1-1218 > run_round2.log 2>&1
echo "ROUND2 END $(date -u +%FT%TZ)" >> timing.log
cat run_round2.log
