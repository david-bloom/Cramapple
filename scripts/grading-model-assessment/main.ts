import { clusterBootstrapDifference, scoreRun } from "./harness.ts";

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

if (import.meta.main) {
  const options = args(Deno.args);
  if (!options.gold || !options.candidate) {
    throw new Error("Usage: deno run --allow-read --allow-write main.ts --gold GOLD.json --candidate RESULTS.json [--baseline RESULTS.json] [--out REPORT.json]");
  }
  const gold = await readJson(options.gold);
  const candidate = scoreRun(gold, await readJson(options.candidate));
  const baseline = options.baseline ? scoreRun(gold, await readJson(options.baseline)) : null;
  const report = {
    schema_version: "grading-assessment-report-v1",
    generated_at: new Date().toISOString(),
    candidate,
    baseline,
    candidate_minus_baseline: baseline
      ? { overall_accuracy: clusterBootstrapDifference(candidate.item_correctness, baseline.item_correctness) }
      : null,
  };
  const output = JSON.stringify(report, null, 2);
  if (options.out) await Deno.writeTextFile(options.out, `${output}\n`);
  else console.log(output);
}
