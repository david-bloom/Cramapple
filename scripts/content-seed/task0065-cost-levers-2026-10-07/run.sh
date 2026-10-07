#!/bin/bash
# Cost levers 2+3: Meta Muse Spark as fourth checker (replaces Kimi) + unit-scoped fact pack. Same 24 topics.
cd "$(dirname "$0")"
R=../../vercel-gateway-check/teaching_pipeline/run.mjs
F="--pack=scoped --fourth=meta/muse-spark-1.3"
topics() { python3 -c "import json;print(','.join(t['topic_code'] for t in json.load(open('sample.json')) if t['subject_key']=='$1'))"; }
echo "START $(date -u +%FT%TZ) $(date +%s)" > timing.log
node $R run --batch=batch --subject=biology --topics=$(topics biology) --session=lev-bio --conc=3 $F > run_biology.log 2>&1
for s in ap-statistics ap-chemistry ap-calculus-ab; do
  node $R run --batch=batch --subject=$s --topics=$(topics $s) --session=lev-$s --conc=3 $F > run_$s.log 2>&1 &
done
wait
echo "END $(date -u +%FT%TZ) $(date +%s)" >> timing.log
node $R report --batch=batch $F > report.log 2>&1
echo DONE >> timing.log
