#!/bin/bash
# Method test, legacy arm, check stage: #340's checker (usage-logging copy), Gemini 3.8 + DeepSeek v4, per subject in parallel.
cd "$(dirname "$0")"
C=../../vercel-gateway-check/method_test_legacy_check.mjs
M=google/gemini-3.8-flash,deepseek/deepseek-v4-pro
echo "CHECK1_START $(date -u +%FT%TZ) $(date +%s)" >> legacy/timing.log
for s in biology ap-statistics ap-chemistry ap-calculus-ab; do
  node $C legacy/$s.json legacy/check1_$s --models=$M > legacy/check1_$s.log 2>&1 &
done
wait
echo "CHECK1_END $(date -u +%FT%TZ) $(date +%s)" >> legacy/timing.log
