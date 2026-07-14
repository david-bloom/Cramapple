// AP Biology harness extensibility probe — compile a Bio SubjectPackage + 3 item-packages
// through the SAME scripts/subject-harness/compiler.ts used for AP Statistics.
//
//   deno run --allow-read docs/content/ap_biology_harness_probe/compile-check.ts
//
// Run A (real registry): EXPECTED TO FAIL, and the only issues should be capability gaps
//   (graph modality is experimental; biology-frq-rubric grader is unregistered). Any other
//   issue code means Bio's structure did NOT fit the contract — a real extensibility finding.
// Run B (control registry, graph + biology-frq-rubric marked supported): EXPECTED GREEN,
//   isolating that the package is fully valid and platform capability was the sole blocker.
//
// Repository/local only. Stages nothing.

import {
  canonicalJson,
  compilePlan,
  HarnessValidationError,
  sha256,
} from "../../../scripts/subject-harness/compiler.ts";

const schemaRoot = new URL("../../../schemas/subject-onboarding/", import.meta.url);
const here = new URL("./", import.meta.url);

async function readJson(u: URL): Promise<Record<string, any>> {
  return JSON.parse(await Deno.readTextFile(u));
}
async function withContentHash(item: Record<string, any>): Promise<Record<string, any>> {
  const clone = structuredClone(item);
  delete clone.provenance.content_sha256;
  item.provenance.content_sha256 = await sha256(canonicalJson(clone));
  return item;
}

const subject = await readJson(new URL("ap-biology.subject-package.json", here));
const registry = await readJson(new URL("platform-capabilities.v1.json", schemaRoot));

const itemFiles = [
  "ap-biology-long-frq.item-package.json",
  "ap-biology-short-frq.item-package.json",
  "ap-biology-graph-frq.item-package.json",
];
const items: Record<string, any>[] = [];
for (const f of itemFiles) {
  const item = await withContentHash(await readJson(new URL(f, here)));
  console.log(`${f} content_sha256 = ${item.provenance.content_sha256}`);
  items.push(item);
}

const EXPECTED = new Set([
  "capability.not_supported",
  "capability.missing",
  "capability.item_modality_not_supported",
]);

console.log("\n===== Run A: real registry (expect capability-only failure) =====");
let runAOk = false;
try {
  await compilePlan(subject, items, registry);
  console.log("!! Unexpected: compile SUCCEEDED on the real registry (graph should be blocked)");
} catch (e) {
  if (!(e instanceof HarnessValidationError)) throw e;
  const codes = new Set(e.issues.map((i) => i.code));
  for (const issue of e.issues) console.log(`  ${issue.code} ${issue.path}: ${issue.message}`);
  const unexpected = [...codes].filter((c) => !EXPECTED.has(c));
  if (unexpected.length === 0) {
    runAOk = true;
    console.log("  -> PASS: failure is capability-only; Bio's structure raised no other issue.");
  } else {
    console.log(`  -> STRUCTURAL FINDING: unexpected issue codes: ${unexpected.join(", ")}`);
  }
}

console.log("\n===== Run B: control registry (graph + biology-frq-rubric supported) =====");
const control = structuredClone(registry);
control.response_modalities.graph = "supported";
control.graders["biology-frq-rubric"] = "supported";
let runBOk = false;
try {
  const plan = await compilePlan(subject, items, control);
  runBOk = true;
  console.log("  COMPILE OK");
  console.log(`  items:       ${plan.items.length}`);
  console.log(`  plan_sha256: ${plan.plan_sha256}`);
} catch (e) {
  if (!(e instanceof HarnessValidationError)) throw e;
  console.log("  !! Unexpected failure with a capable platform:");
  for (const issue of e.issues) console.log(`    ${issue.code} ${issue.path}: ${issue.message}`);
}

console.log("\n===== Probe verdict =====");
console.log(`  Run A capability-only failure: ${runAOk ? "yes" : "NO"}`);
console.log(`  Run B green with capable platform: ${runBOk ? "yes" : "NO"}`);
console.log(
  runAOk && runBOk
    ? "  HARNESS EXTENSIBLE: Bio package structurally valid; sole blockers are the two capability gaps."
    : "  See findings above.",
);
