#!/bin/bash
# Method test, pipeline arm: same run.mjs as production use; topics from sample.json; timed.
cd "$(dirname "$0")"
R=../../vercel-gateway-check/teaching_pipeline/run.mjs
topics() { python3 -c "import json;print(','.join(t['topic_code'] for t in json.load(open('sample.json')) if t['subject_key']=='$1'))"; }
echo "START $(date -u +%FT%TZ) $(date +%s)" > pipeline/timing.log
node $R run --batch=pipeline/batch --subject=biology --topics=$(topics biology) --session=test-bio --conc=3 > pipeline/run_biology.log 2>&1
for s in ap-statistics ap-chemistry ap-calculus-ab; do
  node $R run --batch=pipeline/batch --subject=$s --topics=$(topics $s) --session=test-$s --conc=3 > pipeline/run_$s.log 2>&1 &
done
wait
echo "END $(date -u +%FT%TZ) $(date +%s)" >> pipeline/timing.log
node $R report --batch=pipeline/batch > pipeline/report.log 2>&1
echo DONE >> pipeline/timing.log
