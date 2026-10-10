#!/bin/bash
# Regeneration (2026-10-10): the accepted seeds of 1.2 slot A and 1.8 slot A duplicated the topics' published Open Hand
# items (bank_dedupe.json). supersede.py moved those slots (and their variants) to superseded_seeds, unedited.
# New slots 1.2/E (5.D) and 1.8/C (4.A), 1 variant each, with --bank so the published items are in the
# earlier-seed prompt list and the seed-vs-seed gate. New slot letters keep candidate ids (and key positions) distinct.
set -e
cd "$(dirname "$0")"
P=../../vercel-gateway-check/teaching_pipeline
python3 -c "
import json
t=json.load(open('plan.json'))
t[0]['slots']=[dict(slot='E', practice='5', skills=['5.D'])]
t[1]['slots']=[dict(slot='C', practice='4', skills=['4.A'])]
json.dump(t,open('plan_regen.json','w'),indent=1)"
echo "REGEN START $(date -u +%FT%TZ)" >> timing.log
node $P/seed_pipeline.mjs run --batch=batch --plan=plan_regen.json --bank=bank_topics.json --skills=$P/inputs/skills/ap-chemistry.json --variants=1 --rounds=2 --conc=2 --session=chem-u1-1218 > run_regen.log 2>&1
echo "REGEN END $(date -u +%FT%TZ)" >> timing.log
cat run_regen.log
