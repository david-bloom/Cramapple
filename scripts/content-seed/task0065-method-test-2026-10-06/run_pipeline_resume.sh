#!/bin/bash
# Method test, pipeline arm, segment 2 (after the gateway credit outage): reopened topics only.
cd "$(dirname "$0")"
R=../../vercel-gateway-check/teaching_pipeline/run.mjs
topics() { python3 -c "import json;print(','.join(t['topic_code'] for t in json.load(open('sample.json')) if t['subject_key']=='$1'))"; }
echo "RESUME_START $(date -u +%FT%TZ) $(date +%s)" >> pipeline/timing.log
for s in ap-statistics ap-chemistry ap-calculus-ab; do
  node $R run --batch=pipeline/batch --subject=$s --topics=$(topics $s) --session=test2-$s --conc=3 --rounds=2 > pipeline/run2_$s.log 2>&1 &
done
wait
echo "RESUME_END $(date -u +%FT%TZ) $(date +%s)" >> pipeline/timing.log
node $R report --batch=pipeline/batch > pipeline/report.log 2>&1
echo DONE2 >> pipeline/timing.log
