import {
  clusterBootstrapDifference,
  collapseToItemClusters,
  type ScoringPolicy,
  scoreRun,
} from "./harness.ts";

function args(values: string[]) {
  const result: Record<string, string> = {};
  for (let i = 0; i < values.length; i += 2) {
    if (!values[i]?.startsWith("--") || values[i + 1] == null) throw new Error(`Invalid argument near ${values[i] ?? "end"}`);
    result[values[i].slice(2)] = values[i + 1];
  }
  return result;
}
async function readJson(path: string) {
  return JSON.parse(await Deno.readTextFile(path));
}

function parsePolicy(value: string | undefined): ScoringPolicy {
  if (value === undefined || value === "binary-v1") return "binary-v1";
  if (value === "partial-v2") return "partial-v2";
  throw new Error(
    `Unknown --policy "${value}" (expected "binary-v1" or "partial-v2")`,
  );
}

if (import.meta.main) {
  const options = args(Deno.args);
  if (!options.gold || !options.candidate) {
    throw new Error("Usage: deno run --allow-read --allow-write main.ts --gold GOLD.json --candidate RESULTS.json [--baseline RESULTS.json] [--policy binary-v1|partial-v2] [--out REPORT.json]");
  }
  const policy = parsePolicy(options.policy);
  const gold = await readJson(options.gold);
  const candidate = scoreRun(gold, await readJson(options.candidate), policy);
  const baseline = options.baseline ? scoreRun(gold, await readJson(options.baseline), policy) : null;
  const report = {
    schema_version: "grading-assessment-report-v2",
    generated_at: new Date().toISOString(),
    scoring_policy: policy,
    candidate,
    baseline,
    candidate_minus_baseline: baseline
      ? {
        // Response-level clusters: one per (content_key, response_index).
        // Valid when the scored responses are themselves the independent
        // sampling unit of the design.
        overall_accuracy: clusterBootstrapDifference(candidate.item_correctness, baseline.item_correctness),
        // Item-level clusters: responses collapsed to their content_key
        // (unweighted mean per item) before resampling. This is the correct
        // unit for held-out-item designs, where responses to the same item
        // share rubric/exemplar/prompt scaffolding and are not independent
        // draws -- the gap that invalidated the 2026-08-10 exemplar pilot's
        // CI (exemplar_grading_pilot_2026_08/REPORT.md). Reported alongside,
        // never instead of, the response-level interval so a reader can see
        // both granularities and the design doc decides which one binds.
        overall_accuracy_item_clusters: clusterBootstrapDifference(
          collapseToItemClusters(candidate.item_correctness),
          collapseToItemClusters(baseline.item_correctness),
        ),
      }
      : null,
  };
  const output = JSON.stringify(report, null, 2);
  if (options.out) await Deno.writeTextFile(options.out, `${output}\n`);
  else console.log(output);
}
