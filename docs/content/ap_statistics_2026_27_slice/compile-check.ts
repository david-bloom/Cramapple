// Proof-case: compile the pre-G0A draft AP Statistics 2026-27 vertical slice (Q1-Q4)
// through the H0/H1 harness contract against the subject package + capability registry.
//
//   deno run --allow-read docs/content/ap_statistics_2026_27_slice/compile-check.ts
//
// Prints each item's recomputed canonical content_sha256, then compiles all four items as
// one plan. On success prints the plan hash + operations; on failure prints machine-readable
// issues. Repository/local verification only (DECISION-0040); it stages nothing.

import {
  canonicalJson,
  compilePlan,
  HarnessValidationError,
  sha256,
} from "../../../scripts/subject-harness/compiler.ts";

const schemaRoot = new URL("../../../schemas/subject-onboarding/", import.meta.url);
const here = new URL("./", import.meta.url);

async function readJson(url: URL): Promise<Record<string, any>> {
  return JSON.parse(await Deno.readTextFile(url));
}

// Recompute content_sha256 exactly as the compiler does (hash excludes the field itself).
async function withContentHash(item: Record<string, any>): Promise<Record<string, any>> {
  const clone = structuredClone(item);
  delete clone.provenance.content_sha256;
  item.provenance.content_sha256 = await sha256(canonicalJson(clone));
  return item;
}

const subject = await readJson(
  new URL("fixtures/ap-statistics-2026-27.subject-package.json", schemaRoot),
);
const registry = await readJson(new URL("platform-capabilities.v1.json", schemaRoot));

const items: Record<string, any>[] = [];
for (const n of [1, 2, 3, 4]) {
  const name = `ap-statistics-2027-slice-q${n}.item-package.json`;
  const item = await withContentHash(await readJson(new URL(name, here)));
  console.log(`q${n} content_sha256 = ${item.provenance.content_sha256}`);
  items.push(item);
}

try {
  const plan = await compilePlan(subject, items, registry);
  console.log("\nCOMPILE OK");
  console.log(`  items:       ${plan.items.length}`);
  console.log(`  plan_sha256: ${plan.plan_sha256}`);
  for (const op of plan.operations) {
    if (op.action === "ensure-item-version") console.log(`  op: ${op.action} ${op.key}`);
  }
} catch (error) {
  if (error instanceof HarnessValidationError) {
    console.error("\nCOMPILE FAILED:");
    for (const issue of error.issues) {
      console.error(`  ${issue.code} ${issue.path}: ${issue.message}`);
    }
    Deno.exit(1);
  }
  throw error;
}
