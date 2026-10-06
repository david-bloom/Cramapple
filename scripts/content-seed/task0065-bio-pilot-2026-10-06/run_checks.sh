#!/bin/bash
# TASK-0065 Biology pilot: run checks C1-C6 (L is lint.py). Run from scripts/vercel-gateway-check.
set -u
P=../content-seed/task0065-bio-pilot-2026-10-06
M=deepseek/deepseek-v4-pro,google/gemini-3.8-flash
export SUBJECT_NAME="AP Biology"
node subject_audit_check.mjs $P/items.json $P/out_c1c2 --models=$M > $P/log_c1c2.txt 2>&1 &
node teaching_item_check.mjs $P/items.json $P/out_c3c6 --models=$M --briefs=$P/briefs.json > $P/log_c3c6.txt 2>&1 &
FACT_PACK_FILE=../../docs/product/AP_BIOLOGY_CED_FACT_PACK.md node subject_ced_check.mjs $P/ced_items.json $P/out_c4 --models=$M > $P/log_c4.txt 2>&1 &
for m in deepseek/deepseek-v4-pro google/gemini-3.8-flash openai/gpt-6.1-sol; do
  node apbio_seeded_label_probe.mjs $P/items.json $P/out_c5_${m//\//_} --model=$m --keys=$(cat $P/keys.txt) --samples=2 --taxonomy=$P/taxonomy.json > $P/log_c5_${m//\//_}.txt 2>&1 &
done
wait
echo ALL DONE
