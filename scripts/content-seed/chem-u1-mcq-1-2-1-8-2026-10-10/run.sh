#!/bin/bash
# AP Chemistry Unit 1 practice-MCQ fill for topics 1.2 and 1.8 (protocol v0.6 section 0, DECISION-0099/0101/0102).
# Production had zero practice MCQs on either topic (only the Open Hand teaching items apchem-oht-1.2 / -1.8).
# Target: 5 accepted on 1.2 (3 seeds; 1 variant each on slots A and B) and 4 on 1.8 (2 seeds x 1 variant).
# Step 1: planted-defect controls (batch void if any is accepted). Step 2: seeds+variants. Step 3: third 1.2 seed, no variant.
set -e
cd "$(dirname "$0")"
P=../../vercel-gateway-check/teaching_pipeline
echo "CONTROLS START $(date -u +%FT%TZ)" > timing.log
node $P/run.mjs run --batch=batch_controls --subject=__controls_only__ --session=chem-u1-1218 > controls.log 2>&1
echo "CONTROLS END $(date -u +%FT%TZ)" >> timing.log
grep -q '"controls_all_caught": true' batch_controls/summary.json || { echo "BATCH VOID: a control was accepted" | tee -a timing.log; exit 3; }
echo "GEN START $(date -u +%FT%TZ)" >> timing.log
node $P/seed_pipeline.mjs run --batch=batch --plan=plan.json --skills=$P/inputs/skills/ap-chemistry.json --variants=1 --rounds=2 --conc=2 --session=chem-u1-1218 > run.log 2>&1
node $P/seed_pipeline.mjs run --batch=batch --plan=plan_seed_only.json --skills=$P/inputs/skills/ap-chemistry.json --variants=0 --rounds=2 --conc=1 --session=chem-u1-1218 > run_seed_only.log 2>&1
echo "GEN END $(date -u +%FT%TZ)" >> timing.log
