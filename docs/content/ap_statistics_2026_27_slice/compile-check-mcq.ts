// Compile the AP Statistics 2027 slice MCQ portion (one 3-question set + one standalone MCQ
// per unit) through the same subject-harness compiler, against the ap-statistics-2026-27
// subject package + platform capability registry.
//
//   deno run --allow-read docs/content/ap_statistics_2026_27_slice/compile-check-mcq.ts
//
// The 4-FRQ anchor (plan af858299) is verified separately by compile-check.ts. Repository/local only.

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

const subject = await readJson(
  new URL("fixtures/ap-statistics-2026-27.subject-package.json", schemaRoot),
);
const registry = await readJson(new URL("platform-capabilities.v1.json", schemaRoot));

const mcqFiles = [
  "ap-statistics-2027-slice-mcq-set1-q1.item-package.json",
  "ap-statistics-2027-slice-mcq-set1-q2.item-package.json",
  "ap-statistics-2027-slice-mcq-set1-q3.item-package.json",
  "ap-statistics-2027-slice-mcq-u1.item-package.json",
  "ap-statistics-2027-slice-mcq-u2.item-package.json",
  "ap-statistics-2027-slice-mcq-u3.item-package.json",
  "ap-statistics-2027-slice-mcq-u4.item-package.json",
  "ap-statistics-2027-slice-mcq-u5.item-package.json",
];

const items: Record<string, any>[] = [];
for (const f of mcqFiles) {
  const item = await withContentHash(await readJson(new URL(f, here)));
  console.log(`${f.replace("ap-statistics-2027-slice-", "").replace(".item-package.json", "")}: ${item.provenance.content_sha256}`);
  items.push(item);
}

try {
  const plan = await compilePlan(subject, items, registry);
  console.log("\nCOMPILE OK");
  console.log(`  items:       ${plan.items.length}`);
  console.log(`  plan_sha256: ${plan.plan_sha256}`);
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
