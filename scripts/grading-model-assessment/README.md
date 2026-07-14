# Grading model assessment harness

This offline-first runner scores model result files against a locked gold corpus. It reports correctness before latency and cost, keeps prediction abstentions in overall-accuracy denominators, evaluates repair targeting and answer leakage, and computes deterministic item-cluster bootstrap intervals for candidate-minus-baseline quality.

```sh
deno run --allow-read --allow-write scripts/grading-model-assessment/main.ts \
  --gold scripts/grading-model-assessment/fixtures/gold.json \
  --candidate scripts/grading-model-assessment/fixtures/candidate-results.json \
  --baseline scripts/grading-model-assessment/fixtures/baseline-results.json \
  --out /tmp/grading-assessment-report.json
```

Provider dispatch remains a separate adapter. Capture raw production-shaped results first, stamp their transport and contract provenance, then run this scorer without network access.
