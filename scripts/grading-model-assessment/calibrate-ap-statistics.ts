// Push-button AP Statistics calibration entrypoint for TASK-0016.
//
// Pipeline: label file -> harness gold -> scoreRun(candidate) -> launch-bar
// verdict. Two swap-in points make it authoritative once the people/capture
// work lands:
//   1. --labels: point at the ADJUDICATED gold file (same shape) instead of the
//      provisional one. The report flags provisional labels as non-authoritative.
//   2. --candidate: point at REAL grader outputs captured against these 20
//      responses (production-shaped ResultCase[] with latency_ms + cost_usd).
//      Use --emit-template to get the exact case skeleton to fill.
//
// No network. Capture grader results separately, then score here offline.
//
// Usage:
//   deno run --allow-read --allow-write scripts/grading-model-assessment/calibrate-ap-statistics.ts \
//     --labels docs/research/ap_statistics_gold_set_candidate_2026_07_08/provisional_labels.json \
//     [--candidate RESULTS.json] [--baseline RESULTS.json] \
//     [--emit-gold GOLD.json] [--emit-template TEMPLATE.json] [--out REPORT.json]

import { scoreRun } from "./harness.ts";
import { convertCalibrationLabels } from "./ap-statistics-gold.ts";
import { DEFAULT_LAUNCH_BAR, evaluateLaunchBar } from "./launch-bar.ts";

function parseArgs(values: string[]) {
  const result: Record<string, string> = {};
  for (let i = 0; i < values.length; i += 2) {
    if (!values[i]?.startsWith("--") || values[i + 1] == null) {
      throw new Error(`Invalid argument near ${values[i] ?? "end"}`);
    }
    result[values[i].slice(2)] = values[i + 1];
  }
  return result;
}

async function readJson(path: string) {
  return JSON.parse(await Deno.readTextFile(path));
}

// A blank candidate skeleton for every gold case -- the exact shape a grader
// capture must fill (status per criterion + end-to-end latency_ms + cost_usd).
function candidateTemplate(gold: ReturnType<typeof convertCalibrationLabels>["cases"]) {
  return gold.map((c) => ({
    content_key: c.content_key,
    response_index: c.response_index,
    criteria: c.criteria.map((cr) => ({
      criterion_key: cr.criterion_key,
      status: "REPLACE_WITH_GRADER_STATUS",
      points_awarded: 0,
      points_possible: 1,
    })),
    latency_ms: null,
    cost_usd: null,
  }));
}

if (import.meta.main) {
  const options = parseArgs(Deno.args);
  if (!options.labels) {
    throw new Error(
      "Usage: --labels LABELS.json [--candidate RESULTS.json] [--baseline RESULTS.json] [--emit-gold GOLD.json] [--emit-template TEMPLATE.json] [--out REPORT.json]",
    );
  }

  const doc = await readJson(options.labels);
  const converted = convertCalibrationLabels(doc);

  if (options["emit-gold"]) {
    await Deno.writeTextFile(
      options["emit-gold"],
      `${JSON.stringify(converted.cases, null, 2)}\n`,
    );
  }
  if (options["emit-template"]) {
    await Deno.writeTextFile(
      options["emit-template"],
      `${JSON.stringify(candidateTemplate(converted.cases), null, 2)}\n`,
    );
  }

  let scored = null;
  let launchBar = null;
  if (options.candidate) {
    const candidate = await readJson(options.candidate);
    scored = scoreRun(converted.cases, candidate);
    launchBar = evaluateLaunchBar(
      { overall_accuracy: scored.overall_accuracy, results: candidate },
      DEFAULT_LAUNCH_BAR,
    );
  }

  const report = {
    schema_version: "ap-statistics-calibration-report-v1",
    task: "TASK-0016 Phase C",
    label_source: options.labels,
    label_authority: converted.label_authority,
    labels_are_provisional: converted.is_provisional,
    gate_status: converted.is_provisional
      ? "PROVISIONAL — plumbing only; NOT launch-authoritative until human dual-blind adjudicated gold replaces these labels"
      : "adjudicated labels in use",
    case_count: converted.case_count,
    criterion_count: converted.criterion_count,
    excluded_corpus_defects: converted.excluded_defects,
    candidate_source: options.candidate ?? null,
    scored,
    launch_bar: launchBar,
    launch_bar_config: DEFAULT_LAUNCH_BAR,
  };

  const output = `${JSON.stringify(report, null, 2)}\n`;
  if (options.out) await Deno.writeTextFile(options.out, output);
  else console.log(output);
}
