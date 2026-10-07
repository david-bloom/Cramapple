#!/bin/bash
# Cost-change measurement: same 24 topics as the method test, new run.mjs (cache-friendly prompts, sequential authors).
cd "$(dirname "$0")"
R=../../vercel-gateway-check/teaching_pipeline/run.mjs
topics() { python3 -c "import json;print(','.join(t['topic_code'] for t in json.load(open('sample.json')) if t['subject_key']=='$1'))"; }
echo "START $(date -u +%FT%TZ) $(date +%s)" > timing.log
node $R run --batch=batch --subject=biology --topics=$(topics biology) --session=cost-bio --conc=3 > run_biology.log 2>&1
for s in ap-statistics ap-chemistry ap-calculus-ab; do
  node $R run --batch=batch --subject=$s --topics=$(topics $s) --session=cost-$s --conc=3 > run_$s.log 2>&1 &
done
wait
echo "END $(date -u +%FT%TZ) $(date +%s)" >> timing.log
node $R report --batch=batch > report.log 2>&1
echo DONE >> timing.log
