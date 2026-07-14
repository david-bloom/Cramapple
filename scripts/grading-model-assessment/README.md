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

## AP Statistics calibration (TASK-0016 Phase C)

`calibrate-ap-statistics.ts` wires the AP Statistics gold-set candidate into the
scorer and adds the TASK-0016 launch-bar verdict so the measurement is
push-button the moment the human work lands.

```sh
deno run --allow-read --allow-write \
  scripts/grading-model-assessment/calibrate-ap-statistics.ts \
  --labels docs/research/ap_statistics_gold_set_candidate_2026_07_08/provisional_labels.json \
  --candidate GRADER_RESULTS.json \
  --out REPORT.json
# helpers: --emit-gold GOLD.json (converted harness gold)
#          --emit-template TEMPLATE.json (blank grader-capture skeleton, one row per response)
```

Pipeline: `--labels` → harness gold (`ap-statistics-gold.ts`) → `scoreRun`
(`harness.ts`) → launch-bar verdict (`launch-bar.ts`).

**Launch bar** (TASK-0016): accuracy ≥ 95% criterion agreement **(GATE)**;
end-to-end p50 ≤ 1000 ms **(GATE)**; p90/p99 measured-and-reported; cost
≤ $0.01/item reported (not gated). Targets are ceilings — over a ceiling fails
that gate.

**Two swap-in points make it authoritative — nothing else changes:**
1. `--labels` → the **human dual-blind adjudicated** gold file (same shape) in
   place of `provisional_labels.json`. Until then the report is stamped
   `labels_are_provisional: true` and `gate_status: PROVISIONAL` — plumbing only,
   not launch-authoritative.
2. `--candidate` → **real grader outputs** captured against these 20 responses
   (production-shaped `ResultCase[]` with `latency_ms` + `cost_usd`). Use
   `--emit-template` to get the exact skeleton to fill; capture offline, then
   score here.
